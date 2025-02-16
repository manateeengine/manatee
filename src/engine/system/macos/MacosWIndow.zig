//! A Manatee Window that is intended to be used by applications targeting MacOS.

const manatee = @import("manatee");
const std = @import("std");

const Self = @This();

allocator: std.mem.Allocator,
native_window: *manatee.bindings.apple.app_kit.Window,

pub fn init(allocator: std.mem.Allocator, config: manatee.system.Window.WindowConfig) !Self {
    _ = config;

    const native_window = try manatee.bindings.apple.app_kit.Window.init(
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
}

fn focus(ctx: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    // TODO: Reimplement
    _ = self;
}

fn getDimensions(ctx: *anyopaque) manatee.system.Window.Dimensions {
    const self: *Self = @ptrCast(@alignCast(ctx));
    // TODO: Reimplement
    _ = self;
    return manatee.system.Window.Dimensions{ .height = 0, .width = 0 };
}

fn getNativeWindow(ctx: *anyopaque) *anyopaque {
    const self: *Self = @ptrCast(@alignCast(ctx));
    return self.native_window;
}

fn show(ctx: *anyopaque) void {
    const self: *Self = @ptrCast(@alignCast(ctx));
    // TODO: Reimplement
    _ = self;
}
