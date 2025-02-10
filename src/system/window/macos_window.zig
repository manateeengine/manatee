const std = @import("std");

const apple = @import("../../bindings.zig").apple;
const window = @import("../window.zig");

const App = @import("../app.zig").App;

const Window = window.Window;
const WindowConfig = window.WindowConfig;
const WindowDimensions = window.WindowDimensions;

/// A MacOS implementation of the Manatee `Window` interface.
pub const MacosWindow = struct {
    const Self = @This();

    allocator: std.mem.Allocator,
    native_window: *apple.app_kit.Window,

    pub fn init(allocator: std.mem.Allocator, config: WindowConfig) !Self {
        _ = config; // autofix
        std.debug.print("START window.init\n", .{});

        const native_window = try apple.app_kit.Window.init(
            .{ .origin = .{ .x = 0, .y = 0 }, .size = .{ .height = 600, .width = 800 } },
            .{ .titled_enabled = true, .closable_enabled = true, .miniaturizable_enabled = true, .resizable_enabled = true },
            .buffered,
            false,
        );
        errdefer native_window.deinit();
        native_window.makeKeyAndOrderFront(native_window);

        std.debug.print("END   window.init\n", .{});
        return Self{
            .allocator = allocator,
            .native_window = native_window,
        };
    }

    pub fn window(self: *Self) Window {
        return Window{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Window.VTable{
        .deinit = &deinit,
        .getDimensions = &getDimensions,
        .getNativeWindow = &getNativeWindow,
    };

    fn deinit(ctx: *anyopaque) void {
        std.debug.print("START window.deinit\n", .{});
        const self: *Self = @ptrCast(@alignCast(ctx));
        self.native_window.deinit();
        self.allocator.destroy(self);
        std.debug.print("END   window.deinit\n", .{});
    }

    fn getDimensions(ctx: *anyopaque) WindowDimensions {
        std.debug.print("START window.getDimensions\n", .{});
        const self: *Self = @ptrCast(@alignCast(ctx));

        _ = self;

        std.debug.print("END   window.getDimensions\n", .{});
        return WindowDimensions{ .height = 0, .width = 0 };
    }

    fn getNativeWindow(ctx: *anyopaque) *anyopaque {
        std.debug.print("START window.getNativeWindow\n", .{});
        const self: *Self = @ptrCast(@alignCast(ctx));

        std.debug.print("END   window.getNativeWindow\n", .{});
        return self.native_window;
    }
};
