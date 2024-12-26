const std = @import("std");

const macos = @import("../../bindings.zig").macos;
const window = @import("../window.zig");

const Window = window.Window;
const WindowConfig = window.WindowConfig;
const WindowDimensions = window.WindowDimensions;

/// A MacOS implementation of the Manatee `Window` interface.
pub const MacosWindow = struct {
    allocator: std.mem.Allocator,
    dimensions: WindowDimensions,
    ns_window: *macos.app_kit.NSWindow,

    pub fn init(allocator: std.mem.Allocator, config: WindowConfig) !MacosWindow {
        const style_mask = @intFromEnum(macos.app_kit.NSWindowStyleMask.NSWindowStyleMaskTitled) |
            @intFromEnum(macos.app_kit.NSWindowStyleMask.NSWindowStyleMaskClosable) |
            @intFromEnum(macos.app_kit.NSWindowStyleMask.NSWindowStyleMaskMiniaturizable) |
            @intFromEnum(macos.app_kit.NSWindowStyleMask.NSWindowStyleMaskResizable);

        var ns_window = try allocator.create(macos.app_kit.NSWindow);
        ns_window.* = macos.app_kit.NSWindow.initWithContentRect(
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
            style_mask,
            macos.app_kit.NSBackingStoreType.NSBackingStoreRetained,
            false,
        );

        ns_window.setTitle(config.title);
        ns_window.makeKeyAndOrderFront();

        return MacosWindow{
            .allocator = allocator,
            .dimensions = WindowDimensions{
                .height = config.height,
                .width = config.width,
            },
            .ns_window = ns_window,
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
        self.allocator.destroy(self.ns_window);
        self.allocator.destroy(self);
    }

    fn getDimensions(ctx: *anyopaque) WindowDimensions {
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        return self.dimensions;
    }

    fn getNativeWindow(ctx: *anyopaque) *anyopaque {
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        return self.ns_window.value;
    }
};
