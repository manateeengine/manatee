const std = @import("std");

const manatee = @import("manatee.zig");

/// The entrypoint for the Manatee editor.
/// 
/// Outside of running the editor, this function should never actually be ingested by anything that
/// uses Manatee. Please only use this code to learn how Manatee works, and not in your game!
/// 
/// Fun fact: the Manatee editor is technically a game, and it can be extended and modified using
/// the same patterns that games do! The editor was built this way so that I could try out the
/// Manatee API while building Manatee (eating my own dog food, as some would say). This of course
/// makes building the MVP of Manatee significantly harder, but nobody ever said greatness came
/// easily!
pub fn main() !void {
    var editor_game = manatee.Game.init(.{});
    defer editor_game.deinit();
    try editor_game.run();
}
