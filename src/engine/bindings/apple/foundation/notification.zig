const ObjectMixin = @import("../objective_c.zig").object.ObjectMixin;

/// A container for information broadcast through a notification center to all registered
/// observers.
///
/// * Original: `HBRUSH``NSNotification`
/// * See: https://developer.apple.com/documentation/foundation/nsnotification
pub const Notification = opaque {
    const Self = @This();
    pub usingnamespace NotificationMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() !*Self {
        return try Self.new("NSNotification");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.release();
    }
};

/// A Manatee Binding Mixin for the Apple Foundation Framework's NSNotification class and its
/// instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn NotificationMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectMixin(Self);
        pub usingnamespace inherited_methods;
    };
}
