const std = @import("std");

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
    allocator: std.mem.Allocator,
    app: system.app.App,
    config: game_config.GameConfig,
    gpu: system.gpu.Gpu,

    pub fn init(allocator: std.mem.Allocator, config: game_config.GameConfig) !Game {
        // Create an app for the current platform
        const app = config.app orelse try system.app.getAppInterfaceStruct().init(allocator);

        // Connect to the GPU
        const gpu = config.gpu orelse try system.gpu.getGpuInterfaceStruct().init(allocator);

        // Throw everything into a main game struct, yay!
        return .{
            .allocator = allocator,
            .app = app,
            .config = config,
            .gpu = gpu,
        };
    }

    /// Starts your game's event loop and runs until terminated
    pub fn run(self: *Game) !void {
        // Open the main application window
        // TODO: Add the ability to render content in the window
        const window = try self.app.openWindow(.{ .title = self.config.title });
        defer window.deinit();

        // Start the application event loop
        self.app.run();
    }

    pub fn deinit(
        self: *Game,
    ) void {
        self.gpu.deinit();
        self.app.deinit();
        self.* = undefined;
    }
};
