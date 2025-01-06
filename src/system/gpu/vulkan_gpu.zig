const builtin = @import("builtin");
const std = @import("std");

const vulkan = @import("../../bindings.zig").vulkan;
const App = @import("../app.zig").App;
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
    device: vulkan.Device,
    instance: vulkan.Instance,
    queue_graphics: vulkan.Queue,
    queue_present: vulkan.Queue,
    surface: vulkan.SurfaceKhr,

    pub fn init(allocator: std.mem.Allocator, app: *const App, window: *Window) !VulkanGpu {
        // Create Instance
        const app_info = vulkan.ApplicationInfo{
            .api_version = vulkan.api_version_1_0,
            .p_application_name = "Manatee Game",
            .application_version = vulkan.makeApiVersion(0, 0, 1, 0),
            .p_engine_name = "Manatee",
            .engine_version = vulkan.makeApiVersion(0, 0, 1, 0),
        };
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
        const instance_create_info = vulkan.InstanceCreateInfo{
            .enabled_layer_count = 0,
            .p_application_info = &app_info,
            .pp_extension_names = instance_extensions.ptr,
            .enabled_extension_count = @intCast(instance_extensions.len),
            // TODO: Figure out if this only ever needs to be loaded on MacOS?
            .flags = vulkan.InstanceCreateFlags{ .enumerate_portability_bit_khr = true },
        };
        var instance = try vulkan.Instance.init(&instance_create_info);

        // Create Surface
        const surface = try vulkan.SurfaceKhr.init(instance, app.getNativeApp(), window.getNativeWindow());

        // Determine the Best Physical Device
        const physical_devices = try instance.enumeratePhysicalDevices(allocator);
        defer allocator.free(physical_devices);

        var best_physical_device: ?ManateePhysicalDevice = null;
        var best_physical_device_score: u32 = 0;

        for (physical_devices) |physical_device| {
            const manatee_physical_device = try ManateePhysicalDevice.init(allocator, physical_device, surface);

            if (manatee_physical_device.score > best_physical_device_score) {
                best_physical_device = manatee_physical_device;
                best_physical_device_score = manatee_physical_device.score;
            }
        }

        if (best_physical_device == null) {
            return error.no_suitable_physical_device;
        }

        // Create Queues
        const queue_priorities: [1]f32 = .{1.0};
        const queue_create_infos: [2]vulkan.DeviceQueueCreateInfo = .{
            vulkan.DeviceQueueCreateInfo{
                .queue_count = 1,
                .queue_family_index = best_physical_device.?.queue_family_index_graphics,
                .p_queue_priorities = &queue_priorities,
            },
            vulkan.DeviceQueueCreateInfo{
                .queue_count = 1,
                .queue_family_index = best_physical_device.?.queue_family_index_present,
                .p_queue_priorities = &queue_priorities,
            },
        };

        // Create Device
        const device_extensions: []const [*:0]const u8 = switch (builtin.target.os.tag) {
            .macos => &.{
                "VK_KHR_swapchain",
            },
            .windows => &.{
                "VK_KHR_swapchain",
            },
            else => &.{},
        };

        const device_create_info = vulkan.DeviceCreateInfo{
            .queue_create_info_count = queue_create_infos.len,
            .p_queue_create_infos = &queue_create_infos,
            .p_enabled_features = &best_physical_device.?.features,
            .pp_enabled_extension_names = device_extensions.ptr,
            .enabled_extension_count = @intCast(device_extensions.len),
        };
        var device = try vulkan.Device.init(best_physical_device.?.device, &device_create_info);

        // Get queues from device
        const queue_graphics = device.getQueue(best_physical_device.?.queue_family_index_graphics, 0);
        const queue_present = device.getQueue(best_physical_device.?.queue_family_index_present, 0);

        std.debug.print("Vulkan Initialized Successfully!\n", .{});
        return VulkanGpu{
            .allocator = allocator,
            .device = device,
            .instance = instance,
            .queue_graphics = queue_graphics,
            .queue_present = queue_present,
            .surface = surface,
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
        self.surface.deinit(self.instance);
        self.device.deinit();
        self.instance.deinit();
        self.allocator.destroy(self);
    }
};

/// A Manatee-specific struct that contains a Vulkan Physical Device handle, as well as its
/// features, properties, relevant queue indices, and a score used for picking the best device
const ManateePhysicalDevice = struct {
    const Self = @This();
    device: vulkan.PhysicalDevice,
    features: vulkan.PhysicalDeviceFeatures,
    properties: vulkan.PhysicalDeviceProperties,
    queue_family_index_graphics: u32,
    queue_family_index_present: u32,
    score: u32,

    pub fn init(allocator: std.mem.Allocator, physical_device: vulkan.PhysicalDevice, surface: vulkan.SurfaceKhr) !Self {
        const invalid_queue_family_index = std.math.maxInt(u32);

        const features = physical_device.getFeatures();
        const properties = physical_device.getProperties();

        const queue_family_properties = try physical_device.getQueueFamilyProperties(allocator);
        defer allocator.free(queue_family_properties);

        var queue_family_index_graphics: u32 = invalid_queue_family_index;
        var queue_family_index_present: u32 = invalid_queue_family_index;

        for (queue_family_properties, 0..) |queue_family, idx| {
            // Set graphics queue family index
            if (queue_family_index_graphics == invalid_queue_family_index) {
                const has_graphics_support = @as(u32, @bitCast(queue_family.queue_flags)) & @as(u32, @bitCast(vulkan.QueueFlagBits.graphics_bit)) != 0;
                if (has_graphics_support) {
                    queue_family_index_graphics = @intCast(idx);
                }
            }

            // Set present queue family index
            if (queue_family_index_present == invalid_queue_family_index) {
                const has_present_support = try physical_device.getSurfaceSupportKhr(@intCast(idx), surface);
                if (has_present_support) {
                    queue_family_index_present = @intCast(idx);
                }
            }
        }

        var score: u32 = 0;
        // Discrete GPUs have a significant performance advantage
        if (properties.device_type == .discrete_gpu) {
            score += 1000;
        }

        // Maximum possible size of textures affects graphics quality
        score += properties.limits.max_image_dimension_2d;

        // We want to heavily discourage use of devices that don't have geometry shader support,
        // however for Apple devices with integrated GPUs (such as M1 MacBooks), their GPU will
        // never support geometry shaders (due to a lack of support in the Metal API), so we'll set
        // the device's score to 1 just to be on the safe side
        if (features.geometry_shader == 0) {
            score = 1;
        }

        // If a device has any invalid queue indexes, we'll set the score to 0 as we can't use a
        // device with incomplete queues
        if (queue_family_index_graphics == invalid_queue_family_index or queue_family_index_present == invalid_queue_family_index) {
            score = 0;
        }

        // TODO: I should probably check device swapchain support here

        return Self{
            .device = physical_device,
            .features = features,
            .properties = properties,
            .queue_family_index_graphics = queue_family_index_graphics,
            .queue_family_index_present = queue_family_index_present,
            .score = score,
        };
    }
};

/// A Manatee-specific struct that contains swapchain capabilities, formats, and present modes for
/// a given PhysicalDevice
const ManateeSwapchainSupportDetails = struct {
    const Self = @This();
    allocator: std.mem.Allocator,
    capabilities: vulkan.SurfaceCapabilitiesKhr,
    formats: []vulkan.SurfaceFormatKhr,
    present_modes: []vulkan.PresentModeKhr,

    pub fn init(allocator: std.mem.Allocator, physical_device: *vulkan.PhysicalDevice, surface: vulkan.SurfaceKhr) !Self {
        const capabilities = try physical_device.getSurfaceCapabilitiesKhr(surface);

        const formats = try physical_device.getSurfaceFormats(allocator, surface);
        errdefer allocator.free(formats);

        const present_modes = try physical_device.getSurfacePresentModes(allocator, surface);
        errdefer allocator.free(present_modes);

        return Self{
            .allocator = allocator,
            .capabilities = capabilities,
            .formats = formats,
            .present_modes = present_modes,
        };
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.formats);
        self.allocator.free(self.present_modes);
    }
};
