//! Microsoft's DirectX Graphics Infrastructure API (DXGI)
//! See: https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/d3d10-graphics-reference-dxgi
//!
//! In order for this API to feel more like idiomatic Zig, a few changes have been made surrounding
//! naming conventions. Here's a quick overview of the changes:
//! 1. The "dxgi" keyword has been removed from most things as its irrelevant given how Manatee
//!    exports its 3rd party API bindings
//! 2. Interfaces have had their "I" prefix removed and are consistently in PascalCase
//! 3. Functions are written in camelCase
//! 4. Constants are written in snake_case
//!
//! There'll probably be more changes since I hate how instantiation / pointers work with the DXGI
//! API, but I'm not gonna fuck with that until I at least have my triangle rendering

const c = @import("../c.zig");

pub const Adapter4 = c.graphics.dxgi.IDXGIAdapter4;
pub const Device4 = c.graphics.dxgi.IDXGIDevice4;
pub const Factory7 = c.graphics.dxgi.IDXGIFactory7;
pub const Format = c.graphics.dxgi.common.DXGI_FORMAT;
pub const GpuPreference = c.graphics.dxgi.DXGI_GPU_PREFERENCE;
pub const Scaling = c.graphics.dxgi.DXGI_SCALING;
pub const SwapChain4 = c.graphics.dxgi.IDXGISwapChain4;
pub const SwapChainDesc1 = c.graphics.dxgi.DXGI_SWAP_CHAIN_DESC1;

// Note: Variables named iid_<name> are the equivalent of calling IID_PPV_ARGS(&factory) on
// Note: In the D3D12 docs, you'll often see the function IID_PPV_ARGS called. That function
// doesn't exist in Zig, and the below variables exist to compensate for that.
//
// Let's say I have the following D3D12 C++ code:
// ComPtr<IDXGIFactory7> factory;
// CreateDXGIFactory2(0, IID_PPV_ARGS(&factory));
//
// The equivalent would be:
// var factory: *Factory7 = undefined;
// createFactory2(0, iid_factory7, @ptrCast(&factory));
//
// This really tripped me up while exploring porting D3D12 to Zig, so hopefully this helps somebody
// else trying to also follow C++ docs while writing Zig D3D12 code!
pub const iid_adapter4 = c.graphics.dxgi.IID_IDXGIAdapter4;
pub const iid_device4 = c.graphics.dxgi.IID_IDXGIDevice4;
pub const iid_factory7 = c.graphics.dxgi.IID_IDXGIFactory7;
pub const swap_effect_flip_discard = c.graphics.dxgi.DXGI_SWAP_EFFECT_FLIP_DISCARD;
pub const usage_render_target_output = c.graphics.dxgi.DXGI_USAGE_RENDER_TARGET_OUTPUT;

pub const createFactory2 = c.graphics.dxgi.CreateDXGIFactory2;
