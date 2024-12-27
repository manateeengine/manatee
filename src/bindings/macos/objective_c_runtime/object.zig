const std = @import("std");

const c = @import("c.zig");
const Class = @import("class.zig").Class;

/// A struct that contains all functions prefixed by `object_` in the Objective-C Runtime, while
/// also providing storage for the raw Objective-C object.
pub const Object = struct {
    /// The internal Objective-C Runtime value representing the Object.
    value: c.id,
    const object_mixin = ObjectMixin(Object);
    pub usingnamespace object_mixin;
};

pub fn ObjectMixin(comptime Self: type) type {
    return struct {
        /// Returns the class name of a given object.
        /// See https://developer.apple.com/documentation/objectivec/1418547-object_getclassname
        pub fn getClass(self: Self) Class {
            return Class{ .value = c.object_getClass(self.value) };
        }

        /// Returns the class name of a given object.
        /// See https://developer.apple.com/documentation/objectivec/1418547-object_getclassname
        pub fn getClassName(self: Self) []const u8 {
            return std.mem.sliceTo(c.object_getClassName(self.value), 0);
        }
    };
}
