const builtin = @import("builtin");
const std = @import("std");

const vulkan = @import("../../bindings.zig").vulkan;
const Gpu = @import("../gpu.zig").Gpu;
const Window = @import("../window.zig").Window;

/// A Vulkan implementation of the Manatee `GPU` interface.
///
/// This handles the implementation of Vulkan for targets that natively support Vulkan (including
/// Windows, most Linux distributions, most BSD distributions, and Nintendo Switch), as well as
/// targets that require the MoltenVK adapter, such as MacOS and iOS.
///
/// Most of this implementation was built directly based off of the Vulkan Guide, with a notable
/// exception to the `init` struct method. In the guide, they used the C++ wrapper `vk-bootstrap`
/// to reduce the amount of verbosity required to set up Vulkan. Since we're using Zig, we don't
/// have that luxury, so we had to effectively rewrite that wrapper inside of this struct's `init`
/// method.
///
/// A good portion of this implementation was inspired by spanzeri's `vkguide-zig` repo. I'd like
/// to give a huge shout-out to his work as it dramatically helped with my own understanding of how
/// Vulkan (and other external dynamic libraries) can be used within Zig.
pub const VulkanGpu = struct {
    allocator: std.mem.Allocator,
    device: *vulkan.core.Device,
    instance: *vulkan.core.Instance,

    pub fn init(allocator: std.mem.Allocator, window: *Window) !VulkanGpu {
        _ = window; // autofix
        // Setup App
        const app_info = vulkan.core.ApplicationInfo{
            .api_version = vulkan.core.api_version_1_0,
            .p_application_name = "Manatee Game",
            .application_version = vulkan.core.makeApiVersion(0, 0, 1, 0),
            .p_engine_name = "Manatee",
            .engine_version = vulkan.core.makeApiVersion(0, 0, 1, 0),
        };

        // Setup Instance Extensions
        // TODO: Iterate over these and only pick the ones that exist for the current system
        const instance_extensions: []const [*:0]const u8 = switch (builtin.target.os.tag) {
            .macos => &.{
                "VK_KHR_surface",
                "VK_KHR_get_physical_device_properties2",
                "VK_EXT_metal_surface",
            },
            .windows => &.{
                "VK_KHR_surface",
                "VK_KHR_win32_surface",
            },
            else => &.{},
        };

        // Setup Instance
        const instance_create_info = vulkan.core.InstanceCreateInfo{
            .enabled_layer_count = 0,
            .p_application_info = &app_info,
            .pp_extension_names = instance_extensions.ptr,
            .enabled_extension_count = @intCast(instance_extensions.len),
            // TODO: Figure out if this only ever needs to be loaded on MacOS?
            .flags = vulkan.core.InstanceCreateFlags{ .enumerate_portability_bit_khr = true },
        };

        // Create Instance
        const instance = try allocator.create(vulkan.core.Instance);
        errdefer allocator.destroy(instance);
        if (vulkan.core.createInstance(&instance_create_info, null, instance) != vulkan.core.Result.success) {
            return error.instance_creation_failed;
        }

        // Get all Physical Devices (GPUs)
        var device_count: u32 = 0;
        _ = vulkan.core.enumeratePhysicalDevices(instance.*, &device_count, null);
        if (device_count == 0) {
            return error.no_physical_devices;
        }

        const devices = try allocator.alloc(vulkan.c.VkPhysicalDevice, device_count);
        defer allocator.free(devices);
        if (vulkan.core.enumeratePhysicalDevices(instance.*, &device_count, devices.ptr) != vulkan.core.Result.success) {
            return error.device_enumeration_failed;
        }

        // Iterate over all physical devices and select the one with the highest score
        var best_physical_device: ?vulkan.core.PhysicalDevice = null;
        var best_physical_device_score: u32 = 0;

        for (devices) |device_handle| {
            const device = try vulkan.core.PhysicalDevice.init(allocator, device_handle);
            errdefer allocator.destroy(device);

            if (device.score > best_physical_device_score) {
                best_physical_device = device;
                best_physical_device_score = device.score;
            }

            // TODO: Refactor this into a custom struct and add queue family info. Probably follow
            // https://docs.vulkan.org/tutorial/latest/03_Drawing_a_triangle/00_Setup/03_Physical_devices_and_queue_families.html
        }

        // Setup Logical Device Queue
        const queue_priorities: [1]f32 = .{1.0};
        const queue_create_infos: [1]vulkan.core.DeviceQueueCreateInfo = .{vulkan.core.DeviceQueueCreateInfo{
            .queue_count = 1,
            .queue_family_index = best_physical_device.?.queue_family_index_graphics,
            .p_queue_priorities = &queue_priorities,
        }};

        // Setup Logical Device
        const device_create_info = vulkan.core.DeviceCreateInfo{
            .queue_create_info_count = queue_create_infos.len,
            .p_queue_create_infos = &queue_create_infos,
            .p_enabled_features = &best_physical_device.?.features,
        };

        // Create Logical Device
        const device = try allocator.create(vulkan.core.Device);
        errdefer allocator.destroy(device);
        if (vulkan.core.createDevice(best_physical_device.?, &device_create_info, null, device) != .success) {
            return error.device_creation_failed;
        }

        // Get Graphics Queue Handle
        const graphics_queue = try allocator.create(vulkan.core.Queue);
        defer allocator.destroy(graphics_queue); // Probably remove this
        errdefer allocator.destroy(graphics_queue);
        vulkan.core.getDeviceQueue(device.*, best_physical_device.?.queue_family_index_graphics, 0, graphics_queue);

        // Creating the Window Surface
        // We'll need to execute different functions depending on which platform our build is
        // targeting, as well as create different surface parameters. Luckily for us, the final
        // surface output is platform-agnostic, so we only really care about that during the setup
        // phase here

        // Let's start be allocating memory for our surface
        // const surface = try vulkan.core.SurfaceKHR.init(allocator, instance, window.getNativeWindow());
        // _ = surface;

        // // Now let's create the appropriate surface for the target OS, throwing a compile error if
        // // we're not using a supported OS
        // switch (builtin.target.os.tag) {
        //     .macos => {
        //         const macos = @import("../../bindings/macos.zig");

        //         std.debug.print("Creating Metal Layer", .{});
        //         // Create a CAMetalLayer
        //         var ca_metal_layer = try allocator.create(macos.core_animation.CAMetalLayer);
        //         ca_metal_layer.* = macos.core_animation.CAMetalLayer.init();

        //         std.debug.print("Creating View", .{});
        //         // Create an NSView and set its layer to the newly created CAMetalLayer
        //         var ns_view = macos.app_kit.NSView.init();
        //         ns_view.setWantsLayer(true);
        //         ns_view.setLayer(ca_metal_layer.*);

        //         std.debug.print("Creating Window", .{});
        //         // Create a reference to the native window and set the window's contentView to the
        //         // newly created NSView
        //         var ns_window = macos.app_kit.NSWindow{ .value = @ptrCast(@alignCast(window.getNativeWindow())) };
        //         ns_window.setContentView(ns_view);

        //         std.debug.print("Creating Vulkan Metal Surface", .{});
        //         // Finally create the Vulkan surface and assign the CAMetalLayer to it
        //         const metal_surface_create_info = vulkan.metal.MetalSurfaceCreateInfo{
        //             .p_layer = @ptrCast(&ca_metal_layer.value),
        //         };

        //         if (vulkan.metal.createMetalSurface(instance.*, &metal_surface_create_info, null, surface) != .success) {
        //             return error.metal_surface_creation_failed;
        //         }
        //     },
        //     .windows => {
        //         // TODO: Push, switch machines, and test this on windows
        //     },
        //     else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
        // }

        return VulkanGpu{
            .allocator = allocator,
            .device = device,
            .instance = instance,
        };
    }

    pub fn gpu(self: *VulkanGpu) Gpu {
        return Gpu{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Gpu.VTable{
        .deinit = &deinit,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *VulkanGpu = @ptrCast(@alignCast(ctx));
        vulkan.core.destroyDevice(self.device.*, null);
        self.allocator.destroy(self.device);
        vulkan.core.destroyInstance(self.instance.*, null);
        self.allocator.destroy(self.instance);
        self.allocator.destroy(self);
    }
};
