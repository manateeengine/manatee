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
    // device: *vulkan.core.Device,
    instance: *vulkan.core.Instance,
    // surface: vulkan.core.SurfaceKHR,

    pub fn init(allocator: std.mem.Allocator, app: *const App, window: *Window) !VulkanGpu {
        _ = app;
        _ = window;

        // Create Instance
        const app_info = vulkan.core.ApplicationInfo{
            .api_version = vulkan.core.api_version_1_0,
            .p_application_name = "Manatee Game",
            .application_version = vulkan.core.makeApiVersion(0, 0, 1, 0),
            .p_engine_name = "Manatee",
            .engine_version = vulkan.core.makeApiVersion(0, 0, 1, 0),
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
        const instance_create_info = vulkan.core.InstanceCreateInfo{
            .enabled_layer_count = 0,
            .p_application_info = &app_info,
            .pp_extension_names = instance_extensions.ptr,
            .enabled_extension_count = @intCast(instance_extensions.len),
            // TODO: Figure out if this only ever needs to be loaded on MacOS?
            .flags = vulkan.core.InstanceCreateFlags{ .enumerate_portability_bit_khr = true },
        };
        const instance = try vulkan.core.Instance.init(&instance_create_info, null);

        // Determine the Best Physical Device
        const physical_devices = try instance.enumeratePhysicalDevices(allocator);
        errdefer allocator.free(physical_devices);

        std.debug.print("Vulkan Initialized Successfully!\n", .{});
        return VulkanGpu{
            .allocator = allocator,
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
        self.instance.deinit(null);
        self.allocator.destroy(self);
    }
};
