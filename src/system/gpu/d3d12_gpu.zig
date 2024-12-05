const std = @import("std");

const Gpu = @import("../gpu.zig").Gpu;

/// A D3d12 implementation of the Manatee `GPU` interface.
///
/// In order to maintain a clean multi-backend build, this struct should almost never be directly
/// used. For usage, see `gpu.getGpuInterfaceStruct()`.
pub const D3d12Gpu = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Gpu {
        const instance = try allocator.create(D3d12Gpu);
        instance.* = D3d12Gpu{ .allocator = allocator };
        return Gpu{
            .ptr = instance,
            .impl = &.{ .deinit = deinit },
        };
    }

    // TODO: Implement D3D12 GPU Interface

    pub fn deinit(ctx: *anyopaque) void {
        const self: *D3d12Gpu = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
