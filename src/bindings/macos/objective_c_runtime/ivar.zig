const c = @import("c.zig");

pub const Ivar = struct {
    value: *c.Ivar,
};
