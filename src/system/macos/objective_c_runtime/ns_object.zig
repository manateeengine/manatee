const std = @import("std");

const helpers = @import("helpers.zig");
const Class = @import("class.zig").Class;
const objc = @import("objc.zig");
const Object = @import("object.zig").Object;

/// The root class of most Objective-C class hierarchies, from which subclasses inherit a basic
/// interface to the runtime system and the ability to behave as Objective-C objects.
/// See: https://developer.apple.com/documentation/objectivec/nsobject
///
/// NSObject is kinda weird. It was originally part of the Foundation Framework but has since
/// become a part of the Objective-C runtime itself. It's a little more idiomatic than the rest of
/// the code exported from objective_c_runtime, and it calls a ton of major things in the runtime.
/// Since Zig doesn't have classes / inheritance, you'll likely see the exact patterns used in this
/// struct across all different parts of the Manatee MacOS frameworks
pub const NSObject = struct {
    class: Class,
    object: Object,

    pub fn init() NSObject {
        const class = objc.getClass("NSObject");
        const object = helpers.allocAndInitObject(class);
        return NSObject{
            .class = class,
            .object = object,
        };
    }

    pub fn deinit(self: *NSObject) void {
        helpers.deallocObject(self.object);
        self.* = undefined;
    }
};

test {
    const testing = std.testing;
    const ns_object = NSObject.init();
    defer ns_object.deinit();

    try testing.expect(ns_object.object.value != null);
    try testing.expectEqualStrings("NSObject", ns_object.object.getClassName());
}
