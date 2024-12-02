const std = @import("std");

const App = @import("../app.zig").App;

/// A MacOS implementation of the Manatee `App` interface.
///
/// In order to maintain a clean multi-platform build, this struct should almost never be directly
/// used. For usage, see `app.getApp()`.
pub const MacosApp = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !App {
        const instance = try allocator.create(MacosApp);
        instance.* = MacosApp{ .allocator = allocator };
        return App{
            .ptr = instance,
            .impl = &.{ .deinit = deinit, .run = run },
        };
    }

    pub fn run(ctx: *anyopaque) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        _ = self;
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
