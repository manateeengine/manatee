//! Apple's AppKit Framework
//! See: https://developer.apple.com/documentation/appkit

const foundation = @import("foundation.zig");
const objective_c_runtime = @import("objective_c_runtime.zig");

const Class = objective_c_runtime.Class;
const helpers = objective_c_runtime.helpers;
const Id = objective_c_runtime.Id;
const NSInteger = objective_c_runtime.data_types.NSInteger;
const NsObjectMixin = objective_c_runtime.ns_object.NsObjectMixin;
const NSUInteger = objective_c_runtime.data_types.NSUInteger;
const NSRect = foundation.numbers_data_and_basic_values.NSRect;
const Object = objective_c_runtime.Object;
const objc = objective_c_runtime.objc;

/// Activation policies (used by activationPolicy) that control whether and how an app may be
/// activated.
pub const NSApplicationActivationPolicy = enum(NSInteger) {
    NSApplicationActivationPolicyRegular = 0,
    NSApplicationActivationPolicyAccessory = 1,
    NSApplicationActivationPolicyProhibited = 2,
};

pub const NSBackingStoreType = enum(NSUInteger) {
    NSBackingStoreRetained = 0,
    NSBackingStoreNonretained = 1,
    NSBackingStoreBuffered = 2,
};

/// Constants that specify the style of a window, and that you can combine with the C bitwise OR
/// operator.
/// See: https://developer.apple.com/documentation/appkit/nswindow/stylemask-swift.struct
pub const NSWindowStyleMask = enum(NSUInteger) {
    NSWindowStyleMaskBorderless = 0,
    NSWindowStyleMaskTitled = 1 << 0,
    NSWindowStyleMaskClosable = 1 << 1,
    NSWindowStyleMaskMiniaturizable = 1 << 2,
    NSWindowStyleMaskResizable = 1 << 3,
    NSWindowStyleMaskTexturedBackground = 1 << 8,
    NSWindowStyleMaskUnifiedTitleAndToolbar = 1 << 12,
    NSWindowStyleMaskFullScreen = 1 << 14,
    NSWindowStyleMaskFullSizeContentView = 1 << 15,
    NSWindowStyleMaskUtilityWindow = 1 << 4,
    NSWindowStyleMaskDocModalWindow = 1 << 6,
    NSWindowStyleMaskNonactivatingPanel = 1 << 7,
    NSWindowStyleMaskHUDWindow = 1 << 13,
};

/// An object that manages an app’s main event loop and resources used by all of that app’s
/// objects.
/// See: https://developer.apple.com/documentation/appkit/nsapplication
pub const NSApplication = struct {
    /// The internal Objective-C Runtime value representing the NSApplication
    value: Id,
    const ns_application_mixin = NSApplicationMixin(NSApplication, "NSApplication");
    pub usingnamespace ns_application_mixin;

    pub fn init() NSApplication {
        const class = objc.getClass("NSApplication");
        const object = objc.msgSend(class, Object, "sharedApplication", .{});
        return NSApplication{
            .value = object.value,
        };
    }

    pub fn deinit(self: *NSApplication) void {
        ns_application_mixin.dealloc(self);
        self.* = undefined;
    }
};

pub fn NSApplicationMixin(comptime Self: type, class_name: []const u8) type {
    return struct {
        const ns_object_mixin = NsObjectMixin(Self, class_name);
        pub usingnamespace ns_object_mixin;

        pub fn activate(self: *Self) void {
            return objc.msgSend(self, void, "activate", .{});
        }

        pub fn run(self: *Self) void {
            return objc.msgSend(self, void, "run", .{});
        }

        /// Sets the application's activation policy
        pub fn setActivationPolicy(self: *Self, activation_policy: NSApplicationActivationPolicy) void {
            return objc.msgSend(self, void, "setActivationPolicy:", .{activation_policy});
        }

        /// Sets the application's delegate
        pub fn setDelegate(self: *Self, delegate: anytype) void {
            return objc.msgSend(self, void, "setDelegate:", .{delegate.value});
        }
    };
}

/// A window that an app displays on the screen.
/// See: https://developer.apple.com/documentation/appkit/nswindow
pub const NSWindow = struct {
    /// The internal Objective-C Runtime value representing the NSWindow
    value: Id,
    const ns_window_mixin = NSWindowMixin(NSWindow, "NSWindow");
    pub usingnamespace ns_window_mixin;

    pub fn init() NSWindow {
        const object = ns_window_mixin.alloc();
        return NSWindow{
            .value = object.value,
        };
    }

    pub fn deinit(self: *NSApplication) void {
        ns_window_mixin.dealloc();
        self.* = undefined;
    }

    /// Initializes the window with the specified values.
    /// See: https://developer.apple.com/documentation/appkit/nswindow/init(contentrect:stylemask:backing:defer:)
    pub fn initWithContentRect(contentRect: NSRect, style: NSUInteger, backingStoreType: NSBackingStoreType, flag: bool) NSWindow {
        const object = ns_window_mixin.alloc();
        _ = objc.msgSend(object, Object, "initWithContentRect:styleMask:backing:defer:", .{ contentRect, style, backingStoreType, flag });
        return NSWindow{
            .value = object.value,
        };
    }
};

pub fn NSWindowMixin(comptime Self: type, class_name: []const u8) type {
    return struct {
        const ns_object_mixin = NsObjectMixin(Self, class_name);
        pub usingnamespace ns_object_mixin;

        /// Moves the window to the front of the screen list, within its level, and makes it the key
        /// window; that is, it shows the window.
        /// See: https://developer.apple.com/documentation/appkit/nswindow/makekeyandorderfront(_:)
        pub fn makeKeyAndOrderFront(self: *Self) void {
            return objc.msgSend(self, void, "makeKeyAndOrderFront:", .{null});
        }

        /// Sets the window's title
        pub fn setTitle(self: *Self, title: []const u8) void {
            const ns_string_class = objc.getClass("NSString");
            const titleNsString = objc.msgSend(ns_string_class, Object, "stringWithUTF8String:", .{title});
            return objc.msgSend(self, void, "setTitle:", .{titleNsString});
        }
    };
}
