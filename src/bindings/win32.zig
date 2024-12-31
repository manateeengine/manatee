//! Manatee Idiomatic Zig Bindings for the Win32 API
//! See: https://learn.microsoft.com/en-us/windows/win32/api/

pub const c = @import("win32/c.zig");
pub const lib_loader = @import("win32/lib_loader.zig");
pub const wnd_msg = @import("win32/wnd_msg.zig");
