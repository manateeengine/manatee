//! External C Declarations for the Win32 Binding
//! Note: Most of the types defined in this file are re-exported from Zig's STD because for some
//! reason Zig actually has quite a bit of Windows code in there, which is pretty cool.

const std = @import("std");

/// An opaque handle to a brush object.
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Hbrush = std.os.windows.HBRUSH;

/// An opaque handle to a cursor object.
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Hcursor = std.os.windows.HCURSOR;

/// An opaque handle to an icon object.
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Hicon = std.os.windows.HICON;

/// An opaque handle to an instance object.
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Hinstance = std.os.windows.HINSTANCE;

/// An opaque handle to a menu object.
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Hmenu = std.os.windows.HMENU;

/// An opaque handle to a window object.
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Hwnd = std.os.windows.HWND;

/// A message parameter.
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Lparam = std.os.windows.LPARAM;

/// A Signed result of message processing.
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Lresult = std.os.windows.LRESULT;

/// A message parameter.
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Wparam = std.os.windows.WPARAM;

pub const winapi_callconv = std.builtin.CallingConvention.winapi;

/// A structure that defines the x and y coordinates of a point.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-point
pub const Point = extern struct {
    x: i32,
    y: i32,
};

pub fn createUtf16Str(allocator: std.mem.Allocator, utf8_str: []const u8) ![*:0]const u16 {
    const utf16_str = try std.unicode.utf8ToUtf16LeAllocZ(allocator, utf8_str);
    return utf16_str;
}
