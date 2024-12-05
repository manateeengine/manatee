const c = @import("../c.zig");

pub const getModuleHandleW = c.system.library_loader.GetModuleHandleW;
