const std = @import("std");

const macos = @import("../../bindings.zig").macos;
const App = @import("../app.zig").App;

/// A MacOS implementation of the Manatee `App` interface.
pub const MacosApp = struct {
    allocator: std.mem.Allocator,
    ns_application: *macos.app_kit.NSApplication,
    ns_delegate: *macos.app_kit.NSApplicationDelegate,

    pub fn init(allocator: std.mem.Allocator) !MacosApp {
        // Set up the AppKit NSApplication
        var ns_application = try allocator.create(macos.app_kit.NSApplication);
        ns_application.* = macos.app_kit.NSApplication.init();
        ns_application.setActivationPolicy(macos.app_kit.NSApplicationActivationPolicy.NSApplicationActivationPolicyRegular);

        // Create an AppKit NSApplicationDelegate to allow us to customize the app's behavior
        var application_delegate = try allocator.create(macos.app_kit.NSApplicationDelegate);
        application_delegate.* = macos.app_kit.NSApplicationDelegate.init();
        var application_delegate_class = application_delegate.getClass();

        // Since this is a game, and not a standard app, let's ensure the app itself closes after
        // the last remaining window closes
        _ = application_delegate_class.addMethod("applicationShouldTerminateAfterLastWindowClosed:", struct {
            fn imp() callconv(.C) bool {
                return true;
            }
        }.imp);

        // Now that we've set up our delegate, let's apply it to our app!
        ns_application.setDelegate(application_delegate);

        return MacosApp{
            .allocator = allocator,
            .ns_application = ns_application,
            .ns_delegate = application_delegate,
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
        self.ns_delegate.deinit();
        self.ns_application.deinit();
        self.allocator.destroy(self.ns_delegate);
        self.allocator.destroy(self.ns_application);
        self.allocator.destroy(self);
    }

    fn run(ctx: *anyopaque) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        self.ns_application.activate();
        return self.ns_application.run();
    }
};
