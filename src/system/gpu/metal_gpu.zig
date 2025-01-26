const builtin = @import("builtin");
const std = @import("std");

const App = @import("../app.zig").App;
const Gpu = @import("../gpu.zig").Gpu;
const Window = @import("../window.zig").Window;

/// A Metal implementation of the Manatee `GPU` interface.
pub const MetalGpu = struct {
    const Self = @This();
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, app: *const App, window: *Window) !Self {
        _ = window; // autofix
        _ = app; // autofix
        _ = allocator; // autofix

        return Self{};
    }

    pub fn gpu(self: *Self) Gpu {
        return Gpu{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Gpu.VTable{
        .deinit = &deinit,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *Self = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
