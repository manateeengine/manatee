const builtin = @import("builtin");
const std = @import("std");

/// The standard Manatee GPU interface.
///
/// A GPU represents a unified abstraction over a given graphics API, such as Direct3D12 or Metal.
/// This interface is a very high-level abstraction, and will likely go through a lot of changes
/// as Manatee grows and evolves. The Manatee GPU interface is NOT meant to be a replacement for
/// a unifying low-level graphics API like Vulkan. Instead, this interface is comparable to a
/// less-verbose graphics API, such as Direct3D9, OpenGL, or Magma. This may change in the future,
/// and if it does, there'll likely be a spin-off of this abstraction named something like CoreGpu.
///
/// Note: I've literally never written GPU code or used any graphics APIs before starting this, so
/// expect this to change a LOT as I learn how to do all of this. Suggestions, and criticism are
/// appreciated, as I literally have no idea what I'm doing. With that in mind: LET'S GO MAKE SOME
/// FUCKING TRIANGLES!
///
/// This interface is inspired by the Zig "interface" pattern defined in std.mem.Allocator, and is
/// heavily influenced by SuperAuguste's `zig-patterns` repo's "vtable" example. For more info,
/// see https://github.com/SuperAuguste/zig-patterns/blob/main/src/typing/vtable.zig
pub const Gpu = struct {
    ptr: *anyopaque,
    vtable: *const VTable,

    pub const VTable = struct {
        deinit: *const fn (ctx: *anyopaque) void,
    };

    /// Handles memory cleanup of anything created during the GPU's initialization process.
    pub fn deinit(self: Gpu) void {
        self.vtable.deinit(self.ptr);
    }
};

/// A function that automatically determines which implementation of the Manatee GPU interface to
/// use based off of the Zig compilation target.
///
/// This function will throw a `@compileError` if a GPU implementation does not exist for the
/// targeted OS.
pub fn getGpuInterfaceStruct() type {
    const base_app = switch (builtin.os.tag) {
        // TODO: Post-v0, add native Metal support
        // .macos => @import("gpu/metal_gpu.zig").MetalGpu,
        .macos => @import("gpu/vulkan_gpu.zig").VulkanGpu,
        // TODO: Post-v0, add native D3D12 support
        // .windows => @import("gpu/d3d12_gpu.zig").D3d12Gpu,
        .windows => @import("gpu/vulkan_gpu.zig").VulkanGpu,
        else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
    };

    return base_app;
}
