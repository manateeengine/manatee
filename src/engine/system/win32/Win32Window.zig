//! A Manatee Window that is intended to be used by applications targeting Windows.

const manatee = @import("manatee");
const std = @import("std");

const Self = @This();

allocator: std.mem.Allocator,
native_window: *manatee.bindings.win32.wnd_msg.Window,

pub fn init(allocator: std.mem.Allocator, config: manatee.system.Window.WindowConfig) !Self {
    const class_name = try std.unicode.utf8ToUtf16LeAllocZ(allocator, "ManateeWindowClass");
    defer allocator.free(class_name);

    const window_title = try std.unicode.utf8ToUtf16LeAllocZ(allocator, config.title);
    defer allocator.free(window_title);

    const instance = try manatee.bindings.win32.wnd_msg.Instance.init(null);
    const window_class = manatee.bindings.win32.wnd_msg.window.WindowClassExW{
        .style = .h_redraw,
        .wnd_proc = wndProc,
        .hinstance = instance,
        .class_name = class_name,
    };
    window_class.registerClass();

    const native_window = manatee.bindings.win32.wnd_msg.Window.init(
        manatee.bindings.win32.wnd_msg.window.WindowStyleEx.overlapped_window,
        class_name,
        window_title,
        manatee.bindings.win32.wnd_msg.window.WindowStyle.overlapped_window,
        manatee.bindings.win32.wnd_msg.window.cw_use_default,
        manatee.bindings.win32.wnd_msg.window.cw_use_default,
        @intCast(config.width),
        @intCast(config.height),
        null,
        null,
        instance,
        null,
    );

    return Self{
        .allocator = allocator,
        .native_window = native_window,
    };
}

pub fn window(self: *Self) manatee.system.Window {
    return manatee.system.Window{
        .ptr = @ptrCast(self),
        .vtable = &vtable,
    };
}

const vtable = manatee.system.Window.VTable{
    .deinit = &deinit,
    .focus = &focus,
    .getDimensions = &getDimensions,
    .getNativeWindow = &getNativeWindow,
    .show = &show,
};

fn deinit(ctx: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    self.native_window.deinit();
    self.allocator.destroy(self);
}

fn focus(ctx: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    self.native_window.setFocus();
}

fn getDimensions(ctx: *anyopaque) manatee.system.Window.Dimensions {
    const self: *Self = @ptrCast(@alignCast(ctx));
    const window_rect = self.native_window.getWindowRect() catch manatee.bindings.win32.display_devices.Rect{
        .bottom = 0,
        .left = 0,
        .right = 0,
        .top = 0,
    };
    return manatee.system.Window.Dimensions{
        .height = window_rect.bottom - window_rect.top,
        .width = window_rect.right - window_rect.left,
    };
}

fn getNativeWindow(ctx: *anyopaque) *anyopaque {
    const self: *Self = @ptrCast(@alignCast(ctx));
    return self.native_window;
}

fn show(ctx: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    self.native_window.showWindow(.show);
}

/// Required to build the win32 event loop, used as a param when creating hwnd
fn wndProc(current_window: *manatee.bindings.win32.wnd_msg.Window, msg: u32, w_param: usize, l_param: isize) callconv(std.builtin.CallingConvention.winapi) isize {
    return switch (msg) {
        @intFromEnum(manatee.bindings.win32.wnd_msg.message.WindowNotification.destroy) => {
            current_window.postQuitMessage(0);
            return 0;
        },
        else => current_window.defaultWindowProcedureW(msg, w_param, l_param),
    };
}
