const std = @import("std");

const Class = @import("./class.zig").Class;
const objc = @import("objc.zig");
const Object = @import("./object.zig").Object;

/// A function with no relation to the Objective-C Runtime that handles standardized allocation
/// and initialization for Objective-C objects in Manatee.
///
/// Under the hood, this function takes a given Class and sends an "alloc" message, followed by an
/// "init" message. This should work for the majority of use cases, and you can always send those
/// messages directly instead of calling this helper if needed!
pub fn allocAndInitObject(class: Class) Object {
    const object = objc.msgSend(class, Object, "alloc", .{});
    _ = objc.msgSend(object, Object, "init", .{});
    return object;
}

pub fn deallocObject(object: Object) void {
    objc.msgSend(object, void, "dealloc", .{});
}

test {
    const testing = std.testing;
    const NSObjectClass = objc.getClass("NSObject");

    const object = allocAndInitObject(NSObjectClass);
    try testing.expect(object.value != null);
    try testing.expectEqualStrings("NSObject", object.getClassName());
    objc.msgSend(object, void, "dealloc", .{});
}
