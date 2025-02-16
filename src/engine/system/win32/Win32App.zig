//! A Manatee App that is intended to be used by applications targeting Windows.

const manatee = @import("manatee");
const std = @import("std");

const Self = @This();

allocator: std.mem.Allocator,
main_window: ?*manatee.system.Window = null,
native_app: *manatee.bindings.win32.wnd_msg.Instance,

pub fn init(allocator: std.mem.Allocator) !Self {
    const instance = try manatee.bindings.win32.wnd_msg.Instance.init(null);

    return Self{
        .allocator = allocator,
        .native_app = instance,
    };
}

pub fn app(self: *Self) manatee.system.App {
    return manatee.system.App{
        .ptr = @ptrCast(self),
        .vtable = &vtable,
    };
}

const vtable = manatee.system.App.VTable{
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
    var msg: manatee.bindings.win32.wnd_msg.Message = undefined;
    while (msg.getMessageW(null, 0, 0)) {
        _ = msg.translateMessage();
        _ = msg.dispatchMessageW();
    }
}

fn setMainWindow(ctx: *anyopaque, window: ?*manatee.system.Window) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    if (window != null) {
        window.?.show();
        window.?.focus();
    }
    self.main_window = window;
}
