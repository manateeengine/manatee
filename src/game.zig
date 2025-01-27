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
    // gpu: system.gpu.Gpu,
    main_window: system.window.Window,

    pub fn init(allocator: std.mem.Allocator, config: GameConfig) !Game {
        // Create an app for the current platform
        const BaseApp = system.app.getAppInterfaceStruct();
        var base_app = try allocator.create(BaseApp);

        {
            errdefer allocator.destroy(base_app);
            base_app.* = try BaseApp.init(allocator);
        }

        var app = base_app.app();
        errdefer app.deinit();

        // Create the main application window
        const BaseWindow = system.window.getWindowInterfaceStruct();
        const base_window = try allocator.create(BaseWindow);

        {
            errdefer allocator.destroy(base_window);
            base_window.* = try BaseWindow.init(allocator, &app, .{ .title = config.title });
        }

        var main_window = base_window.window();
        errdefer main_window.deinit();

        // // Connect to the GPU
        // const BaseGpu = system.gpu.getGpuInterfaceStruct();
        // const base_gpu = try allocator.create(BaseGpu);

        // {
        //     errdefer allocator.destroy(base_gpu);
        //     base_gpu.* = try BaseGpu.init(allocator, &app, &main_window);
        // }

        // const gpu = base_gpu.gpu();
        // errdefer gpu.deinit();

        return Game{
            .allocator = allocator,
            .app = app,
            .config = config,
            // .gpu = gpu,
            .main_window = main_window,
        };
    }

    /// Starts your game's event loop and runs until terminated
    pub fn run(self: *Game) !void {
        // Set the newly created window as the app's main window. This is required to start the
        // event loop in MacOS environments, and unused everywhere else
        self.app.setMainWindow(&self.main_window);

        // Start the application event loop
        try self.app.run();
    }

    pub fn deinit(
        self: *Game,
    ) void {
        // self.gpu.deinit();
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
///     .title = "Some Custom Title",
/// };
///
/// This struct is used to modify the default configuration provided in `Game`.
/// ```
pub const GameConfig = struct {
    title: []const u8 = "Manatee Game",
};
