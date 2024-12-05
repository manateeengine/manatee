const std = @import("std");

const Gpu = @import("../gpu.zig").Gpu;

/// A Vulkan implementation of the Manatee `GPU` interface.
///
/// In order to maintain a clean multi-backend build, this struct should almost never be directly
/// used. For usage, see `gpu.getGpuInterfaceStruct()`.
pub const VulkanGpu = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Gpu {
        const instance = try allocator.create(VulkanGpu);
        instance.* = VulkanGpu{ .allocator = allocator };
        return Gpu{
            .ptr = instance,
            .impl = &.{ .deinit = deinit },
        };
    }

    // TODO: Implement Vulkan GPU Interface

    pub fn deinit(ctx: *anyopaque) void {
        const self: *VulkanGpu = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
