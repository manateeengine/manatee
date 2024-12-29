const std = @import("std");

// Zig Setup

// TODO: Does this need to change for other platforms?
pub const vulkan_callconv = std.builtin.CallingConvention.c;

// Constants

pub const VK_MAX_EXTENSION_NAME_SIZE: usize = 256;

// Types

pub const VkInstance = enum(usize) { null_handle = 0, _ };

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

pub const VkExtensionProperties = extern struct {
    extensionName: [VK_MAX_EXTENSION_NAME_SIZE]u8,
    specVersion: u32,
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

// Functions

pub extern fn vkCreateInstance(pCreateInfo: *const VkInstanceCreateInfo, pAllocator: ?*VkAllocationCallbacks, *VkInstance) i32; // VkResult

pub extern fn vkDestroyInstance(instance: VkInstance, pAllocator: ?*VkAllocationCallbacks) void;

pub extern fn vkEnumerateInstanceExtensionProperties(pLayerName: ?[*:0]const u8, pPropertyCount: *u32, pProperties: ?[*]VkExtensionProperties) callconv(vulkan_callconv) i32; // VkResult
