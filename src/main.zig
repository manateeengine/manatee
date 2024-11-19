const std = @import("std");
const manatee = @import("./manatee.zig");

pub fn main() void {
    try manatee.manatee_editor_fn();
}
