const std = @import("std");

const c = @import("c.zig");

/// A struct that contains all functions prefixed by `object_` in the Objective-C Runtime, while
/// also providing storage for the raw Objective-C object.
pub const Object = struct {
    /// The internal Objective-C Runtime value representing the Object.
    value: c.id,

    /// Returns the class name of a given object.
    /// See https://developer.apple.com/documentation/objectivec/1418547-object_getclassname
    pub fn getClassName(self: Object) []const u8 {
        return std.mem.sliceTo(c.object_getClassName(self.value), 0);
    }
};
