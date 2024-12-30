//! A collection of idiomatic Zig bindings for writing native Win32 desktop applications.
//! TODO: This entire section is in desperate need of a rewrite to make it more aligned with the
//! MacOS bindings as well as idiomatic Zig in general. That'll happen at some point, but I'll
//! continue to use ZigWin32 to get this thing off the ground

const std = @import("std");
const c = @import("win32/c.zig");

pub const d3d12 = @import("win32/d3d12.zig");
pub const foundation = @import("win32/foundation.zig");
pub const system = @import("win32/system.zig");
pub const ui = @import("win32/ui.zig");

pub const Guid = c.zig.Guid;
pub const l = c.zig.L;
pub const UInt = c_uint;
pub const WinApi = std.os.windows.WINAPI;
