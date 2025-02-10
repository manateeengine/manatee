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
        _ = config;

        const native_window = try apple.app_kit.Window.init(
            .{ .origin = .{ .x = 0, .y = 0 }, .size = .{ .height = 600, .width = 800 } },
            .{ .titled_enabled = true, .closable_enabled = true, .miniaturizable_enabled = true, .resizable_enabled = true },
            .buffered,
            false,
        );
        errdefer native_window.deinit();
        native_window.makeKeyAndOrderFront(native_window);

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
        const self: *Self = @ptrCast(@alignCast(ctx));
        self.native_window.deinit();
        self.allocator.destroy(self);
    }

    fn getDimensions(ctx: *anyopaque) WindowDimensions {
        const self: *Self = @ptrCast(@alignCast(ctx));

        _ = self;
        return WindowDimensions{ .height = 0, .width = 0 };
    }

    fn getNativeWindow(ctx: *anyopaque) *anyopaque {
        const self: *Self = @ptrCast(@alignCast(ctx));
        return self.native_window;
    }
};
