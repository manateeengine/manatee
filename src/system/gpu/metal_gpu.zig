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
/// Most of this will probably need to be re-organized / abstracted in some way or another as I get
/// more comfortable with Vulkan, but that's okay, we're still a LONG way out from v0 anyway!
///
/// A good portion of this implementation was inspired by spanzeri's `vkguide-zig` repo. I'd like
/// to give a huge shout-out to his work as it dramatically helped with my own understanding of how
/// Vulkan (and other external dynamic libraries) can be used within Zig.
pub const VulkanGpu = struct {
    allocator: std.mem.Allocator,
    command_pool: *vulkan.CommandPool,
    device: *vulkan.Device,
    framebuffers: []*vulkan.Framebuffer,
    graphics_pipeline: *vulkan.Pipeline,
    image_views: []*vulkan.ImageView,
    instance: *vulkan.Instance,
    pipeline_layout: *vulkan.PipelineLayout,
    queue_graphics: *vulkan.Queue,
    queue_present: *vulkan.Queue,
    render_pass: *vulkan.RenderPass,
    surface: *vulkan.SurfaceKhr,
    swapchain: *vulkan.SwapchainKhr,

    pub fn init(allocator: std.mem.Allocator, app: *const App, window: *Window) !VulkanGpu {
        _ = window; // autofix
        _ = app; // autofix
        _ = allocator; // autofix

        return VulkanGpu{};
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
        self.allocator.destroy(self);
        std.debug.print("Vulkan Cleanup Successful, thanks for playing!\n", .{});
    }
};
