const builtin = @import("builtin");
const std = @import("std");

const window = @import("window.zig");
const Window = window.Window;
const WindowConfig = window.window_config.WindowConfig;

/// The standard Manatee App interface.
///
/// An app represents all of the core system functionality needed to create and manage a desktop
/// application for a given OS. This includes (but is not limited to) window creation, window
/// painting, and event loop management.
///
/// This interface is inspired by the Zig "interface" pattern defined in std.mem.Allocator. Fingers
/// crossed that better, less verbose interface patterns will be added to Zig in a future version,
/// but for now this is the best option. For more information on Zig interfaces, check out
/// https://medium.com/@jerrythomas_in/exploring-compile-time-interfaces-in-zig-5c1a1a9e59fd
pub const App = struct {
    ptr: *anyopaque,
    impl: *const AppInterface,

    pub const AppInterface = struct {
        deinit: *const fn (ctx: *anyopaque) void,
        openWindow: *const fn (ctx: *anyopaque, config: WindowConfig) anyerror!Window,
        run: *const fn (ctx: *anyopaque) void,
    };

    pub fn openWindow(self: App, config: WindowConfig) !Window {
        return try self.impl.openWindow(self.ptr, config);
    }

    pub fn run(self: App) void {
        return self.impl.run(self.ptr);
    }

    pub fn deinit(self: App) void {
        return self.impl.deinit(self.ptr);
    }
};

/// A function that automatically determines which instance of the Manatee App interface to use,
/// based off of the Zig compilation target
pub fn getAppInterfaceStruct() type {
    const base_app = switch (builtin.os.tag) {
        .macos => @import("app/macos_app.zig").MacosApp,
        .windows => @import("app/win32_app.zig").Win32App,
        else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
    };

    return base_app;
}
