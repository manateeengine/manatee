const std = @import("std");

const physical_device = @import("physical_device.zig");
const shared = @import("shared.zig");

const Device = @import("device.zig").Device;
const Image = @import("image.zig").Image;
const SurfaceKhr = @import("surface_khr.zig").SurfaceKhr;

const AllocationCallbacks = shared.AllocationCallbacks;
const Format = shared.Format;
const Result = shared.Result;
const StructureType = shared.StructureType;

/// Opaque handle to a swapchain object
/// Original: `VkSwapchainKHR`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSwapchainKHR.html
pub const SwapchainKhr = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(device: *Device, create_info: *const SwapchainCreateInfoKhr) !*Self {
        return createSwapchain(device, create_info, null);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self, device: *Device) void {
        return self.destroySwapchain(device, null);
    }

    /// Create a swapchain
    /// Original: `vkCreateSwapchainKHR`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateSwapchainKHR.html
    pub fn createSwapchain(device: *Device, create_info: *const SwapchainCreateInfoKhr, allocation_callbacks: ?*const AllocationCallbacks) !*Self {
        var swapchain: *Self = undefined;
        try vkCreateSwapchainKHR(device, create_info, allocation_callbacks, &swapchain).check();
        return swapchain;
    }

    /// Destroy a swapchain object
    /// Original: `vkDestroySwapchainKHR`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroySwapchainKHR.html
    pub fn destroySwapchain(self: *Self, device: *Device, allocation_callbacks: ?*const AllocationCallbacks) void {
        return vkDestroySwapchainKHR(device, self, allocation_callbacks);
    }

    /// Obtain the array of presentable images associated with a swapchain
    /// Original: `vkGetSwapchainImagesKHR`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkGetSwapchainImagesKHR.html
    pub fn getImagesKhr(self: *Self, allocator: std.mem.Allocator, device: *Device) ![]*Image {
        var images_count: u32 = 0;
        _ = vkGetSwapchainImagesKHR(device, self, &images_count, null);

        const images = try allocator.alloc(*Image, images_count);
        errdefer allocator.free(images);
        try vkGetSwapchainImagesKHR(device, self, &images_count, images.ptr).check();

        return images;
    }
};

/// Buffer and image sharing modes
/// Original: `VkSharingMode`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSharingMode.html
pub const SharingMode = enum(u32) {
    exclusive = 0,
    concurrent = 1,
};

/// Structure specifying parameters of a newly created swapchain object
/// Original: `VkSwapchainCreateInfoKhr`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSwapchainCreateInfoKHR.html
pub const SwapchainCreateInfoKhr = extern struct {
    structure_type: StructureType = .swapchain_create_info_khr,
    p_next: ?*const anyopaque = null,
    flags: u32 = 0,
    surface: *SurfaceKhr,
    min_image_count: u32,
    image_format: Format,
    image_color_space: physical_device.ColorSpaceKhr,
    image_extent: physical_device.Extent2d,
    image_array_layers: u32,
    image_usage: physical_device.ImageUsageFlags = physical_device.ImageUsageFlags{},
    image_sharing_mode: SharingMode,
    queue_family_index_count: u32 = 0,
    queue_family_indices: ?[*]const u32 = null,
    pre_transform: physical_device.SurfaceTransformFlagsKhr = physical_device.SurfaceTransformFlagsKhr{},
    composite_alpha: physical_device.CompositeAlphaFlagsKhr = physical_device.CompositeAlphaFlagsKhr{},
    present_mode: physical_device.PresentModeKhr,
    clipped: bool,
    old_swapchain: ?*SwapchainKhr,
};

extern fn vkCreateSwapchainKHR(device: *Device, pCreateInfo: *const SwapchainCreateInfoKhr, pAllocator: ?*const AllocationCallbacks, pSwapchain: **SwapchainKhr) Result;
extern fn vkDestroySwapchainKHR(device: *Device, swapchain: *SwapchainKhr, pAllocator: ?*const AllocationCallbacks) void;
extern fn vkGetSwapchainImagesKHR(device: *Device, swapchain: *SwapchainKhr, pSwapchainImageCount: *u32, ?[*]*Image) Result;
