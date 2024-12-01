const system = @import("../system.zig");

/// Global configuration for your Manatee Game.
/// 
/// Example Usage:
/// ```zig
/// const manatee = @import("manatee");
/// 
/// const MyCustomConfig = manatee.GameConfig {
///     .app = some_custom_app_impl.app(),
///     .title = "Some Custom Title",
/// };
/// 
/// This struct is used to modify the default configuration provided in `Game`.
/// ```
pub const GameConfig = struct {
    /// A Manatee `App` implementation. When provided, this value will be used and an os-specific
    /// `App` implementation will not be inferred. See `Game.init()` for more information.
    app: ?system.app.App = null,
    title: []const u8 = "Manatee Game",
};
