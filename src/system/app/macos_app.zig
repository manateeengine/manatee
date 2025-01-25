const std = @import("std");

// const macos = @import("../../bindings.zig").macos;
const apple = @import("../../bindings.zig").apple;
const App = @import("../app.zig").App;
const Window = @import("../window.zig").Window;

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

        try self.native_app.setActivationPolicy(.regular);
        self.native_app.activate();

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

        std.debug.print("Executing NSApplication.run()\n", .{});
        self.native_app.run();
        std.debug.print("Entering Custom Manatee Loop\n", .{});

        // var should_exit = false;
        // var event: ?*apple.app_kit.Event = apple.app_kit.Event.init();
        const until_date = try apple.foundation.Date.initDistantFuture();
        const in_mode = try apple.foundation.String.init("default");
        const dequeue = true;
        while (self.main_window != null) {
            const event = self.native_app.nextEventMatchingMaskUntilDateInModeDequeue(
                std.math.maxInt(u64),
                until_date,
                in_mode,
                dequeue,
            );

            if (event != null) {
                // TODO: Manatee probably needs to do things with this event at some point lol
                const event_type = event.?.getType();
                // const event_subtype = event.?.getSubType();
                // _ = event_subtype;
                std.debug.print("Event Type {}\n", .{event_type});
                // std.debug.print("Event Sub Type {}\n", .{event_subtype});
                self.native_app.sendEvent(event.?);
            }
            self.native_app.updateWindows();
            // const mode = try apple.foundation.String.init("default");
            // event = self.native_app.nextEventMatchingMaskUntilDateInModeDequeue(std.math.maxInt(u64), null, mode, true);
            // if (event != null) {
            //     const event_type = event.?.getType();
            //     switch (event_type) {
            //         @intFromEnum(apple.app_kit.EventType.key_down) => {
            //             should_exit = true;
            //         },
            //         else => {
            //             std.debug.print("Event With Type {}\n", .{event_type});
            //         },
            //     }
            // }
        }
    }

    fn setMainWindow(ctx: *anyopaque, window: ?*Window) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        self.main_window = window;
    }
};

/// A Custom Objective-C Application Delegate for Manatee
const ManateeApplicationDelegate = opaque {
    const Self = @This();
    pub usingnamespace apple.objective_c.object.ObjectMixin(Self);

    pub fn init() !*Self {
        // Get the NSApplicationDelegate Protocol
        const application_delegate_protocol = try apple.objective_c.Protocol.init("NSApplicationDelegate");

        // Create a new Objective-C Class based off of NSObject. This class will act as our custom
        // delegate, so we'll name it ManateeApplicationDelegate
        const delegate_class = try apple.objective_c.Class.allocateClassPair(try apple.objective_c.Class.init("NSObject"), "ManateeApplicationDelegate", null);

        // Add NSApplicationDelegate and register the class
        try delegate_class.addProtocol(application_delegate_protocol);

        // Add any custom methods to the class
        // try delegate_class.addMethod(
        //     apple.objective_c.Sel.init("applicationShouldTerminateAfterLastWindowClosed:"),
        //     applicationShouldTerminateAfterLastWindowClosed,
        //     "b@:",
        // );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationDidFinishLaunching:"),
            applicationDidFinishLaunching,
            "v@:@",
        );

        delegate_class.registerClassPair();
        return try Self.new("ManateeApplicationDelegate");
    }

    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }

    fn applicationDidFinishLaunching(self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        // These params are required by the Objective-C runtime but we don't use them here
        _ = _cmd;
        _ = _ns_notification;

        // It may look like we're creating another application here, but under the hood the Manatee
        // Application.init() call actually fetches the AppKit sharedApplication, which returns the
        // existing instance if it's already been created!

        // As a note, we can't use Zig error returns inside of App Delegate functions, so if the
        // delegate can't get the NSApplication class, it panics, which is a little ugly but eh,
        // it's not like I have another more Zig-friendly choice here (that I know if, that is)
        const shared_app_instance = apple.app_kit.Application.init() catch @panic("Unable to get sharedApplication in Manatee App Delegate");

        shared_app_instance.stop(self);
    }

    // fn applicationShouldTerminateAfterLastWindowClosed(_self: *Self, _cmd: *apple.objective_c.Sel) callconv(.c) bool {
    //     // These params are required by the Objective-C runtime but we don't use them here
    //     _ = _self;
    //     _ = _cmd;
    //     return true;
    // }
};
