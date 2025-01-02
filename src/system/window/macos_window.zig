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
    metal_layer: *apple.core_animation.MetalLayer,
    native_window: *apple.app_kit.Window,

    pub fn init(allocator: std.mem.Allocator, config: WindowConfig) !MacosWindow {
        // Let's start off by creating our window and setting it as the app's default (key) window
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

        // Now that we have our window, let's go ahead and create a MetalLayer for the window. This
        // will let us render GPU content into the window either via MoltenVK or the Metal API!
        const metal_layer = try apple.core_animation.MetalLayer.init();

        // Let's assign the metal layer to the window's layer
        const window_content_view: *apple.app_kit.View = @ptrCast(window_instance.getContentView());
        window_content_view.setWantsLayer(true);
        window_content_view.setLayer(metal_layer);

        return MacosWindow{
            .allocator = allocator,
            .dimensions = WindowDimensions{
                .height = config.height,
                .width = config.width,
            },
            .metal_layer = metal_layer,
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
