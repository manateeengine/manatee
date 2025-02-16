const ObjectMixin = @import("../objective_c.zig").object.ObjectMixin;

/// An abstract class that forms the basis of event and command processing in AppKit.
///
/// * Original: `HBRUSH``NSResponder`
/// * See: https://developer.apple.com/documentation/appkit/nsresponder
pub const Responder = opaque {
    const Self = @This();
    pub usingnamespace ResponderMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() !*Self {
        return try Self.new("NSResponder");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.release();
    }
};

/// A Manatee Binding Mixin for AppKit's NSEvent class NSResponder class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn ResponderMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectMixin(Self);
        pub usingnamespace inherited_methods;
    };
}
