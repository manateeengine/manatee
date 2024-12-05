const std = @import("std");

const win32 = @import("../../bindings.zig").win32;
const App = @import("../app.zig").App;
const Win32Window = @import("../window/win32_window.zig").Win32Window;
const window = @import("../window.zig");

const Window = window.Window;
const WindowConfig = window.window_config.WindowConfig;

/// A Win32App implementation of the Manatee `App` interface.
///
/// In order to maintain a clean multi-platform build, this struct should almost never be directly
/// used. For usage, see `app.getApp()`.
pub const Win32App = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !App {
        const instance = try allocator.create(Win32App);
        instance.* = Win32App{ .allocator = allocator };
        return App{
            .ptr = instance,
            .impl = &.{ .deinit = deinit, .openWindow = openWindow, .run = run },
        };
    }

    pub fn openWindow(ctx: *anyopaque, config: WindowConfig) !Window {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        const new_window = try Win32Window.init(self.allocator, config);
        return new_window;
    }

    pub fn run(ctx: *anyopaque) void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        _ = self; // I'll probably need this at some point lol
        var msg: win32.ui.windows_and_messaging.Msg = undefined;
        while (win32.ui.windows_and_messaging.getMessageW(&msg, null, 0, 0) > 0) {
            _ = win32.ui.windows_and_messaging.translateMessage(&msg);
            _ = win32.ui.windows_and_messaging.dispatchMessageW(&msg);
        }
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
