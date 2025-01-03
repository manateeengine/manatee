//! The Win32 Windows and Messages API
//! See: https://learn.microsoft.com/en-us/windows/win32/api/_winmsg/

pub const brush = @import("wnd_msg/brush.zig");
pub const cursor = @import("wnd_msg/cursor.zig");
pub const icon = @import("wnd_msg/icon.zig");
pub const instance = @import("wnd_msg/instance.zig");
pub const message = @import("wnd_msg/message.zig");
pub const window = @import("wnd_msg/window.zig");

pub const Brush = brush.Brush;
pub const Cursor = cursor.Cursor;
pub const Icon = icon.Icon;
pub const Instance = instance.Instance;
pub const Message = message.Message;
pub const Window = window.Window;
