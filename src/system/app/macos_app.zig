const std = @import("std");

// const macos = @import("../../bindings.zig").macos;
const apple = @import("../../bindings.zig").apple;
const App = @import("../app.zig").App;
const Window = @import("../window.zig").Window;

const ManateeApplicationDelegate = @import("./macos_app/manatee_application_delegate.zig").ManateeApplicationDelegate;

/// A MacOS implementation of the Manatee `App` interface.
pub const MacosApp = struct {
    allocator: std.mem.Allocator,
    delegate: *ManateeApplicationDelegate,
    main_window: ?*Window = null,
    native_app: *apple.app_kit.Application,

    pub fn init(allocator: std.mem.Allocator) !MacosApp {
        // Set up the AppKit Application
        const application_instance = try apple.app_kit.Application.init();
        errdefer application_instance.deinit();

        // Create an Application Delegate to allow us to customize the app's behavior
        const delegate_instance = try ManateeApplicationDelegate.init();
        errdefer delegate_instance.deinit();

        // Now that we've set up our delegate, let's apply it to our app!
        try application_instance.setDelegate(delegate_instance);

        // application_instance.run();

        try application_instance.setActivationPolicy(.regular);

        return MacosApp{
            .allocator = allocator,
            .delegate = delegate_instance,
            .native_app = application_instance,
        };
    }

    fn deinit(ctx: *anyopaque) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        self.delegate.deinit();
        self.native_app.deinit();
        self.allocator.destroy(self);
    }

    pub fn app(self: *MacosApp) App {
        return App{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = App.VTable{
        .deinit = &deinit,
        .getNativeApp = &getNativeApp,
        .run = &run,
        .setMainWindow = &setMainWindow,
    };

    fn getNativeApp(ctx: *anyopaque) *anyopaque {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        return self.native_app;
    }

    fn run(ctx: *anyopaque) !void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));

        if (self.main_window == null) {
            return error.main_window_not_set;
        }

        // self.native_app.run();

        // Since the Manatee app interface is designed to work cross-platform, we have to ensure
        // that everything, regardless off platform, is built as similarly as possible. Since Win32
        // makes us implement our own custom event loop, that means we have to do the same for
        // MacOS, which is probably for the best anyway since there's not a whole lot of options to
        // customize the native AppKit event loop. Unfortunately, AppKit makes this process a lot
        // harder than Win32, so we have to get a little bit creative. Manatee uses the following
        // steps to create a custom AppKit event loop
        //
        // 1. Run the native AppKit event loop
        // 2. In a custom delegate, immediately stop the native AppKit event loop. This seems very
        //    counter-intuitive, but it's what other multi-platform AppKit event loops do, so it's
        //    also what Manatee does (I have no idea why this needs to happen, but it works)
        // 3. Use the horrific function "nextEventMatchingMaskUntilDateInModeDequeue" to get the
        //    app's most recent event (using an NSDate created with "distantFuture")
        // 4. While the event is not null, send the event via the app instance each frame
        // 5. When the event is null, shut down the event loop and allow whatever initialized the
        //    struct to clean things up
        //
        // So yeah, lots of steps here, and I'm not sure why some of them are needed, but they're
        // all required to make this thing work!

        // std.debug.print("Executing NSApplication.run()\n", .{});
        // self.native_app.run();

        // std.debug.print("Finishing App Launch\n", .{});
        // self.native_app.finishLaunching();

        // std.debug.print("Posting Empty Event\n", .{});
        // const empty_event = apple.app_kit.Event.init();
        // self.native_app.postEventAtStart(empty_event, true);

        // std.debug.print("Entering Custom Manatee Loop\n", .{});
        const until_date = try apple.foundation.Date.initDistantFuture();
        const in_mode = try apple.foundation.String.init("default");
        const dequeue = true;

        while (true) {
            const event = self.native_app.nextEventMatchingMaskUntilDateInModeDequeue(
                std.math.maxInt(u64),
                until_date,
                in_mode,
                dequeue,
            );

            if (event == null) {
                std.debug.print("Event is Null\n", .{});
                break;
            }

            const event_type = event.?.getType();
            std.debug.print("Event Type: {}\n", .{event_type});

            self.native_app.sendEvent(event.?);
            self.native_app.updateWindows();
            event.?.release();
        }
        std.debug.print("Exiting Manatee Event Loop\n", .{});
    }

    fn setMainWindow(ctx: *anyopaque, window: ?*Window) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        if (window != null) {
            window.?.show();
            window.?.focus();
        }
        self.main_window = window;
    }
};
