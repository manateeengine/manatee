const std = @import("std");

const win32 = @import("../../bindings.zig").win32;
const d3d12 = @import("../../bindings.zig").d3d12;
const Gpu = @import("../gpu.zig").Gpu;
const Window = @import("../window.zig").Window;

const direct3d = d3d12.direct3d;
const direct3d12 = d3d12.direct3d12;
const dxgi = d3d12.dxgi;

/// A D3d12 implementation of the Manatee `GPU` interface.
///
/// In order to maintain a clean multi-backend build, this struct should almost never be directly
/// used. For usage, see `gpu.getGpuInterfaceStruct()`.
pub const D3d12Gpu = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Gpu {
        // TODO: This should probably be rewritten to be more idiomatic. ALso this should probably
        // check for error codes and return errors

        // Factory
        var factory: *dxgi.Factory7 = undefined;
        _ = dxgi.createFactory2(0, dxgi.iid_factory7, @ptrCast(&factory));

        // Adapter
        var adapter: *dxgi.Adapter4 = undefined;
        _ = factory.IDXGIFactory6.EnumAdapterByGpuPreference(
            0,
            dxgi.GpuPreference.HIGH_PERFORMANCE,
            dxgi.iid_adapter4,
            @ptrCast(&adapter),
        );

        // Device
        var device: *direct3d12.Device9 = undefined;
        _ = direct3d12.createDevice(
            @ptrCast(adapter),
            direct3d.FeatureLevel.@"12_2",
            direct3d12.iid_device9,
            @ptrCast(&device),
        );

        // Command queue
        const command_queue_desc = direct3d12.CommandQueueDesc{
            .Flags = direct3d12.command_queue_flag_none,
            .Priority = @intFromEnum(direct3d12.command_queue_priority_normal),
            .NodeMask = 0,
            .Type = direct3d12.command_list_type_direct,
        };

        // Hey look, a random UUID v4 that I generated, cool! On a more serious not, I have no idea
        // why device9 needs a GUID, but 9 is greater than 8, and 8 doesn't need one, so now I have
        // a UUID for my totally superior device #9!
        const manatee_creator_id = win32.Guid.initString("3e032e0e-9684-4ee5-bf8f-a157d212a4fe");

        var command_queue: *direct3d12.CommandQueue = undefined;
        _ = device.CreateCommandQueue1(
            &command_queue_desc,
            &manatee_creator_id,
            direct3d12.iid_command_queue,
            @ptrCast(&command_queue),
        );

        // Swapchain
        const swap_chain_desc = dxgi.SwapChainDesc1{
            .BufferCount = 2,
            .Format = dxgi.Format.R8G8B8A8_UNORM,
            .Stereo = 0,
            .SampleDesc = .{ .Count = 0, .Quality = 0 },
            .AlphaMode = .UNSPECIFIED,
            .BufferUsage = dxgi.usage_render_target_output,
            .SwapEffect = dxgi.swap_effect_flip_discard,
            .Flags = 0,
            // .Height = window.impl.height,
            // .Width = window.impl.width,
            .Height = 1,
            .Width = 1,
            .Scaling = dxgi.Scaling.NONE,
        };

        _ = swap_chain_desc;

        // TODO: This causes a segfault and I'm too sick to figure out why, gonna take a break from
        // working on D3D12 and work on the Metal impl in the meantime
        // const hwnd: win32.foundation.HWnd = @ptrCast(@alignCast(window.getNativeWindow()));

        // var swap_chain: *dxgi.SwapChain4 = undefined;
        // _ = factory.IDXGIFactory2.CreateSwapChainForHwnd(@ptrCast(&device), hwnd, &swap_chain_desc, null, null, @ptrCast(&swap_chain));

        const instance = try allocator.create(D3d12Gpu);
        instance.* = D3d12Gpu{ .allocator = allocator };
        return Gpu{
            .ptr = instance,
            .impl = &.{ .deinit = deinit },
        };
    }

    pub fn createSwapchain(ctx: *anyopaque) void {
        _ = ctx; // autofix

    }

    pub fn deinit(ctx: *anyopaque) void {
        const self: *D3d12Gpu = @ptrCast(@alignCast(ctx));
        self.allocator.destroy(self);
    }
};
