//! The Manatee Game.
//!
//! ## Remarks
//! This struct should be used as your game's main entrypoint. It handles the engine's ECS, scene
//! management, application lifecycle, and core system functionality. This should be initialized
//! with your own allocator inside of your game's `main` function.

const std = @import("std");

const Self = @This();

/// An instance of a Zig Allocator interface.
allocator: std.mem.Allocator,
config: *const GameConfig,

/// Creates a `Game` instance with the provided `Allocator` and `GameConfig`.
pub fn init(allocator: std.mem.Allocator, config: *const GameConfig) !Self {
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
    _ = self;
    std.debug.print("TODO: In a followup PR, re-implement the event loop ugh\n", .{});
}

/// Compile-time configuration options for your Manatee Game.
pub const GameConfig = struct {
    /// The title of your game.
    ///
    /// ## Remarks
    /// This will be displayed in the title bar of your game's main window, as well as all of its
    /// debug logs. If not provided, a fallback of "Manatee Game" will be used.
    title: [*:0]const u8 = "Manatee Game",
};
