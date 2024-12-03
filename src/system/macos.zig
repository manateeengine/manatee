//! A collection of idiomatic Zig utilities for writing native MacOS desktop applications.

pub const app_kit = @import("macos/app_kit.zig");
pub const core_graphics = @import("macos/core_graphics.zig");
pub const foundation = @import("macos/foundation.zig");
pub const objective_c_runtime = @import("macos/objective_c_runtime.zig");
