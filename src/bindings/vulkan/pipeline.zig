const std = @import("std");

const pipeline_layout = @import("pipeline_layout.zig");
const shared = @import("shared.zig");

const Device = @import("device.zig").Device;
const RenderPass = @import("render_pass.zig").RenderPass;
const ShaderModule = @import("shader_module.zig").ShaderModule;

const PipelineColorBlendStateCreateInfo = pipeline_layout.PipelineColorBlendStateCreateInfo;
const PipelineDynamicStateCreateInfo = pipeline_layout.PipelineDynamicStateCreateInfo;
const PipelineLayout = pipeline_layout.PipelineLayout;
const PipelineMultisampleStateCreateInfo = pipeline_layout.PipelineMultisampleStateCreateInfo;
const PipelineRasterizationStateCreateInfo = pipeline_layout.PipelineRasterizationStateCreateInfo;
const PipelineViewportStateCreateInfo = pipeline_layout.PipelineViewportStateCreateInfo;
const ShaderStageFlags = pipeline_layout.ShaderStageFlags;
const AllocationCallbacks = shared.AllocationCallbacks;
const Format = shared.Format;
const Result = shared.Result;
const StructureType = shared.StructureType;

/// Opaque handle to a pipeline object
/// Original: `VkPipeline`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipeline.html
pub const Pipeline = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    /// Note: This only creates a single pipeline. If you need to create multiple pipelines, please
    /// use the `createGraphicsPipelines` method
    pub fn init(allocator: std.mem.Allocator, device: *Device, cache: ?*PipelineCache, create_info: GraphicsPipelineCreateInfo) !*Self {
        const pipelines = try createGraphicsPipelines(allocator, device, cache, 1, &.{create_info}, null);
        return &pipelines[0].*;
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self, device: *Device) void {
        return self.destroyPipeline(device, null);
    }

    /// Create graphics pipelines
    /// Original: `vkCreateGraphicsPipeline`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateGraphicsPipelines.html
    pub fn createGraphicsPipelines(allocator: std.mem.Allocator, device: *Device, cache: ?*PipelineCache, create_info_count: u32, create_infos: [*]const GraphicsPipelineCreateInfo, allocation_callbacks: ?*const AllocationCallbacks) ![]*Self {
        const graphics_pipelines = try allocator.alloc(*Pipeline, create_info_count);
        try vkCreateGraphicsPipelines(device, cache, create_info_count, create_infos, allocation_callbacks, graphics_pipelines.ptr).check();
        return graphics_pipelines;
    }

    /// Destroy a pipeline object
    /// Original: `vkDestroyPipeline`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyPipeline.html
    pub fn destroyPipeline(self: *Self, device: *Device, allocation_callbacks: ?*const AllocationCallbacks) void {
        return vkDestroyPipeline(device, self, allocation_callbacks);
    }
};

/// Opaque handle to a pipeline cache object
/// Original: `VkPipelineCache`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineCache.html
pub const PipelineCache = opaque {};

/// Comparison operator for depth, stencil, and sampler operations
/// Original: `VkCompareOp`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkCompareOp.html
pub const CompareOp = enum(u32) {
    /// Specifies that the comparison always evaluates false.
    never = 0,
    /// Specifies that the comparison evaluates reference < test.
    less = 1,
    /// Specifies that the comparison evaluates reference = test.
    equal = 2,
    /// Specifies that the comparison evaluates reference ≤ test.
    less_or_equal = 3,
    /// Specifies that the comparison evaluates reference > test.
    greater = 4,
    /// Specifies that the comparison evaluates reference ≠ test.
    not_equal = 5,
    /// Specifies that the comparison evaluates reference ≥ test.
    greater_or_equal = 6,
    /// Specifies that the comparison always evaluates true.
    always = 7,
};

/// Supported primitive topologies
/// Original: `VkPrimitiveTopology`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPrimitiveTopology.html
pub const PrimitiveTopology = enum(u32) {
    /// Specifies a series of separate point primitives.
    point_list = 0,
    /// Specifies a series of separate line primitives.
    line_list = 1,
    /// Specifies a series of connected line primitives with consecutive lines sharing a vertex.
    line_strip = 2,
    /// Specifies a series of separate triangle primitives.
    triangle_list = 3,
    /// Specifies a series of connected triangle primitives with consecutive triangles sharing an
    /// edge.
    triangle_strip = 4,
    /// Specifies a series of connected triangle primitives with all triangles sharing a common
    /// vertex.
    triangle_fan = 5,
    /// Specifies a series of separate line primitives with adjacency.
    line_list_with_adjacency = 6,
    /// Specifies a series of connected line primitives with adjacency, with consecutive primitives
    /// sharing three vertices.
    line_strip_with_adjacency = 7,
    /// Specifies a series of separate triangle primitives with adjacency.
    triangle_list_with_adjacency = 8,
    /// Specifies connected triangle primitives with adjacency, with consecutive triangles sharing
    /// an edge.
    triangle_strip_with_adjacency = 9,
    /// Specifies separate patch primitives.
    patch_list = 10,
};

/// Stencil comparison function
/// Original: `VkStencilOp`
/// See: https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VkStencilOp.html
pub const StencilOp = enum(u32) {
    /// Keeps the current value.
    keep = 0,
    /// Sets the value to 0.
    zero = 1,
    /// Sets the value to `reference`.
    replace = 2,
    /// Increments the current value and clamps to the maximum representable unsigned value.
    increment_and_clamp = 3,
    /// Decrements the current value and clamps to 0.
    decrement_and_clamp = 4,
    /// Bitwise-inverts the current value.
    invert = 5,
    /// Increments the current value and wraps to 0 when the maximum value would have been
    /// exceeded.
    increment_and_wrap = 6,
    /// Decrements the current value and wraps to the maximum possible value when the value would
    /// go below 0.
    decrement_and_wrap = 7,
};

/// Specify rate at which vertex attributes are pulled from buffers
/// Original: `VkVertexInputRate`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkVertexInputRate.html
pub const VertexInputRate = enum(u32) {
    /// Specifies that vertex attribute addressing is a function of the vertex index.
    vertex = 0,
    /// Specifies that vertex attribute addressing is a function of the instance index.
    instance = 1,
};

/// Structure specifying parameters of a newly created graphics pipeline
/// Original: `vkGraphicsPipelineCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkGraphicsPipelineCreateInfo.html
pub const GraphicsPipelineCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_layout_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// A bitmask of `PipelineCreateFlagBits` specifying how the pipeline will be generated.
    flags: PipelineCreateFlags = .{},
    /// The number of entries in the `stages` array.
    stage_count: u32 = 0,
    /// A pointer to an array of `stage_count` `PipelineShaderStageCreateInfo` structures
    /// describing the set of the shader stages to be included in the graphics pipeline.
    stages: ?[*]const PipelineShaderStageCreateInfo = null,
    /// A pointer to a `PipelineVertexInputStateCreateInfo` structure.
    vertex_input_state: ?*const PipelineVertexInputStateCreateInfo = null,
    /// A pointer to a `PipelineInputAssemblyStateCreateInfo` structure which determines input
    /// assembly behavior for vertex shading, as described in Drawing Commands.
    input_assembly_state: ?*const PipelineInputAssemblyStateCreateInfo = null,
    /// A pointer to a `PipelineTessellationStateCreateInfo` structure defining tessellation state
    /// used by tessellation shaders.
    tessellation_state: ?*const PipelineTessellationStateCreateInfo = null,
    /// A pointer to a `PipelineViewportStateCreateInfo` structure defining viewport state used
    /// when rasterization is enabled.
    viewport_state: ?*const PipelineViewportStateCreateInfo = null,
    /// A pointer to a `PipelineRasterizationStateCreateInfo` structure defining rasterization
    /// state.
    rasterization_state: ?*const PipelineRasterizationStateCreateInfo = null,
    /// A pointer to a `PipelineMultisampleStateCreateInfo` structure defining multisample state
    /// used when rasterization is enabled.
    multisample_state: ?*const PipelineMultisampleStateCreateInfo = null,
    /// A pointer to a `PipelineDepthStencilStateCreateInfo` structure defining depth/stencil state
    /// used when rasterization is enabled for depth or stencil attachments accessed during
    /// rendering.
    depth_stencil_state: ?*const PipelineDepthStencilStateCreateInfo = null,
    /// A pointer to a `PipelineColorBlendStateCreateInfo` structure defining color blend state
    /// used when rasterization is enabled for any color attachments accessed during rendering.
    color_blend_state: ?*const PipelineColorBlendStateCreateInfo = null,
    /// A pointer to a `PipelineDynamicStateCreateInfo` structure defining which properties of the
    /// pipeline state object are dynamic and can be changed independently of the pipeline state.
    dynamic_state: ?*const PipelineDynamicStateCreateInfo = null,
    /// The description of binding locations used by both the pipeline and descriptor sets used
    /// with the pipeline.
    layout: ?*PipelineLayout = null,
    /// A handle to a render pass object describing the environment in which the pipeline will be
    /// used.
    render_pass: ?*RenderPass = null,
    /// The index of the subpass in the render pass where this pipeline will be used.
    subpass: u32 = 0,
    /// A pipeline to derive from.
    base_pipeline_handle: ?*Pipeline = null,
    /// An index into the pCreateInfos parameter to use as a pipeline to derive from.
    base_pipeline_index: i32 = 0,
};

/// Bitmask controlling how a pipeline is created
/// Original: `VkPipelineCreateFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineCreateFlagBits.html
/// TODO: Doc comments, etc
pub const PipelineCreateFlags = packed struct(u32) {
    disable_optimization_bit_enabled: bool = false,
    allow_derivatives_bit_enabled: bool = false,
    derivative_bit_enabled: bool = false,
    view_index_from_device_index_bit_enabled: bool = false,
    dispatch_base_bit_enabled: bool = false,
    defer_compile_bit_nv_enabled: bool = false,
    capture_statistics_bit_khr_enabled: bool = false,
    capture_internal_representations_bit_khr_enabled: bool = false,
    fail_on_pipeline_compile_required_bit_enabled: bool = false,
    early_return_on_failure_bit_enabled: bool = false,
    link_time_optimization_bit_ext_enabled: bool = false,
    library_bit_khr_enabled: bool = false,
    ray_tracing_skip_triangles_bit_khr_enabled: bool = false,
    ray_tracing_skip_aabbs_bit_khr_enabled: bool = false,
    ray_tracing_no_null_any_hit_shaders_bit_khr_enabled: bool = false,
    ray_tracing_no_null_closest_hit_shaders_bit_khr_enabled: bool = false,
    ray_tracing_no_null_miss_shaders_bit_khr_enabled: bool = false,
    ray_tracing_no_null_intersection_shaders_bit_khr_enabled: bool = false,
    indirect_bindable_bit_nv_enabled: bool = false,
    ray_tracing_shader_group_handle_capture_replay_bit_khr_enabled: bool = false,
    ray_tracing_allow_motion_bit_nv_enabled: bool = false,
    rendering_fragment_shading_rate_attachment_bit_khr_enabled: bool = false,
    rendering_fragment_density_map_attachment_bit_ext_enabled: bool = false,
    retain_link_time_optimization_info_bit_ext_enabled: bool = false,
    ray_tracing_opacity_micromap_bit_ext_enabled: bool = false,
    color_attachment_feedback_loop_bit_ext_enabled: bool = false,
    depth_stencil_attachment_feedback_loop_bit_ext_enabled: bool = false,
    no_protected_access_bit_ext_enabled: bool = false,
    ray_tracing_displacement_micromap_bit_nv_enabled: bool = false,
    descriptor_buffer_bit_ext_enabled: bool = false,
    protected_access_only_bit_ext_enabled: bool = false,
    _reserved_bit_31: u1 = 0,
};

/// Bitmask specifying additional depth/stencil state information.
/// Original: `VkPipelineDepthStencilCreateFlags`
/// https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineDepthStencilStateCreateFlagBits.html
pub const PipelineDepthStencilStateCreateFlags = packed struct(u32) {
    const Self = @This();

    rasterization_order_attachment_depth_access_bit_ext_enabled: bool = false,
    rasterization_order_attachment_stencil_access_bit_ext_enabled: bool = false,
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

    /// Specifies that access to the depth aspects of depth/stencil and input attachments will
    /// have implicit framebuffer-local memory dependencies.
    pub const rasterization_order_attachment_depth_access_bit_ext = Self{
        .rasterization_order_attachment_depth_access_bit_ext_enabled = true,
    };
    /// Specifies that access to the stencil aspects of depth/stencil and input attachments will
    /// have implicit framebuffer-local memory dependencies.
    pub const rasterization_order_attachment_stencil_access_bit_ext = Self{
        .rasterization_order_attachment_stencil_access_bit_ext_enabled = true,
    };
};

/// Structure specifying parameters of a newly created pipeline depth stencil state
/// Original: `VkPipelineDepthStencilStateCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineDepthStencilStateCreateInfo.html
pub const PipelineDepthStencilStateCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_depth_stencil_state_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// A bitmask of `PipelineDepthStencilStateCreateFlagBits` specifying additional depth/stencil
    /// state information.
    flags: PipelineDepthStencilStateCreateFlags = .{},
    /// Controls whether depth testing is enabled.
    depth_test_enable: bool = false,
    /// Controls whether depth writes are enabled when `depth_test_enable` is `true.
    depth_write_enable: bool = false,
    /// A `CompareOp` value specifying the comparison operator to use in the Depth Comparison step
    /// of the depth test.
    depth_compare_op: CompareOp,
    /// Controls whether depth bounds testing is enabled.
    depth_bounds_test_enable: bool = false,
    /// Controls whether stencil testing is enabled.
    stencil_test_enable: bool = false,
    /// A `StencilOpState` value controlling the front parameters of the stencil test.
    front: StencilOpState,
    /// A `StencilOpState` value controlling the back parameters of the stencil test.
    back: StencilOpState,
    /// The minimum depth bound used in the depth bounds test.
    min_depth_bounds: f32 = 0.0,
    /// The maximum depth bound used in the depth bounds test.
    max_depth_bounds: f32 = 0.0,
};

pub const PipelineInputAssemblyStateCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_input_assembly_state_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use
    flags: u32 = 0,
    /// A `PrimitiveTopology` defining the primitive topology.
    topology: PrimitiveTopology,
    /// Controls whether a special vertex index value is treated as restarting the assembly of primitives.
    primitive_restart_enable: bool,
};

/// Bitmask controlling how a pipeline shader stage is created
/// Original: `VkPipelineShaderStageCreateFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineShaderStageCreateFlagBits.html
pub const PipelineShaderStageCreateFlags = packed struct(u32) {
    const Self = @This();

    allow_varying_subgroup_size_bit_enabled: bool = false,
    require_full_subgroups_bit_enabled: bool = false,
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

    /// Specifies that the SubgroupSize may vary in the shader stage.
    pub const allow_varying_subgroup_size_bit = Self{ .allow_varying_subgroup_size_bit_enabled = true };
    /// Specifies that the subgroup sizes must be launched with all invocations active in the task,
    /// mesh, or compute stage.
    pub const require_full_subgroups_bi = Self{ .require_full_subgroups_bi_enabled = true };
};

/// Structure specifying parameters of a newly created pipeline shader stage
/// Original: `VkPipelineShaderStageCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineShaderStageCreateInfo.html
pub const PipelineShaderStageCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_shader_stage_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// A bitmask of `PipelineShaderStageCreateFlagBits` specifying how the pipeline shader stage
    /// will be generated.
    flags: PipelineShaderStageCreateFlags = .{},
    /// A `ShaderStageFlags` value specifying a single pipeline stage.
    stage: ShaderStageFlags = .{},
    /// An optional optionally `ShaderModule` object containing the shader code for this stage.
    module: *ShaderModule,
    /// A  pointer to a null-terminated UTF-8 string specifying the entry point name of the shader
    /// for this stage.
    name: ?[*:0]const u8 = null,
    /// An optional pointer to a `SpecializationInfo` structure, as described in Specialization
    /// Constants.
    specialization_info: ?*SpecializationInfo = null,
};

/// Structure specifying parameters of a newly created pipeline tessellation state
/// Original: `VkPipelineTessellationStateCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineTessellationStateCreateInfo.html
pub const PipelineTessellationStateCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_tessellation_state_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    /// The number of control points per patch.
    patch_control_points: u32,
};

/// Structure specifying parameters of a newly created pipeline vertex input state
/// Original: `VkPipelineVertexInputStateCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineVertexInputStateCreateInfo.html
pub const PipelineVertexInputStateCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_vertex_input_state_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    /// The number of vertex binding descriptions provided in `vertex_binding_descriptions`.
    vertex_binding_description_count: u32 = 0,
    /// A pointer to an array of `VertexInputBindingDescription` structures.
    vertex_binding_descriptions: ?[*]const VertexInputBindingDescription = null,
    /// The number of vertex binding descriptions provided in `vertex_binding_descriptions`.
    vertex_attribute_description_count: u32 = 0,
    /// A pointer to an array of `VertexInputAttributeDescription` structures.
    vertex_attribute_descriptions: ?[*]const VertexInputAttributeDescription = null,
};

/// Structure specifying specialization information
/// Original: `VkSpecializationInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSpecializationInfo.html
pub const SpecializationInfo = extern struct {
    /// The number of entries in the `map_entries` array.
    man_entry_count: u32 = 0,
    /// A pointer to an array of `SpecializationMapEntry` structures, which map constant IDs to
    /// offsets in `data`.
    map_entries: ?[*]const SpecializationMapEntry = null,
    /// The byte size of the `data` buffer.
    data_size: usize = 0,
    /// The actual constant values to specialize with.
    data: ?*const anyopaque = null,
};

/// Structure specifying a specialization map entry
/// Original: `VkSpecializationMaoEntry`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSpecializationMapEntry.html
pub const SpecializationMapEntry = extern struct {
    /// The ID of the specialization constant in SPIR-V.
    constant_id: u32,
    /// The byte offset of the specialization constant value within the supplied data buffer.
    offset: u32,
    /// The byte size of the specialization constant value within the supplied data buffer.
    size: usize,
};

/// Structure specifying stencil operation state
/// Original: `VkStencilOp`
/// See: https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VkStencilOpState.html
pub const StencilOpState = extern struct {
    /// A `StencilOp` value specifying the action performed on samples that fail the stencil test.
    fail_op: StencilOp,
    /// A `StencilOp` value specifying the action performed on samples that pass both the depth and
    /// stencil tests.
    pass_op: StencilOp,
    /// A `StencilOp` value specifying the action performed on samples that pass the stencil test
    /// and fail the depth test.
    depth_fail_op: StencilOp,
    /// A `CompareOp` value specifying the comparison operator used in the stencil test.
    compare_op: CompareOp,
    /// Selects the bits of the unsigned integer stencil values participating in the stencil test.
    compare_mask: u32,
    /// Selects the bits of the unsigned integer stencil values updated by the stencil test in the
    /// stencil framebuffer attachment.
    write_mask: u32,
    /// An integer stencil reference value that is used in the unsigned stencil comparison.
    reference: u32,
};

/// Structure specifying vertex input attribute description
/// Original: `Vk`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkVertexInputAttributeDescription.html
pub const VertexInputAttributeDescription = extern struct {
    /// The shader input location number for this attribute.
    location: u32,
    /// The binding number which this attribute takes its data from.
    binding: u32,
    /// The size and type of the vertex attribute data.
    format: Format,
    /// A byte offset of this attribute relative to the start of an element in the vertex input
    /// binding.
    offset: u32,
};

/// Structure specifying vertex input binding description
/// Original: `VkVertexInputBindingDescription`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkVertexInputBindingDescription.html
pub const VertexInputBindingDescription = extern struct {
    /// The binding number that this structure describes.
    bindings: u32,
    /// The byte stride between consecutive elements within the buffer.
    stride: u32,
    /// A `VertexInputRate` value specifying whether vertex attribute addressing is a function of
    /// the vertex index or of the instance index.
    input_rate: VertexInputRate,
};

extern fn vkCreateGraphicsPipelines(device: *Device, pipelineCache: ?*PipelineCache, createInfoCount: u32, pCreateInfos: [*]const GraphicsPipelineCreateInfo, pAllocator: ?*const AllocationCallbacks, pipelines: ?[*]*Pipeline) Result;
extern fn vkDestroyPipeline(device: *Device, pipeline: *Pipeline, pAllocator: ?*const AllocationCallbacks) void;
