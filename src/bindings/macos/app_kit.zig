//! Apple's AppKit Framework
//! See: https://developer.apple.com/documentation/appkit

const core_animation = @import("core_animation.zig");
const foundation = @import("foundation.zig");
const objective_c = @import("objective_c.zig");

const CALayer = core_animation.CALayer;

const NSRect = foundation.numbers_data_and_basic_values.NSRect;

const Class = objective_c.Class;
const Id = objective_c.Id;
const NSInteger = objective_c.data_types.NSInteger;
const NSObjectMixin = objective_c.ns_object.NSObjectMixin;
const NSUInteger = objective_c.data_types.NSUInteger;
const Object = objective_c.Object;
const objc = objective_c.objc;

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
        const ns_object_mixin = NSObjectMixin(Self, class_name);
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

/// An abstract class that forms the basis of event and command processing in AppKit.
/// See: https://developer.apple.com/documentation/appkit/nsresponder
pub const NSResponder = struct {
    /// The internal Objective-C Runtime value representing the NSResponder
    value: Id,
    const ns_responder_mixin = NSResponderMixin(NSResponder, "NSResponder");
    pub usingnamespace ns_responder_mixin;

    pub fn init() NSResponder {
        const object = ns_responder_mixin.alloc();
        return NSResponder{
            .value = object.value,
        };
    }

    pub fn deinit(self: *NSResponder) void {
        ns_responder_mixin.dealloc(self);
        self.* = undefined;
    }
};

pub fn NSResponderMixin(comptime Self: type, class_name: []const u8) type {
    return struct {
        const ns_object_mixin = NSObjectMixin(Self, class_name);
        pub usingnamespace ns_object_mixin;
    };
}

/// The infrastructure for drawing, printing, and handling events in an app.
/// See: https://developer.apple.com/documentation/appkit/nsview
pub const NSView = struct {
    /// The internal Objective-C Runtime value representing the NSView
    value: Id,
    const ns_view_mixin = NSViewMixin(NSView, "NSView");
    pub usingnamespace ns_view_mixin;

    pub fn init() NSView {
        const object = ns_view_mixin.alloc();
        return NSView{
            .value = object.value,
        };
    }

    pub fn deinit(self: *NSView) void {
        ns_view_mixin.dealloc(self);
        self.* = undefined;
    }
};

pub fn NSViewMixin(comptime Self: type, class_name: []const u8) type {
    return struct {
        const ns_responder_mixin = NSResponderMixin(Self, class_name);
        pub usingnamespace ns_responder_mixin;

        /// Sets the Boolean value indicating whether the view uses a layer as its backing store.
        pub fn getWantsLayer(self: *Self) bool {
            // return ns_responder_mixin.getInstanceVariable(self, bool, "wantsLayer");
            return objc.msgSend(self, bool, "wantsLayer", .{});
        }

        /// Sets the Core Animation layer that the view uses as its backing store.
        pub fn setLayer(self: *Self, layer: anytype) void {
            return objc.msgSend(self, void, "setLayer:", .{layer.value});
        }

        /// Sets the Boolean value indicating whether the view uses a layer as its backing store.
        pub fn setWantsLayer(self: *Self, wants_layer: bool) void {
            return objc.msgSend(self, void, "setWantsLayer:", .{wants_layer});
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

    pub fn deinit(self: *NSWindow) void {
        ns_window_mixin.dealloc(self);
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
        const ns_responder_mixin = NSResponderMixin(Self, class_name);
        pub usingnamespace ns_responder_mixin;

        /// Moves the window to the front of the screen list, within its level, and makes it the key
        /// window; that is, it shows the window.
        /// See: https://developer.apple.com/documentation/appkit/nswindow/makekeyandorderfront(_:)
        pub fn makeKeyAndOrderFront(self: *Self) void {
            return objc.msgSend(self, void, "makeKeyAndOrderFront:", .{null});
        }

        /// Gets the window’s content view, the highest accessible view object in the window’s view
        /// hierarchy.
        /// See: https://developer.apple.com/documentation/appkit/nswindow/contentview
        pub fn getContentView(self: *Self) *NSView {
            return objc.msgSend(self, *NSView, "getContentView:", .{});
        }

        /// Sets the window’s content view, the highest accessible view object in the window’s view
        /// hierarchy.
        /// See: https://developer.apple.com/documentation/appkit/nswindow/contentview
        pub fn setContentView(self: *Self, content_view: anytype) void {
            return objc.msgSend(self, void, "setContentView:", .{content_view.value});
        }

        /// Sets the string that appears in the title bar of the window or the path to the
        /// represented file.
        /// See: https://developer.apple.com/documentation/appkit/nswindow/title
        pub fn setTitle(self: *Self, title: []const u8) void {
            const ns_string_class = objc.getClass("NSString");
            const titleNsString = objc.msgSend(ns_string_class, Object, "stringWithUTF8String:", .{title});
            return objc.msgSend(self, void, "setTitle:", .{titleNsString});
        }
    };
}
