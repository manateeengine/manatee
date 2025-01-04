const std = @import("std");

const Instance = @import("instance.zig").Instance;
const Result = @import("result.zig").Result;

/// Opaque handle to a physical device object
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDevice.html
pub const PhysicalDevice = enum(usize) {
    const Self = @This();
};
