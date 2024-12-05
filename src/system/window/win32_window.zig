const std = @import("std");

const win32 = @import("../../bindings.zig").win32;
const window = @import("../window.zig");

const Window = window.Window;
const WindowConfig = window.window_config.WindowConfig;

/// A Win32 implementation of the Manatee `Window` interface.
///
/// This interface should never be created directly, as doing os may detach your Window from your
/// application's event loop. Please use app.openWindow() to create new Windows.
pub const Win32Window = struct {
    allocator: std.mem.Allocator,
    hwnd: win32.foundation.HWnd,

    pub fn init(allocator: std.mem.Allocator, config: WindowConfig) !Window {
        const h_instance = @as(win32.foundation.HInstance, @ptrCast(@alignCast(win32.system.library_loader.getModuleHandleW(null).?)));
        const window_class_name = win32.l("ManateeWindowClass");

        const utf16_title = try std.unicode.utf8ToUtf16LeAllocZ(allocator, config.title);
        defer allocator.free(utf16_title);

        const window_class = win32.ui.windows_and_messaging.WndClassExW{
            .cbSize = @sizeOf(win32.ui.windows_and_messaging.WndClassExW),
            .style = win32.ui.windows_and_messaging.WndClassStyles{ .HREDRAW = 1, .VREDRAW = 1 },
            .lpfnWndProc = process,
            .cbClsExtra = 0,
            .cbWndExtra = 0,
            .hInstance = h_instance,
            .hIcon = null,
            .hCursor = null,
            .hbrBackground = null,
            .lpszMenuName = null,
            .lpszClassName = window_class_name,
            .hIconSm = null,
        };
        _ = win32.ui.windows_and_messaging.registerClassExW(&window_class);

        const hwnd = win32.ui.windows_and_messaging.createWindowExW(
            win32.ui.windows_and_messaging.WsExOverlappedWindow,
            window_class_name,
            utf16_title,
            win32.ui.windows_and_messaging.WsOverlappedWindow,
            win32.ui.windows_and_messaging.CwUseDefault,
            win32.ui.windows_and_messaging.CwUseDefault,
            @intCast(config.width),
            @intCast(config.height),
            null,
            null,
            h_instance,
            null,
        );

        _ = win32.ui.windows_and_messaging.showWindow(hwnd, win32.ui.windows_and_messaging.SwShow);

        const instance = try allocator.create(Win32Window);
        instance.* = Win32Window{ .allocator = allocator, .hwnd = hwnd.? };
        return Window{
            .ptr = instance,
            .impl = &.{ .deinit = deinit },
        };
    }

    pub fn process(hwnd: win32.foundation.HWnd, msg: win32.UInt, w_param: win32.foundation.WParam, l_param: win32.foundation.LParam) callconv(win32.WinApi) win32.foundation.LResult {
        return switch (msg) {
            win32.ui.windows_and_messaging.WmDestroy => {
                win32.ui.windows_and_messaging.postQuitMessage(0);
                return 0;
            },
            else => win32.ui.windows_and_messaging.defWindowProcW(hwnd, msg, w_param, l_param),
        };
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
