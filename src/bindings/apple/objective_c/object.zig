const Class = @import("class.zig").Class;
const Protocol = @import("protocol.zig").Protocol;
const Sel = @import("sel.zig").Sel;
const msgSend = @import("msg_send.zig").msgSend;

/// The root class of most Objective-C class hierarchies, from which subclasses inherit a basic
/// interface to the runtime system and the ability to behave as Objective-C objects.
/// Original: `NSObject`
/// See: https://developer.apple.com/documentation/objectivec/nsobject
pub const Object = opaque {
    const Self = @This();
    pub usingnamespace ObjectMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() !*Self {
        return try Self.new("NSObject");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.release();
    }
};

/// A Manatee Binding Mixin for the Objective-C Runtime's NSObject class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
/// Note: This particular mixin is missing a LOT of the methods defined in the `NSObject` docs, and
/// to be completely honest, they probably won't ever get implemented unless someone either makes a
/// PR, or this is moved to a different, dedicated project. Those methods are marked with todo
/// comments.
pub fn ObjectMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectProtocolMixin(Self);
        pub usingnamespace inherited_methods;

        // Methods defined under the NSObject class's "Initializing a Class" section

        // Honestly these probably shouldn't even be here, it feels wrong given all of the other
        // utilities we have around classes, but eh, I'll leave em for now even though they're
        // unused in Manatee

        /// Initializes the class before it receives its first message.
        /// Original: `NSObject.initialize`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1418639-initialize
        pub fn initialize(class_name: [*:0]const u8) !void {
            const class = try Class.init(class_name);
            return msgSend(class, void, Sel.init("initialize"), .{});
        }

        /// Invoked whenever a class or category is added to the Objective-C runtime; implement
        /// this method to perform class-specific behavior upon loading.
        /// Original: `NSObject.load`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1418815-load
        pub fn load(class_name: [*:0]const u8) !*Class {
            const class = try Class.init(class_name);
            return msgSend(class, void, Sel.init("load"), .{});
        }

        // Methods defined under the NSObject class's "Creating, Copying, and Deallocating Objects"
        // section

        /// Returns a new instance of the receiving class.
        /// Original: `NSObject.alloc`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1571958-alloc
        pub fn alloc(class_name: [*:0]const u8) !*Self {
            const class = try Class.init(class_name);
            return msgSend(class, *Self, Sel.init("alloc"), .{});
        }

        // TODO: Implement wrapper for allocWithZone:

        /// Implemented by subclasses to initialize a new object (the receiver) immediately after
        /// memory for it has been allocated.
        /// Original: `NSObject.init`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1418641-init
        /// Note: The name of this function was changed from `init` to `objcInit` so that it
        /// wouldn't conflict with Zig struct `init` methods
        pub fn objcInit(self: *Self) *Self {
            return msgSend(self, *Self, Sel.init("init"), .{});
        }

        /// Returns the object returned by copyWithZone:.
        /// Original: `NSObject.copy`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1418807-copy
        pub fn copy(self: *Self) *Self {
            return msgSend(self, *Self, Sel.init("copy"), .{});
        }

        // TODO: Implement wrapper for copyWithZone:

        /// Returns the object returned by mutableCopyWithZone: where the zone is nil.
        /// Original: `NSObject.mutableCopy`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1418978-mutablecopy
        pub fn mutableCopy(self: *Self) *Self {
            return msgSend(self, *Self, Sel.init("mutableCopy"), .{});
        }

        // TODO: Implement wrapper for mutableCopyWithZone:

        /// De-allocates the memory occupied by the receiver.
        /// Original: `NSObject.dealloc`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1571947-dealloc
        pub fn dealloc(self: *Self) void {
            return msgSend(self, void, Sel.init("dealloc"), .{});
        }

        /// Allocates a new instance of the receiving class, sends it an init message, and returns
        /// the initialized object.
        /// Original: `NSObject.new`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1571948-new
        pub fn new(class_name: [*:0]const u8) !*Self {
            const class = try Class.init(class_name);
            return msgSend(class, *Self, Sel.init("new"), .{});
        }

        // Methods defined under the NSObject class's "Identifying Classes" section

        /// Sets the class object for the receiver’s superclass.
        /// Original: `NSObject.superclass`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1418803-superclass
        pub fn setSuperclass(self: *Self) *Class {
            return msgSend(self, *Class, Sel.init("setSuperclass:"), .{});
        }

        /// Returns a Boolean value that indicates whether the receiving class is a subclass of, or
        /// identical to, a given class.
        /// Original: `NSObject.isSubclassOfClass:`
        /// See: https://developer.apple.com/documentation/objectivec/nsobject/1418669-issubclassofclass
        pub fn isSubclassOfClass(self: *Self, class: *Class) bool {
            return msgSend(self, bool, Sel.init("isSubclassOfClass:"), .{class});
        }

        // TODO: Implement NSObject class's "Testing Class Functionality" section

        // TODO: Implement NSObject class's "Obtaining Information About Methods" section
        // TODO: Implement NSObject class's "Describing Objects" section
        // TODO: Implement NSObject class's "Supporting Discardable Content" section
        // TODO: Implement NSObject class's "Sending Messages" section
        // TODO: Implement NSObject class's "Forwarding Messages" section
        // TODO: Implement NSObject class's "Dynamically Resolving Methods" section
        // TODO: Implement NSObject class's "Handling Errors" section
        // TODO: Implement NSObject class's "Archiving" section
        // TODO: Implement NSObject class's "Working with Class Descriptions" section
        // TODO: Implement NSObject class's "Improving Accessibility" section
        // TODO: Implement NSObject class's "Improving Browser Accessibility" section
        // TODO: Implement NSObject class's "Scripting" section
        // TODO: Implement NSObject class's "Key-Value Coding" section
        // TODO: Implement NSObject class's "Interacting with Web Plug-ins" section
        // TODO: Implement NSObject class's "Implementing Web Scripting" section
        // TODO: Implement NSObject class's "Supporting Cocoa Scripting" section
        // TODO: Implement NSObject class's "Instance Properties" section
        // TODO: Implement NSObject class's "Instance Methods" section
        // TODO: Implement NSObject class's "Type Methods" section
    };
}

/// A Manatee Binding Mixin for the Objective-C Runtime's NSObject Protocol
/// For more information on the mixin pattern, see `bindings/README.md`
/// Note: This function returns a mixin struct that contains most methods from the Objective-C
/// `NSObject` protocol, and is only kept separate from the actual `Object` mixin for semantics.
/// The following methods within the protocol have been marked as "Obsolete" in Apple's docs, so
/// I opted not to implement them:
/// * retain
/// * release
/// * autorelease
/// * autoreleaseCount
/// * zone
pub fn ObjectProtocolMixin(comptime Self: type) type {
    return struct {
        /// Returns the class of an object.
        /// Original: `objc_getClass` and `@protocol NSObject.class`
        pub fn getClass(self: *Self) *Class {
            return object_getClass(self);
        }

        /// Sets the class of an object.
        /// Original: `objc_setClass` and `@protocol NSObject.class`
        /// See: https://developer.apple.com/documentation/objectivec/1418905-object_setclass
        pub fn setClass(self: *Self) *Class {
            return object_getClass(self);
        }

        /// Returns the class object for the receiver’s superclass.
        /// Original: `@protocol NSObject.superclass`
        /// See: https://developer.apple.com/documentation/objectivec/1418905-object_setclass
        pub fn getSuperclass(self: *Self) *Class {
            return msgSend(self, *Class, Sel.init("superclass"), .{});
        }

        // Methods defined under the NSObject protocol's "Identifying and Comparing Objects"
        // section

        /// Returns a Boolean value that indicates whether the receiver and a given object are equal.
        /// Original: `@protocol NSObject.isEqual:`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418795-isequal
        pub fn isEqual(self: *Self, object: *anyopaque) bool {
            return msgSend(self, bool, Sel.init("isEqual:"), .{object});
        }

        /// Returns an integer that can be used as a table address in a hash table structure.
        /// Original: `@protocol NSObject.hash`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418859-hash
        pub fn getHash(self: *Self) u32 {
            return msgSend(self, bool, Sel.init("hash"), .{});
        }

        /// Returns the receiver.
        /// Original: `@protocol NSObject.self`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418954-self
        pub fn getSelf(self: *Self) *Self {
            return msgSend(self, *Self, Sel.init("self"), .{});
        }

        // Methods defined under the NSObject protocol's "Testing Object Inheritance, Behavior, and
        // Conformance" section

        /// Returns a Boolean value that indicates whether the receiver is an instance of given
        /// class or an instance of any class that inherits from that class.
        /// Original: `@protocol NSObject.isKindOfClass:`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418954-self
        pub fn isKindOfClass(self: *Self, class: *Class) bool {
            return msgSend(self, bool, Sel.init("isKindOfClass:"), .{class});
        }

        /// Returns a Boolean value that indicates whether the receiver is an instance of a given
        /// class.
        /// Original: `@protocol NSObject.isMemberOfClass:`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418766-ismemberofclass
        pub fn isMemberOfClass(self: *Self, class: *Class) *Self {
            return msgSend(self, bool, Sel.init("isMemberOfClass:"), .{class});
        }

        /// Returns a Boolean value that indicates whether the receiver implements or inherits a
        /// method that can respond to a specified message.
        /// Original: `@protocol NSObject.respondsToSelector:`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418583-respondstoselector
        pub fn respondsToSelector(self: *Self, sel: *Sel) bool {
            return msgSend(self, bool, Sel.init("respondsToSelector:"), .{sel});
        }

        /// Returns a Boolean value that indicates whether the receiver conforms to a given protocol.
        /// Original: `@protocol NSObject.conformsToProtocol:`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418515-conformstoprotocol
        pub fn conformsToProtocol(self: *Self, protocol: *Protocol) bool {
            return msgSend(self, bool, Sel.init("conformsToProtocol:"), .{protocol});
        }

        // Methods defined under the NSObject protocol's "Describing Objects" section

        /// A textual representation of the receiver.
        /// Original: `@protocol NSObject.description`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418515-conformstoprotocol
        pub fn getDescription(self: *Self) [*:0]const u8 {
            return msgSend(self, [*:0]const u8, Sel.init("description"), .{});
        }

        /// A textual representation of the receiver to use with a debugger.
        /// Original: `@protocol NSObject.debugDescription`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418703-debugdescription
        pub fn getDebugDescription(self: *Self) [*:0]const u8 {
            return msgSend(self, [*:0]const u8, Sel.init("debugDescription"), .{});
        }

        // Methods defined under the NSObject protocol's "Sending Messages" section

        /// Sends a specified message to the receiver and returns the result of the message.
        /// Original: `@protocol NSObject.performSelector:`
        /// https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418867-performselector
        pub fn performSelector(self: *Self, sel: *Sel) *anyopaque {
            return msgSend(self, *anyopaque, Sel.init("performSelector:"), .{sel});
        }

        /// Sends a message to the receiver with an object as the argument.
        /// Original: `@protocol NSObject.performSelector:withObject:`
        /// https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418764-performselector
        pub fn performSelectorWithObject(self: *Self, sel: *Sel, object: *anyopaque) *anyopaque {
            return msgSend(self, *anyopaque, Sel.init("performSelector:withObject:"), .{ sel, object });
        }

        /// Sends a message to the receiver with two objects as arguments.
        /// Original: `@protocol NSObject.performSelector:withObject:withObject:`
        /// https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418667-performselector
        pub fn performSelectorWithObjectWithObject(self: *Self, sel: *Sel, object_1: *anyopaque, object_2: *anyopaque) *anyopaque {
            return msgSend(self, *anyopaque, Sel.init("performSelector:withObject:withObject:"), .{ sel, object_1, object_2 });
        }

        // Methods defined under the NSObject protocol's "Identifying Proxies" section

        /// Returns a Boolean value that indicates whether the receiver does not descend from
        /// NSObject.
        /// Original: `@protocol NSObject.isProxy`
        /// https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418667-performselector
        pub fn isProxy(self: *Self) bool {
            return msgSend(self, bool, Sel.init("isProxy"), .{});
        }

        // Methods defined under the NSObject protocol's "Obsolete Methods" section
        // Note: Although these methods are marked as obsolete, some of them are still useful in
        // the context of Zig. These methods include support for manual reference counting, or ARC.
        // ARC is preferred in Apple's docs when writing Objective-C, and made easier by the helper
        // @autoreleasepool, however, having functionality that automatically releases memory feels
        // wrong inside of Zig. Because of this caveat, we're still implementing these methods

        /// Increments the receiver’s reference count.
        /// Original: `@protocol NSObject.retain`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1571946-retain
        pub fn retain(self: *Self) *Self {
            return msgSend(self, *Self, Sel.init("retain"), .{});
        }

        /// Decrements the receiver’s reference count.
        /// Original: `@protocol NSObject.release`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1571957-release
        pub fn release(self: *Self) void {
            return msgSend(self, void, Sel.init("release"), .{});
        }

        /// Decrements the receiver’s retain count at the end of the current autorelease pool
        /// block.
        /// Original: `@protocol NSObject.autorelease`
        /// See: https://developer.apple.com/documentation/objectivec/1418956-nsobject/1571951-autorelease
        pub fn autorelease(self: *Self) void {
            return msgSend(self, void, Sel.init("autorelease"), .{});
        }

        // Note: I decided to omit the `retainCount` and `zone` methods from this mixin since the
        // docs explicitly said to never use them. If someone finds value in these methods, they're
        // free to open a PR and add them here, but it's not worth my time at this point
    };
}

extern "c" fn object_getClass(obj: *anyopaque) callconv(.c) *Class;
extern "c" fn object_setClass(obj: *anyopaque, cls: *Class) callconv(.c) *Class;
