const c = @import("c.zig");
const core = @import("core.zig");

/// Structure specifying parameters of a newly created Metal surface object
pub const MetalSurfaceCreateInfo = extern struct {
    s_type: core.StructureType = core.StructureType.metal_surface_create_info_ext,
    p_next: ?*const anyopaque = null,
    flags: u32 = 0,
    p_layer: *const anyopaque,
};

/// Create a VkSurfaceKHR object for CAMetalLayer
/// https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateMetalSurfaceEXT.html
pub fn createMetalSurface(instance: core.Instance, create_info: *const MetalSurfaceCreateInfo, allocator: ?*const c.VkAllocationCallbacks, surface: *c.VkSurfaceKHR) core.Result {
    const result = c.vkCreateMetalSurfaceEXT(instance, @ptrCast(create_info), allocator, surface);
    return @enumFromInt(result);
}
