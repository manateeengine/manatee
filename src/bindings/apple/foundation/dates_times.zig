//! The Apple Core Animation Framework
//! See: https://developer.apple.com/documentation/quartzcore

const objective_c = @import("../objective_c.zig");

const Class = objective_c.class.Class;
const ObjectMixin = objective_c.object.ObjectMixin;
const Sel = objective_c.Sel;
const msgSend = objective_c.msgSend;

// Opaque Types

/// A representation of a specific point in time, independent of any calendar or time zone.
/// Original: `NSDate`
/// See: https://developer.apple.com/documentation/foundation/nsdate
pub const Date = opaque {
    const Self = @This();
    pub usingnamespace DateMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() !*Self {
        return Self.new("NSDate");
    }

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn initDistantFuture() !*Self {
        return try Self.distantFuture("NSDate");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }
};

// Structs / Mixins

/// A Manatee Binding Mixin for the Apple Foundation Framework's NSDate class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn DateMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectMixin(Self);
        pub usingnamespace inherited_methods;

        /// A date object representing a date in the distant future.
        /// Original: NSDate.distantFuture`
        /// See: https://developer.apple.com/documentation/foundation/nsdate/1415385-distantfuture
        pub fn distantFuture(class_name: [*:0]const u8) !*Self {
            const class = try Class.init(class_name);
            return msgSend(class, *Self, Sel.init("distantFuture"), .{});
        }
    };
}
