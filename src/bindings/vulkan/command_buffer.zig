const std = @import("std");

const shared = @import("shared.zig");

const CommandPool = @import("command_pool.zig").CommandPool;
const Device = @import("device.zig").Device;
const FrameBuffer = @import("framebuffer.zig").Framebuffer;
const RenderPass = @import("render_pass.zig").RenderPass;

const AllocationCallbacks = shared.AllocationCallbacks;
const Result = shared.Result;
const StructureType = shared.StructureType;

pub const CommandBuffer = opaque {
    const Self = @This();

    /// Allocate command buffers from an existing command pool
    /// Original: `vkAllocateCommandBuffers`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkAllocateCommandBuffers.html
    pub fn allocateCommandBuffers(allocator: std.mem.Allocator, device: *Device, allocate_info: *const CommandBufferAllocateInfo) ![]*Self {
        const command_buffers = try allocator.alloc(*CommandBuffer, allocate_info.command_buffer_count);
        try vkAllocateCommandBuffers(device, allocate_info, command_buffers.ptr).check();
        return command_buffers;
    }

    /// Start recording a command buffer
    /// Original: `vkBeginCommandBuffer`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkBeginCommandBuffer.html
    pub fn beginCommandBuffer(self: *Self, begin_info: *const CommandBufferBeginInfo) !void {
        return try vkBeginCommandBuffer(self, begin_info).check();
    }

    /// Finish recording a command buffer
    /// Original: `vkEndCommandBuffer`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkEndCommandBuffer.html
    pub fn endCommandBuffer(self: *Self) !void {
        return try vkEndCommandBuffer(self).check();
    }
};

/// Enumerant specifying a command buffer level
/// Original: `VkCommandBufferLevel`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkCommandBufferLevel.html
pub const CommandBufferLevel = enum(u32) {
    /// Specifies a primary command buffer.
    primary = 0,
    /// Specifies a secondary command buffer.
    secondary = 1,
};

/// Structure specifying the allocation parameters for command buffer object
/// Original: `CommandBufferAllocateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkCommandBufferAllocateInfo.html
pub const CommandBufferAllocateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.command_buffer_allocate_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// The command pool from which the command buffers are allocated.
    command_pool: *CommandPool,
    /// A `CommandBufferLevel` value specifying the command buffer level.
    level: CommandBufferLevel,
    /// The number of command buffers to allocate from the pool.
    command_buffer_count: u32,
};

/// Structure specifying a command buffer begin operation
/// Original: `VkCommandBufferBeginInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkCommandBufferBeginInfo.html
pub const CommandBufferBeginInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.command_buffer_begin_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// A bitmask of `CommandBufferUsageFlagBits` specifying usage behavior for the command buffer.
    flags: CommandBufferUsageFlags = .{},
    inheritance_info: ?*const CommandBufferInheritanceInfo = null,
};

/// Structure specifying command buffer inheritance information
/// Original: `VkCommandBufferInheritanceInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkCommandBufferInheritanceInfo.html
pub const CommandBufferInheritanceInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.command_buffer_inheritance_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// A `RenderPass` object defining which render passes the `CommandBuffer` will be compatible
    /// with and can be executed within.
    render_pass: *RenderPass,
    /// The index of the subpass within the render pass instance that the `CommandBuffer` will be
    /// executed within.
    subpass: u32,
    /// Can refer to the `Framebuffer` object that the `CommandBuffer` will be rendering to if it
    /// is executed within a render pass instance.
    framebuffer: ?*FrameBuffer = null,
    /// Specifies whether the command buffer can be executed while an occlusion query is active in
    /// the primary command buffer.
    occlusion_query_enable: bool = false,
    /// Specifies the query flags that can be used by an active occlusion query in the primary
    /// command buffer when this secondary command buffer is executed.
    query_flags: QueryControlFlags = .{},
    /// A bitmask of `QueryPipelineStatisticFlagBits` specifying the set of pipeline statistics
    /// that can be counted by an active query in the primary command buffer when this secondary
    /// command buffer is executed.
    pipeline_statistics: QueryPipelineStatisticFlags = .{},
};

/// Bitmask specifying usage behavior for command buffer
/// Original: `VkCommandBufferUsageFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkCommandBufferUsageFlagBits.html
pub const CommandBufferUsageFlags = packed struct(u32) {
    const Self = @This();

    one_time_submit_bit_enabled: bool = false,
    render_pass_continue_bit_enabled: bool = false,
    simultaneous_use_bit_enabled: bool = false,
    _reserved_bit_3: u1 = 0,
    _reserved_bit_4: u1 = 0,
    _reserved_bit_5: u1 = 0,
    _reserved_bit_6: u1 = 0,
    _reserved_bit_7: u1 = 0,
    _reserved_bit_8: u1 = 0,
    _reserved_bit_9: u1 = 0,
    _reserved_bit_10: u1 = 0,
    _reserved_bit_11: u1 = 0,
    _reserved_bit_12: u1 = 0,
    _reserved_bit_13: u1 = 0,
    _reserved_bit_14: u1 = 0,
    _reserved_bit_15: u1 = 0,
    _reserved_bit_16: u1 = 0,
    _reserved_bit_17: u1 = 0,
    _reserved_bit_18: u1 = 0,
    _reserved_bit_19: u1 = 0,
    _reserved_bit_20: u1 = 0,
    _reserved_bit_21: u1 = 0,
    _reserved_bit_22: u1 = 0,
    _reserved_bit_23: u1 = 0,
    _reserved_bit_24: u1 = 0,
    _reserved_bit_25: u1 = 0,
    _reserved_bit_26: u1 = 0,
    _reserved_bit_27: u1 = 0,
    _reserved_bit_28: u1 = 0,
    _reserved_bit_29: u1 = 0,
    _reserved_bit_30: u1 = 0,
    _reserved_bit_31: u1 = 0,
};

/// Bitmask specifying constraints on a query
/// Original: `VkQueryControlFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkQueryControlFlagBits.html
pub const QueryControlFlags = packed struct(u32) {
    const Self = @This();

    precise_bit_enabled: bool = false,
    _reserved_bit_1: u1 = 0,
    _reserved_bit_2: u1 = 0,
    _reserved_bit_3: u1 = 0,
    _reserved_bit_4: u1 = 0,
    _reserved_bit_5: u1 = 0,
    _reserved_bit_6: u1 = 0,
    _reserved_bit_7: u1 = 0,
    _reserved_bit_8: u1 = 0,
    _reserved_bit_9: u1 = 0,
    _reserved_bit_10: u1 = 0,
    _reserved_bit_11: u1 = 0,
    _reserved_bit_12: u1 = 0,
    _reserved_bit_13: u1 = 0,
    _reserved_bit_14: u1 = 0,
    _reserved_bit_15: u1 = 0,
    _reserved_bit_16: u1 = 0,
    _reserved_bit_17: u1 = 0,
    _reserved_bit_18: u1 = 0,
    _reserved_bit_19: u1 = 0,
    _reserved_bit_20: u1 = 0,
    _reserved_bit_21: u1 = 0,
    _reserved_bit_22: u1 = 0,
    _reserved_bit_23: u1 = 0,
    _reserved_bit_24: u1 = 0,
    _reserved_bit_25: u1 = 0,
    _reserved_bit_26: u1 = 0,
    _reserved_bit_27: u1 = 0,
    _reserved_bit_28: u1 = 0,
    _reserved_bit_29: u1 = 0,
    _reserved_bit_30: u1 = 0,
    _reserved_bit_31: u1 = 0,

    /// Specifies the precision of occlusion queries.
    pub const precise_bit = Self{ .precise_bit_enabled = true };
};

/// Bitmask specifying queried pipeline statistics
/// Original: `VkQueryPipelineStatisticFlagBits`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkQueryPipelineStatisticFlagBits.html
pub const QueryPipelineStatisticFlags = packed struct(u32) {
    const Self = @This();

    input_assembly_vertices_bit_enabled: bool = false,
    input_assembly_primitives_bit_enabled: bool = false,
    vertex_shader_invocations_bit_enabled: bool = false,
    geometry_shader_invocations_bit_enabled: bool = false,
    geometry_shader_primitives_bit_enabled: bool = false,
    clipping_invocations_bit_enabled: bool = false,
    clipping_primitives_bit_enabled: bool = false,
    fragment_shader_invocations_bit_enabled: bool = false,
    tessellation_control_shader_patches_bit_enabled: bool = false,
    tessellation_evaluation_shader_invocations_bit_enabled: bool = false,
    compute_shader_invocations_bit_enabled: bool = false,
    task_shader_invocations_bit_ext_enabled: bool = false,
    mesh_shader_invocations_bit_ext_enabled: bool = false,
    cluster_culling_shader_invocations_bit_huawei_enabled: bool = false,
    _reserved_bit_14: u1 = 0,
    _reserved_bit_15: u1 = 0,
    _reserved_bit_16: u1 = 0,
    _reserved_bit_17: u1 = 0,
    _reserved_bit_18: u1 = 0,
    _reserved_bit_19: u1 = 0,
    _reserved_bit_20: u1 = 0,
    _reserved_bit_21: u1 = 0,
    _reserved_bit_22: u1 = 0,
    _reserved_bit_23: u1 = 0,
    _reserved_bit_24: u1 = 0,
    _reserved_bit_25: u1 = 0,
    _reserved_bit_26: u1 = 0,
    _reserved_bit_27: u1 = 0,
    _reserved_bit_28: u1 = 0,
    _reserved_bit_29: u1 = 0,
    _reserved_bit_30: u1 = 0,
    _reserved_bit_31: u1 = 0,

    /// Specifies that queries managed by the pool will count the number of vertices processed by
    /// the input assembly stage.
    pub const input_assembly_vertices_bit = Self{ .input_assembly_vertices_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of primitives processed by
    /// the input assembly stage.
    pub const input_assembly_primitives_bit = Self{ .input_assembly_primitives_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of vertex shader
    /// invocations.
    pub const vertex_shader_invocations_bit = Self{ .vertex_shader_invocations_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of geometry shader
    /// invocations.
    pub const geometry_shader_invocations_bit = Self{ .geometry_shader_invocations_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of primitives generated by
    /// geometry shader invocations.
    pub const geometry_shader_primitives_bit = Self{ .geometry_shader_primitives_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of primitives processed by
    /// the Primitive Clipping stage of the pipeline.
    pub const clipping_invocations_bit = Self{ .clipping_invocations_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of primitives output by
    /// the Primitive Clipping stage of the pipeline.
    pub const clipping_primitives_bit = Self{ .clipping_primitives_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of fragment shader
    /// invocations.
    pub const fragment_shader_invocations_bit = Self{ .fragment_shader_invocations_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of patches processed by
    /// the tessellation control shader.
    pub const tessellation_control_shader_patches_bit = Self{ .tessellation_control_shader_patches_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of invocations of the
    /// tessellation evaluation shader.
    pub const tessellation_evaluation_shader_invocations_bit = Self{ .tessellation_evaluation_shader_invocations_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of compute shader
    /// invocations.
    pub const compute_shader_invocations_bit = Self{ .icompute_shader_invocations_bit_enabled = true };
    /// Specifies that queries managed by the pool will count the number of task shader
    /// invocations.
    pub const task_shader_invocations_bit_ext = Self{ .task_shader_invocations_bit_ext_enabled = true };
    /// specifies that queries managed by the pool will count the number of mesh shader
    /// invocations.
    pub const mesh_shader_invocations_bit_ext = Self{ .mesh_shader_invocations_bit_ext_enabled = true };
    /// Provided by VK_HUAWEI_cluster_culling_shader
    pub const cluster_culling_shader_invocations_bit_huawei = Self{ .cluster_culling_shader_invocations_bit_huawei_enabled = true };
};

extern fn vkAllocateCommandBuffers(device: *Device, pAllocateInfo: *const CommandBufferAllocateInfo, pCommandBuffer: [*]*CommandBuffer) callconv(.c) Result;
extern fn vkBeginCommandBuffer(commandBuffer: *CommandBuffer, pBeginInfo: *const CommandBufferBeginInfo) callconv(.c) Result;
extern fn vkEndCommandBuffer(commandBuffer: *CommandBuffer) callconv(.c) Result;
