const std = @import("std");

/// An opaque handle to an instance object.
/// Original: `HINSTANCE`
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Instance = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(module_name: ?[*:0]const u16) !*Self {
        const instance = GetModuleHandleW(module_name);
        if (instance == null) {
            return error.unable_to_get_module_handle;
        }
        return instance.?;
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        self.* = undefined;
    }

    /// Retrieves a module handle for the specified module.
    /// Original: `GetModuleHandleW`
    /// See: https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulehandlew
    pub fn getModuleHandleW(module_name: ?[*:0]const u16) ?*Self {
        return GetModuleHandleW(module_name);
    }
};

extern "user32" fn GetModuleHandleW(lpModuleName: ?[*:0]const u16) callconv(std.builtin.CallingConvention.winapi) ?*Instance;
