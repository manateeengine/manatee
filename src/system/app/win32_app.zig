const std = @import("std");

const win32 = @import("../../bindings.zig").win32;
const App = @import("../app.zig").App;

/// A Win32App implementation of the Manatee `App` interface.
pub const Win32App = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Win32App {
        return Win32App{
            .allocator = allocator,
        };
    }

    pub fn app(self: *Win32App) App {
        return App{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = App.VTable{
        .deinit = &deinit,
        .run = &run,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }

    fn run(ctx: *anyopaque) void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        _ = self; // I'll probably need this at some point lol
        var msg: win32.ui.windows_and_messaging.Msg = undefined;
        while (win32.ui.windows_and_messaging.getMessageW(&msg, null, 0, 0) > 0) {
            _ = win32.ui.windows_and_messaging.translateMessage(&msg);
            _ = win32.ui.windows_and_messaging.dispatchMessageW(&msg);
        }
    }
};
