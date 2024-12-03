const std = @import("std");

const window = @import("../window.zig");

const Window = window.Window;
const WindowConfig = window.window_config.WindowConfig;

/// A Win32 implementation of the Manatee `Window` interface.
///
/// This interface should never be created directly, as doing os may detach your Window from your
/// application's event loop. Please use app.openWindow() to create new Windows.
pub const Win32Window = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, config: WindowConfig) !Window {
        std.debug.print("TODO: Implement Win32 Window\n", .{});
        _ = config;
        const instance = try allocator.create(Win32Window);
        instance.* = Win32Window{ .allocator = allocator };
        return Window{
            .ptr = instance,
            .impl = &.{ .deinit = deinit },
        };
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *Win32Window = @ptrCast(@alignCast(ctx));
        self.ns_window.deinit();
        self.allocator.destroy(self);
    }
};
