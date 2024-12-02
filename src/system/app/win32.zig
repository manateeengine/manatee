const std = @import("std");

const App = @import("../app.zig").App;

/// A Win32App implementation of the Manatee `App` interface.
///
/// In order to maintain a clean multi-platform build, this struct should almost never be directly
/// used. For usage, see `app.getApp()`.
pub const Win32App = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !App {
        const instance = try allocator.create(Win32App);
        instance.* = Win32App{ .allocator = allocator };
        return App{
            .ptr = instance,
            .impl = &.{ .deinit = deinit, .run = run },
        };
    }

    pub fn run(ctx: *anyopaque) void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        _ = self;
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
