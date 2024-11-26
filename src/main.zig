const std = @import("std");

const manatee = @import("manatee.zig");

/// This function defines the entrypoint for the Manatee editor. Fun fact: the Manatee editor is
/// technically a game, and it can be extended and modified using the same patterns that games do!
pub fn main() !void {
    var editor_game = manatee.Game.init();
    defer editor_game.deinit();
    try editor_game.run();
}
