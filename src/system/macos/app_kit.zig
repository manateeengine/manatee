//! Apple's AppKit Framework
//! See: https://developer.apple.com/documentation/appkit

const foundation = @import("foundation.zig");
const objective_c_runtime = @import("objective_c_runtime.zig");

const NSRect = foundation.numbers_data_and_basic_values.NSRect;
const Class = objective_c_runtime.Class;
const helpers = objective_c_runtime.helpers;
const NSInteger = objective_c_runtime.data_types.NSInteger;
const NSUInteger = objective_c_runtime.data_types.NSUInteger;
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
    class: Class,
    object: Object,
    /// The internal Objective-C Runtime value representing the Object
    value: objective_c_runtime.c.id,

    // TODO: Should this be named initSharedApplication? Idk
    pub fn init() NSApplication {
        const class = objc.getClass("NSApplication");
        const object = objc.msgSend(class, Object, "sharedApplication", .{});
        return NSApplication{
            .class = class,
            .object = object,
            .value = object.value,
        };
    }

    pub fn activate(self: *NSApplication) void {
        return objc.msgSend(self.object, void, "activate", .{});
    }

    pub fn run(self: *NSApplication) void {
        return objc.msgSend(self.object, void, "run", .{});
    }

    pub fn setActivationPolicy(self: *NSApplication, activation_policy: NSApplicationActivationPolicy) void {
        return objc.msgSend(self.object, void, "setActivationPolicy:", .{activation_policy});
    }

    pub fn deinit(self: *NSApplication) void {
        helpers.deallocObject(self.object);
        self.* = undefined;
    }
};

/// A window that an app displays on the screen.
/// See: https://developer.apple.com/documentation/appkit/nswindow
pub const NSWindow = struct {
    class: Class,
    object: Object,
    value: objective_c_runtime.c.id,

    pub fn init() NSWindow {
        const class = objc.getClass("NSWindow");
        const object = objc.msgSend(class, Object, "alloc", .{});
        return NSWindow{
            .class = class,
            .object = object,
            .value = object.value,
        };
    }

    /// Initializes the window with the specified values.
    /// See: https://developer.apple.com/documentation/appkit/nswindow/init(contentrect:stylemask:backing:defer:)
    pub fn initWithContentRect(contentRect: NSRect, style: NSUInteger, backingStoreType: NSBackingStoreType, flag: bool) NSWindow {
        const class = objc.getClass("NSWindow");
        const object = objc.msgSend(class, Object, "alloc", .{});
        _ = objc.msgSend(object, Object, "initWithContentRect:styleMask:backing:defer:", .{ contentRect, style, backingStoreType, flag });
        return NSWindow{
            .class = class,
            .object = object,
            .value = object.value,
        };
    }

    /// Moves the window to the front of the screen list, within its level, and makes it the key
    /// window; that is, it shows the window.
    /// See: https://developer.apple.com/documentation/appkit/nswindow/makekeyandorderfront(_:)
    pub fn makeKeyAndOrderFront(self: *NSWindow) void {
        return objc.msgSend(self.object, void, "makeKeyAndOrderFront:", .{null});
    }

    /// Moves the window to the front of the screen list, within its level, and makes it the key
    /// window; that is, it shows the window.
    /// See: https://developer.apple.com/documentation/appkit/nswindow/makekeyandorderfront(_:)
    pub fn setTitle(self: *NSWindow, title: []const u8) void {
        const ns_string_class = objc.getClass("NSString");
        const titleNsString = objc.msgSend(ns_string_class, Object, "stringWithUTF8String:", .{title});
        return objc.msgSend(self.object, void, "setTitle:", .{titleNsString});
    }

    pub fn deinit(self: *NSWindow) void {
        helpers.deallocObject(self.object);
        self.* = undefined;
    }
};
