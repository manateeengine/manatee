const std = @import("std");

const macos = @import("../../bindings.zig").macos;
const window = @import("../window.zig");

const Window = window.Window;
const WindowConfig = window.window_config.WindowConfig;

/// A MacOS implementation of the Manatee `Window` interface.
///
/// This interface should never be created directly, as doing os may detach your Window from your
/// application's event loop. Please use app.openWindow() to create new Windows.
pub const MacosWindow = struct {
    allocator: std.mem.Allocator,
    ns_window: macos.app_kit.NSWindow,

    pub fn init(allocator: std.mem.Allocator, config: WindowConfig) !Window {
        // This is ugly, I wish Zig's enum support for bitwise was better
        const style_mask = @intFromEnum(macos.app_kit.NSWindowStyleMask.NSWindowStyleMaskTitled) |
            @intFromEnum(macos.app_kit.NSWindowStyleMask.NSWindowStyleMaskClosable) |
            @intFromEnum(macos.app_kit.NSWindowStyleMask.NSWindowStyleMaskMiniaturizable) |
            @intFromEnum(macos.app_kit.NSWindowStyleMask.NSWindowStyleMaskResizable);

        var ns_window = macos.app_kit.NSWindow.initWithContentRect(
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

        const instance = try allocator.create(MacosWindow);
        instance.* = MacosWindow{ .allocator = allocator, .ns_window = ns_window };
        return Window{
            .ptr = instance,
            .impl = &.{ .height = @intCast(config.height), .width = @intCast(config.width), .deinit = deinit, .getNativeWindow = getNativeWindow },
        };
    }

    fn getNativeWindow(ctx: *anyopaque) *anyopaque {
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        return self.ns_window.value;
    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        self.ns_window.deinit();
        self.allocator.destroy(self);
    }
};
