const system = @import("system.zig");

pub const game_config = @import("game/game_config.zig");

/// The Manatee Game.
///
/// Example Usage:
/// ```zig
/// const manatee = @import("manatee");
///
/// pub fn main() !void {
///     var editor_game = manatee.Game.init(.{ .title = "My Game" });
///     defer editor_game.deinit();
///     try editor_game.run();
/// }
/// ```
///
/// This struct handles your game's overall configuration and scene management. Unless you're doing
/// something truly bespoke, the `Game` struct will be instantiated and called in your game's main
/// entrypoint. It provides reasonable defaults, including an App based off of your target OS, an
/// allocator, and automatic GPU configuration based off of the best API for your current system.
///
/// For more information on configuration (and what parts of this struct can be overridden via
/// configuration), see the `GameConfig` struct.
pub const Game = struct {
    app: system.app.App,
    title: []const u8,

    pub fn init(config: game_config.GameConfig) Game {
        const app = config.app orelse system.app.getApp();
        return .{
            .app = app,
            .title = config.title,
        };
    }

    /// Starts your game's event loop and runs until terminated
    pub fn run(self: *Game) !void {
        // Start the application event loop
        self.app.run();
    }

    pub fn deinit(self: *Game) void {
        self.app.deinit();
        self.* = undefined;
    }
};
