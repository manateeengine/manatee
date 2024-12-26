const std = @import("std");

const system = @import("system.zig");

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
    config: GameConfig,
    gpu: system.gpu.Gpu,
    main_window: system.window.Window,

    pub fn init(allocator: std.mem.Allocator, config: GameConfig) !Game {
        // Create an app for the current platform
        const BaseApp = system.app.getAppInterfaceStruct();
        var base_app = try allocator.create(BaseApp);
        base_app.* = try BaseApp.init(allocator);
        const app = base_app.app();

        // Create the main application window
        const BaseWindow = system.window.getWindowInterfaceStruct();
        const base_window = try allocator.create(BaseWindow);
        base_window.* = try BaseWindow.init(allocator, .{ .title = config.title });
        var main_window = base_window.window();

        // Connect to the GPU
        const BaseGpu = system.gpu.getGpuInterfaceStruct();
        const base_gpu = try allocator.create(BaseGpu);
        base_gpu.* = try BaseGpu.init(allocator, &main_window);
        const gpu = base_gpu.gpu();

        return Game{
            .allocator = allocator,
            .app = app,
            .config = config,
            .gpu = gpu,
            .main_window = main_window,
        };
    }

    /// Starts your game's event loop and runs until terminated
    pub fn run(self: *Game) !void {
        std.debug.print("Running Game\n", .{});
        _ = self.main_window.getNativeWindow();
        // Start the application event loop
        self.app.run();
    }

    pub fn deinit(
        self: *Game,
    ) void {
        std.debug.print("Game Deinit\n", .{});
        self.gpu.deinit();
        self.main_window.deinit();
        self.app.deinit();
        self.* = undefined;
    }
};

/// Global configuration for your Manatee Game.
///
/// Example Usage:
/// ```zig
/// const manatee = @import("manatee");
///
/// const MyCustomConfig = manatee.GameConfig {
///     .app = some_custom_app_impl,
///     .gpu = GpuBackend.vulkan,
///     .title = "Some Custom Title",
/// };
///
/// This struct is used to modify the default configuration provided in `Game`.
/// ```
pub const GameConfig = struct {
    /// A Manatee `App` implementation. When provided, this value will be used and an os-specific
    /// `App` implementation will not be inferred. See `Game.init()` for more information.
    app: ?system.app.App = null,
    /// A Manatee `Gpu` implementation. When provided, this value will be used and an os-specific
    /// `Gpu` implementation will not be inferred. See `Game.init()` for more information.
    // gpu: ?system.gpu.Gpu = null,
    title: []const u8 = "Manatee Game",
};
