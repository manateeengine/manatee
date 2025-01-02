const std = @import("std");

// const macos = @import("../../bindings.zig").macos;
const apple = @import("../../bindings.zig").apple;
const App = @import("../app.zig").App;

/// A MacOS implementation of the Manatee `App` interface.
pub const MacosApp = struct {
    allocator: std.mem.Allocator,
    delegate: *ManateeApplicationDelegate,
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

    pub fn app(self: *MacosApp) App {
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
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        self.delegate.deinit();
        self.native_app.deinit();
        self.allocator.destroy(self);
    }

    fn run(ctx: *anyopaque) !void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        std.debug.print("Running App", .{});
        try self.native_app.setActivationPolicy(.regular);
        self.native_app.activate();
        return self.native_app.run();
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
        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationShouldTerminateAfterLastWindowClosed:"),
            applicationShouldTerminateAfterLastWindowClosed,
            "b@:",
        );
        delegate_class.registerClassPair();

        return try Self.new("ManateeApplicationDelegate");
    }

    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }

    fn applicationShouldTerminateAfterLastWindowClosed(_self: *Self, _cmd: *apple.objective_c.Sel) callconv(.c) bool {
        // These params are required by the Objective-C runtime but we don't use them here
        _ = _self;
        _ = _cmd;
        return true;
    }
};
