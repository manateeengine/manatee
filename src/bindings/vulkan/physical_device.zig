const std = @import("std");

const Instance = @import("instance.zig").Instance;
const Result = @import("result.zig").Result;

/// Opaque handle to a physical device object
/// Original: `VhPhysicalDevice`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDevice.html
pub const PhysicalDevice = enum(usize) {
    const Self = @This();

    /// Reports capabilities of a physical device
    /// Original: `vkGetPhysicalDeviceFeatures`
    /// https://registry.khronos.org/vulkan/specs/latest/man/html/vkGetPhysicalDeviceProperties.html
    pub fn getFeatures(self: *Self) PhysicalDeviceFeatures {
        var physical_device_features: PhysicalDeviceFeatures = undefined;
        vkGetPhysicalDeviceFeatures(self.*, &physical_device_features);
        return physical_device_features;
    }

    /// Returns properties of a physical device
    /// Original: `vkGetPhysicalDeviceProperties`
    /// https://registry.khronos.org/vulkan/specs/latest/man/html/vkGetPhysicalDeviceProperties.html
    pub fn getProperties(self: *Self) PhysicalDeviceProperties {
        var physical_device_properties: PhysicalDeviceProperties = undefined;
        vkGetPhysicalDeviceProperties(self.*, &physical_device_properties);
        return physical_device_properties;
    }

    /// Reports properties of the queues of the specified physical device
    /// Original: `vkGetPhysicalDeviceQueueFamilyProperties`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkGetPhysicalDeviceQueueFamilyProperties.html
    pub fn getQueueFamilyProperties(self: *Self, allocator: std.mem.Allocator) ![]QueueFamilyProperties {
        var physical_device_queue_family_property_count: u32 = 0;
        vkGetPhysicalDeviceQueueFamilyProperties(self.*, &physical_device_queue_family_property_count, null);

        const physical_device_queue_family_properties = try allocator.alloc(QueueFamilyProperties, physical_device_queue_family_property_count);
        errdefer allocator.free(physical_device_queue_family_properties);
        vkGetPhysicalDeviceQueueFamilyProperties(self.*, &physical_device_queue_family_property_count, physical_device_queue_family_properties.ptr);

        return physical_device_queue_family_properties;
    }
};

/// An internal Manatee value used to denote a queue family index as invalid / unset
pub const invalid_queue_family_index = std.math.maxInt(u32);

/// Length of a physical device name string
/// Original: `VK_MAX_PHYSICAL_DEVICE_NAME_SIZE`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VK_MAX_PHYSICAL_DEVICE_NAME_SIZE.html
pub const max_physical_device_name_size: usize = 256;

/// Length of a universally unique device or driver build identifier
/// Original: `VK_UUID_SIZE`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VK_UUID_SIZE.html
pub const uuid_size: usize = 16;

/// Supported physical device types
/// Original: VkPhysicalDeviceType
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDeviceType.html
pub const PhysicalDeviceType = enum(u32) {
    /// The device does not match any other available types.
    other = 0,
    /// The device is typically one embedded in or tightly coupled with the host.
    integrated_gpu = 1,
    /// The device is typically a separate processor connected to the host via an interlink.
    discrete_gpu = 2,
    /// The device is typically a virtual node in a virtualization environment.
    virtual_gpu = 3,
    /// The device is typically running on the same processors as the host.
    cpu = 4,
};

/// Structure specifying a three-dimensional extent
/// Original: `VkExtent3D`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkExtent3D.html
pub const Extent3d = extern struct {
    /// The width of the extent.
    width: u32,
    /// The height of the extent.
    height: u32,
    /// The depth of the extent.
    depth: u32,
};

/// Structure describing the fine-grained features that can be supported by an implementation
/// Original: `VkPhysicalDeviceFeatures`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDeviceFeatures.html
pub const PhysicalDeviceFeatures = extern struct {
    /// Specifies that accesses to buffers are bounds-checked against the range of the buffer
    /// descriptor
    robust_buffer_access: u32,
    /// specifies the full 32-bit range of indices is supported for indexed draw calls when using
    /// an IndexType `u32`
    full_draw_index_uint_32: u32,
    /// Specifies whether image views with a ImageViewType of `cube_array` can be created, and that
    /// the corresponding SampledCubeArray and ImageCubeArray SPIR-V capabilities can be used in
    /// shader code.
    image_cube_array: u32,
    /// Specifies whether the PipelineColorBlendAttachmentState settings are controlled
    /// independently per-attachment.
    independent_blend: u32,
    /// Specifies whether geometry shaders are supported.
    geometry_shader: u32,
    /// Specifies whether tessellation control and evaluation shaders are supported.
    tessellation_shader: u32,
    /// Specifies whether Sample Shading and multisample interpolation are supported.
    sample_rate_shading: u32,
    /// Specifies whether blend operations which take two sources are supported.
    dual_src_blend: u32,
    /// Specifies whether logic operations are supported.
    logic_op: u32,
    /// Specifies whether multiple draw indirect is supported.
    multi_draw_indirect: u32,
    /// Specifies whether indirect drawing calls support the firstInstance parameter.
    draw_indirect_first_instance: u32,
    /// Specifies whether depth clamping is supported.
    depth_clamp: u32,
    /// Specifies whether depth bias clamping is supported.
    depth_bias_clamp: u32,
    /// Specifies whether point and wireframe fill modes are supported.
    fill_mode_non_solid: u32,
    /// Specifies whether depth bounds tests are supported.
    depth_bounds: u32,
    /// Specifies whether lines with width other than 1.0 are supported.
    wide_lines: u32,
    /// Specifies whether points with size greater than 1.0 are supported.
    large_points: u32,
    /// Specifies whether the implementation is able to replace the alpha value of the fragment
    /// shader color output in the Multisample Coverage fragment operation.
    alpha_to_one: u32,
    /// Specifies whether more than one viewport is supported.
    multi_viewport: u32,
    /// Specifies whether anisotropic filtering is supported.
    sampler_anisotropy: u32,
    /// Specifies whether all of the ETC2 and EAC compressed texture formats are supported.
    texture_compression_etc_2: u32,
    /// Specifies whether all of the ASTC LDR compressed texture formats are supported.
    texture_compression_astc_ldr: u32,
    /// Specifies whether all of the BC compressed texture formats are supported.
    texture_compression_bc: u32,
    /// Specifies whether occlusion queries returning actual sample counts are supported.
    occlusion_query_precise: u32,
    /// Specifies whether the pipeline statistics queries are supported.
    pipeline_statistics_query: u32,
    /// Specifies whether storage buffers and images support stores and atomic operations in the
    /// vertex, tessellation, and geometry shader stages.
    vertex_pipeline_stores_and_atomics: u32,
    /// Specifies whether storage buffers and images support stores and atomic operations in the
    /// fragment shader stage.
    fragment_stores_and_atomics: u32,
    /// specifies whether the PointSize built-in decoration is available in the tessellation
    /// control, tessellation evaluation, and geometry shader stages.
    shader_tessellation_and_geometry_point_size: u32,
    /// Specifies whether the extended set of image gather instructions are available in shader
    /// code.
    shader_image_gather_extended: u32,
    /// Specifies whether all the “storage image extended formats” are supported
    shader_storage_image_extended_formats: u32,
    /// Specifies whether multisampled storage images are supported.
    shader_storage_image_multisample: u32,
    /// Specifies whether storage images and storage texel buffers require a format qualifier to be
    /// specified when reading.
    shader_storage_image_read_without_format: u32,
    /// Specifies whether storage images and storage texel buffers require a format qualifier to be
    /// specified when writing.
    shader_storage_image_write_without_format: u32,
    /// Specifies whether arrays of uniform buffers can be indexed by integer expressions that are
    /// dynamically uniform within either the subgroup or the invocation group in shader code.
    shader_uniform_buffer_array_dynamic_indexing: u32,
    /// Specifies whether arrays of samplers or sampled images can be indexed by integer
    /// expressions that are dynamically uniform within either the subgroup or the invocation group
    /// in shader code.
    shader_sampled_image_array_dynamic_indexing: u32,
    /// Specifies whether arrays of storage buffers can be indexed by integer expressions that are
    /// dynamically uniform within either the subgroup or the invocation group in shader code.
    shader_storage_buffer_array_dynamic_indexing: u32,
    /// Specifies whether arrays of storage images can be indexed by integer expressions that are
    /// dynamically uniform within either the subgroup or the invocation group in shader code.
    shader_storage_image_array_dynamic_indexing: u32,
    /// Specifies whether clip distances are supported in shader code.
    shader_clip_distance: u32,
    /// Specifies whether cull distances are supported in shader code.
    shader_cull_distance: u32,
    /// Specifies whether 64-bit floats (doubles) are supported in shader code.
    shader_float64: u32,
    /// Specifies whether 64-bit integers (signed and unsigned) are supported in shader code.
    shader_int64: u32,
    /// Specifies whether 16-bit integers (signed and unsigned) are supported in shader code.
    shader_int16: u32,
    /// Specifies whether image operations that return resource residency information are supported
    /// in shader code.
    shader_resource_residency: u32,
    /// Specifies whether image operations specifying the minimum resource LOD are supported in
    /// shader code.
    shader_resource_min_lod: u32,
    /// Specifies whether resource memory can be managed at opaque sparse block level instead of at
    /// the object level.
    sparse_binding: u32,
    /// Specifies whether the device can access partially resident buffers.
    sparse_residency_buffer: u32,
    /// Specifies whether the device can access partially resident 2D images with 1 sample per
    /// pixel.
    sparse_residency_image2d: u32,
    /// Specifies whether the device can access partially resident 3D images.
    sparse_residency_image3d: u32,
    /// Specifies whether the physical device can access partially resident 2D images with 2
    /// samples per pixel.
    sparse_residency_2_samples: u32,
    /// Specifies whether the physical device can access partially resident 2D images with 4
    /// samples per pixel.
    sparse_residency_4_samples: u32,
    /// Specifies whether the physical device can access partially resident 2D images with 8
    /// samples per pixel.
    sparse_residency_8_samples: u32,
    /// Specifies whether the physical device can access partially resident 2D images with 16
    /// samples per pixel.
    sparse_residency_16_samples: u32,
    /// Specifies whether the physical device can correctly access data aliased into multiple
    /// locations.
    sparse_residency_aliased: u32,
    /// Specifies whether all pipelines that will be bound to a command buffer during a subpass
    /// which uses no attachments must have the same value for PipelineMultisampleStateCreateInfo
    /// rasterization_samples.
    variable_multisample_rate: u32,
    /// Specifies whether a secondary command buffer may be executed while a query is active.
    inherited_queries: u32,
};

/// Structure reporting implementation-dependent physical device limits
/// Original: `VkPhysicalDeviceLimits`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDeviceLimits.html
/// TODO: Copy over per-property descriptions... it's gonna be a lot
pub const PhysicalDeviceLimits = extern struct {
    max_image_dimension_1d: u32,
    max_image_dimension_2d: u32,
    max_image_dimension_3d: u32,
    max_image_dimension_cube: u32,
    max_image_array_layers: u32,
    max_texel_buffer_elements: u32,
    max_uniform_buffer_range: u32,
    max_storage_buffer_range: u32,
    max_push_constants_size: u32,
    max_memory_allocation_count: u32,
    max_sampler_allocation_count: u32,
    buffer_image_granularity: u64,
    sparse_address_space_size: u64,
    max_bound_descriptor_sets: u32,
    max_per_stage_descriptor_samplers: u32,
    max_per_stage_descriptor_uniform_buffers: u32,
    max_per_stage_descriptor_storage_buffers: u32,
    max_per_stage_descriptor_sampled_images: u32,
    max_per_stage_descriptor_storage_images: u32,
    max_per_stage_descriptor_input_attachments: u32,
    max_per_stage_resources: u32,
    max_descriptor_set_samplers: u32,
    max_descriptor_set_uniform_buffers: u32,
    max_descriptor_set_uniform_buffers_dynamic: u32,
    max_descriptor_set_storage_buffers: u32,
    max_descriptor_set_storage_buffers_dynamic: u32,
    max_descriptor_set_sampled_images: u32,
    max_descriptor_set_storage_images: u32,
    max_descriptor_set_input_attachments: u32,
    max_vertex_input_attributes: u32,
    max_vertex_input_bindings: u32,
    max_vertex_input_attribute_offset: u32,
    max_vertex_input_binding_stride: u32,
    max_vertex_output_components: u32,
    max_tessellation_generation_level: u32,
    max_tessellation_patch_size: u32,
    max_tessellation_control_per_vertex_input_components: u32,
    max_tessellation_control_per_vertex_output_components: u32,
    max_tessellation_control_per_patch_output_components: u32,
    max_tessellation_control_total_output_components: u32,
    max_tessellation_evaluation_input_components: u32,
    max_tessellation_evaluation_output_components: u32,
    max_geometry_shader_invocations: u32,
    max_geometry_input_components: u32,
    max_geometry_output_components: u32,
    max_geometry_output_vertices: u32,
    max_geometry_total_output_components: u32,
    max_fragment_input_components: u32,
    max_fragment_output_attachments: u32,
    max_fragment_dual_src_attachments: u32,
    max_fragment_combined_output_resources: u32,
    max_compute_shared_memory_size: u32,
    max_compute_work_group_count: [3]u32,
    max_compute_work_group_invocations: u32,
    max_compute_work_group_size: [3]u32,
    sub_pixel_precision_bits: u32,
    sub_texel_precision_bits: u32,
    mipmap_precision_bits: u32,
    max_draw_indexed_index_value: u32,
    max_draw_indirect_count: u32,
    max_sampler_lod_bias: f32,
    max_sampler_anisotropy: f32,
    max_viewports: u32,
    max_viewport_dimensions: [2]u32,
    viewport_bounds_range: [2]f32,
    viewport_sub_pixel_bits: u32,
    min_memory_map_alignment: usize,
    min_texel_buffer_offset_alignment: u64,
    min_uniform_buffer_offset_alignment: u64,
    min_storage_buffer_offset_alignment: u64,
    min_texel_offset: i32,
    max_texel_offset: u32,
    min_texel_gather_offset: i32,
    max_texel_gather_offset: u32,
    min_interpolation_offset: f32,
    max_interpolation_offset: f32,
    sub_pixel_interpolation_offset_bits: u32,
    max_framebuffer_width: u32,
    max_framebuffer_height: u32,
    max_framebuffer_layers: u32,
    framebuffer_color_sample_counts: SampleCountFlags,
    framebuffer_depth_sample_counts: SampleCountFlags,
    framebuffer_stencil_sample_counts: SampleCountFlags,
    framebuffer_no_attachments_sample_counts: SampleCountFlags,
    max_color_attachments: u32,
    sampled_image_color_sample_counts: SampleCountFlags,
    sampled_image_integer_sample_counts: SampleCountFlags,
    sampled_image_depth_sample_counts: SampleCountFlags,
    sampled_image_stencil_sample_counts: SampleCountFlags,
    storage_image_sample_counts: SampleCountFlags,
    max_sample_mask_words: u32,
    timestamp_compute_and_graphics: u32,
    timestamp_period: f32,
    max_clip_distances: u32,
    max_cull_distances: u32,
    max_combined_clip_and_cull_distances: u32,
    discrete_queue_priorities: u32,
    point_size_range: [2]f32,
    line_width_range: [2]f32,
    point_size_granularity: f32,
    line_width_granularity: f32,
    strict_lines: u32,
    standard_sample_locations: u32,
    optimal_buffer_copy_offset_alignment: u64,
    optimal_buffer_copy_row_pitch_alignment: u64,
    non_coherent_atom_size: u64,
};

/// Structure specifying physical device properties
/// Original: `VkPhysicalDeviceProperties`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDeviceProperties.html
pub const PhysicalDeviceProperties = extern struct {
    /// The version of Vulkan supported by the device, encoded as described in the Vulkan Spec.
    api_version: u32,
    /// The vendor-specified version of the driver.
    driver_version: u32,
    /// A unique identifier for the vendor (see below) of the physical device.
    vendor_id: u32,
    /// A unique identifier for the physical device among devices available from the vendor.
    device_id: u32,
    /// A `PhysicalDeviceType` specifying the type of device.
    device_type: PhysicalDeviceType,
    /// An array of max_physical_device_name_size char containing a null-terminated UTF-8 string
    /// which is the name of the device.
    device_name: [max_physical_device_name_size]u8,
    /// An array of VK_UUID_SIZE uint8_t values representing a universally unique identifier for
    /// the device.
    pipeline_cache_uuid: [uuid_size]u8,
    /// The PhysicalDeviceLimits structure specifying device-specific limits of the physical
    /// device.
    limits: PhysicalDeviceLimits,
    /// the PhysicalDeviceSparseProperties structure specifying various sparse related properties
    /// of the physical device.
    sparse_properties: PhysicalDeviceSparseProperties,
};

/// Structure specifying physical device sparse memory properties
/// https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDeviceSparseProperties.html
/// TODO: Copy over per-property descriptions
pub const PhysicalDeviceSparseProperties = extern struct {
    residency_standard_2d_block_shape: u32,
    residency_standard_2d_multisample_block_shape: u32,
    residency_standard_3d_block_shape: u32,
    residency_aligned_mip_size: u32,
    residency_non_resident_strict: u32,
};

/// Structure providing information about a queue family
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkQueueFamilyProperties.html
pub const QueueFamilyProperties = extern struct {
    /// A bitmask of QueueFlagBits indicating capabilities of the queues in this queue family.
    queue_flags: u32,
    queue_count: u32,
    timestamp_valid_bits: u32,
    min_image_transfer_granularity: Extent3d,
};

/// Bitmask specifying capabilities of queues in a queue family
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkQueueFlagBits.html
pub const QueueFlagBits = packed struct(u32) {
    const Self = @This();

    graphics_bit_enabled: bool = false,
    compute_bit_enabled: bool = false,
    transfer_bit_enabled: bool = false,
    sparse_binding_bit_enabled: bool = false,
    protected_bit_enabled: bool = false,
    video_decode_bit_khr_enabled: bool = false,
    video_encode_bit_khr_enabled: bool = false,
    _reserved_bit_7: u1 = 0,
    optical_flow_bit_nv_enabled: bool = false,
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

    /// Specifies that queues in this queue family support graphics operations.
    pub const graphics_bit = Self{ .graphics_bit_enabled = true };
    /// Specifies that queues in this queue family support compute operations.
    pub const compute_bit = Self{ .compute_bit_enabled = true };
    /// Specifies that queues in this queue family support transfer operations.
    pub const transfer_bit = Self{ .transfer_bit_enabled = true };
    /// Specifies that queues in this queue family support sparse memory management operations.
    pub const sparse_binding_bit = Self{ .sparse_binding_bit_enabled = true };
    /// Specifies that queues in this queue family support the ProtectedBit bit.
    pub const protected_bit = Self{ .protected_bit_enabled = true };
    /// Specifies that queues in this queue family support video decode operations.
    pub const video_decode_bit_khr = Self{ .video_decode_bit_khr_enabled = true };
    /// Specifies that queues in this queue family support video encode operations.
    pub const video_encode_bit_khr = Self{ .video_encode_bit_khr_enabled = true };
    /// Specifies that queues in this queue family support optical flow operations.
    pub const optical_flow_bit_nv = Self{ .optical_flow_bit_nv_enabled = true };
};

/// Bitmask of VkSampleCountFlagBits
/// Original: `VkSampleCountFlagBits`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSampleCountFlags.html
pub const SampleCountFlags = packed struct(u32) {
    const Self = @This();

    one_bit_enabled: bool = false,
    two_bit_enabled: bool = false,
    four_bit_enabled: bool = false,
    eight_bit_enabled: bool = false,
    sixteen_bit_enabled: bool = false,
    thirty_two_bit_enabled: bool = false,
    sixty_four_bit_enabled: bool = false,
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

    /// Specifies an image with one sample per pixel.
    pub const one_bit = Self{ .one_bit_enabled = true };
    /// Specifies an image with 2 samples per pixel.
    pub const two_bit = Self{ .two_bit_enabled = true };
    /// Specifies an image with 4 samples per pixel.
    pub const four_bit = Self{ .four_bit_enabled = true };
    /// Specifies an image with 8 samples per pixel.
    pub const eight_bit = Self{ .eight_bit_enabled = true };
    /// Specifies an image with 16 samples per pixel.
    pub const sixteen_bit = Self{ .sixteen_bit_enabled = true };
    /// Specifies an image with 32 samples per pixel.
    pub const thirty_two_bit = Self{ .thirty_two_bit_enabled = true };
    /// Specifies an image with 64 samples per pixel.
    pub const sixty_four_bit = Self{ .sixty_four_bit_enabled = true };
};

extern fn vkGetPhysicalDeviceFeatures(physicalDevice: PhysicalDevice, pFeatures: *PhysicalDeviceFeatures) void;
extern fn vkGetPhysicalDeviceProperties(physicalDevice: PhysicalDevice, pProperties: *PhysicalDeviceProperties) void;
extern fn vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice: PhysicalDevice, pQueueFamilyPropertyCount: *u32, pQueueFamilyProperties: ?[*]QueueFamilyProperties) void;
