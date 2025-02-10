const builtin = @import("builtin");
const std = @import("std");

// const Window = @import("window.zig").Window;

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
        getNextEvent: *const fn (ctx: *anyopaque) anyerror!AppEvent,
        processEvent: *const fn (ctx: *anyopaque, event: AppEvent) anyerror!void,
    };

    /// Returns an opaque pointer to the Window's associated OS-level app object.
    pub fn getNativeApp(self: App) *anyopaque {
        return self.vtable.getNativeApp(self.ptr);
    }

    /// Gets the next AppEvent.
    ///
    /// This should be called at the beginning of your application's main loop.
    pub fn getNextEvent(self: App) !AppEvent {
        return try self.vtable.getNextEvent(self.ptr);
    }

    /// Handles any required system processing for the provided AppEvent.
    ///
    /// This should be called at the end of your application's main loop, after any bespoke
    /// processing has been done.
    pub fn processEvent(self: App, event: AppEvent) !void {
        return try self.vtable.processEvent(self.ptr, event);
    }

    /// Handles memory cleanup of anything created during the App's initialization process.
    pub fn deinit(self: App) void {
        self.vtable.deinit(self.ptr);
    }
};

/// A Manatee application event.
pub const AppEvent = struct {
    /// The type of event being executed.
    event_type: AppEventType,
    /// A pointer to the platform event. This is used during event processing by the platform.
    native_event: ?*anyopaque,
};

/// A generic event type enum to handle different events from different platforms in a standardized
/// way.
///
/// TODO: Obviously more events need to be handled here, but this is a start!
pub const AppEventType = enum(i32) {
    /// The application is sending an event that Manatee doesn't know how to handle (yet)
    unknown = -1,
    /// The application is sending an empty event. This is most commonly encountered on MacOS and
    /// will usually not require any additional processing.
    empty = 0,
    /// The application is sending an event indicating that it should exit. While handling this
    /// event, you should clean up any leftover memory, and safely break out of the event loop.
    exit = 1,
    /// The application is sending a system event.
    system = 2,
    /// The application is sending an input event. This usually correlated with a mouse movement or
    /// a keyboard key press.
    input = 3,
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
