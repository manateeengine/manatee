//! A Manatee Window that is intended to be used by applications targeting MacOS.

const std = @import("std");

const apple = @import("../../bindings/apple.zig");
const system = @import("../../system.zig");

const Self = @This();

allocator: std.mem.Allocator,
native_window: *apple.app_kit.Window,

pub fn init(allocator: std.mem.Allocator, config: system.Window.Config) !Self {
    _ = config;

    const native_window = try apple.app_kit.Window.init(
        .{ .origin = .{ .x = 0, .y = 0 }, .size = .{ .height = 600, .width = 800 } },
        .{ .titled_enabled = true, .closable_enabled = true, .miniaturizable_enabled = true, .resizable_enabled = true },
        .buffered,
        false,
    );
    errdefer native_window.deinit();
    native_window.makeKeyAndOrderFront(native_window);

    return Self{
        .allocator = allocator,
        .native_window = native_window,
    };
}

pub fn window(self: *Self) system.Window {
    return system.Window{
        .ptr = @ptrCast(self),
        .vtable = &vtable,
    };
}

const vtable = system.Window.VTable{
    .deinit = &deinit,
    .getDimensions = &getDimensions,
    .getNativeWindow = &getNativeWindow,
};

fn deinit(ctx: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    self.native_window.deinit();
}

fn getDimensions(ctx: *anyopaque) system.Window.Dimensions {
    const self: *Self = @ptrCast(@alignCast(ctx));
    // TODO: Reimplement
    _ = self;
    return system.Window.Dimensions{ .height = 0, .width = 0 };
}

fn getNativeWindow(ctx: *anyopaque) *anyopaque {
    const self: *Self = @ptrCast(@alignCast(ctx));
    return self.native_window;
}
