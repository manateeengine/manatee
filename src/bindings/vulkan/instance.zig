const std = @import("std");

const AllocationCallbacks = @import("allocation_callbacks.zig").AllocationCallbacks;
const PhysicalDevice = @import("physical_device.zig").PhysicalDevice;
const Result = @import("result.zig").Result;
const StructureType = @import("structure_type.zig").StructureType;

/// Opaque handle to an instance object
/// Original: `VkInstance`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkInstance.html
pub const Instance = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(create_info: *const InstanceCreateInfo) !*Self {
        return try createInstance(create_info, null);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.destroyInstance(null);
    }

    /// Create a new Vulkan instance
    /// Original: `VkCreateInstance`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateInstance.html
    pub fn createInstance(create_info: *const InstanceCreateInfo, allocation_callbacks: ?*AllocationCallbacks) !*Self {
        var instance: *Self = undefined;
        const result = vkCreateInstance(create_info, allocation_callbacks, &instance);

        if (result != Result.success) {
            return error.instance_creation_failed;
        }
        return instance;
    }

    /// Enumerates the physical devices accessible to a Vulkan instance
    /// Original: `vkEnumeratePhysicalDevices`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkEnumeratePhysicalDevices.html
    pub fn enumeratePhysicalDevices(self: *Self, allocator: std.mem.Allocator) ![]*PhysicalDevice {
        var physical_Device_count: u32 = 0;
        _ = vkEnumeratePhysicalDevices(self, &physical_Device_count, null);

        if (physical_Device_count == 0) {
            return error.no_physical_devices;
        }

        const physical_devices = try allocator.alloc(*PhysicalDevice, physical_Device_count);
        errdefer allocator.free(physical_devices);

        if (vkEnumeratePhysicalDevices(self, &physical_Device_count, physical_devices.ptr) != .success) {
            return error.device_enumeration_failed;
        }

        return physical_devices;
    }

    /// Destroy an instance of Vulkan
    /// Original: `vkDestroyInstance`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyInstance.html
    pub fn destroyInstance(self: *Self, allocation_callbacks: ?*AllocationCallbacks) void {
        vkDestroyInstance(self, allocation_callbacks);
    }
};

/// The API version number for Vulkan 1.0.0.
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VK_API_VERSION_1_0.html
pub const api_version_1_0 = makeApiVersion(0, 1, 0, 0);

/// Structure specifying application information
/// Original: `VkApplicationInfo`
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

/// Structure specifying parameters of a newly created instance
/// Original: `VkInstanceCreateInfo`
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
/// Original: `VkInstanceCreateFlags`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkInstanceCreateFlags.html
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

/// Construct an API version number
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VK_MAKE_API_VERSION.html
pub fn makeApiVersion(variant: u3, major: u7, minor: u10, patch: u12) u32 {
    return (@as(u32, variant) << 29) | (@as(u32, major) << 22) | (@as(u32, minor) << 12) | patch;
}

extern fn vkCreateInstance(pCreateInfo: *const InstanceCreateInfo, pAllocator: ?*const AllocationCallbacks, instance: **Instance) callconv(.c) Result;
extern fn vkDestroyInstance(instance: *Instance, pAllocator: ?*const AllocationCallbacks) void;
extern fn vkEnumeratePhysicalDevices(instance: *Instance, pPhysicalDeviceCount: *u32, pPhysicalDevices: ?[*]*PhysicalDevice) Result;
