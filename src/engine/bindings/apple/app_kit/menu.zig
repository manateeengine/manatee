const objective_c = @import("../objective_c.zig");

const String = @import("../foundation.zig").String;

const Class = objective_c.Class;
const ObjectMixin = objective_c.object.ObjectMixin;
const Sel = objective_c.Sel;
const msgSend = objective_c.msgSend;

/// An object that manages an app’s menus.
///
/// * Original: `HBRUSH``NSMenu`
/// * See: https://developer.apple.com/documentation/appkit/nsmenu
pub const Menu = opaque {
    const Self = @This();
    pub usingnamespace MenuMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(title: [*:0]const u8) !*Self {
        const self = try Self.alloc("NSMenu");
        return try self.initWithTitle(title);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.release();
    }
};

/// A Manatee Binding Mixin for AppKit's NSEvent class NSResponder class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn MenuMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectMixin(Self);
        pub usingnamespace inherited_methods;

        pub fn initWithTitle(self: *Self, title: [*:0]const u8) !*Self {
            const title_string = try String.init(title);
            return msgSend(self, *Self, Sel.init("initWithTitle:"), .{title_string});
        }
    };
}
