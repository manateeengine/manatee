const objective_c = @import("../objective_c.zig");

const Class = objective_c.Class;
const ObjectMixin = objective_c.object.ObjectMixin;
const Sel = objective_c.Sel;
const msgSend = objective_c.msgSend;

// Opaque Types

/// A static, plain-text Unicode string object.
///
/// * Original: `HBRUSH``NSString`
/// * See: https://developer.apple.com/documentation/foundation/nsdate
pub const String = opaque {
    const Self = @This();
    pub usingnamespace StringMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(value: [*:0]const u8) !*Self {
        const self = try Self.alloc("NSString");
        return self.initWithUtf8String(value);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.release();
    }
};

// Structs / Mixins

/// A Manatee Binding Mixin for the Apple Foundation Framework's NSString class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn StringMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectMixin(Self);
        pub usingnamespace inherited_methods;

        /// Returns an NSString object initialized by copying the characters from a given C array of
        /// UTF8-encoded bytes.
        ///
        /// * Original: `HBRUSH``NSString.initWithUTF8String:`
        /// * See: https://developer.apple.com/documentation/foundation/nsstring/1412128-initwithutf8string
        pub fn initWithUtf8String(self: *Self, null_terminated_c_string: [*:0]const u8) !*Self {
            return msgSend(self, *Self, Sel.init("initWithUTF8String:"), .{null_terminated_c_string});
        }
    };
}
