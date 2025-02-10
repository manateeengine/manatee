const builtin = @import("builtin");
const std = @import("std");

/// The standard Manatee Window interface.
///
/// A Window represents an operating system window in a desktop application. In the future, a
/// Window may also represent a web view or mobile app pane, but those things are far out of scope
/// for the initial version of Manatee.
///
/// This interface is inspired by the Zig "interface" pattern defined in std.mem.Allocator, and is
/// heavily influenced by SuperAuguste's `zig-patterns` repo's "vtable" example. For more info,
/// see https://github.com/SuperAuguste/zig-patterns/blob/main/src/typing/vtable.zig
pub const Window = struct {
    ptr: *anyopaque,
    vtable: *const VTable,

    pub const VTable = struct {
        deinit: *const fn (ctx: *anyopaque) void,
        // focus: *const fn (ctx: *anyopaque) void,
        getDimensions: *const fn (ctx: *anyopaque) WindowDimensions,
        getNativeWindow: *const fn (ctx: *anyopaque) *anyopaque,
        // show: *const fn (ctx: *anyopaque) void,
    };

    /// Returns an opaque pointer to the Window's associated OS-level window object.
    ///
    /// This is most commonly used in GPU bindings to associate a GPU image with a window and to
    /// handle actual window drawing.
    pub fn getNativeWindow(self: Window) *anyopaque {
        return self.vtable.getNativeWindow(self.ptr);
    }

    /// Returns the current width and height of the Window.
    pub fn getDimensions(self: Window) WindowDimensions {
        return self.vtable.getDimensions(self.ptr);
    }

    /// Focuses the current window
    pub fn focus(self: Window) void {
        return self.vtable.focus(self.ptr);
    }

    /// Shows the current window
    pub fn show(self: Window) void {
        return self.vtable.show(self.ptr);
    }

    /// Handles memory cleanup of anything created during the Window's initialization process.
    pub fn deinit(self: Window) void {
        self.vtable.deinit(self.ptr);
    }
};

/// Configuration for an application Window in your Manatee game.
pub const WindowConfig = struct {
    height: u32 = 600,
    title: []const u8,
    width: u32 = 800,
};

/// The current dimensions of a given Window.
pub const WindowDimensions = struct {
    height: u32,
    width: u32,
};

/// A function that automatically determines which implementation of the Manatee Window interface
/// to use based off of the Zig compilation target.
///
/// This function will throw a `@compileError` if a Window implementation does not exist for the
/// targeted OS.
pub fn getWindowInterfaceStruct() type {
    const base_app = switch (builtin.os.tag) {
        .macos => @import("window/macos_window.zig").MacosWindow,
        .windows => @import("window/win32_window.zig").Win32Window,
        else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
    };

    return base_app;
}
