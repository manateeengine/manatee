const std = @import("std");

// Zig Setup

// TODO: Does this need to change for other platforms?
pub const vulkan_callconv = std.builtin.CallingConvention.c;

// Constants

pub const VK_MAX_EXTENSION_NAME_SIZE: usize = 256;
pub const VK_MAX_PHYSICAL_DEVICE_NAME_SIZE: usize = 256;
pub const VK_UUID_SIZE: usize = 16;

// Types

pub const VkDevice = enum(usize) { null_handle = 0, _ };
pub const VkInstance = enum(usize) { null_handle = 0, _ };
pub const VkPhysicalDevice = enum(usize) { null_handle = 0, _ };
pub const VkQueue = enum(usize) { null_handle = 0, _ };
pub const VkSurfaceKHR = enum(u64) { null_handle = 0, _ };

// Structs

// TODO: Implement this (if Manatee even needs it?)
pub const VkAllocationCallbacks = opaque {};

pub const VkApplicationInfo = extern struct {
    sType: i32,
    pNext: ?*const anyopaque,
    pApplicationName: ?[*:0]const u8,
    applicationVersion: u32,
    pEngineName: ?[*:0]const u8,
    engineVersion: u32,
    apiVersion: u32,
};

pub const VkDeviceCreateInfo = extern struct {
    sType: i32,
    pNext: ?*const anyopaque,
    flags: u32,
    queueCreateInfoCount: i32,
    pQueueCreateInfos: ?[*]const VkDeviceQueueCreateInfo,
    enabledLayerCount: u32,
    ppEnabledLayerNames: ?[*]const [*:0]const u8,
    enabledExtensionCount: u32,
    ppEnabledExtensionNames: ?[*]const [*:0]const u8,
    pEnabledFeatures: ?*VkPhysicalDeviceFeatures,
};

pub const VkDeviceQueueCreateInfo = extern struct {
    sType: i32,
    pNext: ?*const anyopaque,
    flags: u32,
    queueFamilyIndex: u32,
    queueCount: u32,
    pQueuePriorities: [*]f32,
};

pub const VkExtensionProperties = extern struct {
    extensionName: [VK_MAX_EXTENSION_NAME_SIZE]u8,
    specVersion: u32,
};

pub const VkExtent3D = extern struct {
    width: u32,
    height: u32,
    depth: u32,
};

pub const VkMetalSurfaceCreateInfoEXT = extern struct {
    sType: i32,
    pNext: ?*const anyopaque,
    flags: u32,
    pLayer: *const anyopaque,
};

pub const VkInstanceCreateInfo = extern struct {
    sType: i32,
    pNext: ?*const anyopaque,
    flags: u32,
    pApplicationInfo: ?*const VkApplicationInfo,
    enabledLayerCount: u32,
    ppEnabledLayerNames: ?[*]const [*:0]const u8,
    enabledExtensionCount: u32,
    ppExtensionNames: ?[*]const [*:0]const u8,
};

pub const VkPhysicalDeviceFeatures = extern struct {
    robustBufferAccess: u32,
    fullDrawIndexUint32: u32,
    imageCubeArray: u32,
    independentBlend: u32,
    geometryShader: u32,
    tessellationShader: u32,
    sampleRateShading: u32,
    dualSrcBlend: u32,
    logicOp: u32,
    multiDrawIndirect: u32,
    drawIndirectFirstInstance: u32,
    depthClamp: u32,
    depthBiasClamp: u32,
    fillModeNonSolid: u32,
    depthBounds: u32,
    wideLines: u32,
    largePoints: u32,
    alphaToOne: u32,
    multiViewport: u32,
    samplerAnisotropy: u32,
    textureCompressionETC2: u32,
    textureCompressionASTC_LDR: u32,
    textureCompressionBC: u32,
    occlusionQueryPrecise: u32,
    pipelineStatisticsQuery: u32,
    vertexPipelineStoresAndAtomics: u32,
    fragmentStoresAndAtomics: u32,
    shaderTessellationAndGeometryPointSize: u32,
    shaderImageGatherExtended: u32,
    shaderStorageImageExtendedFormats: u32,
    shaderStorageImageMultisample: u32,
    shaderStorageImageReadWithoutFormat: u32,
    shaderStorageImageWriteWithoutFormat: u32,
    shaderUniformBufferArrayDynamicIndexing: u32,
    shaderSampledImageArrayDynamicIndexing: u32,
    shaderStorageBufferArrayDynamicIndexing: u32,
    shaderStorageImageArrayDynamicIndexing: u32,
    shaderClipDistance: u32,
    shaderCullDistance: u32,
    shaderFloat64: u32,
    shaderInt64: u32,
    shaderInt16: u32,
    shaderResourceResidency: u32,
    shaderResourceMinLod: u32,
    sparseBinding: u32,
    sparseResidencyBuffer: u32,
    sparseResidencyImage2D: u32,
    sparseResidencyImage3D: u32,
    sparseResidency2Samples: u32,
    sparseResidency4Samples: u32,
    sparseResidency8Samples: u32,
    sparseResidency16Samples: u32,
    sparseResidencyAliased: u32,
    variableMultisampleRate: u32,
    inheritedQueries: u32,
};

pub const VkPhysicalDeviceLimits = extern struct {
    maxImageDimension1D: u32,
    maxImageDimension2D: u32,
    maxImageDimension3D: u32,
    maxImageDimensionCube: u32,
    maxImageArrayLayers: u32,
    maxTexelBufferElements: u32,
    maxUniformBufferRange: u32,
    maxStorageBufferRange: u32,
    maxPushConstantsSize: u32,
    maxMemoryAllocationCount: u32,
    maxSamplerAllocationCount: u32,
    bufferImageGranularity: u64,
    sparseAddressSpaceSize: u64,
    maxBoundDescriptorSets: u32,
    maxPerStageDescriptorSamplers: u32,
    maxPerStageDescriptorUniformBuffers: u32,
    maxPerStageDescriptorStorageBuffers: u32,
    maxPerStageDescriptorSampledImages: u32,
    maxPerStageDescriptorStorageImages: u32,
    maxPerStageDescriptorInputAttachments: u32,
    maxPerStageResources: u32,
    maxDescriptorSetSamplers: u32,
    maxDescriptorSetUniformBuffers: u32,
    maxDescriptorSetUniformBuffersDynamic: u32,
    maxDescriptorSetStorageBuffers: u32,
    maxDescriptorSetStorageBuffersDynamic: u32,
    maxDescriptorSetSampledImages: u32,
    maxDescriptorSetStorageImages: u32,
    maxDescriptorSetInputAttachments: u32,
    maxVertexInputAttributes: u32,
    maxVertexInputBindings: u32,
    maxVertexInputAttributeOffset: u32,
    maxVertexInputBindingStride: u32,
    maxVertexOutputComponents: u32,
    maxTessellationGenerationLevel: u32,
    maxTessellationPatchSize: u32,
    maxTessellationControlPerVertexInputComponents: u32,
    maxTessellationControlPerVertexOutputComponents: u32,
    maxTessellationControlPerPatchOutputComponents: u32,
    maxTessellationControlTotalOutputComponents: u32,
    maxTessellationEvaluationInputComponents: u32,
    maxTessellationEvaluationOutputComponents: u32,
    maxGeometryShaderInvocations: u32,
    maxGeometryInputComponents: u32,
    maxGeometryOutputComponents: u32,
    maxGeometryOutputVertices: u32,
    maxGeometryTotalOutputComponents: u32,
    maxFragmentInputComponents: u32,
    maxFragmentOutputAttachments: u32,
    maxFragmentDualSrcAttachments: u32,
    maxFragmentCombinedOutputResources: u32,
    maxComputeSharedMemorySize: u32,
    maxComputeWorkGroupCount: [3]u32,
    maxComputeWorkGroupInvocations: u32,
    maxComputeWorkGroupSize: [3]u32,
    subPixelPrecisionBits: u32,
    subTexelPrecisionBits: u32,
    mipmapPrecisionBits: u32,
    maxDrawIndexedIndexValue: u32,
    maxDrawIndirectCount: u32,
    maxSamplerLodBias: f32,
    maxSamplerAnisotropy: f32,
    maxViewports: u32,
    maxViewportDimensions: [2]u32,
    viewportBoundsRange: [2]f32,
    viewportSubPixelBits: u32,
    minMemoryMapAlignment: usize,
    minTexelBufferOffsetAlignment: u64,
    minUniformBufferOffsetAlignment: u64,
    minStorageBufferOffsetAlignment: u64,
    minTexelOffset: i32,
    maxTexelOffset: u32,
    minTexelGatherOffset: i32,
    maxTexelGatherOffset: u32,
    minInterpolationOffset: f32,
    maxInterpolationOffset: f32,
    subPixelInterpolationOffsetBits: u32,
    maxFramebufferWidth: u32,
    maxFramebufferHeight: u32,
    maxFramebufferLayers: u32,
    framebufferColorSampleCounts: u32,
    framebufferDepthSampleCounts: u32,
    framebufferStencilSampleCounts: u32,
    framebufferNoAttachmentsSampleCounts: u32,
    maxColorAttachments: u32,
    sampledImageColorSampleCounts: u32,
    sampledImageIntegerSampleCounts: u32,
    sampledImageDepthSampleCounts: u32,
    sampledImageStencilSampleCounts: u32,
    storageImageSampleCounts: u32,
    maxSampleMaskWords: u32,
    timestampComputeAndGraphics: u32,
    timestampPeriod: f32,
    maxClipDistances: u32,
    maxCullDistances: u32,
    maxCombinedClipAndCullDistances: u32,
    discreteQueuePriorities: u32,
    pointSizeRange: [2]f32,
    lineWidthRange: [2]f32,
    pointSizeGranularity: f32,
    lineWidthGranularity: f32,
    strictLines: u32,
    standardSampleLocations: u32,
    optimalBufferCopyOffsetAlignment: u64,
    optimalBufferCopyRowPitchAlignment: u64,
    nonCoherentAtomSize: u64,
};

pub const VkPhysicalDeviceProperties = extern struct {
    apiVersion: u32,
    driverVersion: u32,
    vendorId: u32,
    deviceId: u32,
    deviceType: i32,
    deviceName: [VK_MAX_PHYSICAL_DEVICE_NAME_SIZE]u8,
    pipelineCacheUUID: [VK_UUID_SIZE]u8,
    limits: VkPhysicalDeviceLimits,
    sparseProperties: VkPhysicalDeviceSparseProperties,
};

pub const VkPhysicalDeviceSparseProperties = extern struct {
    residencyStandard2DBlockShape: u32,
    residencyStandard2DMultisampleBlockShape: u32,
    residencyStandard3DBlockShape: u32,
    residencyAlignedMipSize: u32,
    residencyNonResidentStrict: u32,
};

pub const VkQueueFamilyProperties = extern struct {
    queueFlags: u32,
    queueCount: u32,
    timestampValidBits: u32,
    minImageTransferGranularity: VkExtent3D,
};

pub const VkWin32SurfaceCreateInfoKHR = extern struct {
    const win32 = @import("../win32.zig");
    sType: i32,
    flags: u32,
    hinstance: *win32.wnd_msg.Instance,
    hwnd: *win32.wnd_msg.Window,
};

// Functions

pub extern fn vkCreateDevice(physicalDevice: VkPhysicalDevice, *const VkDeviceCreateInfo, pAllocator: ?*const VkAllocationCallbacks, pDevice: *VkDevice) i32; // VkResult;

pub extern fn vkCreateMetalSurfaceEXT(instance: VkInstance, pCreateInfo: *const VkMetalSurfaceCreateInfoEXT, pAllocator: ?*const VkAllocationCallbacks, pSurface: *VkSurfaceKHR) i32; // VkResult

pub extern fn vkCreateInstance(pCreateInfo: *const VkInstanceCreateInfo, pAllocator: ?*const VkAllocationCallbacks, *VkInstance) i32; // VkResult

pub extern fn vkCreateWin32SurfaceKHR(instance: VkInstance, pCreateInfo: *const VkWin32SurfaceCreateInfoKHR, pAllocator: ?*const VkAllocationCallbacks, surface: *VkSurfaceKHR) i32; // VkResult

pub extern fn vkDestroyDevice(device: VkDevice, pAllocator: ?*const VkAllocationCallbacks) void;

pub extern fn vkDestroyInstance(instance: VkInstance, pAllocator: ?*const VkAllocationCallbacks) void;

pub extern fn vkEnumeratePhysicalDevices(instance: VkInstance, pPhysicalDeviceCount: *u32, pPhysicalDevices: ?[*]VkPhysicalDevice) i32; // VkResult

pub extern fn vkEnumerateInstanceExtensionProperties(pLayerName: ?[*:0]const u8, pPropertyCount: *u32, pProperties: ?[*]VkExtensionProperties) callconv(vulkan_callconv) i32; // VkResult

pub extern fn vkGetDeviceQueue(device: VkDevice, queueFamilyIndex: u32, queueIndex: u32, pQueue: *VkQueue) void;

pub extern fn vkGetPhysicalDeviceFeatures(physicalDevice: VkPhysicalDevice, pFeatures: *VkPhysicalDeviceFeatures) void;

pub extern fn vkGetPhysicalDeviceProperties(physicalDevice: VkPhysicalDevice, pProperties: *VkPhysicalDeviceProperties) void;

pub extern fn vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice: VkPhysicalDevice, pQueueFamilyPropertyCount: *u32, pQueueFamilyProperties: ?[*]VkQueueFamilyProperties) void;
