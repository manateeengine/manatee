const std = @import("std");

const Protocol = @import("protocol.zig").Protocol;
const Sel = @import("sel.zig").Sel;

/// An opaque type that represents an Objective-C class.
/// Original: `Class`
/// See: https://developer.apple.com/documentation/objectivec/class
pub const Class = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(name: [*:0]const u8) !*Self {
        const class = getClass(name);
        if (class == null) {
            return error.class_not_registered;
        }
        return class.?;
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        self.* = undefined;
    }

    // Methods defined under the Objective-C runtime's "Working with Classes" section

    /// Returns the name of a class.
    /// Original: `class_getName`
    /// See: https://developer.apple.com/documentation/objectivec/1418635-class_getname
    pub fn getName(self: *Self) [*:0]const u8 {
        return class_getName(self);
    }

    // TODO: Implement wrapper for class_getSuperClass
    // TODO: Implement wrapper for class_setSuperClass
    // TODO: Implement wrapper for class_isMetaClass
    // TODO: Implement wrapper for class_getInstanceSize
    // TODO: Implement wrapper for class_getInstanceVariable
    // TODO: Implement wrapper for class_getClassVariable
    // TODO: Implement wrapper for class_addIvar
    // TODO: Implement wrapper for class_copyIvarList
    // TODO: Implement wrapper for class_getIvarLayout
    // TODO: Implement wrapper for class_setIvarLayout
    // TODO: Implement wrapper for class_getWeakIvarLayout
    // TODO: Implement wrapper for class_setWeakIvarLayout
    // TODO: Implement wrapper for class_getProperty
    // TODO: Implement wrapper for class_copyPropertyList

    /// Adds a new method to a class with a given name and implementation.
    pub fn addMethod(self: *Self, name: *Sel, imp: anytype, types: [*:0]const u8) !void {
        // Adding methods to a class via Zig is a little bit rough. It's easy enough to get the
        // class, method name, and actual implementation, but Objective-C wants us to also send the
        // method's type information over. Given the subtle differences between Zig and C, and then
        // the subsequent differences between C and Objective-C, we need to encode these typings in
        // a way that Objective-C will understand. The methodology for encoding can be found in the
        // function `createMethodEncoding`.
        // TODO: There should probably be a convenience helper for encoding Objective-C type
        // strings. I might make one if this ends up getting used in more than a couple places
        if (!class_addMethod(self, name, @ptrCast(&imp), types)) {
            return error.error_adding_method;
        }
    }

    // TODO: Implement wrapper for class_getInstanceMethod
    // TODO: Implement wrapper for class_getClassMethod
    // TODO: Implement wrapper for class_copyMethodList
    // TODO: Implement wrapper for class_replaceMethod
    // TODO: Implement wrapper for class_getMethodImplementation
    // TODO: Implement wrapper for class_getMethodImplementation_stret
    // TODO: Implement wrapper for class_respondsToSelector

    /// Adds a protocol to a class.
    /// Original: `class_addProtocol`
    /// See: https://developer.apple.com/documentation/objectivec/1418773-class_addprotocol
    pub fn addProtocol(self: *Self, protocol: *Protocol) !void {
        if (!class_addProtocol(self, protocol)) {
            return error.add_protocol_failed;
        }
    }

    // TODO: Implement wrapper for class_addProperty
    // TODO: Implement wrapper for class_replaceProperty
    // TODO: Implement wrapper for class_confirmsToProtocol
    // TODO: Implement wrapper for class_copyProtocolList
    // TODO: Implement wrapper for class_getVersion
    // TODO: Implement wrapper for class_setVersion
    // TODO: Implement wrapper for objc_getFutureClass
    // TODO: Implement wrapper for objc_setFutureClass

    // Methods defined under the Objective-C runtime's "Adding Classes" section

    /// Creates a new class and metaclass.
    /// Original: `objc_allocateClassPair`
    /// See: https://developer.apple.com/documentation/objectivec/1418559-objc_allocateclasspair
    pub fn allocateClassPair(superclass: ?*Self, name: [*:0]const u8, extra_bytes: ?usize) !*Self {
        const class_pair = objc_allocateClassPair(superclass, name, extra_bytes orelse 0);
        if (class_pair == null) {
            return error.class_pair_allocation_failed;
        }
        return class_pair.?;
    }

    /// Destroys a class and its associated metaclass.
    /// Original: `objc_disposeClassPair`
    /// See: https://developer.apple.com/documentation/objectivec/1418912-objc_disposeclasspair
    pub fn disposeClassPair(self: *Self) void {
        return objc_disposeClassPair(self);
    }

    /// Creates a new class and metaclass.
    /// Original: `objc_allocateClassPair`
    /// See: https://developer.apple.com/documentation/objectivec/1418559-objc_allocateclasspair
    pub fn registerClassPair(self: *Self) void {
        return objc_registerClassPair(self);
    }

    /// Used by Foundation's Key-Value Observing.
    /// Original: `objc_duplicateClass`
    /// See: https://developer.apple.com/documentation/objectivec/1418645-objc_duplicateclass
    pub fn duplicateClass(self: *Self, name: [*:0]const u8, extra_bytes: ?usize) *Self {
        return objc_duplicateClass(self, name, extra_bytes);
    }

    // Methods defined under the Objective-C runtime's "Instantiating Classes" section

    // TODO: Implement wrapper for class_createInstance
    // TODO: Implement wrapper for objc_constructInstance

    // Methods defined under the Objective-C runtime's "Obtaining Class Definitions" section

    // TODO: Implement wrapper for objc_getClassList

    /// Creates and returns a list of pointers to all registered class definitions.
    /// Original: `objc_copyClassList`
    /// See: https://developer.apple.com/documentation/objectivec/1418762-objc_copyclasslist
    pub fn copyClassList() []*Self {
        var class_count: u32 = undefined;
        const class_list = objc_copyClassList(&class_count);
        return class_list[0..class_count];
    }

    /// Returns the class definition of a specified class.
    /// Original: `objc_lookUpClass`
    /// See: https://developer.apple.com/documentation/objectivec/1418760-objc_lookupclass
    pub fn lookUpClass(name: [*:0]const u8) ?*Self {
        return objc_lookUpClass(name);
    }

    /// Returns the class definition of a specified class.
    /// Original: `objc_getClass`
    /// See: https://developer.apple.com/documentation/objectivec/1418952-objc_getclass
    pub fn getClass(name: [*:0]const u8) ?*Self {
        return objc_getClass(name);
    }

    /// Returns the class definition of a specified class.
    /// Original: `objc_getRequiredClass`
    pub fn getRequiredClass(name: [*:0]const u8) *Self {
        return objc_getRequiredClass(name);
    }

    /// Returns the metaclass definition of a specified class.
    /// Original: `objc_getMetaClass`
    /// See: https://developer.apple.com/documentation/objectivec/1418721-objc_getmetaclass
    pub fn getMetaClass(name: [*:0]const u8) ?*Self {
        return objc_getMetaClass(name);
    }
};

extern "c" fn class_addMethod(cls: *Class, sel: *Sel, imp: *const fn () callconv(.c) void, types: [*:0]const u8) callconv(.c) bool;
extern "c" fn class_addProtocol(cls: *Class, protocol: *Protocol) bool;
extern "c" fn class_getName(cls: *Class) callconv(.c) [*:0]const u8;
extern "c" fn objc_allocateClassPair(superclass: ?*Class, name: [*:0]const u8, extraBytes: usize) callconv(.c) ?*Class;
extern "c" fn objc_copyClassList(outCount: *u32) callconv(.c) [*]*Class;
extern "c" fn objc_disposeClassPair(class: *Class) callconv(.c) void;
extern "c" fn objc_duplicateClass(class: *Class, name: [*:0]const u8, extraBytes: usize) callconv(.c) *Class;
extern "c" fn objc_getClass(name: [*:0]const u8) callconv(.c) ?*Class;
extern "c" fn objc_getMetaClass(name: [*:0]const u8) callconv(.c) ?*Class;
extern "c" fn objc_getRequiredClass(name: [*:0]const u8) callconv(.c) ?*Class;
extern "c" fn objc_lookUpClass(name: [*:0]const u8) callconv(.c) ?*Class;
extern "c" fn objc_registerClassPair(class: *Class) callconv(.c) void;
