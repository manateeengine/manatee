//! A Manatee App that is intended to be used by applications targeting Windows.

const std = @import("std");

const win32 = @import("../../bindings/win32.zig");
const system = @import("../../system.zig");

const Self = @This();

allocator: std.mem.Allocator,
main_window: ?*system.Window = null,
native_app: *win32.wnd_msg.Instance,

pub fn init(allocator: std.mem.Allocator) !Self {
    const instance = try win32.wnd_msg.Instance.init(null);

    return Self{
        .allocator = allocator,
        .native_app = instance,
    };
}

pub fn app(self: *Self) system.App {
    return system.App{
        .ptr = @ptrCast(self),
        .vtable = &vtable,
    };
}

const vtable = system.App.VTable{
    .deinit = &deinit,
    .getNativeApp = &getNativeApp,
    .run = &run,
    .setMainWindow = &setMainWindow,
};

fn deinit(ctx: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    self.allocator.destroy(self);
}

fn getNativeApp(ctx: *anyopaque) *anyopaque {
    const self: *Self = @ptrCast(@alignCast(ctx));
    return self.native_app;
}

fn run(ctx: *anyopaque) !void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    _ = self; // I'll probably need this at some point lol
    var msg: win32.wnd_msg.Message = undefined;
    while (msg.getMessageW(null, 0, 0)) {
        _ = msg.translateMessage();
        _ = msg.dispatchMessageW();
    }
}

fn setMainWindow(ctx: *anyopaque, window: ?*system.Window) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    if (window != null) {
        window.?.show();
        window.?.focus();
    }
    self.main_window = window;
}
