//! A Manatee App that is intended to be used by applications targeting MacOS.

const std = @import("std");

const apple = @import("../../bindings/apple.zig");
const system = @import("../../system.zig");

const ManateeApplicationDelegate = @import("ManateeApplicationDelegate.zig");

const Self = @This();

allocator: std.mem.Allocator,
is_setup_complete: bool = false,
native_app: *apple.app_kit.Application,
native_app_delegate: *ManateeApplicationDelegate,

pub fn init(allocator: std.mem.Allocator) !Self {
    const native_app = try apple.app_kit.Application.init();
    const native_app_delegate = try ManateeApplicationDelegate.init();

    try native_app.setActivationPolicy(.regular);
    native_app.activateIgnoringOtherApps(true);
    try native_app.setDelegate(native_app_delegate);

    return Self{
        .allocator = allocator,
        .native_app = native_app,
        .native_app_delegate = native_app_delegate,
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
};

fn deinit(ctx: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    self.native_app_delegate.deinit();
    self.native_app.deinit();
}

fn getNativeApp(ctx: *anyopaque) *anyopaque {
    const self: *Self = @ptrCast(@alignCast(ctx));
    return self.native_app;
}

fn run(ctx: *anyopaque) !void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    _ = self;
    // Ugh todo
}
