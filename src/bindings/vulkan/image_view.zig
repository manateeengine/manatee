const AllocationCallbacks = @import("allocation_callbacks.zig").AllocationCallbacks;
const Device = @import("device.zig").Device;
const Format = @import("format.zig").Format;
const Image = @import("image.zig").Image;
const Result = @import("result.zig").Result;
const StructureType = @import("structure_type.zig").StructureType;

/// Opaque handle to an image view object
/// Original: `VkImageView`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkImageView.html
pub const ImageView = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(device: *Device, create_info: *const ImageViewCreateInfo) !*Self {
        return try createImageView(device, create_info, null);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self, device: *Device) void {
        return self.destroyImageView(device, null);
    }

    /// Create an image view from an existing image
    /// Original: `vkCreateImageView`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateImageView.html
    pub fn createImageView(device: *Device, create_info: *const ImageViewCreateInfo, allocation_callbacks: ?*AllocationCallbacks) !*Self {
        var image_view: *Self = undefined;
        try vkCreateImageView(device, create_info, allocation_callbacks, &image_view).check();
        return image_view;
    }

    /// Destroy an image view object
    /// Original: `vkDestroyImageView`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyImageView.html
    pub fn destroyImageView(self: *Self, device: *Device, allocation_callbacks: ?*AllocationCallbacks) void {
        return vkDestroyImageView(device, self, allocation_callbacks);
    }
};

/// Specify how a component is swizzled
/// Original: `VkComponentSwizzle`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkComponentSwizzle.html
pub const ComponentSwizzle = enum(u32) {
    /// Specifies that the component is set to the identity swizzle.
    identity = 0,
    /// Specifies that the component is set to zero.
    zero = 1,
    /// Specifies that the component is set to either 1 or 1.0, depending on whether the type of
    /// the image view format is integer or floating-point respectively, as determined by the
    /// Format Definition section for each `Format`.
    one = 2,
    /// Specifies that the component is set to the value of the R component of the image.
    r = 3,
    /// Specifies that the component is set to the value of the G component of the image.
    g = 4,
    /// Specifies that the component is set to the value of the B component of the image.
    b = 5,
    /// Specifies that the component is set to the value of the A component of the image.
    a = 6,
};

/// Image view types
/// Original: `VkImageViewType`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkImageViewType.html
pub const ImageViewType = enum(u32) {
    @"1d" = 0,
    @"2d" = 1,
    @"3d" = 2,
    cube = 3,
    @"1d_array" = 4,
    @"2d_array" = 5,
    cube_array = 6,
};

/// Structure specifying a color component mapping
/// Original: `VkComponentSwizzle`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkComponentMapping.html
pub const ComponentMapping = extern struct {
    /// A `ComponentSwizzle` specifying the component value placed in the R component of the output
    /// vector.
    r: ComponentSwizzle,
    /// A `ComponentSwizzle` specifying the component value placed in the G component of the output
    /// vector.
    g: ComponentSwizzle,
    /// A `ComponentSwizzle` specifying the component value placed in the B component of the output
    /// vector.
    b: ComponentSwizzle,
    /// A `ComponentSwizzle` specifying the component value placed in the A component of the output
    /// vector.
    a: ComponentSwizzle,
};

/// Bitmask specifying which aspects of an image are included in a view
/// Original: `VkImageAspectFlagBits`
/// See: https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VkImageAspectFlagBits.html
pub const ImageAspectFlags = packed struct(u32) {
    const Self = @This();

    color_bit_enabled: bool = false,
    depth_bit_enabled: bool = false,
    stencil_bit_enabled: bool = false,
    metadata_bit_enabled: bool = false,
    plane_0_bit_enabled: bool = false,
    plane_1_bit_enabled: bool = false,
    plane_2_bit_enabled: bool = false,
    memory_plane_0_bit_ext_enabled: bool = false,
    memory_plane_1_bit_ext_enabled: bool = false,
    memory_plane_2_bit_ext_enabled: bool = false,
    memory_plane_3_bit_ext_enabled: bool = false,
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

    /// Specifies the color aspect.
    pub const color_bit = Self{ .color_bit_enabled = true };
    /// Specifies the depth aspect.
    pub const depth_bit = Self{ .depth_bit_enabled = true };
    /// Specifies the stencil aspect.
    pub const stencil_bit = Self{ .stencil_bit_enabled = true };
    /// Specifies the metadata aspect used for sparse resource operations.
    pub const metadata_bit = Self{ .metadata_bit_enabled = true };
    /// Specifies plane 0 of a multi-planar image format.
    pub const plane_0_bit = Self{ .plane_0_bit_enabled = true };
    /// Specifies plane 1 of a multi-planar image format.
    pub const plane_1_bit = Self{ .plane_1_bit_enabled = true };
    /// Specifies plane 2 of a multi-planar image format.
    pub const plane_2_bit = Self{ .plane_2_bit_enabled = true };
    /// Specifies memory plane 0.
    pub const memory_plane_0_bit = Self{ .memory_plane_0_bit_enabled = true };
    /// Specifies memory plane 1.
    pub const memory_plane_1_bit = Self{ .memory_plane_1_bit_enabled = true };
    /// Specifies memory plane 2.
    pub const memory_plane_2_bit = Self{ .memory_plane_2_bit_enabled = true };
    /// Specifies memory plane 3.
    pub const memory_plane_3_bit = Self{ .memory_plane_3_bit_enabled = true };
};

/// Structure specifying an image subresource range
/// Original: `VkImageSubresourceRange`
/// See: https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VkImageSubresourceRange.html
pub const ImageSubresourceRange = extern struct {
    /// A bitmask of `ImageAspectFlags` specifying which aspect(s) of the image are included in the
    /// view.
    aspect_mask: ImageAspectFlags,
    /// The first mipmap level accessible to the view.
    base_mip_level: u32,
    /// The number of mipmap levels (starting from `base_mip_level`) accessible to the view.
    level_count: u32,
    /// The first array layer accessible to the view.
    base_array_layer: u32,
    /// The number of array layers (starting from `base_array_layer`) accessible to the view.
    layer_count: u32,
};

/// Bitmask specifying additional parameters of an image view
/// Original: `VkImageViewCreateFlagBits`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkImageViewCreateFlagBits.html
pub const ImageViewCreateFlags = packed struct(u32) {
    const Self = @This();

    fragment_density_map_dynamic_bit_ext_enabled: bool = false,
    fragment_density_map_deferred_bit_ext_enabled: bool = false,
    descriptor_buffer_capture_replay_bit_ext_enabled: bool = false,
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

    /// Specifies that the fragment density map will be read by device.
    pub const fragment_density_map_dynamic_bit_ext = Self{ .fragment_density_map_dynamic_bit_ext_enabled = true };
    /// Specifies that the image view can be used with descriptor buffers when capturing and
    /// replaying
    pub const descriptor_buffer_capture_replay_bit_ext = Self{ .descriptor_buffer_capture_replay_bit_ext_enabled = true };
    /// Specifies that the fragment density map will be read by the host.
    pub const fragment_density_map_deferred_bit_ext = Self{ .fragment_density_map_deferred_bit_ext_enabled = true };
};

pub const ImageViewCreateInfo = extern struct {
    type: StructureType = StructureType.image_view_create_info,
    next: ?*anyopaque = null,
    flags: ImageViewCreateFlags = ImageViewCreateFlags{},
    image: *Image,
    view_type: ImageViewType,
    format: Format,
    components: ComponentMapping,
    subresource_range: ImageSubresourceRange,
};

extern fn vkCreateImageView(device: *Device, pCreateInfo: *const ImageViewCreateInfo, pAllocator: ?*AllocationCallbacks, pView: **ImageView) Result;
extern fn vkDestroyImageView(device: *Device, imageView: *ImageView, pAllocator: ?*AllocationCallbacks) void;
