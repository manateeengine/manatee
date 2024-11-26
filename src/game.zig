const std = @import("std");

/// The main Game struct. This struct manages your game's configuration, event loop, and contains
/// all of the logic required to create a game!
pub const Game = struct {
    const Self = @This();

    pub fn init() Self {
        return .{};
    }

    /// Starts your game's event loop and runs until terminated
    pub fn run(self: *Self) !void {
        _ = self;
        std.debug.print("Running Game!", .{});
    }

    pub fn deinit(self: *Self) void {
        self.* = undefined;
    }
};
