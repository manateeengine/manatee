//! All relevant headers from the Objective-C Runtime

pub const Id = @import("../macos/objective_c_runtime.zig").Id;

pub extern fn MTLCreateSystemDefaultDevice() ?*Id;
