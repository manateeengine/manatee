//! Idiomatic Zig bindings for system libraries, frameworks, and APIs used by Manatee
//! See: `bindings/README.md` for more information as to how these bindings are constructed

pub const apple = @import("bindings/apple.zig");
pub const vulkan = @import("bindings/vulkan.zig");
pub const win32 = @import("bindings/win32.zig");
