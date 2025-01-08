const AllocationCallbacks = @import("allocation_callbacks.zig").AllocationCallbacks;
const Device = @import("device.zig").Device;
const Result = @import("result.zig").Result;
const StructureType = @import("structure_type.zig").StructureType;

/// Opaque handle to a shader module object
/// Original: `VkShaderModule`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkShaderModule.html
pub const ShaderModule = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(device: *Device, create_info: *const ShaderModuleCreateInfo) !*Self {
        return createShaderModule(device, create_info, null);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self, device: *Device) void {
        return self.destroyShaderModule(device, null);
    }

    /// Creates a new shader module object
    /// Original: `vkCreateShaderModule`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateShaderModule.html
    pub fn createShaderModule(device: *Device, create_info: *const ShaderModuleCreateInfo, allocation_callbacks: ?*AllocationCallbacks) !*Self {
        var shader_module: *Self = undefined;
        try vkCreateShaderModule(device, create_info, allocation_callbacks, &shader_module).check();
        return shader_module;
    }

    /// Destroy a shader module
    /// Original: `vkDestroyShaderModule`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroyShaderModule.html
    pub fn destroyShaderModule(self: *Self, device: *Device, allocation_callbacks: ?*AllocationCallbacks) void {
        return vkDestroyShaderModule(device, self, allocation_callbacks);
    }
};

/// Structure specifying parameters of a newly created shader module
/// Original: `VkShaderModuleCreateInfo`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkShaderModuleCreateInfo.html
pub const ShaderModuleCreateInfo = extern struct {
    /// A StructureType value identifying this structure.
    type: StructureType = StructureType.shader_module_create_info,
    /// An optional pointer to a structure extending this structure.
    next: ?*const anyopaque = null,
    /// Reserved for future use.
    flags: u32 = 0,
    /// The size, in bytes, of the code pointed to by `code`.
    code_size: usize,
    /// A pointer to code that is used to create the shader module.
    code: [*]const u32,
};

extern fn vkCreateShaderModule(device: *Device, pCreateInfo: *const ShaderModuleCreateInfo, pAllocator: ?*AllocationCallbacks, pShaderModule: **ShaderModule) Result;
extern fn vkDestroyShaderModule(device: *Device, shaderModule: *ShaderModule, pAllocator: ?*AllocationCallbacks) void;
