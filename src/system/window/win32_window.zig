const std = @import("std");

const win32 = @import("../../bindings.zig").win32;
const window = @import("../window.zig");

const App = @import("../app.zig").App;

const Window = window.Window;
const WindowConfig = window.WindowConfig;
const WindowDimensions = window.WindowDimensions;

/// A Win32 implementation of the Manatee `Window` interface.
pub const Win32Window = struct {
    allocator: std.mem.Allocator,
    app: *App,
    native_window: *win32.wnd_msg.Window,

    pub fn init(allocator: std.mem.Allocator, app: *App, config: WindowConfig) !Win32Window {
        const class_name = try std.unicode.utf8ToUtf16LeAllocZ(allocator, "ManateeWindowClass");
        defer allocator.free(class_name);

        const window_title = try std.unicode.utf8ToUtf16LeAllocZ(allocator, config.title);
        defer allocator.free(window_title);

        const instance = try win32.wnd_msg.Instance.init(null);
        const window_class = win32.wnd_msg.window.WindowClassExW{
            .style = .h_redraw,
            .wnd_proc = process,
            .hinstance = instance,
            .class_name = class_name,
        };
        window_class.registerClass();

        const native_window = win32.wnd_msg.Window.init(
            win32.wnd_msg.window.WindowStyleEx.overlapped_window,
            class_name,
            window_title,
            win32.wnd_msg.window.WindowStyle.overlapped_window,
            win32.wnd_msg.window.cw_use_default,
            win32.wnd_msg.window.cw_use_default,
            @intCast(config.width),
            @intCast(config.height),
            null,
            null,
            instance,
            null,
        );

        return Win32Window{
            .allocator = allocator,
            .app = app,
            .native_window = native_window,
        };
    }

    pub fn window(self: *Win32Window) Window {
        return Window{
            .app = self.app,
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Window.VTable{
        .deinit = &deinit,
        .focus = &focus,
        .getDimensions = &getDimensions,
        .getNativeWindow = &getNativeWindow,
        .show = &show,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        self.native_window.deinit();
        self.allocator.destroy(self);
    }

    fn focus(ctx: *anyopaque) void {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        self.native_window.setFocus();
    }

    fn getDimensions(ctx: *anyopaque) WindowDimensions {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        const window_rect = self.native_window.getWindowRect() catch win32.display_devices.Rect{ .bottom = 0, .left = 0, .right = 0, .top = 0 };
        return WindowDimensions{
            .height = window_rect.bottom - window_rect.top,
            .width = window_rect.right - window_rect.left,
        };
    }

    fn getNativeWindow(ctx: *anyopaque) *anyopaque {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        return self.native_window;
    }

    fn show(ctx: *anyopaque) void {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        self.native_window.showWindow(.show);
    }

    /// Required to build the win32 event loop, used as a param when creating hwnd
    fn process(current_window: *win32.wnd_msg.Window, msg: u32, w_param: usize, l_param: isize) callconv(std.builtin.CallingConvention.winapi) isize {
        return switch (msg) {
            @intFromEnum(win32.wnd_msg.message.WindowNotification.destroy) => {
                current_window.postQuitMessage(0);
                return 0;
            },
            else => current_window.defaultWindowProcedureW(msg, w_param, l_param),
        };
    }
};
