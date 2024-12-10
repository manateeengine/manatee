const builtin = @import("builtin");
const std = @import("std");

pub const window_config = @import("window/window_config.zig");

/// The standard Manatee Window interface.
///
/// A Window represents an operating system window in a desktop application. In the future, a
/// Window may also represent a web view or mobile app pane, but those things are far out of scope
/// for the initial version of Manatee.
///
/// This interface is inspired by the Zig "interface" pattern defined in std.mem.Allocator. Fingers
/// crossed that better, less verbose interface patterns will be added to Zig in a future version,
/// but for now this is the best option. For more information on Zig interfaces, check out
/// https://medium.com/@jerrythomas_in/exploring-compile-time-interfaces-in-zig-5c1a1a9e59fd
pub const Window = struct {
    ptr: *anyopaque,
    impl: *const WindowInterface,

    pub const WindowInterface = struct {
        height: u32,
        width: u32,
        deinit: *const fn (ctx: *anyopaque) void,
        getNativeWindow: *const fn (ctx: *anyopaque) *anyopaque,
    };

    pub fn getNativeWindow(self: Window) *anyopaque {
        return self.impl.getNativeWindow(self.ptr);
    }

    pub fn deinit(self: Window) void {
        return self.impl.deinit(self.ptr);
    }
};

/// A function that automatically determines which instance of the Manatee App interface to use,
/// based off of the Zig compilation target
pub fn getWindowInterfaceStruct() type {
    const base_window = switch (builtin.os.tag) {
        .macos => @import("window/macos_window.zig").MacosWindow,
        .windows => @import("window/win32_window.zig").Win32Window,
        else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
    };

    return base_window;
}
