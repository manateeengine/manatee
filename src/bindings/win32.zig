//! A collection of idiomatic Zig bindings for writing native Win32 desktop applications.

const std = @import("std");
const c = @import("win32/c.zig");

pub const foundation = @import("win32/foundation.zig");
pub const system = @import("win32/system.zig");
pub const ui = @import("win32/ui.zig");

pub const Guid = c.zig.Guid;
pub const l = c.zig.L;
pub const UInt = c_uint;
pub const WinApi = std.os.windows.WINAPI;
