const builtin = @import("builtin");
const std = @import("std");

/// The standard Manatee App interface.
/// 
/// Example Usage:
/// ```zig
/// const manatee = @import("manatee");
/// 
/// pub const MyCustomApp = struct {
///     pub fn init() MyCustomApp {
///         return MyCustomApp {};
///     }
/// 
///     pub fn app(self: *MyCustomApp) manatee.system.App {
///         return manatee.system.App {
///             .ptr = self,
///             .impl = &.{ .deinit = deinit, .run = run },
///         };
///     }
/// 
///     pub fn run(ctx: *anyopaque) void {
///         const self: *MyCustomApp = @ptrCast(@alignCast(ctx));
///         // Your custom event loop goes here!
///     }
/// 
///     pub fn deinit(ctx: *anyopaque) void {
///         const self: *MyCustomApp = @ptrCast(@alignCast(ctx));
///         self.* = undefined;
///     }
/// };
/// ```
/// 
/// An app represents all of the core system functionality needed to create and manage a desktop
/// application for a given OS. This includes (but is not limited to) window creation, window
/// painting, and event loop management.
/// 
/// This interface is inspired by the Zig "interface" pattern defined in std.mem.Allocator. Fingers
/// crossed that better, less verbose interface patterns will be added to Zig in a future version,
/// but for now this is the best option. For more information on Zig interfaces, check out
/// https://medium.com/@jerrythomas_in/exploring-compile-time-interfaces-in-zig-5c1a1a9e59fd
pub const App = struct {
    ptr: *anyopaque,
    impl: *const AppInterface,

    pub const AppInterface = struct {
        deinit: *const fn (ctx: *anyopaque) void,
        run: *const fn (ctx: *anyopaque) void,
    };

    pub fn run(self: App) void {
        return self.impl.run(self.ptr);
    }

    pub fn deinit(self: App) void {
        self.impl.deinit(self.ptr);
    }
};

