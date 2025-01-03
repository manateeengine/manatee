const std = @import("std");

const Window = @import("window.zig").Window;

/// Contains message information from a thread's message queue.
/// Original: `MSG`
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-msg
pub const Message = extern struct {
    hwnd: ?*Window,
    message: WindowNotification,
    wparam: usize,
    lparam: isize,
    time: u32,
    pt: Point,

    const Self = @This();

    /// Dispatches a message to a window procedure.
    /// Original: `DispatchMessageW`
    /// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getmessagew
    pub fn dispatchMessageW(self: *Self) isize {
        return DispatchMessageW(self);
    }

    /// Retrieves a message from the calling thread's message queue.
    /// Original: `GetMessageW`
    /// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getmessagew
    pub fn getMessageW(self: *Self, window: ?*Window, filter_min: u32, filter_max: u32) bool {
        return GetMessageW(self, window, filter_min, filter_max);
    }

    /// Translates virtual-key messages into character messages.
    /// Original: `TranslateMessage`
    /// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-translatemessage
    pub fn translateMessage(self: *Self) isize {
        return TranslateMessage(self);
    }
};

/// A structure that defines the x and y coordinates of a point.
/// Original: `POINT`
/// See: https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-point
pub const Point = extern struct {
    x: i32,
    y: i32,
};

/// Window Notifications
/// See: https://learn.microsoft.com/en-us/windows/win32/winmsg/window-notifications
pub const WindowNotification = enum(u32) {
    /// Sent when an application requests that a window be created by calling the createWindowEx
    /// or createWindow function.
    create = 1,
    /// Sent when a window is being destroyed. It is sent to the window procedure of the window
    /// being destroyed after the window is removed from the screen.
    destroy = 2,
};

extern "user32" fn DispatchMessageW(lpMsg: ?*Message) callconv(std.builtin.CallingConvention.winapi) isize;
extern "user32" fn GetMessageW(lpMsg: ?*Message, hWnd: ?*Window, wMsgFilterMin: u32, wMsgFilterMax: u32) callconv(std.builtin.CallingConvention.winapi) bool;
extern "user32" fn TranslateMessage(lpMsg: ?*Message) callconv(std.builtin.CallingConvention.winapi) isize;
