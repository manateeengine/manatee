const std = @import("std");
const App = @import("../app.zig").App;

/// A Win32 implementation of the Manatee `App` interface.
/// 
/// In order to maintain a clean multi-platform build, this struct should almost never be directly
/// used. For usage, see `app.getApp()`.
pub const Win32App = struct {
    pub fn init() Win32App {
        return Win32App {};
    }

    pub fn app(self: *Win32App) App {
        return App {
            .ptr = self,
            .impl = &.{ .deinit = deinit, .run = run },
        };
    }

    pub fn run(ctx: *anyopaque) void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        _ = self;
        std.debug.print("TODO: Build Win32 App Event Loop\n", .{});
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        self.* = undefined;
    }
};
