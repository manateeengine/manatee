const std = @import("std");

const macos = @import("../../bindings.zig").macos;
const App = @import("../app.zig").App;

/// A MacOS implementation of the Manatee `App` interface.
pub const MacosApp = struct {
    allocator: std.mem.Allocator,
    ns_application: *macos.app_kit.NSApplication,

    pub fn init(allocator: std.mem.Allocator) !MacosApp {
        // Set up the AppKit NSApplication
        var ns_application = try allocator.create(macos.app_kit.NSApplication);
        ns_application.* = macos.app_kit.NSApplication.init();
        ns_application.setActivationPolicy(macos.app_kit.NSApplicationActivationPolicy.NSApplicationActivationPolicyRegular);

        return MacosApp{
            .allocator = allocator,
            .ns_application = ns_application,
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
        self.allocator.destroy(self.ns_application);
        self.allocator.destroy(self);
    }

    fn run(ctx: *anyopaque) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        self.ns_application.activate();
        return self.ns_application.run();
    }
};
