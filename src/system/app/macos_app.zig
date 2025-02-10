const std = @import("std");

const apple = @import("../../bindings.zig").apple;
const App = @import("../app.zig").App;
const ManateeApplicationDelegate = @import("macos_app/manatee_application_delegate.zig").ManateeApplicationDelegate;

/// A MacOS implementation of the Manatee `App` interface.
pub const MacosApp = struct {
    const Self = @This();

    allocator: std.mem.Allocator,
    native_app: *apple.app_kit.Application,
    native_app_delegate: *ManateeApplicationDelegate,

    pub fn init(allocator: std.mem.Allocator) !Self {
        std.debug.print("START app.init\n", .{});

        const native_app = try apple.app_kit.Application.init();
        const native_app_delegate = try ManateeApplicationDelegate.init();

        try native_app.setActivationPolicy(.regular);
        native_app.activateIgnoringOtherApps(true);
        try native_app.setDelegate(native_app_delegate);

        std.debug.print("END   app.init\n", .{});
        return Self{
            .allocator = allocator,
            .native_app = native_app,
            .native_app_delegate = native_app_delegate,
        };
    }

    fn deinit(ctx: *anyopaque) void {
        std.debug.print("START app.deinit\n", .{});
        const self: *Self = @ptrCast(@alignCast(ctx));
        self.native_app_delegate.deinit();
        self.native_app.deinit();
        self.allocator.destroy(self);
        std.debug.print("END   app.deinit\n", .{});
    }

    pub fn app(self: *Self) App {
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

    fn getNativeApp(ctx: *anyopaque) *anyopaque {
        std.debug.print("START app.getNativeApp\n", .{});
        const self: *Self = @ptrCast(@alignCast(ctx));
        std.debug.print("END   app.getNativeApp\n", .{});
        return self.native_app;
    }

    fn run(ctx: *anyopaque) !void {
        const self: *Self = @ptrCast(@alignCast(ctx));
        std.debug.print("START app.run\n", .{});

        std.debug.print("MANATEE Running Native Event Loop\n", .{});
        self.native_app.run();

        std.debug.print("MANATEE Entering Manatee Event Loop\n", .{});
        while (true) {
            const event = try self.native_app.nextEventMatchingMaskUntilDateInModeDequeue(
                std.math.maxInt(u64),
                try apple.foundation.Date.initDistantFuture(),
                "default",
                true,
            );

            if (event != null) {
                self.native_app.sendEvent(event.?);
            }
        }
        std.debug.print("END   app.run\n", .{});
    }
};
