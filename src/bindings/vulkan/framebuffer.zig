const shared = @import("shared.zig");

const Device = @import("device.zig").Device;
const ImageView = @import("image_view.zig").ImageView;
const RenderPass = @import("render_pass.zig").RenderPass;

const AllocationCallbacks = shared.AllocationCallbacks;
const Result = shared.Result;
const StructureType = shared.StructureType;

/// Opaque handle to a framebuffer object
/// Original: `VkFramebuffer`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkFramebuffer.html
pub const Framebuffer = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(device: *Device, create_info: *const FramebufferCreateInfo) !*Self {
        return try createFramebuffer(device, create_info, null);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self, device: *Device) void {
        return self.destroyFramebuffer(device, null);
    }

    /// Create a new framebuffer object
    /// Original: `vkCreateFramebuffer`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateFramebuffer.html
    pub fn createFramebuffer(device: *Device, create_info: *const FramebufferCreateInfo, allocation_callbacks: ?*const AllocationCallbacks) !*Self {
        var framebuffer: *Self = undefined;
        try vkCreateFramebuffer(device, create_info, allocation_callbacks, &framebuffer).check();
        return framebuffer;
    }

    /// Destroy a framebuffer object
    /// Original: `vkDestroyFramebuffer`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyFramebuffer.html
    pub fn destroyFramebuffer(self: *Self, device: *Device, allocation_callbacks: ?*const AllocationCallbacks) void {
        return vkDestroyFramebuffer(device, self, allocation_callbacks);
    }
};

/// Bitmask specifying framebuffer properties
/// Original: `VkFramebufferCreateFlags`
/// https://registry.khronos.org/vulkan/specs/latest/man/html/VkFramebufferCreateFlagBits.html
pub const FramebufferCreateFlags = packed struct(u32) {
    const Self = @This();

    imageless_bit_enabled: bool = false,
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

    /// Specifies that image views are not specified, and only attachment compatibility information
    /// will be provided via a `FramebufferAttachmentImageInfo` structure.
    pub const imageless_bit = Self{
        .imageless_bit_enabled = true,
    };
};

/// Structure specifying parameters of a newly created framebuffer
/// Original: `VkFramebufferCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkFramebufferCreateInfo.html
pub const FramebufferCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.framebuffer_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// A bitmask of `FramebufferCreateFlagBits`
    flags: FramebufferCreateFlags = .{},
    /// A render pass defining what render passes the framebuffer will be compatible with.
    render_pass: *RenderPass,
    /// The number of attachments.
    attachment_count: u32 = 0,
    /// A pointer to an array of `ImageView` handles, each of which will be used as the
    /// corresponding attachment in a render pass instance.
    attachments: ?[*]const *ImageView = null,
    /// The width of the framebuffer.
    width: u32,
    /// The height of the framebuffer.
    height: u32,
    /// The number of layers in the framebuffer.
    layers: u32,
};

extern fn vkCreateFramebuffer(device: *Device, pCreateInfo: *const FramebufferCreateInfo, pAllocator: ?*const AllocationCallbacks, pFramebuffer: **Framebuffer) callconv(.c) Result;
extern fn vkDestroyFramebuffer(device: *Device, framebuffer: *Framebuffer, pAllocator: ?*const AllocationCallbacks) callconv(.c) void;
