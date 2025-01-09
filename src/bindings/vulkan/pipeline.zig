const shared = @import("shared.zig");

const Device = @import("device.zig").Device;

const AllocationCallbacks = shared.AllocationCallbacks;
const Extent2d = shared.Extent2d;
const Offset2d = shared.Offset2d;
const Result = shared.Result;
const SampleCountFlags = shared.SampleCountFlags;
const StructureType = shared.StructureType;

/// Opaque handle to a descriptor set layout object
/// Original: `VkDescriptorSetLayout`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkDescriptorSetLayout.html
pub const DescriptorSetLayout = opaque {};

/// Opaque handle to a pipeline layout object
/// Original: `VkPipelineLayout`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineLayout.html
pub const PipelineLayout = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(device: *Device, create_info: *const PipelineLayoutCreateInfo) !*Self {
        return try createPipelineLayout(device, create_info, null);
    }

    /// Creates a new pipeline layout object
    /// Original: `vkCreatePipelineLayout`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreatePipelineLayout.html
    pub fn createPipelineLayout(device: *Device, create_info: *const PipelineLayoutCreateInfo, allocation_callbacks: ?*const AllocationCallbacks) !*Self {
        var pipeline_layout: *Self = undefined;
        try vkCreatePipelineLayout(device, create_info, allocation_callbacks, &pipeline_layout).check();
        return pipeline_layout;
    }
};

/// Framebuffer blending factors
/// Original: VkBlendFactor
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkBlendFactor.html
pub const BlendFactor = enum(u32) {
    zero = 0,
    one = 1,
    src_color = 2,
    one_minus_src_color = 3,
    dst_color = 4,
    one_minus_dst_color = 5,
    src_alpha = 6,
    one_minus_src_alpha = 7,
    dst_alpha = 8,
    one_minus_dst_alpha = 9,
    constant_color = 10,
    one_minus_constant_color = 11,
    constant_alpha = 12,
    one_minus_constant_alpha = 13,
    src_alpha_saturate = 14,
    src1_color = 15,
    one_minus_src1_color = 16,
    src1_alpha = 17,
    one_minus_src1_alpha = 18,
};

/// Framebuffer blending operations
/// Original: `VkBlendOp`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkBlendOp.html
pub const BlendOp = enum(u32) {
    add = 0,
    subtract = 1,
    reverse_subtract = 2,
    min = 3,
    max = 4,
    zero_ext = 1000148000,
    src_ext = 1000148001,
    dst_ext = 1000148002,
    src_over_ext = 1000148003,
    dst_over_ext = 1000148004,
    src_in_ext = 1000148005,
    dst_in_ext = 1000148006,
    src_out_ext = 1000148007,
    dst_out_ext = 1000148008,
    src_atop_ext = 1000148009,
    dst_atop_ext = 1000148010,
    xor_ext = 1000148011,
    multiply_ext = 1000148012,
    screen_ext = 1000148013,
    overlay_ext = 1000148014,
    darken_ext = 1000148015,
    lighten_ext = 1000148016,
    colordodge_ext = 1000148017,
    colorburn_ext = 1000148018,
    hardlight_ext = 1000148019,
    softlight_ext = 1000148020,
    difference_ext = 1000148021,
    exclusion_ext = 1000148022,
    invert_ext = 1000148023,
    invert_rgb_ext = 1000148024,
    lineardodge_ext = 1000148025,
    linearburn_ext = 1000148026,
    vividlight_ext = 1000148027,
    linearlight_ext = 1000148028,
    pinlight_ext = 1000148029,
    hardmix_ext = 1000148030,
    hsl_hue_ext = 1000148031,
    hsl_saturation_ext = 1000148032,
    hsl_color_ext = 1000148033,
    hsl_luminosity_ext = 1000148034,
    plus_ext = 1000148035,
    plus_clamped_ext = 1000148036,
    plus_clamped_alpha_ext = 1000148037,
    plus_darker_ext = 1000148038,
    minus_ext = 1000148039,
    minus_clamped_ext = 1000148040,
    contrast_ext = 1000148041,
    invert_ovg_ext = 1000148042,
    red_ext = 1000148043,
    green_ext = 1000148044,
    blue_ext = 1000148045,
};

/// Indicate which dynamic state is taken from dynamic state commands
/// Original: `VkDynamicState`
/// See: https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VkDynamicState.html
/// TODO: Finish doc comments
pub const DynamicState = enum(u32) {
    viewport = 0,
    scissor = 1,
    line_width = 2,
    depth_bias = 3,
    blend_constants = 4,
    depth_bounds = 5,
    stencil_compare_mask = 6,
    stencil_write_mask = 7,
    stencil_reference = 8,
    cull_mode = 1000267000,
    front_face = 1000267001,
    primitive_topology = 1000267002,
    viewport_with_count = 1000267003,
    scissor_with_count = 1000267004,
    vertex_input_binding_stride = 1000267005,
    depth_test_enable = 1000267006,
    depth_write_enable = 1000267007,
    depth_compare_op = 1000267008,
    depth_bounds_test_enable = 1000267009,
    stencil_test_enable = 1000267010,
    stencil_op = 1000267011,
    rasterizer_discard_enable = 1000377001,
    depth_bias_enable = 1000377002,
    primitive_restart_enable = 1000377004,
    discard_rectangle_ext = 1000099000,
    discard_rectangle_enable_ext = 1000099001,
    discard_rectangle_mode_ext = 1000099002,
    sample_locations_ext = 1000143000,
    fragment_shading_rate_khr = 1000226000,
    vertex_input_ext = 1000352000,
    patch_control_points_ext = 1000377000,
    logic_op_ext = 1000377003,
    color_write_enable_ext = 1000381000,
    line_stipple_khr = 1000259000,
};

/// Interpret polygon front-facing orientation
/// Original: `VkFrontFace`
/// See: https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VkFrontFace.html
pub const FrontFace = enum(u32) {
    /// specifies that a triangle with positive area is considered front-facing.
    counter_clockwise = 0,
    /// specifies that a triangle with negative area is considered front-facing.
    clockwise = 1,
};

/// Framebuffer logical operations
/// Original: `VkLogicOp`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkLogicOp.html
pub const LogicOp = enum(u32) {
    clear = 0,
    @"and" = 1,
    and_reverse = 2,
    copy = 3,
    and_inverted = 4,
    no_op = 5,
    xor = 6,
    @"or" = 7,
    nor = 8,
    equivalent = 9,
    invert = 10,
    or_reverse = 11,
    copy_inverted = 12,
    or_inverted = 13,
    nand = 14,
    set = 15,
};

/// Control polygon rasterization mode
/// Original: `VkPolygonMode`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPolygonMode.html
pub const PolygonMode = enum(u32) {
    /// Specifies that polygons are rendered using the polygon rasterization rules in this section.
    fill = 0,
    /// Specifies that polygon edges are drawn as line segments.
    line = 1,
    /// Specifies that polygon vertices are drawn as points.
    point = 2,
    /// Specifies that polygons are rendered using polygon rasterization rules, modified to
    /// consider a sample within the primitive if the sample location is inside the axis-aligned
    /// bounding box of the triangle after projection.
    fill_rectangle_nv = 1000153000,
};

/// Bitmask controlling which components are written to the framebuffer
/// Original: `VkColorComponentFlagBits`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkColorComponentFlagBits.html
pub const ColorComponentFlags = packed struct(u32) {
    /// Specifies that the R value is written to the color attachment for the appropriate sample.
    r_bit_enabled: bool = false,
    /// Specifies that the G value is written to the color attachment for the appropriate sample.
    g_bit_enabled: bool = false,
    /// Specifies that the B value is written to the color attachment for the appropriate sample.
    b_bit_enabled: bool = false,
    /// Specifies that the A value is written to the color attachment for the appropriate sample.
    a_bit_enabled: bool = false,
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

/// Bitmask controlling triangle culling
/// Original: `VkCullModeFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkCullModeFlagBits.html
pub const CullModeFlags = packed struct(u32) {
    const Self = @This();

    front_bit_enabled: bool = false,
    back_bit_enabled: bool = false,
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

    /// Specifies that no triangles are discarded
    pub const none = Self{};
    /// Specifies that front-facing triangles are discarded
    pub const front_bit = Self{ .front_bit_enabled = true };
    /// Specifies that back-facing triangles are discarded
    pub const back_bit = Self{ .back_bit_enabled = true };
    /// Specifies that all triangles are discarded.
    pub const front_and_back = Self{ .front_bit_enabled = true, .back_bit_enabled = true };
};

/// Structure specifying a pipeline color blend attachment state
/// Original: `VkPipelineColorBlendAttachmentState`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineColorBlendAttachmentState.html
pub const PipelineColorBlendAttachmentState = extern struct {
    /// Controls whether blending is enabled for the corresponding color attachment.
    blend_enable: bool = false,
    /// Selects which blend factor is used to determine the source factors
    src_color_blend_factor: BlendFactor = .one,
    /// Selects which blend factor is used to determine the destination factors
    dst_color_blend_factor: BlendFactor = .zero,
    /// Selects which blend operation is used to calculate the RGB values to write to the color
    /// attachment.
    color_blend_op: BlendOp = .add,
    /// Selects which blend factor is used to determine the source factor
    src_alpha_blend_factor: BlendFactor = .one,
    /// Selects which blend factor is used to determine the destination factor
    dst_alpha_blend_factor: BlendFactor = .zero,
    /// Selects which blend operation is used to calculate the alpha values to write to the color
    /// attachment.
    alpha_blend_op: BlendOp = .add,
    /// A bitmask of `ColorComponentFlagBits` specifying which of the R, G, B, and/or A components
    /// are enabled for writing, as described for the Color Write Mask.
    color_write_mask: ColorComponentFlags = ColorComponentFlags{ .r_bit_enabled = true, .g_bit_enabled = true, .b_bit_enabled = true, .a_bit_enabled = true },
};

/// Bitmask specifying additional parameters of an image
/// Original: `VkPipelineColorBlendStateCreateFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineColorBlendStateCreateFlagBits.html
pub const PipelineColorBlendStateCreateFlags = packed struct(u32) {
    const Self = @This();
    create_rasterization_order_attachment_access_bit_ext_enabled: bool = false,
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

    /// Specifies that access to color and input attachments will have implicit framebuffer-local
    /// memory dependencies, allowing applications to express custom blending operations in a
    /// fragment shader.
    pub const create_rasterization_order_attachment_access_bit_ext = Self{ .create_rasterization_order_attachment_access_bit_ext_enabled = true };
};

/// Structure specifying parameters of a newly created pipeline color blend state
/// Original: `VkPipelineColorBlendStateCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineColorBlendStateCreateInfo.html
pub const PipelineColorBlendStateCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_dynamic_state_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// A bitmask of `PipelineColorBlendStateCreateFlagBits` specifying additional color blending
    /// information.
    flags: PipelineColorBlendStateCreateFlags = .{},
    /// Controls whether to apply Logical Operations.
    logic_op_enable: bool = false,
    /// Selects which logical operation to apply.
    logic_op: LogicOp = .clear,
    /// The number of VkPipelineColorBlendAttachmentState elements in pAttachments.
    attachment_count: u32,
    /// A pointer to an array of VkPipelineColorBlendAttachmentState structures defining blend
    /// state for each color attachment.
    attachments: ?[*]const PipelineColorBlendAttachmentState = null,
    /// A pointer to an array of four values used as the R, G, B, and A components of the blend
    /// constant that are used in blending, depending on the blend factor.
    blend_constants: *const [4]f32,
};

/// Structure specifying parameters of a newly created pipeline dynamic state
/// Original: `VkPipelineDynamicStateCreateInfo`
/// See: https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VkPipelineDynamicStateCreateInfo.html
pub const PipelineDynamicStateCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_dynamic_state_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    /// The number of elements in the dynamic_states array.
    dynamic_state_count: u32,
    /// A pointer to an array of `DynamicState` values specifying which pieces of pipeline state
    /// will use the values from dynamic state commands rather than from pipeline state creation
    /// information.
    dynamic_states: ?[*]const DynamicState,
};

/// Structure specifying parameters of a newly created pipeline multisample state
/// Original: `VkPipelineMultisampleStateCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineMultisampleStateCreateInfo.html
pub const PipelineMultisampleStateCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_multisample_state_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    /// A `SampleCountFlag` value specifying the number of samples used in rasterization.
    rasterization_samples: SampleCountFlags,
    /// Used to enable Sample Shading.
    sample_shading_enabled: bool = false,
    /// Specifies a minimum fraction of sample shading if `sample_shading_enabled` is `true`.
    min_sample_shading: f32 = 0.0,
    /// A pointer to an array of `SampleMask` values used in the sample mask test.
    sample_mask: ?[*]const u32 = null,
    /// Controls whether a temporary coverage value is generated based on the alpha component of
    /// the fragment’s first color output as specified in the Multisample Coverage section.
    alpha_to_coverage_enable: bool = false,
    /// controls whether the alpha component of the fragment’s first color output is replaced with
    /// one as described in Multisample Coverage.
    alpha_to_one_enable: bool = false,
};

/// Structure specifying the parameters of a newly created pipeline layout object
/// Original: `VkPipelineLayoutCreateInfo`
/// See: https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VkPipelineLayoutCreateInfo.html
pub const PipelineLayoutCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_layout_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    layouts_count: u32 = 0,
    set_layouts: ?[*]const *DescriptorSetLayout = null,
    push_constant_range_count: u32 = 0,
    push_constant_ranges: ?[*]const PushConstantRange = null,
};

/// Structure specifying parameters of a newly created pipeline rasterization state
/// Original: `VkPipelineRasterizationStateCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineRasterizationStateCreateInfo.html
pub const PipelineRasterizationStateCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_rasterization_state_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    /// Controls whether to clamp the fragment’s depth values as described in Depth Test.
    depth_clamp_enable: bool = false,
    /// Controls whether primitives are discarded immediately before the rasterization stage.
    rasterizer_discard_enable: bool = false,
    /// The triangle rendering mode.
    polygon_mode: PolygonMode,
    /// The triangle facing direction used for primitive culling.
    cull_mode: CullModeFlags = CullModeFlags.none,
    /// A `FrontFace` value specifying the front-facing triangle orientation to be used for
    /// culling.
    front_face: FrontFace,
    /// Controls whether to bias fragment depth values.
    depth_bias_enable: bool = false,
    /// A scalar factor controlling the constant depth value added to each fragment.
    depth_bias_constant_factor: f32 = 0.0,
    /// The maximum (or minimum) depth bias of a fragment.
    depth_bias_clamp: f32 = 0.0,
    /// A scalar factor applied to a fragment’s slope in depth bias calculations.
    depth_bias_slope_factor: f32 = 0.0,
    /// The width of rasterized line segments.
    line_width: f32 = 1.0,
};

/// Structure specifying parameters of a newly created pipeline viewport state
/// Original: `VkPipelineViewportStateCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineViewportStateCreateInfo.html
pub const PipelineViewportStateCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.pipeline_viewport_state_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    /// The number of viewports used by the pipeline.
    viewport_count: u32,
    /// A pointer to an array of `Viewport` structures, defining the viewport transforms. If the
    /// viewport state is dynamic, this member is ignored.
    viewports: ?[*]Viewport = null,
    /// The number of scissors and must match the number of viewports.
    scissor_count: u32,
    /// A pointer to an array of `Rect2d` structures defining the rectangular bounds of the scissor
    /// for the corresponding viewport. If the scissor state is dynamic, this member is ignored.
    scissors: ?[*]Rect2d = null,
};

/// Structure specifying a push constant range
/// Original: `VkPushConstantRange`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPushConstantRange.html
pub const PushConstantRange = extern struct {
    /// A set of stage flags describing the shader stages that will access a range of push constants.
    stage_flags: ShaderStageFlags,
    /// The start offset.
    offset: u32,
    /// The start size.
    size: u32,
};

/// Structure specifying a two-dimensional subregion
/// Original: `VkRect2D`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkRect2D.html
pub const Rect2d = extern struct {
    /// An `Offset2D` specifying the rectangle offset.
    offset: Offset2d,
    /// An `Extent2D` specifying the rectangle extent.
    extent: Extent2d,
};

/// Bitmask specifying a pipeline stage
/// Original: `VkShaderFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkShaderStageFlagBits.html
/// TODO: Doc comments and associated constants
pub const ShaderStageFlags = packed struct(u32) {
    vertex_bit_enabled: bool = false,
    tessellation_control_bit_enabled: bool = false,
    tessellation_evaluation_bit_enabled: bool = false,
    geometry_bit_enabled: bool = false,
    fragment_bit_enabled: bool = false,
    compute_bit_enabled: bool = false,
    task_bit_ext_enabled: bool = false,
    mesh_bit_ext_enabled: bool = false,
    raygen_bit_khr_enabled: bool = false,
    any_hit_bit_khr_enabled: bool = false,
    closest_hit_bit_khr_enabled: bool = false,
    miss_bit_khr_enabled: bool = false,
    intersection_bit_khr_enabled: bool = false,
    callable_bit_khr_enabled: bool = false,
    subpass_shading_bit_huawei_enabled: bool = false,
    _reserved_bit_15: u1 = 0,
    _reserved_bit_16: u1 = 0,
    _reserved_bit_17: u1 = 0,
    _reserved_bit_18: u1 = 0,
    cluster_culling_bit_huawei_enabled: bool = false,
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

/// Structure specifying a Viewport
/// Original: `VkViewport`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkViewport.html
pub const Viewport = extern struct {
    /// The viewport’s upper left corner x position.
    x: f32,
    /// The viewport’s upper left corner y position.
    y: f32,
    /// The viewport’s width.
    width: f32,
    /// The viewport’s height.
    height: f32,
    /// The minimum depth range for the viewport.
    min_depth: f32,
    /// The maximum depth range for the viewport.
    max_depth: f32,
};

extern fn vkCreatePipelineLayout(device: *Device, pCreateInfo: *const PipelineLayoutCreateInfo, pAllocator: ?*const AllocationCallbacks, pPipelineLayout: **PipelineLayout) Result;
