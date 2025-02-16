//! The standard Manatee App interface.
//!
//! An App represents all of the core system functionality needed to create and manage a desktop
//! application for a given OS. This includes (but is not limited to) window creation, window
//! painting, and event loop management.

const Self = @This();

/// The type erased pointer to the App implementation.
ptr: *anyopaque,
/// A pointer to the App implementation's VTable.
vtable: *const VTable,

/// Frees the backing allocation and leaves the App in an undefined state.
pub fn deinit(self: Self) void {
    self.vtable.deinit(self.ptr);
}

/// Returns an opaque pointer to the App's associated OS-level app object.
pub fn getNativeApp(self: Self) *anyopaque {
    return self.vtable.getNativeApp(self.ptr);
}

/// Gets the next AppEvent.
///
/// This should be called at the beginning of your application's main loop.
pub fn getNextEvent(self: Self) !AppEvent {
    return try self.vtable.getNextEvent(self.ptr);
}

/// Handles any required system processing for the provided AppEvent.
///
/// This should be called at the end of your application's main loop, after any bespoke
/// processing has been done.
pub fn processEvent(self: Self, event: AppEvent) !void {
    return try self.vtable.processEvent(self.ptr, event);
}

/// A virtual method table linking the implementation back to the original interface.
pub const VTable = struct {
    deinit: *const fn (ctx: *anyopaque) void,
    getNativeApp: *const fn (ctx: *anyopaque) *anyopaque,
    getNextEvent: *const fn (ctx: *anyopaque) anyerror!AppEvent,
    processEvent: *const fn (ctx: *anyopaque, event: AppEvent) anyerror!void,
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
