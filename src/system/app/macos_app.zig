const std = @import("std");

const app = @import("../app.zig");

const apple = @import("../../bindings.zig").apple;
const ManateeApplicationDelegate = @import("macos_app/manatee_application_delegate.zig").ManateeApplicationDelegate;

const App = app.App;
const AppEvent = app.AppEvent;
const AppEventType = app.AppEventType;

/// A MacOS implementation of the Manatee `App` interface.
pub const MacosApp = struct {
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

    fn deinit(ctx: *anyopaque) void {
        const self: *Self = @ptrCast(@alignCast(ctx));
        self.native_app_delegate.deinit();
        self.native_app.deinit();
        self.allocator.destroy(self);
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
        .getNextEvent = &getNextEvent,
        .processEvent = &processEvent,
        // .run = &run,
    };

    fn getNativeApp(ctx: *anyopaque) *anyopaque {
        const self: *Self = @ptrCast(@alignCast(ctx));
        return self.native_app;
    }

    fn getNextEvent(ctx: *anyopaque) !AppEvent {
        const self: *Self = @ptrCast(@alignCast(ctx));
        if (!self.is_setup_complete) {
            self.native_app.run();
            self.is_setup_complete = true;
        }
        const native_event = try self.native_app.nextEventMatchingMaskUntilDateInModeDequeue(
            std.math.maxInt(u64),
            try apple.foundation.Date.initDistantFuture(),
            "default",
            true,
        );

        if (native_event == null) {
            return AppEvent{
                .event_type = .empty,
                .native_event = null,
            };
        }

        // TODO: Obviously we want to have better processing here, but this is a start
        const native_event_type = native_event.?.getType();
        const event_type = switch (native_event_type) {
            // TODO: Figure out exit event idk
            .app_kit_defined => AppEventType.system,
            .left_mouse_down => AppEventType.input,
            else => AppEventType.unknown,
        };

        return AppEvent{
            .event_type = event_type,
            .native_event = native_event.?,
        };
    }

    fn processEvent(ctx: *anyopaque, event: AppEvent) !void {
        const self: *Self = @ptrCast(@alignCast(ctx));
        const native_event: ?*apple.app_kit.Event = @ptrCast(event.native_event);

        if (native_event != null) {
            self.native_app.sendEvent(native_event.?);
        }
    }
};
