const builtin = @import("builtin");
const std = @import("std");

const Window = @import("window.zig").Window;

/// The standard Manatee App interface.
///
/// An app represents all of the core system functionality needed to create and manage a desktop
/// application for a given OS. This includes (but is not limited to) window creation, window
/// painting, and event loop management.
///
/// This interface is inspired by the Zig "interface" pattern defined in std.mem.Allocator, and is
/// heavily influenced by SuperAuguste's `zig-patterns` repo's "vtable" example. For more info,
/// see https://github.com/SuperAuguste/zig-patterns/blob/main/src/typing/vtable.zig
pub const App = struct {
    ptr: *anyopaque,
    vtable: *const VTable,

    pub const VTable = struct {
        deinit: *const fn (ctx: *anyopaque) void,
        getNativeApp: *const fn (ctx: *anyopaque) *anyopaque,
        run: *const fn (ctx: *anyopaque) anyerror!void,
        setMainWindow: *const fn (ctx: *anyopaque, window: ?*Window) void,
    };

    /// Returns an opaque pointer to the Window's associated OS-level app object.
    pub fn getNativeApp(self: App) *anyopaque {
        return self.vtable.getNativeApp(self.ptr);
    }

    /// Starts the application's native event loop and runs until a termination signal is received.
    pub fn run(self: App) !void {
        return try self.vtable.run(self.ptr);
    }

    /// Sets the provided window as the application's main window. This does not clean up the
    /// currently set main window, that responsibility is given to whatever sets the main window.
    pub fn setMainWindow(self: App, window: ?*Window) void {
        return self.vtable.setMainWindow(self.ptr, window);
    }

    /// Handles memory cleanup of anything created during the App's initialization process.
    pub fn deinit(self: App) void {
        self.vtable.deinit(self.ptr);
    }
};

/// A function that automatically determines which implementation of the Manatee App interface to
/// use based off of the Zig compilation target.
///
/// This function will throw a `@compileError` if an App implementation does not exist for the
/// targeted OS.
pub fn getAppInterfaceStruct() type {
    const base_app = switch (builtin.os.tag) {
        .macos => @import("app/macos_app.zig").MacosApp,
        .windows => @import("app/win32_app.zig").Win32App,
        else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
    };

    return base_app;
}
