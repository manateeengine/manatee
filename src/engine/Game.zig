//! The Manatee Game.
//!
//! ## Remarks
//! This struct should be used as your game's main entrypoint. It handles the engine's ECS, scene
//! management, application lifecycle, and core system functionality. This should be initialized
//! with your own allocator inside of your game's `main` function.

const builtin = @import("builtin");
const std = @import("std");

const Self = @This();

/// An instance of a Zig Allocator interface.
allocator: std.mem.Allocator,
config: *const Config,

/// Creates a `Game` instance with the provided `Allocator` and `GameConfig`.
pub fn init(allocator: std.mem.Allocator, config: *const Config) !Self {
    return Self{
        .allocator = allocator,
        .config = config,
    };
}

/// Frees the backing allocation and leaves the Game in an undefined state.
pub fn deinit(self: *Self) void {
    self.* = undefined;
}

/// Starts the Game's main event loop and blocks until loop is terminated.
pub fn run(self: *Self) !void {
    // TODO: Determine if the app should be a part of Game.init() or Game.run(). I lean towards
    // putting it here so that we don't have to create the struct with an allocator, but then that
    // allows the app context to only be touched within the running game. Maybe that's fine?
    var base_app = try getAppForOs().init(self.allocator);
    const app = base_app.app();
    defer app.deinit();

    var base_window = try getWindowForOs().init(self.allocator, .{ .title = self.config.title });
    const window = base_window.window();
    defer window.deinit();

    std.debug.print("TODO: Build Main Loop\n", .{});
}

/// Compile-time configuration options for your Manatee Game.
pub const Config = struct {
    /// The title of your game.
    ///
    /// ## Remarks
    /// This will be displayed in the title bar of your game's main window, as well as all of its
    /// debug logs. If not provided, a fallback of "Manatee Game" will be used.
    title: [*:0]const u8 = "Manatee Game",
};

/// A function that automatically determines which implementation of the Manatee App interface to
/// use based off of the Zig compilation target.
///
/// This function will throw a `@compileError` if an App implementation does not exist for the
/// targeted OS.
pub fn getAppForOs() type {
    const base_app = switch (builtin.os.tag) {
        .macos => @import("system/macos/MacosApp.zig"),
        .windows => @import("system/win32/Win32App.zig"),
        else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
    };

    return base_app;
}

/// A function that automatically determines which implementation of the Manatee Window interface
/// to use based off of the Zig compilation target.
///
/// This function will throw a `@compileError` if a Window implementation does not exist for the
/// targeted OS.
pub fn getWindowForOs() type {
    const base_app = switch (builtin.os.tag) {
        .macos => @import("system/macos/MacosWindow.zig"),
        .windows => @import("system/win32/Win32Window.zig"),
        else => @compileError(std.fmt.comptimePrint("Unsupported OS: {}", .{builtin.os.tag})),
    };

    return base_app;
}
