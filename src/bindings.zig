//! Idiomatic Zig bindings for various libraries used by Manatee
//!
//! Note: there's currently one (1) external Zig dep in this portion of the codebase, and that's
//! zigwin32. See win32.zig for more information as to why that's included, as that breaks
//! Manatee's paradigm of "zero dependencies wherever possible"

pub const d3d12 = @import("bindings/d3d12.zig");
pub const macos = @import("bindings/macos.zig");
pub const win32 = @import("bindings/win32.zig");
