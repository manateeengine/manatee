//! The Manatee Editor Module

const manatee = @import("manatee");
const std = @import("std");

/// The main entrypoint for the Manatee Editor exe.
///
/// ## Remarks
/// This function, although public, is not designed for external usage, and should only ever be
/// called by Manatee's `src/main.zig`. For more detailed information on Manatee's module directory
/// structure, see `README.md`.
///
/// As a note, the editor is actually a game under the hood. By building the editor with the exact
/// same technology that we use for the engine, it allows us to dog-food our own code and test new
/// features in realtime!
pub fn main() !void {
    // TODO: Should this use an arena allocator?
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var editor_game = try manatee.Game.init(allocator, &.{});
    defer editor_game.deinit();

    try editor_game.run();
}
