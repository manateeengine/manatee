const builtin = @import("builtin");
const std = @import("std");

/// The standard Manatee Window interface.
///
/// A Window represents an operating system window in a desktop application. In the future, a
/// Window may also represent a web view or mobile app pane, but those things are far out of scope
/// for the initial version of Manatee.
///
/// This interface is inspired by the Zig "interface" pattern defined in std.mem.Allocator. Fingers
/// crossed that better, less verbose interface patterns will be added to Zig in a future version,
/// but for now this is the best option. For more information on Zig interfaces, check out
/// https://medium.com/@jerrythomas_in/exploring-compile-time-interfaces-in-zig-5c1a1a9e59fd
pub const Window = struct {
    ptr: *anyopaque,
    vtable: *const VTable,

    pub const VTable = struct {
        deinit: *const fn (ctx: *anyopaque) void,
        getDimensions: *const fn (ctx: *anyopaque) WindowDimensions,
        getNativeWindow: *const fn (ctx: *anyopaque) *anyopaque,
    };

    pub fn getNativeWindow(self: Window) *anyopaque {
        return self.vtable.getNativeWindow(self.ptr);
    }

    pub fn getDimensions(self: Window) WindowDimensions {
        return self.vtable.getDimensions(self.ptr);
    }

    pub fn deinit(self: Window) void {
        self.vtable.deinit(self.ptr);
    }
};

/// Configuration for an application Window in your Manatee game
pub const WindowConfig = struct {
    height: u32 = 600,
    title: []const u8,
    width: u32 = 800,
};

/// The current dimensions of a given Window
pub const WindowDimensions = struct {
    height: u32,
    width: u32,
};

/// A function that automatically determines which instance of the Manatee Window interface to use,
/// based off of the Zig compilation target
pub fn getWindowInterfaceStruct() type {
    const base_app = switch (builtin.os.tag) {
        .macos => @import("window/macos_window.zig").MacosWindow,
        .windows => @import("window/win32_window.zig").Win32Window,
        else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
    };

    return base_app;
}
