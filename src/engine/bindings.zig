//! Idiomatic Zig bindings for system libraries, frameworks, and APIs used by Manatee.
//!
//! ## Remarks
//! These bindings are currently painstakingly hand-maintained. This might change in the future,
//! but not any time soon! Because of this, these may become out of date. Please file an issue if
//! you run into any bindings that need updates, assuming I don't generate them before anyone uses
//! this engine in a somewhat serious capacity.

pub const apple = @import("bindings/apple.zig");
pub const win32 = @import("bindings/win32.zig");
