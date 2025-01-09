const builtin = @import("builtin");
const std = @import("std");

const shared = @import("shared.zig");

const Instance = @import("instance.zig").Instance;

const AllocationCallbacks = shared.AllocationCallbacks;
const Result = shared.Result;
const StructureType = shared.StructureType;

/// Opaque handle to a surface object
/// Original: `VkSurfaceKHR`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkSurfaceKHR.html
pub const SurfaceKhr = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    /// Note: This function handles SurfaceKhr creation for ALL supported operating systems. Please
    /// make sure you have all appropriate extensions enabled when setting up your instance
    pub fn init(instance: *Instance, native_app: *anyopaque, native_window: *anyopaque) !*Self {
        switch (builtin.target.os.tag) {
            .macos => {
                const apple = @import("../apple.zig");
                const window_instance: *apple.app_kit.Window = @ptrCast(native_window);
                const window_view: *apple.app_kit.View = @ptrCast(window_instance.getContentView());

                const metal_surface_create_info = MetalSurfaceCreateInfoExt{
                    .layer = window_view.getLayer(),
                };

                return try createMetalSurfaceExt(instance, &metal_surface_create_info, null);
            },
            .windows => {
                const win32_surface_create_info = Win32SurfaceCreateInfoKhr{
                    .hwnd = @ptrCast(native_window),
                    .hinstance = @ptrCast(native_app),
                };

                return try createWin32SurfaceKhr(instance, &win32_surface_create_info, null);
            },
            else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
        }
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self, instance: *Instance) void {
        return self.destroySurface(instance, null);
    }

    /// Create a VkSurfaceKHR object for CAMetalLayer
    /// Original: `vkCreateMetalSurfaceEXT`
    /// https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateMetalSurfaceEXT.html
    pub fn createMetalSurfaceExt(instance: *Instance, create_info: *const MetalSurfaceCreateInfoExt, allocation_callbacks: ?*const AllocationCallbacks) !*Self {
        var surface: *Self = undefined;
        try vkCreateMetalSurfaceEXT(instance, create_info, allocation_callbacks, &surface).check();
        return surface;
    }

    /// Create a VkSurfaceKHR object for a Win32 native window
    /// Original: `vkCreateWin32SurfaceKHR`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkCreateWin32SurfaceKHR.html
    pub fn createWin32SurfaceKhr(instance: *Instance, create_info: *const Win32SurfaceCreateInfoKhr, allocation_callbacks: ?*const AllocationCallbacks) !*Self {
        var surface: *Self = undefined;
        try vkCreateWin32SurfaceKHR(instance, create_info, allocation_callbacks, &surface).check();
        return surface;
    }

    /// Destroy a VkSurfaceKHR object
    /// Original: `vkDestroySurfaceKHR`
    /// See: https://registry.khronos.org/vulkan/specs/latest/man/html/vkDestroySurfaceKHR.html
    pub fn destroySurface(self: *Self, instance: *Instance, allocation_callbacks: ?*const AllocationCallbacks) void {
        return vkDestroySurfaceKHR(instance, self, allocation_callbacks);
    }
};

/// Structure specifying parameters of a newly created Metal surface object
/// Original: `VkMetalSurfaceCreateInfoEXT`
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkMetalSurfaceCreateInfoEXT.html
pub const MetalSurfaceCreateInfoExt = extern struct {
    type: StructureType = StructureType.metal_surface_create_info_ext,
    next: ?*const anyopaque = null,
    flags: u32 = 0,
    layer: *const anyopaque,
};

/// Structure specifying parameters of a newly created Win32 surface object
/// Original: VkWin32SurfaceCreateInfoKHR
/// See: https://registry.khronos.org/vulkan/specs/latest/man/html/VkWin32SurfaceCreateInfoKHR.html
pub const Win32SurfaceCreateInfoKhr = extern struct {
    const win32 = @import("../win32.zig");
    sType: StructureType = StructureType.win32_surface_create_info_khr,
    flags: u32 = 0,
    hinstance: *win32.wnd_msg.Instance,
    hwnd: *win32.wnd_msg.Window,
};

extern fn vkCreateMetalSurfaceEXT(instance: *Instance, pCreateInfo: *const MetalSurfaceCreateInfoExt, pAllocator: ?*const AllocationCallbacks, pSurface: **SurfaceKhr) Result;
extern fn vkCreateWin32SurfaceKHR(instance: *Instance, pCreateInfo: *const Win32SurfaceCreateInfoKhr, pAllocator: ?*const AllocationCallbacks, surface: **SurfaceKhr) Result;
extern fn vkDestroySurfaceKHR(instance: *Instance, surface: *SurfaceKhr, pAllocator: ?*const AllocationCallbacks) void;
