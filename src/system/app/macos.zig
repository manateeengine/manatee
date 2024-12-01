const std = @import("std");
const App = @import("../app.zig").App;

/// A MacOS implementation of the Manatee `App` interface.
/// 
/// In order to maintain a clean multi-platform build, this struct should almost never be directly
/// used. For usage, see `app.getApp()`.
pub const MacosApp = struct {
    pub fn init() MacosApp {
        return MacosApp {};
    }

    pub fn app(self: *MacosApp) App {
        return App {
            .ptr = self,
            .impl = &.{ .deinit = deinit, .run = run },
        };
    }

    pub fn run(ctx: *anyopaque) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        _ = self;
        std.debug.print("TODO: Build MacOS App Event Loop\n", .{});
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        self.* = undefined;
    }
};
