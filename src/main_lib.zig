//! The Manatee Engine C API
//!
//! ## Remarks
//! I've never actually written a C API (or any type of lib outside of the TypeScript ecosystem for
//! that matter) in my entire career, so this is really new to me. This file will likely change
//! DRAMATICALLY over the course of Manatee's development, probably to a greater degree than the
//! engine itself. Please be patient with me here, and if you have any (constructive) feedback, I'd
//! love to hear it!

const std = @import("std");

export fn createGame() void {
    std.debug.print("TODO: Create C API\n", .{});
}
