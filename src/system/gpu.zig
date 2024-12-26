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
/// This interface is inspired by the Zig "interface" pattern defined in std.mem.Allocator. Fingers
/// crossed that better, less verbose interface patterns will be added to Zig in a future version,
/// but for now this is the best option. For more information on Zig interfaces, check out
/// https://medium.com/@jerrythomas_in/exploring-compile-time-interfaces-in-zig-5c1a1a9e59fd
pub const Gpu = struct {
    ptr: *anyopaque,
    vtable: *const VTable,

    pub const VTable = struct {
        deinit: *const fn (ctx: *anyopaque) void,
    };

    pub fn deinit(self: Gpu) void {
        self.vtable.deinit(self.ptr);
    }
};

/// A function that automatically determines which instance of the Manatee GPU interface to use,
/// based off of the Zig compilation target
pub fn getGpuInterfaceStruct() type {
    const base_app = switch (builtin.os.tag) {
        .macos => @import("gpu/metal_gpu.zig").MetalGpu,
        .windows => @import("gpu/d3d12_gpu.zig").D3d12Gpu,
        else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
    };

    return base_app;
}
