const builtin = @import("builtin");
const std = @import("std");

pub const window_config = @import("window/window_config.zig");

/// The standard Manatee Window interface.
///
/// A Window represents an operating system window in a desktop application. In the future, a
/// Window may also represent a web view or mobile app pane, but those things are far out of scope
/// for the initial version of Manatee.
///
/// This interface is inspired by the Zig "interface" pattern defined in std.mem.Allocator. Fingers
/// crossed that better, less verbose interface patterns will be added to Zig in a future version,
/// but for now this is the best option. For more information on Zig interfaces, check out
/// https://medium.com/@jerrythomas_in/exploring-compile-time-interfaces-in-zig-5c1a1a9e59fd
pub const Window = struct {
    ptr: *anyopaque,
    impl: *const WindowInterface,

    pub const WindowInterface = struct {
        deinit: *const fn (ctx: *anyopaque) void,
    };

    pub fn deinit(self: Window) void {
        return self.impl.deinit(self.ptr);
    }
};
