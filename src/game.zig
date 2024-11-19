const std = @import("std");

pub const Game = struct {
    const Self = @This();

    pub fn init() Self {
        return .{};
    }

    pub fn run(self: *Self) void {
        _ = self;
        std.debug.print("Running Game!", .{});
    }

    pub fn deinit(self: *Self) void {
        self.* = undefined;
    }
};
