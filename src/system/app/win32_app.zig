const std = @import("std");

const win32 = @import("../../bindings.zig").win32;
const App = @import("../app.zig").App;

/// A Win32App implementation of the Manatee `App` interface.
pub const Win32App = struct {
    allocator: std.mem.Allocator,
    native_app: *win32.wnd_msg.Instance,

    pub fn init(allocator: std.mem.Allocator) !Win32App {
        const instance = try win32.wnd_msg.Instance.init(null);

        return Win32App{
            .allocator = allocator,
            .native_app = instance,
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
        .getNativeApp = &getNativeApp,
        .run = &run,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }

    fn getNativeApp(ctx: *anyopaque) *anyopaque {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        return self.native_app;
    }

    fn run(ctx: *anyopaque) !void {
        const self: *Win32App = @ptrCast(@alignCast(ctx));
        _ = self; // I'll probably need this at some point lol
        var msg: win32.wnd_msg.Message = undefined;
        while (msg.getMessageW(null, 0, 0)) {
            _ = msg.translateMessage();
            _ = msg.dispatchMessageW();
        }
    }
};
