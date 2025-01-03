const std = @import("std");

const win32 = @import("../../bindings.zig").win32;
const window = @import("../window.zig");

const Window = window.Window;
const WindowConfig = window.WindowConfig;
const WindowDimensions = window.WindowDimensions;

/// A Win32 implementation of the Manatee `Window` interface.
pub const Win32Window = struct {
    allocator: std.mem.Allocator,
    dimensions: WindowDimensions,
    native_window: *win32.wnd_msg.Window,

    pub fn init(allocator: std.mem.Allocator, config: WindowConfig) !Win32Window {
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
        native_window.showWindow(.show);

        return Win32Window{
            .allocator = allocator,
            .dimensions = WindowDimensions{
                .height = config.height,
                .width = config.width,
            },
            .native_window = native_window,
        };
    }

    pub fn window(self: *Win32Window) Window {
        return Window{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Window.VTable{
        .deinit = &deinit,
        .getDimensions = &getDimensions,
        .getNativeWindow = &getNativeWindow,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        self.native_window.deinit();
        self.allocator.destroy(self);
    }

    fn getDimensions(ctx: *anyopaque) WindowDimensions {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        return self.dimensions;
    }

    fn getNativeWindow(ctx: *anyopaque) *anyopaque {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        return self.native_window;
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
