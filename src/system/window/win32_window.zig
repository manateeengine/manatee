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
    hwnd: *win32.wnd_msg.Hwnd,

    pub fn init(allocator: std.mem.Allocator, config: WindowConfig) !Win32Window {
        const class_name = try std.unicode.utf8ToUtf16LeAllocZ(allocator, "ManateeWindowClass");
        defer allocator.free(class_name);

        const window_title = try std.unicode.utf8ToUtf16LeAllocZ(allocator, config.title);
        defer allocator.free(window_title);

        const hinstance = try win32.wnd_msg.Hinstance.init(null);
        const window_class = win32.wnd_msg.WndClassExW{
            .style = .h_redraw,
            .wnd_proc = process,
            .hinstance = hinstance._value,
            .class_name = class_name,
        };
        _ = window_class.register();

        const hwnd = try win32.wnd_msg.Hwnd.create(allocator, .{
            .style = .overlapped_window,
            .class_name = class_name,
            .window_name = window_title,
            .window_style = .overlapped_window,
            .width = @intCast(config.width),
            .height = @intCast(config.height),
            .hinstance = hinstance,
        });

        hwnd.show(.show);

        // const h_instance = @as(win32.foundation.HInstance, @ptrCast(@alignCast(win32.system.library_loader.getModuleHandleW(null).?)));
        // const window_class_name = win32.l("ManateeWindowClass");

        // const utf16_title = try std.unicode.utf8ToUtf16LeAllocZ(allocator, config.title);
        // defer allocator.free(utf16_title);

        // const window_class = win32.ui.windows_and_messaging.WndClassExW{
        //     .cbSize = @sizeOf(win32.ui.windows_and_messaging.WndClassExW),
        //     .style = win32.ui.windows_and_messaging.WndClassStyles{ .HREDRAW = 1, .VREDRAW = 1 },
        //     .lpfnWndProc = process,
        //     .cbClsExtra = 0,
        //     .cbWndExtra = 0,
        //     .hInstance = h_instance,
        //     .hIcon = null,
        //     .hCursor = null,
        //     .hbrBackground = null,
        //     .lpszMenuName = null,
        //     .lpszClassName = window_class_name,
        //     .hIconSm = null,
        // };
        // _ = win32.ui.windows_and_messaging.registerClassExW(&window_class);

        // const hwnd = win32.ui.windows_and_messaging.createWindowExW(
        //     win32.ui.windows_and_messaging.WsExOverlappedWindow,
        //     window_class_name,
        //     utf16_title,
        //     win32.ui.windows_and_messaging.WsOverlappedWindow,
        //     win32.ui.windows_and_messaging.CwUseDefault,
        //     win32.ui.windows_and_messaging.CwUseDefault,
        //     @intCast(config.width),
        //     @intCast(config.height),
        //     null,
        //     null,
        //     h_instance,
        //     null,
        // ).?;

        // _ = win32.ui.windows_and_messaging.showWindow(hwnd, win32.ui.windows_and_messaging.SwShow);

        return Win32Window{
            .allocator = allocator,
            .dimensions = WindowDimensions{
                .height = config.height,
                .width = config.width,
            },
            .hwnd = hwnd,
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
        self.hwnd.destroy();
        self.allocator.destroy(self);
    }

    fn getDimensions(ctx: *anyopaque) WindowDimensions {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        return self.dimensions;
    }

    fn getNativeWindow(ctx: *anyopaque) *anyopaque {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        return self.hwnd._value;
    }

    /// Required to build the win32 event loop, used as a param when creating hwnd
    fn process(hwnd: win32.c.Hwnd, msg: u32, w_param: win32.c.Wparam, l_param: win32.c.Lparam) callconv(win32.c.winapi_callconv) win32.c.Lparam {
        return switch (msg) {
            @intFromEnum(win32.wnd_msg.WindowNotification.destroy) => {
                win32.wnd_msg.postQuitMessage(0);
                return 0;
            },
            else => win32.wnd_msg.defWindowProcW(hwnd, msg, w_param, l_param),
        };
    }
};
