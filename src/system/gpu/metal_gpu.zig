const std = @import("std");

const Gpu = @import("../gpu.zig").Gpu;
const Window = @import("../window.zig").Window;

/// A Metal implementation of the Manatee `GPU` interface.
///
/// In order to maintain a clean multi-backend build, this struct should almost never be directly
/// used. For usage, see `gpu.getGpuInterfaceStruct()`.
pub const MetalGpu = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, main_window: *Window) !Gpu {
        const instance = try allocator.create(MetalGpu);
        _ = main_window;
        instance.* = MetalGpu{ .allocator = allocator };
        return Gpu{
            .ptr = instance,
            .impl = &.{ .deinit = deinit },
        };
    }

    // TODO: Implement Metal GPU Interface

    pub fn deinit(ctx: *anyopaque) void {
        const self: *MetalGpu = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
