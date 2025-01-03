//! Zig bindings for Vulkan's vulkan_core.h

const builtin = @import("builtin");
const std = @import("std");
const c = @import("c.zig");

// Constants

/// The API version number for Vulkan 1.0.0.
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VK_API_VERSION_1_0.html
pub const api_version_1_0 = makeApiVersion(0, 1, 0, 0);

pub const invalid_queue_family_index = std.math.maxInt(u32);

/// Maximum length of a layer of extension name string
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VK_MAX_EXTENSION_NAME_SIZE.html
pub const max_extension_name_size = c.VK_MAX_EXTENSION_NAME_SIZE;

/// Length of a physical device name string
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VK_MAX_PHYSICAL_DEVICE_NAME_SIZE.html
pub const max_physical_device_name_size = c.VK_MAX_PHYSICAL_DEVICE_NAME_SIZE;

/// Length of a universally unique device or driver build identifier
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VK_UUID_SIZE.html
pub const uuid_size = c.VK_UUID_SIZE;

// Enums

/// Supported physical device types
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDeviceType.html
pub const PhysicalDeviceType = enum(i32) {
    other = 0,
    integrated_gpu = 1,
    discrete_gpu = 2,
    virtual_gpu = 3,
    cpu = 4,
};

/// Bitmask specifying capabilities of queues in a queue family
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkQueueFlagBits.html
pub const QueueFlagBits = enum(u32) {
    /// Specifies that queues in this queue family support graphics operations.
    graphics_bit = 0x00000001,
    /// Specifies that queues in this queue family support compute operations.
    compute_bit = 0x00000002,
    /// Specifies that queues in this queue family support transfer operations.
    transfer_bit = 0x00000004,
    /// Specifies that queues in this queue family support sparse memory management operations.
    sparse_binding_bit = 0x00000008,
    /// Specifies that queues in this queue family support the VK_DEVICE_QUEUE_CREATE_PROTECTED_BIT
    /// bit.
    protected_bit = 0x00000010,
    /// Specifies that queues in this queue family support video decode operations.
    video_decode_bit_khr = 0x00000020,
    /// Specifies that queues in this queue family support video encode operations.
    video_encode_bit_khr = 0x00000040,
    /// Specifies that queues in this queue family support optical flow operations.
    optical_flow_bit_nv = 0x00000100,
};

/// Vulkan command return codes
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkResult.html
pub const Result = enum(i32) {
    success = 0,
    not_ready = 1,
    timeout = 2,
    event_set = 3,
    event_reset = 4,
    incomplete = 5,
    error_out_of_host_memory = -1,
    error_out_of_device_memory = -2,
    error_initialization_failed = -3,
    error_device_lost = -4,
    error_memory_map_failed = -5,
    error_layer_not_present = -6,
    error_extension_not_present = -7,
    error_feature_not_present = -8,
    error_incompatible_driver = -9,
    error_too_many_objects = -10,
    error_format_not_supported = -11,
    error_fragmented_pool = -12,
    error_unknown = -13,
    error_out_of_pool_memory = -1000069000,
    error_invalid_external_handle = -1000072003,
    error_fragmentation = -1000161000,
    error_invalid_opaque_capture_address = -1000257000,
    pipeline_compile_required = 1000297000,
    error_surface_lost_khr = -1000000000,
    error_native_window_in_use_khr = -1000000001,
    suboptimal_khr = 1000001003,
    error_out_of_date_khr = -1000001004,
    error_incompatible_display_khr = -1000003001,
    error_validation_failed_ext = -1000011001,
    error_invalid_shader_nv = -1000012000,
    error_image_usage_not_supported_khr = -1000023000,
    error_video_picture_layout_not_supported_khr = -1000023001,
    error_video_profile_operation_not_supported_khr = -1000023002,
    error_video_profile_format_not_supported_khr = -1000023003,
    error_video_profile_codec_not_supported_khr = -1000023004,
    error_video_std_version_not_supported_khr = -1000023005,
    error_invalid_drm_format_modifier_plane_layout_ext = -1000158000,
    error_not_permitted_khr = -1000174001,
    error_full_screen_exclusive_mode_lost_ext = -1000255000,
    thread_idle_khr = 1000268000,
    thread_done_khr = 1000268001,
    operation_deferred_khr = 1000268002,
    operation_not_deferred_khr = 1000268003,
    error_invalid_video_std_parameters_khr = -1000299000,
    error_compression_exhausted_ext = -1000338000,
    incompatible_shader_binary_ext = 1000482000,
    pipeline_binary_missing_khr = 1000483000,
    error_not_enough_space_khr = -1000483000,
    result_max_enum = 0x7fffffff,
};

/// Bitmask of VkSampleCountFlagBits
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSampleCountFlags.html
pub const SampleCountFlags = enum(u32) {
    @"1_bit" = 0x00000001,
    @"2_bit" = 0x00000002,
    @"4_bit" = 0x00000004,
    @"8_bit" = 0x00000008,
    @"16_bit" = 0x00000010,
    @"32_bit" = 0x00000020,
    @"64_bit" = 0x00000040,
    max_enum = 0x7FFFFFFF,
};

/// Vulkan structure types (pname:sType)
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkStructureType.html
pub const StructureType = enum(i32) {
    application_info = 0,
    instance_create_info = 1,
    device_queue_create_info = 2,
    device_create_info = 3,
    submit_info = 4,
    memory_allocate_info = 5,
    mapped_memory_range = 6,
    bind_sparse_info = 7,
    fence_create_info = 8,
    semaphore_create_info = 9,
    event_create_info = 10,
    query_pool_create_info = 11,
    buffer_create_info = 12,
    buffer_view_create_info = 13,
    image_create_info = 14,
    image_view_create_info = 15,
    shader_module_create_info = 16,
    pipeline_cache_create_info = 17,
    pipeline_shader_stage_create_info = 18,
    pipeline_vertex_input_state_create_info = 19,
    pipeline_input_assembly_state_create_info = 20,
    pipeline_tessellation_state_create_info = 21,
    pipeline_viewport_state_create_info = 22,
    pipeline_rasterization_state_create_info = 23,
    pipeline_multisample_state_create_info = 24,
    pipeline_depth_stencil_state_create_info = 25,
    pipeline_color_blend_state_create_info = 26,
    pipeline_dynamic_state_create_info = 27,
    graphics_pipeline_create_info = 28,
    compute_pipeline_create_info = 29,
    pipeline_layout_create_info = 30,
    sampler_create_info = 31,
    descriptor_set_layout_create_info = 32,
    descriptor_pool_create_info = 33,
    descriptor_set_allocate_info = 34,
    write_descriptor_set = 35,
    copy_descriptor_set = 36,
    framebuffer_create_info = 37,
    render_pass_create_info = 38,
    command_pool_create_info = 39,
    command_buffer_allocate_info = 40,
    command_buffer_inheritance_info = 41,
    command_buffer_begin_info = 42,
    render_pass_begin_info = 43,
    buffer_memory_barrier = 44,
    image_memory_barrier = 45,
    memory_barrier = 46,
    loader_instance_create_info = 47,
    loader_device_create_info = 48,
    physical_device_subgroup_properties = 1000094000,
    bind_buffer_memory_info = 1000157000,
    bind_image_memory_info = 1000157001,
    physical_device_16bit_storage_features = 1000083000,
    memory_dedicated_requirements = 1000127000,
    memory_dedicated_allocate_info = 1000127001,
    memory_allocate_flags_info = 1000060000,
    device_group_render_pass_begin_info = 1000060003,
    device_group_command_buffer_begin_info = 1000060004,
    device_group_submit_info = 1000060005,
    device_group_bind_sparse_info = 1000060006,
    bind_buffer_memory_device_group_info = 1000060013,
    bind_image_memory_device_group_info = 1000060014,
    physical_device_group_properties = 1000070000,
    device_group_device_create_info = 1000070001,
    buffer_memory_requirements_info_2 = 1000146000,
    image_memory_requirements_info_2 = 1000146001,
    image_sparse_memory_requirements_info_2 = 1000146002,
    memory_requirements_2 = 1000146003,
    sparse_image_memory_requirements_2 = 1000146004,
    physical_device_features_2 = 1000059000,
    physical_device_properties_2 = 1000059001,
    format_properties_2 = 1000059002,
    image_format_properties_2 = 1000059003,
    physical_device_image_format_info_2 = 1000059004,
    queue_family_properties_2 = 1000059005,
    physical_device_memory_properties_2 = 1000059006,
    sparse_image_format_properties_2 = 1000059007,
    physical_device_sparse_image_format_info_2 = 1000059008,
    physical_device_point_clipping_properties = 1000117000,
    render_pass_input_attachment_aspect_create_info = 1000117001,
    image_view_usage_create_info = 1000117002,
    pipeline_tessellation_domain_origin_state_create_info = 1000117003,
    render_pass_multiview_create_info = 1000053000,
    physical_device_multiview_features = 1000053001,
    physical_device_multiview_properties = 1000053002,
    physical_device_variable_pointers_features = 1000120000,
    protected_submit_info = 1000145000,
    physical_device_protected_memory_features = 1000145001,
    physical_device_protected_memory_properties = 1000145002,
    device_queue_info_2 = 1000145003,
    sampler_ycbcr_conversion_create_info = 1000156000,
    sampler_ycbcr_conversion_info = 1000156001,
    bind_image_plane_memory_info = 1000156002,
    image_plane_memory_requirements_info = 1000156003,
    physical_device_sampler_ycbcr_conversion_features = 1000156004,
    sampler_ycbcr_conversion_image_format_properties = 1000156005,
    descriptor_update_template_create_info = 1000085000,
    physical_device_external_image_format_info = 1000071000,
    external_image_format_properties = 1000071001,
    physical_device_external_buffer_info = 1000071002,
    external_buffer_properties = 1000071003,
    physical_device_id_properties = 1000071004,
    external_memory_buffer_create_info = 1000072000,
    external_memory_image_create_info = 1000072001,
    export_memory_allocate_info = 1000072002,
    physical_device_external_fence_info = 1000112000,
    external_fence_properties = 1000112001,
    export_fence_create_info = 1000113000,
    export_semaphore_create_info = 1000077000,
    physical_device_external_semaphore_info = 1000076000,
    external_semaphore_properties = 1000076001,
    physical_device_maintenance_3_properties = 1000168000,
    descriptor_set_layout_support = 1000168001,
    physical_device_shader_draw_parameters_features = 1000063000,
    physical_device_vulkan_1_1_features = 49,
    physical_device_vulkan_1_1_properties = 50,
    physical_device_vulkan_1_2_features = 51,
    physical_device_vulkan_1_2_properties = 52,
    image_format_list_create_info = 1000147000,
    attachment_description_2 = 1000109000,
    attachment_reference_2 = 1000109001,
    subpass_description_2 = 1000109002,
    subpass_dependency_2 = 1000109003,
    render_pass_create_info_2 = 1000109004,
    subpass_begin_info = 1000109005,
    subpass_end_info = 1000109006,
    physical_device_8bit_storage_features = 1000177000,
    physical_device_driver_properties = 1000196000,
    physical_device_shader_atomic_int64_features = 1000180000,
    physical_device_shader_float16_int8_features = 1000082000,
    physical_device_float_controls_properties = 1000197000,
    descriptor_set_layout_binding_flags_create_info = 1000161000,
    physical_device_descriptor_indexing_features = 1000161001,
    physical_device_descriptor_indexing_properties = 1000161002,
    descriptor_set_variable_descriptor_count_allocate_info = 1000161003,
    descriptor_set_variable_descriptor_count_layout_support = 1000161004,
    physical_device_depth_stencil_resolve_properties = 1000199000,
    subpass_description_depth_stencil_resolve = 1000199001,
    physical_device_scalar_block_layout_features = 1000221000,
    image_stencil_usage_create_info = 1000246000,
    physical_device_sampler_filter_minmax_properties = 1000130000,
    sampler_reduction_mode_create_info = 1000130001,
    physical_device_vulkan_memory_model_features = 1000211000,
    physical_device_imageless_framebuffer_features = 1000108000,
    framebuffer_attachments_create_info = 1000108001,
    framebuffer_attachment_image_info = 1000108002,
    render_pass_attachment_begin_info = 1000108003,
    physical_device_uniform_buffer_standard_layout_features = 1000253000,
    physical_device_shader_subgroup_extended_types_features = 1000175000,
    physical_device_separate_depth_stencil_layouts_features = 1000241000,
    attachment_reference_stencil_layout = 1000241001,
    attachment_description_stencil_layout = 1000241002,
    physical_device_host_query_reset_features = 1000261000,
    physical_device_timeline_semaphore_features = 1000207000,
    physical_device_timeline_semaphore_properties = 1000207001,
    semaphore_type_create_info = 1000207002,
    timeline_semaphore_submit_info = 1000207003,
    semaphore_wait_info = 1000207004,
    semaphore_signal_info = 1000207005,
    physical_device_buffer_device_address_features = 1000257000,
    buffer_device_address_info = 1000244001,
    buffer_opaque_capture_address_create_info = 1000257002,
    memory_opaque_capture_address_allocate_info = 1000257003,
    device_memory_opaque_capture_address_info = 1000257004,
    physical_device_vulkan_1_3_features = 53,
    physical_device_vulkan_1_3_properties = 54,
    pipeline_creation_feedback_create_info = 1000192000,
    physical_device_shader_terminate_invocation_features = 1000215000,
    physical_device_tool_properties = 1000245000,
    physical_device_shader_demote_to_helper_invocation_features = 1000276000,
    physical_device_private_data_features = 1000295000,
    device_private_data_create_info = 1000295001,
    private_data_slot_create_info = 1000295002,
    physical_device_pipeline_creation_cache_control_features = 1000297000,
    memory_barrier_2 = 1000314000,
    buffer_memory_barrier_2 = 1000314001,
    image_memory_barrier_2 = 1000314002,
    dependency_info = 1000314003,
    submit_info_2 = 1000314004,
    semaphore_submit_info = 1000314005,
    command_buffer_submit_info = 1000314006,
    physical_device_synchronization_2_features = 1000314007,
    physical_device_zero_initialize_workgroup_memory_features = 1000325000,
    physical_device_image_robustness_features = 1000335000,
    copy_buffer_info_2 = 1000337000,
    copy_image_info_2 = 1000337001,
    copy_buffer_to_image_info_2 = 1000337002,
    copy_image_to_buffer_info_2 = 1000337003,
    blit_image_info_2 = 1000337004,
    resolve_image_info_2 = 1000337005,
    buffer_copy_2 = 1000337006,
    image_copy_2 = 1000337007,
    image_blit_2 = 1000337008,
    buffer_image_copy_2 = 1000337009,
    image_resolve_2 = 1000337010,
    physical_device_subgroup_size_control_properties = 1000225000,
    pipeline_shader_stage_required_subgroup_size_create_info = 1000225001,
    physical_device_subgroup_size_control_features = 1000225002,
    physical_device_inline_uniform_block_features = 1000138000,
    physical_device_inline_uniform_block_properties = 1000138001,
    write_descriptor_set_inline_uniform_block = 1000138002,
    descriptor_pool_inline_uniform_block_create_info = 1000138003,
    physical_device_texture_compression_astc_hdr_features = 1000066000,
    rendering_info = 1000044000,
    rendering_attachment_info = 1000044001,
    pipeline_rendering_create_info = 1000044002,
    physical_device_dynamic_rendering_features = 1000044003,
    command_buffer_inheritance_rendering_info = 1000044004,
    physical_device_shader_integer_dot_product_features = 1000280000,
    physical_device_shader_integer_dot_product_properties = 1000280001,
    physical_device_texel_buffer_alignment_properties = 1000281001,
    format_properties_3 = 1000360000,
    physical_device_maintenance_4_features = 1000413000,
    physical_device_maintenance_4_properties = 1000413001,
    device_buffer_memory_requirements = 1000413002,
    device_image_memory_requirements = 1000413003,
    swapchain_create_info_khr = 1000001000,
    present_info_khr = 1000001001,
    device_group_present_capabilities_khr = 1000060007,
    image_swapchain_create_info_khr = 1000060008,
    bind_image_memory_swapchain_info_khr = 1000060009,
    acquire_next_image_info_khr = 1000060010,
    device_group_present_info_khr = 1000060011,
    device_group_swapchain_create_info_khr = 1000060012,
    display_mode_create_info_khr = 1000002000,
    display_surface_create_info_khr = 1000002001,
    display_present_info_khr = 1000003000,
    xlib_surface_create_info_khr = 1000004000,
    xcb_surface_create_info_khr = 1000005000,
    wayland_surface_create_info_khr = 1000006000,
    android_surface_create_info_khr = 1000008000,
    win32_surface_create_info_khr = 1000009000,
    debug_report_callback_create_info_ext = 1000011000,
    pipeline_rasterization_state_rasterization_order_amd = 1000018000,
    debug_marker_object_name_info_ext = 1000022000,
    debug_marker_object_tag_info_ext = 1000022001,
    debug_marker_marker_info_ext = 1000022002,
    video_profile_info_khr = 1000023000,
    video_capabilities_khr = 1000023001,
    video_picture_resource_info_khr = 1000023002,
    video_session_memory_requirements_khr = 1000023003,
    bind_video_session_memory_info_khr = 1000023004,
    video_session_create_info_khr = 1000023005,
    video_session_parameters_create_info_khr = 1000023006,
    video_session_parameters_update_info_khr = 1000023007,
    video_begin_coding_info_khr = 1000023008,
    video_end_coding_info_khr = 1000023009,
    video_coding_control_info_khr = 1000023010,
    video_reference_slot_info_khr = 1000023011,
    queue_family_video_properties_khr = 1000023012,
    video_profile_list_info_khr = 1000023013,
    physical_device_video_format_info_khr = 1000023014,
    video_format_properties_khr = 1000023015,
    queue_family_query_result_status_properties_khr = 1000023016,
    video_decode_info_khr = 1000024000,
    video_decode_capabilities_khr = 1000024001,
    video_decode_usage_info_khr = 1000024002,
    dedicated_allocation_image_create_info_nv = 1000026000,
    dedicated_allocation_buffer_create_info_nv = 1000026001,
    dedicated_allocation_memory_allocate_info_nv = 1000026002,
    physical_device_transform_feedback_features_ext = 1000028000,
    physical_device_transform_feedback_properties_ext = 1000028001,
    pipeline_rasterization_state_stream_create_info_ext = 1000028002,
    cu_module_create_info_nvx = 1000029000,
    cu_function_create_info_nvx = 1000029001,
    cu_launch_info_nvx = 1000029002,
    image_view_handle_info_nvx = 1000030000,
    image_view_address_properties_nvx = 1000030001,
    video_encode_h264_capabilities_khr = 1000038000,
    video_encode_h264_session_parameters_create_info_khr = 1000038001,
    video_encode_h264_session_parameters_add_info_khr = 1000038002,
    video_encode_h264_picture_info_khr = 1000038003,
    video_encode_h264_dpb_slot_info_khr = 1000038004,
    video_encode_h264_nalu_slice_info_khr = 1000038005,
    video_encode_h264_gop_remaining_frame_info_khr = 1000038006,
    video_encode_h264_profile_info_khr = 1000038007,
    video_encode_h264_rate_control_info_khr = 1000038008,
    video_encode_h264_rate_control_layer_info_khr = 1000038009,
    video_encode_h264_session_create_info_khr = 1000038010,
    video_encode_h264_quality_level_properties_khr = 1000038011,
    video_encode_h264_session_parameters_get_info_khr = 1000038012,
    video_encode_h264_session_parameters_feedback_info_khr = 1000038013,
    video_encode_h265_capabilities_khr = 1000039000,
    video_encode_h265_session_parameters_create_info_khr = 1000039001,
    video_encode_h265_session_parameters_add_info_khr = 1000039002,
    video_encode_h265_picture_info_khr = 1000039003,
    video_encode_h265_dpb_slot_info_khr = 1000039004,
    video_encode_h265_nalu_slice_segment_info_khr = 1000039005,
    video_encode_h265_gop_remaining_frame_info_khr = 1000039006,
    video_encode_h265_profile_info_khr = 1000039007,
    video_encode_h265_rate_control_info_khr = 1000039009,
    video_encode_h265_rate_control_layer_info_khr = 1000039010,
    video_encode_h265_session_create_info_khr = 1000039011,
    video_encode_h265_quality_level_properties_khr = 1000039012,
    video_encode_h265_session_parameters_get_info_khr = 1000039013,
    video_encode_h265_session_parameters_feedback_info_khr = 1000039014,
    video_decode_h264_capabilities_khr = 1000040000,
    video_decode_h264_picture_info_khr = 1000040001,
    video_decode_h264_profile_info_khr = 1000040003,
    video_decode_h264_session_parameters_create_info_khr = 1000040004,
    video_decode_h264_session_parameters_add_info_khr = 1000040005,
    video_decode_h264_dpb_slot_info_khr = 1000040006,
    texture_lod_gather_format_properties_amd = 1000041000,
    rendering_fragment_shading_rate_attachment_info_khr = 1000044006,
    rendering_fragment_density_map_attachment_info_ext = 1000044007,
    attachment_sample_count_info_amd = 1000044008,
    multiview_per_view_attributes_info_nvx = 1000044009,
    stream_descriptor_surface_create_info_ggp = 1000049000,
    physical_device_corner_sampled_image_features_nv = 1000050000,
    external_memory_image_create_info_nv = 1000056000,
    export_memory_allocate_info_nv = 1000056001,
    import_memory_win32_handle_info_nv = 1000057000,
    export_memory_win32_handle_info_nv = 1000057001,
    win32_keyed_mutex_acquire_release_info_nv = 1000058000,
    validation_flags_ext = 1000061000,
    vi_surface_create_info_nn = 1000062000,
    image_view_astc_decode_mode_ext = 1000067000,
    physical_device_astc_decode_features_ext = 1000067001,
    pipeline_robustness_create_info_ext = 1000068000,
    physical_device_pipeline_robustness_features_ext = 1000068001,
    physical_device_pipeline_robustness_properties_ext = 1000068002,
    import_memory_win32_handle_info_khr = 1000073000,
    export_memory_win32_handle_info_khr = 1000073001,
    memory_win32_handle_properties_khr = 1000073002,
    memory_get_win32_handle_info_khr = 1000073003,
    import_memory_fd_info_khr = 1000074000,
    memory_fd_properties_khr = 1000074001,
    memory_get_fd_info_khr = 1000074002,
    win32_keyed_mutex_acquire_release_info_khr = 1000075000,
    import_semaphore_win32_handle_info_khr = 1000078000,
    export_semaphore_win32_handle_info_khr = 1000078001,
    d3d12_fence_submit_info_khr = 1000078002,
    semaphore_get_win32_handle_info_khr = 1000078003,
    import_semaphore_fd_info_khr = 1000079000,
    semaphore_get_fd_info_khr = 1000079001,
    physical_device_push_descriptor_properties_khr = 1000080000,
    command_buffer_inheritance_conditional_rendering_info_ext = 1000081000,
    physical_device_conditional_rendering_features_ext = 1000081001,
    conditional_rendering_begin_info_ext = 1000081002,
    present_regions_khr = 1000084000,
    pipeline_viewport_w_scaling_state_create_info_nv = 1000087000,
    surface_capabilities_2_ext = 1000090000,
    display_power_info_ext = 1000091000,
    device_event_info_ext = 1000091001,
    display_event_info_ext = 1000091002,
    swapchain_counter_create_info_ext = 1000091003,
    present_times_info_google = 1000092000,
    physical_device_multiview_per_view_attributes_properties_nvx = 1000097000,
    pipeline_viewport_swizzle_state_create_info_nv = 1000098000,
    physical_device_discard_rectangle_properties_ext = 1000099000,
    pipeline_discard_rectangle_state_create_info_ext = 1000099001,
    physical_device_conservative_rasterization_properties_ext = 1000101000,
    pipeline_rasterization_conservative_state_create_info_ext = 1000101001,
    physical_device_depth_clip_enable_features_ext = 1000102000,
    pipeline_rasterization_depth_clip_state_create_info_ext = 1000102001,
    hdr_metadata_ext = 1000105000,
    physical_device_relaxed_line_rasterization_features_img = 1000110000,
    shared_present_surface_capabilities_khr = 1000111000,
    import_fence_win32_handle_info_khr = 1000114000,
    export_fence_win32_handle_info_khr = 1000114001,
    fence_get_win32_handle_info_khr = 1000114002,
    import_fence_fd_info_khr = 1000115000,
    fence_get_fd_info_khr = 1000115001,
    physical_device_performance_query_features_khr = 1000116000,
    physical_device_performance_query_properties_khr = 1000116001,
    query_pool_performance_create_info_khr = 1000116002,
    performance_query_submit_info_khr = 1000116003,
    acquire_profiling_lock_info_khr = 1000116004,
    performance_counter_khr = 1000116005,
    performance_counter_description_khr = 1000116006,
    physical_device_surface_info_2_khr = 1000119000,
    surface_capabilities_2_khr = 1000119001,
    surface_format_2_khr = 1000119002,
    display_properties_2_khr = 1000121000,
    display_plane_properties_2_khr = 1000121001,
    display_mode_properties_2_khr = 1000121002,
    display_plane_info_2_khr = 1000121003,
    display_plane_capabilities_2_khr = 1000121004,
    ios_surface_create_info_mvk = 1000122000,
    macos_surface_create_info_mvk = 1000123000,
    debug_utils_object_name_info_ext = 1000128000,
    debug_utils_object_tag_info_ext = 1000128001,
    debug_utils_label_ext = 1000128002,
    debug_utils_messenger_callback_data_ext = 1000128003,
    debug_utils_messenger_create_info_ext = 1000128004,
    android_hardware_buffer_usage_android = 1000129000,
    android_hardware_buffer_properties_android = 1000129001,
    android_hardware_buffer_format_properties_android = 1000129002,
    import_android_hardware_buffer_info_android = 1000129003,
    memory_get_android_hardware_buffer_info_android = 1000129004,
    external_format_android = 1000129005,
    android_hardware_buffer_format_properties_2_android = 1000129006,
    physical_device_shader_enqueue_features_amdx = 1000134000,
    physical_device_shader_enqueue_properties_amdx = 1000134001,
    execution_graph_pipeline_scratch_size_amdx = 1000134002,
    execution_graph_pipeline_create_info_amdx = 1000134003,
    pipeline_shader_stage_node_create_info_amdx = 1000134004,
    sample_locations_info_ext = 1000143000,
    render_pass_sample_locations_begin_info_ext = 1000143001,
    pipeline_sample_locations_state_create_info_ext = 1000143002,
    physical_device_sample_locations_properties_ext = 1000143003,
    multisample_properties_ext = 1000143004,
    physical_device_blend_operation_advanced_features_ext = 1000148000,
    physical_device_blend_operation_advanced_properties_ext = 1000148001,
    pipeline_color_blend_advanced_state_create_info_ext = 1000148002,
    pipeline_coverage_to_color_state_create_info_nv = 1000149000,
    write_descriptor_set_acceleration_structure_khr = 1000150007,
    acceleration_structure_build_geometry_info_khr = 1000150000,
    acceleration_structure_device_address_info_khr = 1000150002,
    acceleration_structure_geometry_aabbs_data_khr = 1000150003,
    acceleration_structure_geometry_instances_data_khr = 1000150004,
    acceleration_structure_geometry_triangles_data_khr = 1000150005,
    acceleration_structure_geometry_khr = 1000150006,
    acceleration_structure_version_info_khr = 1000150009,
    copy_acceleration_structure_info_khr = 1000150010,
    copy_acceleration_structure_to_memory_info_khr = 1000150011,
    copy_memory_to_acceleration_structure_info_khr = 1000150012,
    physical_device_acceleration_structure_features_khr = 1000150013,
    physical_device_acceleration_structure_properties_khr = 1000150014,
    acceleration_structure_create_info_khr = 1000150017,
    acceleration_structure_build_sizes_info_khr = 1000150020,
    physical_device_ray_tracing_pipeline_features_khr = 1000347000,
    physical_device_ray_tracing_pipeline_properties_khr = 1000347001,
    ray_tracing_pipeline_create_info_khr = 1000150015,
    ray_tracing_shader_group_create_info_khr = 1000150016,
    ray_tracing_pipeline_interface_create_info_khr = 1000150018,
    physical_device_ray_query_features_khr = 1000348013,
    pipeline_coverage_modulation_state_create_info_nv = 1000152000,
    physical_device_shader_sm_builtins_features_nv = 1000154000,
    physical_device_shader_sm_builtins_properties_nv = 1000154001,
    drm_format_modifier_properties_list_ext = 1000158000,
    physical_device_image_drm_format_modifier_info_ext = 1000158002,
    image_drm_format_modifier_list_create_info_ext = 1000158003,
    image_drm_format_modifier_explicit_create_info_ext = 1000158004,
    image_drm_format_modifier_properties_ext = 1000158005,
    drm_format_modifier_properties_list_2_ext = 1000158006,
    validation_cache_create_info_ext = 1000160000,
    shader_module_validation_cache_create_info_ext = 1000160001,
    physical_device_portability_subset_features_khr = 1000163000,
    physical_device_portability_subset_properties_khr = 1000163001,
    pipeline_viewport_shading_rate_image_state_create_info_nv = 1000164000,
    physical_device_shading_rate_image_features_nv = 1000164001,
    physical_device_shading_rate_image_properties_nv = 1000164002,
    pipeline_viewport_coarse_sample_order_state_create_info_nv = 1000164005,
    ray_tracing_pipeline_create_info_nv = 1000165000,
    acceleration_structure_create_info_nv = 1000165001,
    geometry_nv = 1000165003,
    geometry_triangles_nv = 1000165004,
    geometry_aabb_nv = 1000165005,
    bind_acceleration_structure_memory_info_nv = 1000165006,
    write_descriptor_set_acceleration_structure_nv = 1000165007,
    acceleration_structure_memory_requirements_info_nv = 1000165008,
    physical_device_ray_tracing_properties_nv = 1000165009,
    ray_tracing_shader_group_create_info_nv = 1000165011,
    acceleration_structure_info_nv = 1000165012,
    physical_device_representative_fragment_test_features_nv = 1000166000,
    pipeline_representative_fragment_test_state_create_info_nv = 1000166001,
    physical_device_image_view_image_format_info_ext = 1000170000,
    filter_cubic_image_view_image_format_properties_ext = 1000170001,
    import_memory_host_pointer_info_ext = 1000178000,
    memory_host_pointer_properties_ext = 1000178001,
    physical_device_external_memory_host_properties_ext = 1000178002,
    physical_device_shader_clock_features_khr = 1000181000,
    pipeline_compiler_control_create_info_amd = 1000183000,
    physical_device_shader_core_properties_amd = 1000185000,
    video_decode_h265_capabilities_khr = 1000187000,
    video_decode_h265_session_parameters_create_info_khr = 1000187001,
    video_decode_h265_session_parameters_add_info_khr = 1000187002,
    video_decode_h265_profile_info_khr = 1000187003,
    video_decode_h265_picture_info_khr = 1000187004,
    video_decode_h265_dpb_slot_info_khr = 1000187005,
    device_queue_global_priority_create_info_khr = 1000174000,
    physical_device_global_priority_query_features_khr = 1000388000,
    queue_family_global_priority_properties_khr = 1000388001,
    device_memory_overallocation_create_info_amd = 1000189000,
    physical_device_vertex_attribute_divisor_properties_ext = 1000190000,
    present_frame_token_ggp = 1000191000,
    physical_device_mesh_shader_features_nv = 1000202000,
    physical_device_mesh_shader_properties_nv = 1000202001,
    physical_device_shader_image_footprint_features_nv = 1000204000,
    pipeline_viewport_exclusive_scissor_state_create_info_nv = 1000205000,
    physical_device_exclusive_scissor_features_nv = 1000205002,
    checkpoint_data_nv = 1000206000,
    queue_family_checkpoint_properties_nv = 1000206001,
    physical_device_shader_integer_functions_2_features_intel = 1000209000,
    query_pool_performance_query_create_info_intel = 1000210000,
    initialize_performance_api_info_intel = 1000210001,
    performance_marker_info_intel = 1000210002,
    performance_stream_marker_info_intel = 1000210003,
    performance_override_info_intel = 1000210004,
    performance_configuration_acquire_info_intel = 1000210005,
    physical_device_pci_bus_info_properties_ext = 1000212000,
    display_native_hdr_surface_capabilities_amd = 1000213000,
    swapchain_display_native_hdr_create_info_amd = 1000213001,
    imagepipe_surface_create_info_fuchsia = 1000214000,
    metal_surface_create_info_ext = 1000217000,
    physical_device_fragment_density_map_features_ext = 1000218000,
    physical_device_fragment_density_map_properties_ext = 1000218001,
    render_pass_fragment_density_map_create_info_ext = 1000218002,
    fragment_shading_rate_attachment_info_khr = 1000226000,
    pipeline_fragment_shading_rate_state_create_info_khr = 1000226001,
    physical_device_fragment_shading_rate_properties_khr = 1000226002,
    physical_device_fragment_shading_rate_features_khr = 1000226003,
    physical_device_fragment_shading_rate_khr = 1000226004,
    physical_device_shader_core_properties_2_amd = 1000227000,
    physical_device_coherent_memory_features_amd = 1000229000,
    physical_device_dynamic_rendering_local_read_features_khr = 1000232000,
    rendering_attachment_location_info_khr = 1000232001,
    rendering_input_attachment_index_info_khr = 1000232002,
    physical_device_shader_image_atomic_int64_features_ext = 1000234000,
    physical_device_shader_quad_control_features_khr = 1000235000,
    physical_device_memory_budget_properties_ext = 1000237000,
    physical_device_memory_priority_features_ext = 1000238000,
    memory_priority_allocate_info_ext = 1000238001,
    surface_protected_capabilities_khr = 1000239000,
    physical_device_dedicated_allocation_image_aliasing_features_nv = 1000240000,
    physical_device_buffer_device_address_features_ext = 1000244000,
    buffer_device_address_create_info_ext = 1000244002,
    validation_features_ext = 1000247000,
    physical_device_present_wait_features_khr = 1000248000,
    physical_device_cooperative_matrix_features_nv = 1000249000,
    cooperative_matrix_properties_nv = 1000249001,
    physical_device_cooperative_matrix_properties_nv = 1000249002,
    physical_device_coverage_reduction_mode_features_nv = 1000250000,
    pipeline_coverage_reduction_state_create_info_nv = 1000250001,
    framebuffer_mixed_samples_combination_nv = 1000250002,
    physical_device_fragment_shader_interlock_features_ext = 1000251000,
    physical_device_ycbcr_image_arrays_features_ext = 1000252000,
    physical_device_provoking_vertex_features_ext = 1000254000,
    pipeline_rasterization_provoking_vertex_state_create_info_ext = 1000254001,
    physical_device_provoking_vertex_properties_ext = 1000254002,
    surface_full_screen_exclusive_info_ext = 1000255000,
    surface_capabilities_full_screen_exclusive_ext = 1000255002,
    surface_full_screen_exclusive_win32_info_ext = 1000255001,
    headless_surface_create_info_ext = 1000256000,
    physical_device_shader_atomic_float_features_ext = 1000260000,
    physical_device_extended_dynamic_state_features_ext = 1000267000,
    physical_device_pipeline_executable_properties_features_khr = 1000269000,
    pipeline_info_khr = 1000269001,
    pipeline_executable_properties_khr = 1000269002,
    pipeline_executable_info_khr = 1000269003,
    pipeline_executable_statistic_khr = 1000269004,
    pipeline_executable_internal_representation_khr = 1000269005,
    physical_device_host_image_copy_features_ext = 1000270000,
    physical_device_host_image_copy_properties_ext = 1000270001,
    memory_to_image_copy_ext = 1000270002,
    image_to_memory_copy_ext = 1000270003,
    copy_image_to_memory_info_ext = 1000270004,
    copy_memory_to_image_info_ext = 1000270005,
    host_image_layout_transition_info_ext = 1000270006,
    copy_image_to_image_info_ext = 1000270007,
    subresource_host_memcpy_size_ext = 1000270008,
    host_image_copy_device_performance_query_ext = 1000270009,
    memory_map_info_khr = 1000271000,
    memory_unmap_info_khr = 1000271001,
    physical_device_map_memory_placed_features_ext = 1000272000,
    physical_device_map_memory_placed_properties_ext = 1000272001,
    memory_map_placed_info_ext = 1000272002,
    physical_device_shader_atomic_float_2_features_ext = 1000273000,
    surface_present_mode_ext = 1000274000,
    surface_present_scaling_capabilities_ext = 1000274001,
    surface_present_mode_compatibility_ext = 1000274002,
    physical_device_swapchain_maintenance_1_features_ext = 1000275000,
    swapchain_present_fence_info_ext = 1000275001,
    swapchain_present_modes_create_info_ext = 1000275002,
    swapchain_present_mode_info_ext = 1000275003,
    swapchain_present_scaling_create_info_ext = 1000275004,
    release_swapchain_images_info_ext = 1000275005,
    physical_device_device_generated_commands_properties_nv = 1000277000,
    graphics_shader_group_create_info_nv = 1000277001,
    graphics_pipeline_shader_groups_create_info_nv = 1000277002,
    indirect_commands_layout_token_nv = 1000277003,
    indirect_commands_layout_create_info_nv = 1000277004,
    generated_commands_info_nv = 1000277005,
    generated_commands_memory_requirements_info_nv = 1000277006,
    physical_device_device_generated_commands_features_nv = 1000277007,
    physical_device_inherited_viewport_scissor_features_nv = 1000278000,
    command_buffer_inheritance_viewport_scissor_info_nv = 1000278001,
    physical_device_texel_buffer_alignment_features_ext = 1000281000,
    command_buffer_inheritance_render_pass_transform_info_qcom = 1000282000,
    render_pass_transform_begin_info_qcom = 1000282001,
    physical_device_depth_bias_control_features_ext = 1000283000,
    depth_bias_info_ext = 1000283001,
    depth_bias_representation_info_ext = 1000283002,
    physical_device_device_memory_report_features_ext = 1000284000,
    device_device_memory_report_create_info_ext = 1000284001,
    device_memory_report_callback_data_ext = 1000284002,
    physical_device_robustness_2_features_ext = 1000286000,
    physical_device_robustness_2_properties_ext = 1000286001,
    sampler_custom_border_color_create_info_ext = 1000287000,
    physical_device_custom_border_color_properties_ext = 1000287001,
    physical_device_custom_border_color_features_ext = 1000287002,
    pipeline_library_create_info_khr = 1000290000,
    physical_device_present_barrier_features_nv = 1000292000,
    surface_capabilities_present_barrier_nv = 1000292001,
    swapchain_present_barrier_create_info_nv = 1000292002,
    present_id_khr = 1000294000,
    physical_device_present_id_features_khr = 1000294001,
    video_encode_info_khr = 1000299000,
    video_encode_rate_control_info_khr = 1000299001,
    video_encode_rate_control_layer_info_khr = 1000299002,
    video_encode_capabilities_khr = 1000299003,
    video_encode_usage_info_khr = 1000299004,
    query_pool_video_encode_feedback_create_info_khr = 1000299005,
    physical_device_video_encode_quality_level_info_khr = 1000299006,
    video_encode_quality_level_properties_khr = 1000299007,
    video_encode_quality_level_info_khr = 1000299008,
    video_encode_session_parameters_get_info_khr = 1000299009,
    video_encode_session_parameters_feedback_info_khr = 1000299010,
    physical_device_diagnostics_config_features_nv = 1000300000,
    device_diagnostics_config_create_info_nv = 1000300001,
    cuda_module_create_info_nv = 1000307000,
    cuda_function_create_info_nv = 1000307001,
    cuda_launch_info_nv = 1000307002,
    physical_device_cuda_kernel_launch_features_nv = 1000307003,
    physical_device_cuda_kernel_launch_properties_nv = 1000307004,
    query_low_latency_support_nv = 1000310000,
    export_metal_object_create_info_ext = 1000311000,
    export_metal_objects_info_ext = 1000311001,
    export_metal_device_info_ext = 1000311002,
    export_metal_command_queue_info_ext = 1000311003,
    export_metal_buffer_info_ext = 1000311004,
    import_metal_buffer_info_ext = 1000311005,
    export_metal_texture_info_ext = 1000311006,
    import_metal_texture_info_ext = 1000311007,
    export_metal_io_surface_info_ext = 1000311008,
    import_metal_io_surface_info_ext = 1000311009,
    export_metal_shared_event_info_ext = 1000311010,
    import_metal_shared_event_info_ext = 1000311011,
    queue_family_checkpoint_properties_2_nv = 1000314008,
    checkpoint_data_2_nv = 1000314009,
    physical_device_descriptor_buffer_properties_ext = 1000316000,
    physical_device_descriptor_buffer_density_map_properties_ext = 1000316001,
    physical_device_descriptor_buffer_features_ext = 1000316002,
    descriptor_address_info_ext = 1000316003,
    descriptor_get_info_ext = 1000316004,
    buffer_capture_descriptor_data_info_ext = 1000316005,
    image_capture_descriptor_data_info_ext = 1000316006,
    image_view_capture_descriptor_data_info_ext = 1000316007,
    sampler_capture_descriptor_data_info_ext = 1000316008,
    opaque_capture_descriptor_data_create_info_ext = 1000316010,
    descriptor_buffer_binding_info_ext = 1000316011,
    descriptor_buffer_binding_push_descriptor_buffer_handle_ext = 1000316012,
    acceleration_structure_capture_descriptor_data_info_ext = 1000316009,
    physical_device_graphics_pipeline_library_features_ext = 1000320000,
    physical_device_graphics_pipeline_library_properties_ext = 1000320001,
    graphics_pipeline_library_create_info_ext = 1000320002,
    physical_device_shader_early_and_late_fragment_tests_features_amd = 1000321000,
    physical_device_fragment_shader_barycentric_features_khr = 1000203000,
    physical_device_fragment_shader_barycentric_properties_khr = 1000322000,
    physical_device_shader_subgroup_uniform_control_flow_features_khr = 1000323000,
    physical_device_fragment_shading_rate_enums_properties_nv = 1000326000,
    physical_device_fragment_shading_rate_enums_features_nv = 1000326001,
    pipeline_fragment_shading_rate_enum_state_create_info_nv = 1000326002,
    acceleration_structure_geometry_motion_triangles_data_nv = 1000327000,
    physical_device_ray_tracing_motion_blur_features_nv = 1000327001,
    acceleration_structure_motion_info_nv = 1000327002,
    physical_device_mesh_shader_features_ext = 1000328000,
    physical_device_mesh_shader_properties_ext = 1000328001,
    physical_device_ycbcr_2_plane_444_formats_features_ext = 1000330000,
    physical_device_fragment_density_map_2_features_ext = 1000332000,
    physical_device_fragment_density_map_2_properties_ext = 1000332001,
    copy_command_transform_info_qcom = 1000333000,
    physical_device_workgroup_memory_explicit_layout_features_khr = 1000336000,
    physical_device_image_compression_control_features_ext = 1000338000,
    image_compression_control_ext = 1000338001,
    image_compression_properties_ext = 1000338004,
    physical_device_attachment_feedback_loop_layout_features_ext = 1000339000,
    physical_device_4444_formats_features_ext = 1000340000,
    physical_device_fault_features_ext = 1000341000,
    device_fault_counts_ext = 1000341001,
    device_fault_info_ext = 1000341002,
    physical_device_rgba10x6_formats_features_ext = 1000344000,
    directfb_surface_create_info_ext = 1000346000,
    physical_device_vertex_input_dynamic_state_features_ext = 1000352000,
    vertex_input_binding_description_2_ext = 1000352001,
    vertex_input_attribute_description_2_ext = 1000352002,
    physical_device_drm_properties_ext = 1000353000,
    physical_device_address_binding_report_features_ext = 1000354000,
    device_address_binding_callback_data_ext = 1000354001,
    physical_device_depth_clip_control_features_ext = 1000355000,
    pipeline_viewport_depth_clip_control_create_info_ext = 1000355001,
    physical_device_primitive_topology_list_restart_features_ext = 1000356000,
    import_memory_zircon_handle_info_fuchsia = 1000364000,
    memory_zircon_handle_properties_fuchsia = 1000364001,
    memory_get_zircon_handle_info_fuchsia = 1000364002,
    import_semaphore_zircon_handle_info_fuchsia = 1000365000,
    semaphore_get_zircon_handle_info_fuchsia = 1000365001,
    buffer_collection_create_info_fuchsia = 1000366000,
    import_memory_buffer_collection_fuchsia = 1000366001,
    buffer_collection_image_create_info_fuchsia = 1000366002,
    buffer_collection_properties_fuchsia = 1000366003,
    buffer_constraints_info_fuchsia = 1000366004,
    buffer_collection_buffer_create_info_fuchsia = 1000366005,
    image_constraints_info_fuchsia = 1000366006,
    image_format_constraints_info_fuchsia = 1000366007,
    sysmem_color_space_fuchsia = 1000366008,
    buffer_collection_constraints_info_fuchsia = 1000366009,
    subpass_shading_pipeline_create_info_huawei = 1000369000,
    physical_device_subpass_shading_features_huawei = 1000369001,
    physical_device_subpass_shading_properties_huawei = 1000369002,
    physical_device_invocation_mask_features_huawei = 1000370000,
    memory_get_remote_address_info_nv = 1000371000,
    physical_device_external_memory_rdma_features_nv = 1000371001,
    pipeline_properties_identifier_ext = 1000372000,
    physical_device_pipeline_properties_features_ext = 1000372001,
    physical_device_frame_boundary_features_ext = 1000375000,
    frame_boundary_ext = 1000375001,
    physical_device_multisampled_render_to_single_sampled_features_ext = 1000376000,
    subpass_resolve_performance_query_ext = 1000376001,
    multisampled_render_to_single_sampled_info_ext = 1000376002,
    physical_device_extended_dynamic_state_2_features_ext = 1000377000,
    screen_surface_create_info_qnx = 1000378000,
    physical_device_color_write_enable_features_ext = 1000381000,
    pipeline_color_write_create_info_ext = 1000381001,
    physical_device_primitives_generated_query_features_ext = 1000382000,
    physical_device_ray_tracing_maintenance_1_features_khr = 1000386000,
    physical_device_image_view_min_lod_features_ext = 1000391000,
    image_view_min_lod_create_info_ext = 1000391001,
    physical_device_multi_draw_features_ext = 1000392000,
    physical_device_multi_draw_properties_ext = 1000392001,
    physical_device_image_2d_view_of_3d_features_ext = 1000393000,
    physical_device_shader_tile_image_features_ext = 1000395000,
    physical_device_shader_tile_image_properties_ext = 1000395001,
    micromap_build_info_ext = 1000396000,
    micromap_version_info_ext = 1000396001,
    copy_micromap_info_ext = 1000396002,
    copy_micromap_to_memory_info_ext = 1000396003,
    copy_memory_to_micromap_info_ext = 1000396004,
    physical_device_opacity_micromap_features_ext = 1000396005,
    physical_device_opacity_micromap_properties_ext = 1000396006,
    micromap_create_info_ext = 1000396007,
    micromap_build_sizes_info_ext = 1000396008,
    acceleration_structure_triangles_opacity_micromap_ext = 1000396009,
    physical_device_displacement_micromap_features_nv = 1000397000,
    physical_device_displacement_micromap_properties_nv = 1000397001,
    acceleration_structure_triangles_displacement_micromap_nv = 1000397002,
    physical_device_cluster_culling_shader_features_huawei = 1000404000,
    physical_device_cluster_culling_shader_properties_huawei = 1000404001,
    physical_device_cluster_culling_shader_vrs_features_huawei = 1000404002,
    physical_device_border_color_swizzle_features_ext = 1000411000,
    sampler_border_color_component_mapping_create_info_ext = 1000411001,
    physical_device_pageable_device_local_memory_features_ext = 1000412000,
    physical_device_shader_core_properties_arm = 1000415000,
    physical_device_shader_subgroup_rotate_features_khr = 1000416000,
    device_queue_shader_core_control_create_info_arm = 1000417000,
    physical_device_scheduling_controls_features_arm = 1000417001,
    physical_device_scheduling_controls_properties_arm = 1000417002,
    physical_device_image_sliced_view_of_3d_features_ext = 1000418000,
    image_view_sliced_create_info_ext = 1000418001,
    physical_device_descriptor_set_host_mapping_features_valve = 1000420000,
    descriptor_set_binding_reference_valve = 1000420001,
    descriptor_set_layout_host_mapping_info_valve = 1000420002,
    physical_device_depth_clamp_zero_one_features_ext = 1000421000,
    physical_device_non_seamless_cube_map_features_ext = 1000422000,
    physical_device_render_pass_striped_features_arm = 1000424000,
    physical_device_render_pass_striped_properties_arm = 1000424001,
    render_pass_stripe_begin_info_arm = 1000424002,
    render_pass_stripe_info_arm = 1000424003,
    render_pass_stripe_submit_info_arm = 1000424004,
    physical_device_fragment_density_map_offset_features_qcom = 1000425000,
    physical_device_fragment_density_map_offset_properties_qcom = 1000425001,
    subpass_fragment_density_map_offset_end_info_qcom = 1000425002,
    physical_device_copy_memory_indirect_features_nv = 1000426000,
    physical_device_copy_memory_indirect_properties_nv = 1000426001,
    physical_device_memory_decompression_features_nv = 1000427000,
    physical_device_memory_decompression_properties_nv = 1000427001,
    physical_device_device_generated_commands_compute_features_nv = 1000428000,
    compute_pipeline_indirect_buffer_info_nv = 1000428001,
    pipeline_indirect_device_address_info_nv = 1000428002,
    physical_device_linear_color_attachment_features_nv = 1000430000,
    physical_device_shader_maximal_reconvergence_features_khr = 1000434000,
    physical_device_image_compression_control_swapchain_features_ext = 1000437000,
    physical_device_image_processing_features_qcom = 1000440000,
    physical_device_image_processing_properties_qcom = 1000440001,
    image_view_sample_weight_create_info_qcom = 1000440002,
    physical_device_nested_command_buffer_features_ext = 1000451000,
    physical_device_nested_command_buffer_properties_ext = 1000451001,
    external_memory_acquire_unmodified_ext = 1000453000,
    physical_device_extended_dynamic_state_3_features_ext = 1000455000,
    physical_device_extended_dynamic_state_3_properties_ext = 1000455001,
    physical_device_subpass_merge_feedback_features_ext = 1000458000,
    render_pass_creation_control_ext = 1000458001,
    render_pass_creation_feedback_create_info_ext = 1000458002,
    render_pass_subpass_feedback_create_info_ext = 1000458003,
    direct_driver_loading_info_lunarg = 1000459000,
    direct_driver_loading_list_lunarg = 1000459001,
    physical_device_shader_module_identifier_features_ext = 1000462000,
    physical_device_shader_module_identifier_properties_ext = 1000462001,
    pipeline_shader_stage_module_identifier_create_info_ext = 1000462002,
    shader_module_identifier_ext = 1000462003,
    physical_device_rasterization_order_attachment_access_features_ext = 1000342000,
    physical_device_optical_flow_features_nv = 1000464000,
    physical_device_optical_flow_properties_nv = 1000464001,
    optical_flow_image_format_info_nv = 1000464002,
    optical_flow_image_format_properties_nv = 1000464003,
    optical_flow_session_create_info_nv = 1000464004,
    optical_flow_execute_info_nv = 1000464005,
    optical_flow_session_create_private_data_info_nv = 1000464010,
    physical_device_legacy_dithering_features_ext = 1000465000,
    physical_device_pipeline_protected_access_features_ext = 1000466000,
    physical_device_external_format_resolve_features_android = 1000468000,
    physical_device_external_format_resolve_properties_android = 1000468001,
    android_hardware_buffer_format_resolve_properties_android = 1000468002,
    physical_device_maintenance_5_features_khr = 1000470000,
    physical_device_maintenance_5_properties_khr = 1000470001,
    rendering_area_info_khr = 1000470003,
    device_image_subresource_info_khr = 1000470004,
    subresource_layout_2_khr = 1000338002,
    image_subresource_2_khr = 1000338003,
    pipeline_create_flags_2_create_info_khr = 1000470005,
    buffer_usage_flags_2_create_info_khr = 1000470006,
    physical_device_anti_lag_features_amd = 1000476000,
    anti_lag_data_amd = 1000476001,
    anti_lag_presentation_info_amd = 1000476002,
    physical_device_ray_tracing_position_fetch_features_khr = 1000481000,
    physical_device_shader_object_features_ext = 1000482000,
    physical_device_shader_object_properties_ext = 1000482001,
    shader_create_info_ext = 1000482002,
    physical_device_pipeline_binary_features_khr = 1000483000,
    pipeline_binary_create_info_khr = 1000483001,
    pipeline_binary_info_khr = 1000483002,
    pipeline_binary_key_khr = 1000483003,
    physical_device_pipeline_binary_properties_khr = 1000483004,
    release_captured_pipeline_data_info_khr = 1000483005,
    pipeline_binary_data_info_khr = 1000483006,
    pipeline_create_info_khr = 1000483007,
    device_pipeline_binary_internal_cache_control_khr = 1000483008,
    pipeline_binary_handles_info_khr = 1000483009,
    physical_device_tile_properties_features_qcom = 1000484000,
    tile_properties_qcom = 1000484001,
    physical_device_amigo_profiling_features_sec = 1000485000,
    amigo_profiling_submit_info_sec = 1000485001,
    physical_device_multiview_per_view_viewports_features_qcom = 1000488000,
    physical_device_ray_tracing_invocation_reorder_features_nv = 1000490000,
    physical_device_ray_tracing_invocation_reorder_properties_nv = 1000490001,
    physical_device_extended_sparse_address_space_features_nv = 1000492000,
    physical_device_extended_sparse_address_space_properties_nv = 1000492001,
    physical_device_mutable_descriptor_type_features_ext = 1000351000,
    mutable_descriptor_type_create_info_ext = 1000351002,
    physical_device_legacy_vertex_attributes_features_ext = 1000495000,
    physical_device_legacy_vertex_attributes_properties_ext = 1000495001,
    layer_settings_create_info_ext = 1000496000,
    physical_device_shader_core_builtins_features_arm = 1000497000,
    physical_device_shader_core_builtins_properties_arm = 1000497001,
    physical_device_pipeline_library_group_handles_features_ext = 1000498000,
    physical_device_dynamic_rendering_unused_attachments_features_ext = 1000499000,
    latency_sleep_mode_info_nv = 1000505000,
    latency_sleep_info_nv = 1000505001,
    set_latency_marker_info_nv = 1000505002,
    get_latency_marker_info_nv = 1000505003,
    latency_timings_frame_report_nv = 1000505004,
    latency_submission_present_id_nv = 1000505005,
    out_of_band_queue_type_info_nv = 1000505006,
    swapchain_latency_create_info_nv = 1000505007,
    latency_surface_capabilities_nv = 1000505008,
    physical_device_cooperative_matrix_features_khr = 1000506000,
    cooperative_matrix_properties_khr = 1000506001,
    physical_device_cooperative_matrix_properties_khr = 1000506002,
    physical_device_multiview_per_view_render_areas_features_qcom = 1000510000,
    multiview_per_view_render_areas_render_pass_begin_info_qcom = 1000510001,
    physical_device_compute_shader_derivatives_features_khr = 1000201000,
    physical_device_compute_shader_derivatives_properties_khr = 1000511000,
    video_decode_av1_capabilities_khr = 1000512000,
    video_decode_av1_picture_info_khr = 1000512001,
    video_decode_av1_profile_info_khr = 1000512003,
    video_decode_av1_session_parameters_create_info_khr = 1000512004,
    video_decode_av1_dpb_slot_info_khr = 1000512005,
    physical_device_video_maintenance_1_features_khr = 1000515000,
    video_inline_query_info_khr = 1000515001,
    physical_device_per_stage_descriptor_set_features_nv = 1000516000,
    physical_device_image_processing_2_features_qcom = 1000518000,
    physical_device_image_processing_2_properties_qcom = 1000518001,
    sampler_block_match_window_create_info_qcom = 1000518002,
    sampler_cubic_weights_create_info_qcom = 1000519000,
    physical_device_cubic_weights_features_qcom = 1000519001,
    blit_image_cubic_weights_info_qcom = 1000519002,
    physical_device_ycbcr_degamma_features_qcom = 1000520000,
    sampler_ycbcr_conversion_ycbcr_degamma_create_info_qcom = 1000520001,
    physical_device_cubic_clamp_features_qcom = 1000521000,
    physical_device_attachment_feedback_loop_dynamic_state_features_ext = 1000524000,
    physical_device_vertex_attribute_divisor_properties_khr = 1000525000,
    pipeline_vertex_input_divisor_state_create_info_khr = 1000190001,
    physical_device_vertex_attribute_divisor_features_khr = 1000190002,
    physical_device_shader_float_controls_2_features_khr = 1000528000,
    screen_buffer_properties_qnx = 1000529000,
    screen_buffer_format_properties_qnx = 1000529001,
    import_screen_buffer_info_qnx = 1000529002,
    external_format_qnx = 1000529003,
    physical_device_external_memory_screen_buffer_features_qnx = 1000529004,
    physical_device_layered_driver_properties_msft = 1000530000,
    physical_device_index_type_uint8_features_khr = 1000265000,
    physical_device_line_rasterization_features_khr = 1000259000,
    pipeline_rasterization_line_state_create_info_khr = 1000259001,
    physical_device_line_rasterization_properties_khr = 1000259002,
    calibrated_timestamp_info_khr = 1000184000,
    physical_device_shader_expect_assume_features_khr = 1000544000,
    physical_device_maintenance_6_features_khr = 1000545000,
    physical_device_maintenance_6_properties_khr = 1000545001,
    bind_memory_status_khr = 1000545002,
    bind_descriptor_sets_info_khr = 1000545003,
    push_constants_info_khr = 1000545004,
    push_descriptor_set_info_khr = 1000545005,
    push_descriptor_set_with_template_info_khr = 1000545006,
    set_descriptor_buffer_offsets_info_ext = 1000545007,
    bind_descriptor_buffer_embedded_samplers_info_ext = 1000545008,
    physical_device_descriptor_pool_overallocation_features_nv = 1000546000,
    physical_device_raw_access_chains_features_nv = 1000555000,
    physical_device_shader_relaxed_extended_instruction_features_khr = 1000558000,
    physical_device_command_buffer_inheritance_features_nv = 1000559000,
    physical_device_maintenance_7_features_khr = 1000562000,
    physical_device_maintenance_7_properties_khr = 1000562001,
    physical_device_layered_api_properties_list_khr = 1000562002,
    physical_device_layered_api_properties_khr = 1000562003,
    physical_device_layered_api_vulkan_properties_khr = 1000562004,
    physical_device_shader_atomic_float16_vector_features_nv = 1000563000,
    physical_device_shader_replicated_composites_features_ext = 1000564000,
    physical_device_ray_tracing_validation_features_nv = 1000568000,
    physical_device_device_generated_commands_features_ext = 1000572000,
    physical_device_device_generated_commands_properties_ext = 1000572001,
    generated_commands_memory_requirements_info_ext = 1000572002,
    indirect_execution_set_create_info_ext = 1000572003,
    generated_commands_info_ext = 1000572004,
    indirect_commands_layout_create_info_ext = 1000572006,
    indirect_commands_layout_token_ext = 1000572007,
    write_indirect_execution_set_pipeline_ext = 1000572008,
    write_indirect_execution_set_shader_ext = 1000572009,
    indirect_execution_set_pipeline_info_ext = 1000572010,
    indirect_execution_set_shader_info_ext = 1000572011,
    indirect_execution_set_shader_layout_info_ext = 1000572012,
    generated_commands_pipeline_info_ext = 1000572013,
    generated_commands_shader_info_ext = 1000572014,
    physical_device_image_alignment_control_features_mesa = 1000575000,
    physical_device_image_alignment_control_properties_mesa = 1000575001,
    image_alignment_control_create_info_mesa = 1000575002,
    physical_device_depth_clamp_control_features_ext = 1000582000,
    pipeline_viewport_depth_clamp_control_create_info_ext = 1000582001,
    max_enum = 0x7fffffff,
};

// Types

/// Opaque handle to a device object
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkDevice.html
pub const Device = c.VkDevice;

/// Opaque handle to an instance object
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkInstance.html
pub const Instance = c.VkInstance;

/// Opaque handle to a queue object
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkQueue.html
pub const Queue = c.VkQueue;

// Structs

/// Structure specifying application information
/// https://registry.khronos.org/vulkan/specs/latest/man/html/VkApplicationInfo.html
pub const ApplicationInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    s_type: StructureType = .application_info,
    /// An optional pointer to a structure extending this structure.
    p_next: ?*const anyopaque = null,
    /// An optional pointer to a null-terminated UTF-8 string containing the name of the
    /// application.
    p_application_name: ?[*:0]const u8 = null,
    /// An unsigned integer variable containing the developer-supplied version number of the
    /// application.
    application_version: u32,
    /// An optional pointer to a null-terminated UTF-8 string containing the name of the engine (if
    /// any) used to create the application.
    p_engine_name: ?[*:0]const u8 = null,
    /// An unsigned integer variable containing the developer-supplied version number of the engine
    /// used to create the application.
    engine_version: u32,
    /// The highest version of Vulkan that the application is designed to use, encoded as described
    /// in https://registry.khronos.org/vulkan/specs/latest/html/vkspec.html#extendingvulkan-coreversions-versionnumbers.
    /// The patch version number specified in apiVersion is ignored when creating an instance
    /// object. The variant version of the instance must match that requested in apiVersion.
    api_version: u32,
};

/// Structure specifying parameters of a newly created device
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkDeviceCreateInfo.html
pub const DeviceCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    s_type: StructureType = StructureType.device_create_info,
    /// An optional pointer to a structure extending this structure.
    p_next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    /// The unsigned integer size of the p_queue_create_infos array.
    queue_create_info_count: i32,
    /// A pointer to an array of DeviceQueueCreateInfo structures describing the queues that are
    /// requested to be created along with the logical device.
    p_queue_create_infos: ?[*]const DeviceQueueCreateInfo,
    /// DEPRECATED: `enabled_layer_count` is deprecated and ignored.
    enabled_layer_count: u32 = 0,
    /// DEPRECATED: `pp_enabled_layer_names` is deprecated and ignored
    pp_enabled_layer_names: ?[*]const [*:0]const u8 = null,
    /// The number of device extensions to enable.
    enabled_extension_count: u32 = 0,
    /// An optional pointer to an array of enabledExtensionCount null-terminated UTF-8 strings
    /// containing the names of extensions to enable for the created device.
    pp_enabled_extension_names: ?[*]const [*:0]const u8 = null,
    /// An optional pointer to a PhysicalDeviceFeatures structure containing boolean indicators of
    /// all the features to be enabled.
    p_enabled_features: ?*PhysicalDeviceFeatures,
};

/// Structure specifying parameters of a newly created device queue
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkDeviceQueueCreateInfo.html
pub const DeviceQueueCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    s_type: StructureType = StructureType.device_queue_create_info,
    /// An optional pointer to a structure extending this structure.
    p_next: ?*const anyopaque = null,
    /// A bitmask indicating behavior of the queues.
    flags: u32 = 0,
    /// An unsigned integer indicating the index of the queue family in which to create the queues
    /// on this device. This index corresponds to the index of an element of the
    /// `p_queue_family_properties` array that was returned by
    /// `getPhysicalDeviceQueueFamilyProperties`.
    queue_family_index: u32,
    /// An unsigned integer specifying the number of queues to create in the queue family indicated
    /// by queueFamilyIndex, and with the behavior specified by flags.
    queue_count: u32,
    /// A pointer to an array of queueCount normalized floating-point values, specifying priorities
    /// of work that will be submitted to each created queue.
    p_queue_priorities: [*]const f32,
};

/// Structure specifying an extension properties
/// See: https://registry.khronos.org/VulkanSC/specs/latest/man/html/VkExtensionProperties.html
pub const ExtensionProperties = extern struct {
    /// An array of max_extension_name_size u8 (c_char) containing a null-terminated UTF-8 string
    /// which is the name of the extension.
    extension_name: [max_extension_name_size]u8,
    /// The version of this extension. It is an integer, incremented with backward compatible
    /// changes.
    spec_version: u32,
};

/// Structure specifying a three-dimensional extent
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkExtent3D.html
pub const Extent3d = extern struct {
    /// The width of the extent.
    width: u32,
    /// The height of the extent.
    height: u32,
    /// The depth of the extent.
    depth: u32,
};

/// Structure specifying parameters of a newly created instance
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkInstanceCreateInfo.html
pub const InstanceCreateInfo = extern struct {
    /// A StructureType value identifying this structure.
    s_type: StructureType = .instance_create_info,
    /// An optional pointer to a structure extending this structure.
    p_next: ?*const anyopaque = null,
    /// A bitmask of VkInstanceCreateFlagBits indicating the behavior of the instance.
    flags: InstanceCreateFlags = .{},
    /// An optional pointer to a VkApplicationInfo structure. If not NULL, this information helps
    /// implementations recognize behavior inherent to classes of applications.
    p_application_info: ?*const ApplicationInfo = null,
    /// The number of global layers to enable.
    enabled_layer_count: u32,
    /// An optional pointer to an array of enabledLayerCount null-terminated UTF-8 strings
    /// containing the names of layers to enable for the created instance. The layers are loaded
    /// in the order they are listed in this array, with the first array element being the closest
    /// to the application, and the last array element being the closest to the driver. See the
    /// https://registry.khronos.org/vulkan/specs/latest/html/vkspec.html#extendingvulkan-layers
    /// section for further details.
    pp_enabled_layer_names: ?[*]const ?[*:0]const u8 = null,
    /// The number of global extensions to enable.
    enabled_extension_count: u32 = 0,
    /// An optional pointer to an array of enabledExtensionCount null-terminated UTF-8 strings
    ///containing the names of extensions to enable.
    pp_extension_names: ?[*]const ?[*:0]const u8 = null,
};

/// Bitmask of VkInstanceCreateFlagBits
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkInstanceCreateFlags.html
/// TODO: Rewrite this, I hate this
pub const InstanceCreateFlags = packed struct(u32) {
    enumerate_portability_bit_khr: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    _reserved_bit_32: bool = false,
};

/// A Vulkan Physical Device handle, as well as the device's features, properties, and Queue types.
pub const PhysicalDevice = struct {
    /// Opaque handle to a physical device object
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDevice.html
    handle: c.VkPhysicalDevice,
    /// Fine-grained features that can be supported by an implementation
    features: PhysicalDeviceFeatures,
    /// Physical device properties
    properties: PhysicalDeviceProperties,
    /// TODO: Write doc comment
    queue_family_index_graphics: u32,
    /// A Manatee-specific numeric score for the device. Whichever device has the highest score
    /// will be used when creating the GPU context
    score: u32,

    pub fn init(allocator: std.mem.Allocator, handle: c.VkPhysicalDevice) !PhysicalDevice {
        var device_properties: PhysicalDeviceProperties = undefined;
        getPhysicalDeviceProperties(handle, &device_properties);

        var device_features: PhysicalDeviceFeatures = undefined;
        getPhysicalDeviceFeatures(handle, &device_features);

        var queue_family_property_count: u32 = 0;
        getPhysicalDeviceQueueFamilyProperties(handle, &queue_family_property_count, null);

        const queue_family_properties = try allocator.alloc(QueueFamilyProperties, queue_family_property_count);
        defer allocator.free(queue_family_properties);
        getPhysicalDeviceQueueFamilyProperties(handle, &queue_family_property_count, queue_family_properties.ptr);

        var queue_family_index_graphics: u32 = invalid_queue_family_index;

        for (queue_family_properties, 0..) |queue_family, idx| {
            if (queue_family_index_graphics == invalid_queue_family_index and @intFromEnum(queue_family.queue_flags) & @intFromEnum(QueueFlagBits.graphics_bit) != 0) {
                queue_family_index_graphics = @intCast(idx);
            }

            // TODO: More will come here as I progress with the tutorial
        }

        var score: u32 = 0;
        // Discrete GPUs have a significant performance advantage
        if (device_properties.device_type == .discrete_gpu) {
            score += 1000;
        }

        // Maximum possible size of textures affects graphics quality
        score += device_properties.limits.max_image_dimension_2d;

        // We want to heavily discourage use of devices that don't have geometry shader support,
        // however for Apple devices with integrated GPUs (such as M1 MacBooks), their GPU will
        // never support geometry shaders (due to a lack of support in the Metal API), so we'll set
        // the device's score to 1 just to be on the safe side
        if (device_features.geometry_shader == 0) {
            score = 1;
        }

        return PhysicalDevice{
            .handle = handle,
            .features = device_features,
            .properties = device_properties,
            .queue_family_index_graphics = queue_family_index_graphics,
            .score = score,
        };
    }

    pub fn deinit(self: *PhysicalDevice) void {
        self.* = undefined;
    }
};

/// Structure describing the fine-grained features that can be supported by an implementation
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkPhysicalDeviceFeatures.html
/// TODO: Copy over per-property descriptions... it's gonna be a lot
pub const PhysicalDeviceFeatures = extern struct {
    robust_buffer_access: u32,
    full_draw_index_uint_32: u32,
    image_cube_array: u32,
    independent_blend: u32,
    geometry_shader: u32,
    tessellation_shader: u32,
    sample_rate_shading: u32,
    dual_src_blend: u32,
    logic_op: u32,
    multi_draw_indirect: u32,
    draw_indirect_first_instance: u32,
    depth_clamp: u32,
    depth_bias_clamp: u32,
    fill_mode_non_solid: u32,
    depth_bounds: u32,
    wide_lines: u32,
    large_points: u32,
    alpha_to_one: u32,
    multi_viewport: u32,
    sampler_anisotropy: u32,
    texture_compression_etc_2: u32,
    texture_compression_astc_ldr: u32,
    texture_compression_bc: u32,
    occlusion_query_precise: u32,
    pipeline_statistics_query: u32,
    vertex_pipeline_stores_and_atomics: u32,
    fragment_stores_and_atomics: u32,
    shader_tessellation_and_geometry_point_size: u32,
    shader_image_gather_extended: u32,
    shader_storage_image_extended_formats: u32,
    shader_storage_image_multisample: u32,
    shader_storage_image_read_without_format: u32,
    shader_storage_image_write_without_format: u32,
    shader_uniform_buffer_array_dynamic_indexing: u32,
    shader_sampled_image_array_dynamic_indexing: u32,
    shader_storage_buffer_array_dynamic_indexing: u32,
    shader_storage_image_array_dynamic_indexing: u32,
    shader_clip_distance: u32,
    shader_cull_distance: u32,
    shader_float64: u32,
    shader_int64: u32,
    shader_int16: u32,
    shader_resource_residency: u32,
    shader_resource_min_lod: u32,
    sparse_binding: u32,
    sparse_residency_buffer: u32,
    sparse_residency_image2d: u32,
    sparse_residency_image3d: u32,
    sparse_residency_2_samples: u32,
    sparse_residency_4_samples: u32,
    sparse_residency_8_samples: u32,
    sparse_residency_16_samples: u32,
    sparse_residency_aliased: u32,
    variable_multisample_rate: u32,
    inherited_queries: u32,
};

/// Structure reporting implementation-dependent physical device limits
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
    queue_flags: QueueFlagBits,
    queue_count: u32,
    timestamp_valid_bits: u32,
    min_image_transfer_granularity: Extent3d,
};

pub const Win32SurfaceCreateInfoKHR = extern struct {
    const win32 = @import("../win32.zig");
    sType: StructureType = StructureType.win32_surface_create_info_khr,
    flags: u32 = 0,
    hinstance: *win32.wnd_msg.Instance,
    hwnd: *win32.wnd_msg.Window,
};

/// A Vulkan SurfaceKHR handle with cross-platform initialization
pub const SurfaceKHR = struct {
    allocator: std.mem.Allocator,
    /// Opaque handle to a surface object
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSurfaceKHR.html
    handle: *c.VkSurfaceKHR,
    /// A CoreAnimation CAMetalLayer, only required on MacOS
    /// macos_ca_metal_layer: ?*macos.core_animation.CAMetalLayer,
    /// An AppKit NSView, only required on MacOS
    /// macos_ns_view: ?*macos.app_kit.NSView,
    pub fn init(allocator: std.mem.Allocator, instance: *Instance, native_window: *anyopaque) !SurfaceKHR {
        switch (builtin.target.os.tag) {
            .macos => {
                const apple = @import("../apple.zig");
                const metal = @import("metal.zig");

                const surface_khr_handle = try allocator.create(c.VkSurfaceKHR);
                errdefer allocator.destroy(surface_khr_handle);

                const window_instance: *apple.app_kit.Window = @ptrCast(native_window);
                const window_view: *apple.app_kit.View = @ptrCast(window_instance.getContentView());

                const metal_surface_create_info = metal.MetalSurfaceCreateInfo{
                    .p_layer = window_view.getLayer(),
                };

                if (metal.createMetalSurface(instance.*, &metal_surface_create_info, null, surface_khr_handle) != .success) {
                    return error.metal_surface_creation_failed;
                }

                return SurfaceKHR{
                    .allocator = allocator,
                    .handle = @ptrCast(surface_khr_handle),
                    // .macos_ca_metal_layer = ca_metal_layer,
                    // .macos_ns_view = ns_view,
                };
            },
            .windows => {
                const win32 = @import("../win32.zig");

                const surface_khr_handle = try allocator.create(c.VkSurfaceKHR);
                errdefer allocator.destroy(surface_khr_handle);

                const win32_surface_create_info = Win32SurfaceCreateInfoKHR{
                    .hwnd = @ptrCast(native_window),
                    .hinstance = @ptrCast(try win32.wnd_msg.Instance.init(null)),
                };

                if (createWin32SurfaceKHR(instance.*, &win32_surface_create_info, null, surface_khr_handle) != .success) {
                    return error.metal_surface_creation_failed;
                }

                return SurfaceKHR{
                    .allocator = allocator,
                    .handle = @ptrCast(surface_khr_handle),
                    // .macos_ca_metal_layer = null,
                    // .macos_ns_view = null,
                };
            },
            else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
        }
    }
};

// Functions

/// Create a new device instance
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateDevice.html
pub fn createDevice(physical_device: PhysicalDevice, device_create_info: *const DeviceCreateInfo, allocator: ?*c.VkAllocationCallbacks, device: *Device) Result {
    const result = c.vkCreateDevice(physical_device.handle, @ptrCast(device_create_info), allocator, device);
    return @enumFromInt(result);
}

/// Create a new Vulkan instance
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateInstance.html
pub fn createInstance(create_info: *const InstanceCreateInfo, allocator: ?*c.VkAllocationCallbacks, instance: *Instance) Result {
    const result = c.vkCreateInstance(@ptrCast(create_info), allocator, @ptrCast(instance));
    return @enumFromInt(result);
}

/// Create a new Vulkan instance
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateInstance.html
pub fn createWin32SurfaceKHR(instance: Instance, create_info: *const Win32SurfaceCreateInfoKHR, allocator: ?*const c.VkAllocationCallbacks, surface: *c.VkSurfaceKHR) Result {
    const result = c.vkCreateWin32SurfaceKHR(instance, @ptrCast(create_info), allocator, surface);
    return @enumFromInt(result);
}

/// Destroy a logical device
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyDevice.html
pub fn destroyDevice(device: Device, allocator: ?*c.VkAllocationCallbacks) void {
    return c.vkDestroyDevice(device, allocator);
}

/// Destroy an instance of Vulkan
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyInstance.html
pub fn destroyInstance(instance: Instance, allocator: ?*c.VkAllocationCallbacks) void {
    return c.vkDestroyInstance(instance, allocator);
}

/// Returns up to requested number of global extension properties
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkEnumeratePhysicalDevices.html
pub fn enumeratePhysicalDevices(instance: Instance, physical_device_count: *u32, physical_devices: ?[*]c.VkPhysicalDevice) Result {
    const result = c.vkEnumeratePhysicalDevices(instance, physical_device_count, @ptrCast(physical_devices));
    return @enumFromInt(result);
}

/// Enumerates the physical devices accessible to a Vulkan instance
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkEnumerateInstanceExtensionProperties.html
pub fn enumerateInstanceExtensionProperties(layer_name: ?[*:0]const u8, property_count: *u32, properties: ?[*]ExtensionProperties) Result {
    const result = c.vkEnumerateInstanceExtensionProperties(layer_name, property_count, @ptrCast(properties));
    return @enumFromInt(result);
}

/// Get a queue handle from a device
/// https://registry.khronos.org/vulkan/specs/latest/man/html/vkGetDeviceQueue.html
pub fn getDeviceQueue(device: Device, queue_family_index: u32, queue_index: u32, queue: *Queue) void {
    return c.vkGetDeviceQueue(device, queue_family_index, queue_index, queue);
}

/// Reports capabilities of a physical device
/// https://registry.khronos.org/vulkan/specs/latest/man/html/vkGetPhysicalDeviceProperties.html
pub fn getPhysicalDeviceFeatures(physical_device: c.VkPhysicalDevice, features: *PhysicalDeviceFeatures) void {
    return c.vkGetPhysicalDeviceFeatures(physical_device, @ptrCast(features));
}

/// Returns properties of a physical device
/// https://registry.khronos.org/vulkan/specs/latest/man/html/vkGetPhysicalDeviceProperties.html
pub fn getPhysicalDeviceProperties(physical_device: c.VkPhysicalDevice, properties: *PhysicalDeviceProperties) void {
    return c.vkGetPhysicalDeviceProperties(physical_device, @ptrCast(properties));
}

/// Reports properties of the queues of the specified physical device
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkGetPhysicalDeviceQueueFamilyProperties.html
pub fn getPhysicalDeviceQueueFamilyProperties(physical_device: c.VkPhysicalDevice, queue_family_property_count: *u32, queue_family_properties: ?[*]QueueFamilyProperties) void {
    return c.vkGetPhysicalDeviceQueueFamilyProperties(physical_device, queue_family_property_count, @ptrCast(queue_family_properties));
}

/// Construct an API version number
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VK_MAKE_API_VERSION.html
pub fn makeApiVersion(variant: u3, major: u7, minor: u10, patch: u12) u32 {
    return (@as(u32, variant) << 29) | (@as(u32, major) << 22) | (@as(u32, minor) << 12) | patch;
}
