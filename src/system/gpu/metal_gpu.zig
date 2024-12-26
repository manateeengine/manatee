const std = @import("std");

const macos = @import("../../bindings.zig").macos;
const Gpu = @import("../gpu.zig").Gpu;
const Window = @import("../window.zig").Window;

/// A Metal implementation of the Manatee `GPU` interface.
pub const MetalGpu = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, window: *Window) !MetalGpu {
        _ = window.getNativeWindow();
        // TODO: Implement Metal GPU
        return MetalGpu{
            .allocator = allocator,
        };
    }

    pub fn gpu(self: *MetalGpu) Gpu {
        return Gpu{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Gpu.VTable{
        .deinit = &deinit,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *MetalGpu = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
