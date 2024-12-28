const std = @import("std");

const macos = @import("../../bindings.zig").macos;
const Gpu = @import("../gpu.zig").Gpu;
const Window = @import("../window.zig").Window;

/// A Metal implementation of the Manatee `GPU` interface.
pub const MetalGpu = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, window: *Window) !MetalGpu {
        _ = window.getNativeWindow();

        const device = macos.metal.gpu_devices_and_work_submission.createSystemDefaultDevice();

        var metal_layer = macos.core_animation.CAMetalLayer.init();
        metal_layer.setDevice(device);

        var ns_view = macos.app_kit.NSView.init();
        ns_view.setWantsLayer(true);
        ns_view.setLayer(metal_layer);

        var ns_window = macos.app_kit.NSWindow{ .value = @ptrCast(@alignCast(window.getNativeWindow())) };
        ns_window.setContentView(ns_view);

        return MetalGpu{
            .allocator = allocator,
        };
    }

    pub fn gpu(self: *MetalGpu) Gpu {
        return Gpu{
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Gpu.VTable{
        .deinit = &deinit,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *MetalGpu = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
