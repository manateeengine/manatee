const shared = @import("shared.zig");

const Device = @import("device.zig").Device;

const AllocationCallbacks = shared.AllocationCallbacks;
const Extent2d = shared.Extent2d;
const Format = shared.Format;
const Offset2d = shared.Offset2d;
const Result = shared.Result;
const SampleCountFlags = shared.SampleCountFlags;
const StructureType = shared.StructureType;

/// Opaque handle to a render pass object
/// Original: `VkRenderPass`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkRenderPass.html
pub const RenderPass = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(device: *Device, create_info: *const RenderPassCreateInfo) !*Self {
        return try createRenderPass(device, create_info, null);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self, device: *Device) void {
        return self.destroyRenderPass(device, null);
    }

    /// Create a new render pass object
    /// Original: `vkCreateRenderPass`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateRenderPass.html
    pub fn createRenderPass(device: *Device, create_info: *const RenderPassCreateInfo, allocation_callbacks: ?*AllocationCallbacks) !*Self {
        var render_pass: *Self = undefined;
        try vkCreateRenderPass(device, create_info, allocation_callbacks, &render_pass).check();
        return render_pass;
    }

    /// Destroy a render pass object
    /// Original: `vkDestroyRenderPass`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyRenderPass.html
    pub fn destroyRenderPass(self: *Self, device: *Device, allocation_callbacks: ?*const AllocationCallbacks) void {
        return vkDestroyRenderPass(device, self, allocation_callbacks);
    }
};

/// Specify how contents of an attachment are treated at the beginning of the subpass where it is
/// first used
/// Original: `VkAttachmentLoadOp`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkAttachmentLoadOp.html
pub const AttachmentLoadOp = enum(u32) {
    /// Specifies that the previous contents of the image within the render area will be preserved as the initial values.
    load = 0,
    /// Specifies that the contents within the render area will be cleared to a uniform value, which is specified when a render pass instance is begun.
    clear = 1,
    /// Specifies that the previous contents within the area need not be preserved
    dont_care = 2,
    /// Specifies that the previous contents of the image will be undefined inside the render pass.
    none = 1000400000,
};

/// Specify how contents of an attachment are treated at the end of the subpass where it is last
/// used
/// Original: `VkAttachmentStoreOp`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkAttachmentStoreOp.html
pub const AttachmentStoreOp = enum(u32) {
    /// Specifies the contents generated during the render pass and within the render area are
    /// written to memory.
    store = 0,
    /// Specifies the contents within the render area are not needed after rendering, and may be
    /// discarded
    dont_care = 1,
    /// Specifies the contents within the render area are not accessed by the store operation as
    /// long as no values are written to the attachment during the render pass.
    none = 1000301000,
};

/// Layout of image and image subresources
/// Original: `VkImageLayout`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkImageLayout.html
/// TODO: Doc Comments
pub const ImageLayout = enum(u32) {
    undefined = 0,
    general = 1,
    color_attachment_optimal = 2,
    depth_stencil_attachment_optimal = 3,
    depth_stencil_read_only_optimal = 4,
    shader_read_only_optimal = 5,
    transfer_src_optimal = 6,
    transfer_dst_optimal = 7,
    preinitialized = 8,
    depth_read_only_stencil_attachment_optimal = 1000117000,
    depth_attachment_stencil_read_only_optimal = 1000117001,
    depth_attachment_optimal = 1000241000,
    depth_read_only_optimal = 1000241001,
    stencil_attachment_optimal = 1000241002,
    stencil_read_only_optimal = 1000241003,
    read_only_optimal = 1000314000,
    attachment_optimal = 1000314001,
    rendering_local_read = 1000232000,
    present_src_khr = 1000001002,
    video_decode_dst_khr = 1000024000,
    video_decode_src_khr = 1000024001,
    video_decode_dpb_khr = 1000024002,
    shared_present_khr = 1000111000,
    fragment_density_map_optimal_ext = 1000218000,
    fragment_shading_rate_attachment_optimal_khr = 1000164003,
    video_encode_dst_khr = 1000299000,
    video_encode_src_khr = 1000299001,
    video_encode_dpb_khr = 1000299002,
    attachment_feedback_loop_optimal_ext = 1000339000,
    video_encode_quantization_map_khr = 1000553000,
};

/// Specify the bind point of a pipeline object to a command buffer
/// Original: `VkPipelineBindPoint`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineBindPoint.html
pub const PipelineBindPoint = enum(u32) {
    /// Specifies binding as a graphics pipeline.
    graphics = 0,
    /// Specifies binding as a compute pipeline.
    compute = 1,
    /// Specifies binding as an execution graph pipeline.
    execution_graph_amdx = 1000134000,
    /// Specifies binding as a ray tracing pipeline.
    ray_tracing_khr = 1000165000,
    /// Specifies binding as a subpass shading pipeline.
    subpass_shading_huawei = 1000369003,
};

///Bitmask specifying memory access types that will participate in a memory dependency
/// Original: `VkAccessFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkAccessFlagBits.html
/// TODO: Doc comments, etc
pub const AccessFlags = packed struct(u32) {
    indirect_command_read_bit_enabled: bool = false,
    index_read_bit_enabled: bool = false,
    vertex_attribute_read_bit_enabled: bool = false,
    uniform_read_bit_enabled: bool = false,
    input_attachment_read_bit_enabled: bool = false,
    shader_read_bit_enabled: bool = false,
    shader_write_bit_enabled: bool = false,
    color_attachment_read_bit_enabled: bool = false,
    color_attachment_write_bit_enabled: bool = false,
    depth_stencil_attachment_read_bit_enabled: bool = false,
    depth_stencil_attachment_write_bit_enabled: bool = false,
    transfer_read_bit_enabled: bool = false,
    transfer_write_bit_enabled: bool = false,
    host_read_bit_enabled: bool = false,
    host_write_bit_enabled: bool = false,
    memory_read_bit_enabled: bool = false,
    memory_write_bit_enabled: bool = false,
    command_preprocess_read_bit_nv_enabled: bool = false,
    command_preprocess_write_bit_nv_enabled: bool = false,
    color_attachment_read_noncoherent_bit_ext_enabled: bool = false,
    conditional_rendering_read_bit_ext_enabled: bool = false,
    acceleration_structure_read_bit_khr_enabled: bool = false,
    acceleration_structure_write_bit_khr_enabled: bool = false,
    fragment_shading_rate_attachment_read_bit_khr_enabled: bool = false,
    fragment_density_map_read_bit_ext_enabled: bool = false,
    transform_feedback_write_bit_ext_enabled: bool = false,
    transform_feedback_counter_read_bit_ext_enabled: bool = false,
    transform_feedback_counter_write_bit_ext_enabled: bool = false,
    _reserved_bit_28: u1 = 0,
    _reserved_bit_29: u1 = 0,
    _reserved_bit_30: u1 = 0,
    _reserved_bit_31: u1 = 0,
};

/// Structure specifying an attachment description
/// Original: `VkAttachmentDescription`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkAttachmentDescription.html
pub const AttachmentDescription = extern struct {
    flags: AttachmentDescriptionFlags = .{},
    format: Format,
    samples: SampleCountFlags = .{},
    load_op: AttachmentLoadOp = .none,
    store_op: AttachmentStoreOp = .none,
    stencil_load_op: AttachmentLoadOp = .none,
    stencil_store_op: AttachmentStoreOp = .none,
    initial_layout: ImageLayout = .undefined,
    final_layout: ImageLayout = .undefined,
};

/// Bitmask specifying additional properties of an attachment
/// Original: `VkAttachmentDescriptionFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkAttachmentDescriptionFlagBits.html
pub const AttachmentDescriptionFlags = packed struct(u32) {
    const Self = @This();

    may_alias_bit_enabled: bool = false,
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

    /// Specifies that the attachment aliases the same device memory as other attachments.
    pub const may_alias_bit = Self{ .may_alias_bit_enabled = true };
};

/// Structure specifying an attachment reference
/// Original: `VkAttachmentReference`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkAttachmentReference.html
pub const AttachmentReference = extern struct {
    /// Either an integer value identifying an attachment at the corresponding index in
    /// `RenderPassCreateInfo.attachments`, or `vk_attachment_unused` to signify that this
    /// attachment is not used.
    attachment: u32,
    /// An `ImageLayout` value specifying the layout the attachment uses during the subpass.
    layout: ImageLayout,
};

/// Bitmask specifying how execution and memory dependencies are formed
/// Original: `VkDependencyFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkDependencyFlagBits.html
/// TODO: Doc comments, etc
pub const DependencyFlags = packed struct(u32) {
    const Self = @This();

    by_region_bit_enabled: bool = false,
    view_local_bit_enabled: bool = false,
    device_group_bit_enabled: bool = false,
    feedback_loop_bit_ext_enabled: bool = false,
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

    /// Specifies that the attachment aliases the same device memory as other attachments.
    pub const may_alias_bit = Self{ .may_alias_bit_enabled = true };
};

/// Bitmask specifying pipeline stages
/// Original: `VkPipelineStageFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPipelineStageFlagBits.html
/// TODO: Doc comments, etc
pub const PipelineStageFlags = packed struct(u32) {
    top_of_pipe_bit_enabled: bool = false,
    draw_indirect_bit_enabled: bool = false,
    vertex_input_bit_enabled: bool = false,
    vertex_shader_bit_enabled: bool = false,
    tessellation_control_shader_bit_enabled: bool = false,
    tessellation_evaluation_shader_bit_enabled: bool = false,
    geometry_shader_bit_enabled: bool = false,
    fragment_shader_bit_enabled: bool = false,
    early_fragment_tests_bit_enabled: bool = false,
    late_fragment_tests_bit_enabled: bool = false,
    color_attachment_output_bit_enabled: bool = false,
    compute_shader_bit_enabled: bool = false,
    transfer_bit_enabled: bool = false,
    bottom_of_pipe_bit_enabled: bool = false,
    host_bit_enabled: bool = false,
    all_graphics_bit_enabled: bool = false,
    all_commands_bit_enabled: bool = false,
    command_preprocess_bit_nv_enabled: bool = false,
    conditional_rendering_bit_ext_enabled: bool = false,
    task_shader_bit_ext_enabled: bool = false,
    mesh_shader_bit_ext_enabled: bool = false,
    ray_tracing_shader_bit_khr_enabled: bool = false,
    fragment_shading_rate_attachment_bit_khr_enabled: bool = false,
    fragment_density_process_bit_ext_enabled: bool = false,
    transform_feedback_bit_ext_enabled: bool = false,
    acceleration_structure_build_bit_khr_enabled: bool = false,
    _reserved_bit_26: u1 = 0,
    _reserved_bit_27: u1 = 0,
    _reserved_bit_28: u1 = 0,
    _reserved_bit_29: u1 = 0,
    _reserved_bit_30: u1 = 0,
    _reserved_bit_31: u1 = 0,
};

/// Bitmask specifying additional properties of a render pass
/// Original: `VkRenderPassCreateFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkRenderPassCreateFlagBits.html
pub const RenderPassCreateFlags = packed struct(u32) {
    const Self = @This();
    _reserved_bit_0: u1 = 0,
    transform_bit_qcom_enabled: bool = false,
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

    /// Specifies that the created render pass is compatible with render pass transform.
    pub const transform_bit_qcom = Self{ .transform_bit_qcom_enabled = true };
};

/// Structure specifying parameters of a newly created render pass
/// Original: `VkRenderPassCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkRenderPassCreateInfo.html
pub const RenderPassCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.render_pass_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// A bitmask of `RenderPassCreateFlagBits`
    flags: RenderPassCreateFlags = .{},
    /// The number of attachments used by this render pass.
    attachment_count: u32 = 0,
    /// A pointer to an array of `attachment_count` `AttachmentDescription` structures describing
    /// the attachments used by the render pass.
    attachments: ?[*]const AttachmentDescription = null,
    /// The number of subpasses to create.
    subpass_count: u32 = 0,
    /// A pointer to an array of `subpass_count` `SubpassDescription` structures describing each
    /// subpass.
    subpasses: ?[*]const SubpassDescription = null,
    /// The number of memory dependencies between pairs of subpasses.
    dependency_count: u32 = 0,
    /// A pointer to an array of `dependency_count` `SubpassDependency` structures describing
    /// dependencies between pairs of subpasses.
    dependencies: ?[*]const SubpassDependency = null,
};

/// Structure specifying a subpass dependency
/// Original: `VkSubpassDependency`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSubpassDependency.html
pub const SubpassDependency = extern struct {
    src_subpass: u32,
    dst_subpass: u32,
    src_stage_mask: PipelineStageFlags = .{},
    dst_stage_mask: PipelineStageFlags = .{},
    src_access_mask: AccessFlags = .{},
    dst_access_mask: AccessFlags = .{},
    dependency_flags: DependencyFlags = .{},
};

/// Structure specifying a subpass description
/// Original: `VkSubpassDescription`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSubpassDescription.html
pub const SubpassDescription = extern struct {
    /// A bitmask of `SubpassDescriptionFlagBits` specifying usage of the subpass.
    flags: SubpassDescriptionFlags = .{},
    /// A `PipelineBindPoint` value specifying the pipeline type supported for this subpass.
    pipeline_bind_point: PipelineBindPoint = .graphics,
    /// The number of input attachments.
    input_attachment_count: u32 = 0,
    /// A pointer to an array of `AttachmentReference` structures defining the input attachments
    /// for this subpass and their layouts.
    input_attachments: ?[*]const AttachmentReference = null,
    /// The number of color attachments.
    color_attachment_count: u32 = 0,
    /// A pointer to an array of `color_attachment_count` `AttachmentReference` structures defining
    /// the color attachments for this subpass and their layouts.
    color_attachments: ?[*]const AttachmentReference = null,
    /// An optional pointer to an array of `color_attachment_count` `AttachmentReference`
    /// structures defining the resolve attachments for this subpass and their layouts.
    resolve_attachments: ?[*]const AttachmentReference = null,
    /// A pointer to a `AttachmentReference` structure specifying the depth/stencil attachment for
    /// this subpass and its layout.
    depth_stencil_attachments: ?[*]const AttachmentReference = null,
    /// The number of preserved attachments.
    preserve_attachment_count: u32 = 0,
    /// A pointer to an array of `preserve_attachment_count` render pass attachment indices
    /// identifying attachments that are not used by this subpass, but whose contents must be
    /// preserved throughout the subpass.
    preserve_attachments: ?[*]const u32 = null,
};

/// Bitmask specifying usage of a subpass
/// Original: `VkSubpassDescriptionFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSubpassDescriptionFlagBits.html
/// TODO: Doc comments, etc
pub const SubpassDescriptionFlags = packed struct(u32) {
    const Self = @This();
    per_view_attributes_bit_nvx_enabled: bool = false,
    per_view_position_x_only_bit_nvx_enabled: bool = false,
    fragment_region_bit_qcom_enabled: bool = false,
    shader_resolve_bit_qcom_enabled: bool = false,
    rasterization_order_attachment_color_access_bit_ext_enabled: bool = false,
    rasterization_order_attachment_depth_access_bit_ext_enabled: bool = false,
    rasterization_order_attachment_stencil_access_bit_ext_enabled: bool = false,
    enable_legacy_dithering_bit_ext_enabled: bool = false,
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

extern fn vkCreateRenderPass(device: *Device, pCreateInfo: *const RenderPassCreateInfo, pAllocator: ?*const AllocationCallbacks, pRenderPass: **RenderPass) Result;
extern fn vkDestroyRenderPass(device: *Device, renderPass: *RenderPass, pAllocator: ?*const AllocationCallbacks) void;
