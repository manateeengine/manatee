//! A collection of idiomatic Zig bindings for accessing the D3D12 Graphics API.
//! TODO: This entire section is in desperate need of a rewrite to make it more aligned with the
//! MacOS bindings as well as idiomatic Zig in general. That'll happen at some point, but I'll
//! continue to use ZigWin32 to get this thing off the ground

pub const direct3d = @import("./d3d12/direct3d.zig");
pub const direct3d12 = @import("./d3d12/direct3d12.zig");
pub const dxgi = @import("./d3d12/dxgi.zig");
