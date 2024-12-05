const std = @import("std");

const c = @import("c.zig");

/// A struct that contains all functions prefixed by `class_` in the Objective-C Runtime, while
/// also providing storage for the raw Objective-C class.
///
/// Note: the following methods have not yet been implemented as they haven't been required for
/// Manatee functionality:
///
/// * `class_getSuperclass`
/// * `class_isMetaClass`
/// * `class_getInstanceSize`
/// * `class_getInstanceVariable`
/// * `class_getClassVariable`
/// * `class_addIvar`
/// * `class_copyIvarList`
/// * `class_getIvarLayout`
/// * `class_setIvarLayout`
/// * `class_getWeakIvarLayout`
/// * `class_getProperty`
/// * `class_copyPropertyList`
/// * `class_addMethod`
/// * `class_getInstanceMethod`
/// * `class_getClassMethod`
/// * `class_copyMethodList`
/// * `class_replaceMethod`
/// * `class_getMethodImplementation`
/// * `class_getMethodImplementation_stret`
/// * `class_respondsToSelector`
/// * `class_addProtocol`
/// * `class_addProperty`
/// * `class_replaceProperty`
/// * `class_conformsToProtocol`
/// * `class_copyProtocolList`
/// * `class_getVersion`
/// * `class_setVersion`
/// * `class_getImageName`
pub const Class = struct {
    /// The internal Objective-C Runtime value representing the Class.
    value: c.Class,

    /// Returns the name of a class.
    /// See: https://developer.apple.com/documentation/objectivec/1418635-class_getname
    pub fn getName(class: *Class) []const u8 {
        return std.mem.sliceTo(c.class_getName(class.value), 0);
    }
};
