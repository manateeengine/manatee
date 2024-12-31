//! The Win32 Library Loader API
//! See: https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/

const std = @import("std");

const c = @import("c.zig");

/// Retrieves a module handle for the specified module.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulehandlew
pub fn getModuleHandleW(module_name: ?[*:0]const u16) c.Hinstance {
    return GetModuleHandleW(module_name);
}
extern "user32" fn GetModuleHandleW(lpModuleName: ?[*:0]const u16) callconv(c.winapi_callconv) c.Hinstance;
