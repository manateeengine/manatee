const std = @import("std");
const manatee = @import("./manatee.zig");

export fn manatee_editor_fn() void {
    try manatee.manatee_editor_fn();
}
