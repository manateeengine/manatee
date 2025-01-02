const std = @import("std");

const apple = @import("../../bindings.zig").apple;
const window = @import("../window.zig");

const Window = window.Window;
const WindowConfig = window.WindowConfig;
const WindowDimensions = window.WindowDimensions;

/// A MacOS implementation of the Manatee `Window` interface.
pub const MacosWindow = struct {
    allocator: std.mem.Allocator,
    dimensions: WindowDimensions,
    native_window: *apple.app_kit.Window,

    pub fn init(allocator: std.mem.Allocator, config: WindowConfig) !MacosWindow {
        const window_instance = try apple.app_kit.Window.init(
            .{
                .origin = .{
                    .x = 0,
                    .y = 0,
                },
                .size = .{
                    .height = @floatFromInt(config.height),
                    .width = @floatFromInt(config.width),
                },
            },
            .{ .titled_enabled = true, .closable_enabled = true, .miniaturizable_enabled = true, .resizable_enabled = true },
            .retained,
            false,
        );
        errdefer window_instance.deinit();

        window_instance.makeKeyAndOrderFront();

        return MacosWindow{
            .allocator = allocator,
            .dimensions = WindowDimensions{
                .height = config.height,
                .width = config.width,
            },
            .native_window = window_instance,
        };
    }

    pub fn window(self: *MacosWindow) Window {
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
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        self.native_window.deinit();
        self.allocator.destroy(self);
    }

    fn getDimensions(ctx: *anyopaque) WindowDimensions {
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        return self.dimensions;
    }

    fn getNativeWindow(ctx: *anyopaque) *anyopaque {
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        return self.native_window;
    }
};
