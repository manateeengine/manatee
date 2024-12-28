const std = @import("std");

const c = @import("c.zig");
const helpers = @import("helpers.zig");
const Class = @import("class.zig").Class;
const objc = @import("objc.zig");
const object = @import("object.zig");

/// The root class of most Objective-C class hierarchies, from which subclasses inherit a basic
/// interface to the runtime system and the ability to behave as Objective-C objects.
/// See: https://developer.apple.com/documentation/objectivec/nsobject
///
/// NSObject is kinda weird. It was originally part of the Foundation Framework but has since
/// become a part of the Objective-C runtime itself. It's a little more idiomatic than the rest of
/// the code exported from objective_c, and it calls a ton of major things in the runtime. Since
/// Zig doesn't have classes / inheritance, you'll likely see the exact patterns used in this
/// struct across all different parts of the Manatee MacOS frameworks
pub const NSObject = struct {
    value: c.id,
    const ns_object_mixin = NSObjectMixin(NSObject, "NSObject");
    pub usingnamespace ns_object_mixin;

    pub fn init() NSObject {
        return ns_object_mixin.alloc();
    }

    pub fn deinit(self: *NSObject) void {
        ns_object_mixin.dealloc(self);
        self.* = undefined;
    }
};

test {
    const testing = std.testing;
    const ns_object = NSObject.init();
    defer ns_object.deinit();

    try testing.expect(ns_object.value != null);
    try testing.expectEqualStrings("NSObject", ns_object.getClassName());
}

pub fn NSObjectMixin(comptime Self: type, class_name: []const u8) type {
    return struct {
        const object_mixin = object.ObjectMixin(Self);
        pub usingnamespace object_mixin;

        /// Returns a new instance of the receiving class.
        pub fn alloc() Self {
            const class = objc.getClass(class_name);
            return objc.msgSend(class, Self, "alloc", .{});
        }

        // TODO: Implement allocWithZone
        // TODO: Implement copy
        // TODO: Implement copyWithZone
        // TODO: Implement mutableCopy
        // TODO: Implement mutableCopyWithZone

        pub fn dealloc(self: *Self) void {
            objc.msgSend(self, void, "dealloc", .{});
        }

        // TODO: Implement new
    };
}
