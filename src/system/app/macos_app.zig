const std = @import("std");

const macos = @import("../../bindings.zig").macos;
const App = @import("../app.zig").App;

/// A MacOS implementation of the Manatee `App` interface.
pub const MacosApp = struct {
    allocator: std.mem.Allocator,
    ns_application: *macos.app_kit.NSApplication,
    ns_delegate: *macos.objective_c.NSObject,

    pub fn init(allocator: std.mem.Allocator) !MacosApp {
        // Set up the AppKit NSApplication
        var ns_application = try allocator.create(macos.app_kit.NSApplication);
        ns_application.* = macos.app_kit.NSApplication.init();
        ns_application.setActivationPolicy(macos.app_kit.NSApplicationActivationPolicy.NSApplicationActivationPolicyRegular);

        // There HAS to be a better, more Zig-native way to do this, but I don't know enough about
        // Objective-C programming to implement it, whatever it is
        const ns_application_delegate = macos.objective_c.objc.allocateProtocol("NSApplicationDelegate");
        var application_delegate = try allocator.create(macos.objective_c.NSObject);
        application_delegate.* = macos.objective_c.NSObject.init();
        var application_delegate_class = application_delegate.getClass();
        _ = application_delegate_class.addProtocol(ns_application_delegate);
        _ = application_delegate_class.addMethod("applicationShouldTerminateAfterLastWindowClosed:", struct {
            fn imp() callconv(.C) bool {
                return true;
            }
        }.imp);
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
