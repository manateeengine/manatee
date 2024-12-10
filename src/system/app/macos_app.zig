const std = @import("std");

const macos = @import("../../bindings.zig").macos;
const App = @import("../app.zig").App;
const MacosWindow = @import("../window/macos_window.zig").MacosWindow;
const window = @import("../window.zig");

const Window = window.Window;
const WindowConfig = window.window_config.WindowConfig;

/// A MacOS implementation of the Manatee `App` interface.
///
/// In order to maintain a clean multi-platform build, this struct should almost never be directly
/// used. For usage, see `app.getApp()`.
pub const MacosApp = struct {
    allocator: std.mem.Allocator,
    ns_application: macos.app_kit.NSApplication,

    pub fn init(allocator: std.mem.Allocator) !App {
        // Set up the AppKit NSApplication
        var ns_application = macos.app_kit.NSApplication.init();
        ns_application.setActivationPolicy(macos.app_kit.NSApplicationActivationPolicy.NSApplicationActivationPolicyRegular);

        const instance = try allocator.create(MacosApp);
        instance.* = MacosApp{ .allocator = allocator, .ns_application = ns_application };
        return App{
            .ptr = instance,
            .impl = &.{ .deinit = deinit, .run = run },
        };
    }

    pub fn run(ctx: *anyopaque) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        self.ns_application.activate();
        return self.ns_application.run();
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *MacosApp = @ptrCast(@alignCast(ctx));
        self.ns_application.deinit();
        self.allocator.destroy(self);
    }
};
