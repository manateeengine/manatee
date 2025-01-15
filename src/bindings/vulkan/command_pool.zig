const shared = @import("shared.zig");

const Device = @import("device.zig").Device;

const AllocationCallbacks = shared.AllocationCallbacks;
const Result = shared.Result;
const StructureType = shared.StructureType;

/// Opaque handle to a command pool object
/// Original: `VkCommandPool`
/// See: https://registry.khronos.org/VulkanSC/specs/1.0-extensions/man/html/VkCommandPool.html
pub const CommandPool = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(device: *Device, create_info: *const CommandPoolCreateInfo) !*Self {
        return try createCommandPool(device, create_info, null);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self, device: *Device) void {
        return self.destroyCommandPool(device, null);
    }

    /// Create a new command pool object
    /// Original: `vkCreateCommandPool`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateCommandPool.html
    pub fn createCommandPool(device: *Device, create_info: *const CommandPoolCreateInfo, allocation_callbacks: ?*AllocationCallbacks) !*Self {
        var command_pool: *Self = undefined;
        try vkCreateCommandPool(device, create_info, allocation_callbacks, &command_pool).check();
        return command_pool;
    }

    /// Destroy a command pool object
    /// Original: `vkDestroyCommandPool`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyCommandPool.html
    pub fn destroyCommandPool(self: *Self, device: *Device, allocation_callbacks: ?*AllocationCallbacks) void {
        return vkDestroyCommandPool(device, self, allocation_callbacks);
    }
};

/// Bitmask specifying usage behavior for a command pool
/// Original: `VkCommandPoolCreateFlags`
/// https://registry.khronos.org/vulkan/specs/latest/man/html/VkCommandPoolCreateFlagBits.html
pub const CommandPoolCreateFlags = packed struct(u32) {
    const Self = @This();

    transient_bit_enabled: bool = false,
    reset_command_buffer_bit_enabled: bool = false,
    protected_bit_enabled: bool = false,
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

    /// Specifies that command buffers allocated from the pool will be short-lived, meaning that
    /// they will be reset or freed in a relatively short timeframe.
    pub const transient_bit = Self{
        .transient_bit_enabled = true,
    };
    /// Allows any command buffer allocated from a pool to be individually reset to the initial
    /// state; either by calling `resetCommandBuffer`, or via the implicit reset when calling
    /// `beginCommandBuffer`.
    pub const reset_command_buffer_bit = Self{
        .reset_command_buffer_bit_enabled = true,
    };
    /// Specifies that command buffers allocated from the pool are protected command buffers.
    pub const protected_bit = Self{
        .protected_bit_enabled = true,
    };
};

/// Structure specifying parameters of a newly created command pool
/// Original: `VkCommandPoolCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkCommandPoolCreateInfo.html
pub const CommandPoolCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.command_pool_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// A bitmask of `CommandPoolCreateFlagBits` indicating usage behavior for the pool and command
    /// buffers allocated from it.
    flags: CommandPoolCreateFlags = .{},
    /// Designates a queue family as described in section Queue Family Properties.
    queue_family_index: u32,
};

extern fn vkCreateCommandPool(device: *Device, pCreateInfo: *const CommandPoolCreateInfo, pAllocator: ?*const AllocationCallbacks, pCommandPool: **CommandPool) callconv(.c) Result;
extern fn vkDestroyCommandPool(device: *Device, commandPool: *CommandPool, pAllocator: ?*const AllocationCallbacks) callconv(.c) void;
