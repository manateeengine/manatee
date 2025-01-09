const physical_device = @import("physical_device.zig");
const shared = @import("shared.zig");

const PhysicalDevice = physical_device.PhysicalDevice;
const PhysicalDeviceFeatures = physical_device.PhysicalDeviceFeatures;
const AllocationCallbacks = shared.AllocationCallbacks;
const Result = shared.Result;
const StructureType = shared.StructureType;

/// Opaque handle to a device object
/// Original: `VkDevice`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkDevice.html
pub const Device = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(physical: *PhysicalDevice, device_create_info: *const DeviceCreateInfo) !*Self {
        return createDevice(physical, device_create_info, null);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.destroyDevice(null);
    }

    /// Create a new device instance
    /// Original: `vkCreateDevice`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateDevice.html
    pub fn createDevice(physical: *PhysicalDevice, device_create_info: *const DeviceCreateInfo, allocator_callbacks: ?*const AllocationCallbacks) !*Self {
        var device: *Self = undefined;
        try vkCreateDevice(physical, device_create_info, allocator_callbacks, &device).check();
        return device;
    }

    /// Destroy a logical device
    /// Original: `vkDestroyDevice`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyDevice.html
    pub fn destroyDevice(self: *Self, allocator_callbacks: ?*const AllocationCallbacks) void {
        return vkDestroyDevice(self, allocator_callbacks);
    }

    /// Get a queue handle from a device
    /// Original: `vkGetDeviceQueue`
    /// https://registry.khronos.org/vulkan/specs/latest/man/html/vkGetDeviceQueue.html
    pub fn getQueue(self: *Self, queue_family_index: u32, queue_index: u32) *Queue {
        var queue: *Queue = undefined;
        vkGetDeviceQueue(self, queue_family_index, queue_index, &queue);
        return queue;
    }
};

/// Opaque handle to a queue object
/// Original: `VkQueue`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkQueue.html
pub const Queue = opaque {};

/// Structure specifying parameters of a newly created device
/// Original: `VkDeviceCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkDeviceCreateInfo.html
pub const DeviceCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.device_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    /// The unsigned integer size of the p_queue_create_infos array.
    queue_create_info_count: i32,
    /// A pointer to an array of DeviceQueueCreateInfo structures describing the queues that are
    /// requested to be created along with the logical device.
    queue_create_infos: ?[*]const DeviceQueueCreateInfo,
    /// DEPRECATED: `enabled_layer_count` is deprecated and ignored.
    enabled_layer_count: u32 = 0,
    /// DEPRECATED: `pp_enabled_layer_names` is deprecated and ignored
    enabled_layer_names: ?[*]const [*:0]const u8 = null,
    /// The number of device extensions to enable.
    enabled_extension_count: u32 = 0,
    /// An optional pointer to an array of enabledExtensionCount null-terminated UTF-8 strings
    /// containing the names of extensions to enable for the created device.
    enabled_extension_names: ?[*]const [*:0]const u8 = null,
    /// An optional pointer to a PhysicalDeviceFeatures structure containing boolean indicators of
    /// all the features to be enabled.
    enabled_features: ?*PhysicalDeviceFeatures,
};

/// Structure specifying parameters of a newly created device queue
/// Original: `VkDeviceQueueCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkDeviceQueueCreateInfo.html
pub const DeviceQueueCreateInfo = extern struct {
    /// A `StructureType` value identifying this structure.
    type: StructureType = StructureType.device_queue_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
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
    queue_priorities: [*]const f32,
};

extern fn vkCreateDevice(physicalDevice: *PhysicalDevice, *const DeviceCreateInfo, pAllocator: ?*const AllocationCallbacks, pDevice: **Device) Result;
extern fn vkDestroyDevice(device: *Device, pAllocator: ?*const AllocationCallbacks) void;
extern fn vkGetDeviceQueue(device: *Device, queueFamilyIndex: u32, queueIndex: u32, pQueue: **Queue) void;
