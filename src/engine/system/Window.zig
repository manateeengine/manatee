//! The standard Manatee Window interface.
//!
//! A Window represents an operating system window in a desktop application. In the future, a
//! Window may also represent a web view or mobile app pane, but those things are far out of scope
//! for the initial version of Manatee.

const builtin = @import("builtin");
const std = @import("std");

const Self = @This();

ptr: *anyopaque,
vtable: *const VTable,

pub const VTable = struct {
    deinit: *const fn (ctx: *anyopaque) void,
    getDimensions: *const fn (ctx: *anyopaque) Dimensions,
    getNativeWindow: *const fn (ctx: *anyopaque) *anyopaque,
};

/// Frees the backing allocation and leaves the App in an undefined state.
pub fn deinit(self: Self) void {
    self.vtable.deinit(self.ptr);
}

/// Returns an opaque pointer to the Window's associated OS-level window object.
///
/// This is most commonly used in GPU bindings to associate a GPU image with a window and to
/// handle actual window drawing.
pub fn getNativeWindow(self: Self) *anyopaque {
    return self.vtable.getNativeWindow(self.ptr);
}

/// Returns the current width and height of the Window.
pub fn getDimensions(self: Self) Dimensions {
    return self.vtable.getDimensions(self.ptr);
}

/// Configuration for an application Window in your Manatee game.
pub const Config = struct {
    height: u32 = 600,
    title: []const u8,
    width: u32 = 800,
};

/// The current dimensions of a given Window.
pub const Dimensions = struct {
    height: u32,
    width: u32,
};
