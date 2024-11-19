const std = @import("std");
const manatee = @import("./manatee.zig");

pub fn main() void {
    var game = manatee.Game.init();
    game.run();
    defer game.deinit();
}
