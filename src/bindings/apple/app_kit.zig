//! The Apple AppKit Framework
//! See: https://developer.apple.com/documentation/appkit

const core_graphics = @import("core_graphics.zig");
const objective_c = @import("objective_c.zig");

pub const Rect = core_graphics.Rect;

const Class = objective_c.Class;
const ObjectMixin = objective_c.object.ObjectMixin;
const Protocol = objective_c.Protocol;
const Sel = objective_c.Sel;
const msgSend = objective_c.msgSend;

/// An abstract class that forms the basis of event and command processing in AppKit.
/// Original: `NSApplication`
/// See: https://developer.apple.com/documentation/appkit/nsresponder
pub const Application = opaque {
    const Self = @This();
    pub usingnamespace ApplicationMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() !*Self {
        // Note: Most of these Objective-C class wrappers call the class's `new` function, however
        // NSApplication works a little bit differently, and instead of allocating and initializing
        // the instance directly, Apple wants you to connect to the window server (via the
        // sharedApplication property) and have something under the hood allocate it for you, at
        // least, I think. It really isn't documented super well for usage outside of XCode and
        // native Objective-C
        return try Self.getSharedApplication("NSApplication");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }
};

/// An abstract class that forms the basis of event and command processing in AppKit.
/// Original: `NSResponder`
/// See: https://developer.apple.com/documentation/appkit/nsresponder
pub const Responder = opaque {
    const Self = @This();
    pub usingnamespace ResponderMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() *Self {
        return Self.new("NSResponder");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }
};

/// The infrastructure for drawing, printing, and handling events in an app.
/// Original: `NSView`
/// See: https://developer.apple.com/documentation/appkit/nsview
pub const View = opaque {
    const Self = @This();
    pub usingnamespace ViewMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() *Self {
        return Self.new("NSView");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }
};

/// An abstract class that forms the basis of event and command processing in AppKit.
/// Original: `NSWindow`
/// See: https://developer.apple.com/documentation/appkit/nsresponder
pub const Window = opaque {
    const Self = @This();
    pub usingnamespace WindowMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(content_rect: Rect, style_mask: WindowStyleMask, backing_store_type: BackingStoreType, flag: bool) !*Self {
        const self = try Self.alloc("NSWindow");
        return Self.initWithContentRectStyleMaskBackingDefer(self, content_rect, style_mask, backing_store_type, flag);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }
};

// Enums

/// Constants that specify how the window device buffers the drawing done in a window.
/// Original: `NSBackingStoreType`
/// See: https://developer.apple.com/documentation/appkit/nswindow/backingstoretype
pub const BackingStoreType = enum(u32) {
    /// DEPRECATED: The window uses a buffer, but draws directly to the screen where possible and
    /// to the buffer for obscured portions.
    retained = 0,
    /// DEPRECATED: The window draws directly to the screen without using any buffer.
    nonretained = 1,
    /// The window renders all drawing into a display buffer and then flushes it to the screen.
    buffered = 2,
};

// Structs / Mixins

/// Activation policies (used by activationPolicy) that control whether and how an app may be
/// activated.
/// Original: `NSApplicationPolicy`
/// See: https://developer.apple.com/documentation/appkit/nsapplication/activationpolicy-swift.enum
pub const ApplicationActivationPolicy = enum(u32) {
    regular = 0,
    dock = 1,
    prohibited = 2,
};

/// A Manatee Binding Mixin for the Objective-C Runtime's NSApplication class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn ApplicationMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ResponderMixin(Self);
        pub usingnamespace inherited_methods;

        // Methods defined under the NSWindow class's "Getting the Shared App Object" section

        /// Returns the application instance, creating it if it doesn’t exist yet.
        /// Original: `NSApplication.sharedApplication`
        /// See: https://developer.apple.com/documentation/appkit/nsapplication/shared
        pub fn getSharedApplication(class_name: [*:0]const u8) !*Self {
            // I think this function also internally calls alloc so you don't need to do that when
            // getting the shared application? Honestly not sure, the docs are pretty sparse here
            const class = try Class.init(class_name);
            return msgSend(class, *Self, Sel.init("sharedApplication"), .{});
        }

        /// The global variable for the shared app instance.
        /// Original: `NSApplication.NSApp`
        /// See: https://developer.apple.com/documentation/appkit/nsapp
        /// Note: This is effectively the same exact thing as calling `getSharedApplication`, this
        /// is only here for semantics and to capture more complete functionality
        pub fn getNsApp(self: *Self) *Self {
            return msgSend(self, *Self, Sel.init("NSApp"), .{});
        }

        // Methods defined under the NSWindow class's "Managing the App's Behavior" section

        /// Returns the app delegate object.
        /// Original: `NSApplication.delegate`
        /// See: https://developer.apple.com/documentation/appkit/nsapplication/delegate
        pub fn getDelegate(self: *Self) *anyopaque {
            return msgSend(self, *anyopaque, Sel.init("delegate"), .{});
        }

        /// Sets the app delegate object.
        /// Original: `NSApplication.delegate`
        /// See: https://developer.apple.com/documentation/appkit/nsapplication/delegate
        pub fn setDelegate(self: *Self, delegate: anytype) !void {
            // Since everything needs to be an opaque type due to Zig not having inheritance (which
            // is honestly not a bad thing), we'll need to do a little bit of runtime checking here
            // to ensure whatever we're passing in actually implements the NSApplicationDelegate
            // protocol. Luckily for us, we have plenty of methods at our disposal to do this, and
            // to make things even better, code won't even compile if the var passed in isn't an
            // NSObject, as this calls that object's conformsToProtocol method
            const application_delegate_protocol = try Protocol.init("NSApplicationDelegate");
            if (!delegate.conformsToProtocol(application_delegate_protocol)) {
                return error.invalid_delegate_protocol;
            }

            return msgSend(self, void, Sel.init("setDelegate:"), .{delegate});
        }

        // Methods defined under the NSWindow class's "Managing the Event Loop" section

        // TODO: Implement wrapper for nextEventMatchingMask...
        // TODO: Implement wrapper for discardEventsMatchingMask...
        // TODO: Implement wrapper for currentEvent
        // TODO: Implement wrapper for running

        /// Starts the main event loop.
        /// Original: `NSApplication.run()`
        /// See: https://developer.apple.com/documentation/appkit/nsapplication/run()
        pub fn run(self: *Self) void {
            return msgSend(self, void, Sel.init("run"), .{});
        }

        // TODO: Implement wrapper for finishLaunching
        // TODO: Implement wrapper for stop:
        // TODO: Implement wrapper for sendEvent:
        // TODO: Implement wrapper for postEvent:atStart:

        // TODO: Implement NSApplication class's "Posting Actions" section
        // TODO: Implement NSApplication class's "Terminating the App" section

        // Methods defined under the NSWindow class's "Activating and Deactivating the App" section

        /// Activates the receiver app, if appropriate.
        /// Original: `NSApplication.activate`
        /// See: https://developer.apple.com/documentation/appkit/nsapplication/activate()
        pub fn activate(self: *Self) void {
            return msgSend(self, void, Sel.init("activate"), .{});
        }

        // TODO: Implement wrapper for deactivate
        // TODO: Implement wrapper for active
        // TODO: Implement wrapper for yieldActivationToApplication:
        // TODO: Implement wrapper for yieldActivationToApplicationWithBundleIdentifier:

        // TODO: Implement NSApplication class's "Managing Relaunch on Login" section
        // TODO: Implement NSApplication class's "Managing Remote Notifications" section
        // TODO: Implement NSApplication class's "Managing the App's Appearance" section
        // TODO: Implement NSApplication class's "Managing Windows, Panels, and Menus" section
        // TODO: Implement NSApplication class's "User Interface Layout Direction" section
        // TODO: Implement NSApplication class's "Accessing the Dock Tile" section
        // TODO: Implement NSApplication class's "Customizing the Touch Bar" section
        // TODO: Implement NSApplication class's "Managing User Attention Requests" section
        // TODO: Implement NSApplication class's "Providing Help Information" section
        // TODO: Implement NSApplication class's "Providing Services" section
        // TODO: Implement NSApplication class's "Determining Access to the Keyboard" section
        // TODO: Implement NSApplication class's "Hiding Apps" section
        // TODO: Implement NSApplication class's "Managing Threads" section
        // TODO: Implement NSApplication class's "Logging Exceptions" section

        // Methods defined under the NSWindow class's "Configuring the Activation Policy" section

        /// Returns the app’s activation policy.
        /// Original: `NSApplication.activationPolicy`
        /// See: https://developer.apple.com/documentation/appkit/nsapplication/activationpolicy()
        pub fn activationPolicy(self: *Self) ApplicationActivationPolicy {
            return msgSend(self, ApplicationActivationPolicy, Sel.init("activationPolicy"), .{});
        }

        /// Attempts to modify the app’s activation policy.
        /// Original: `NSApplication.setActivationPolicy`
        /// See: https://developer.apple.com/documentation/appkit/nsapplication/setactivationpolicy(_:)
        pub fn setActivationPolicy(self: *Self, activation_policy: ApplicationActivationPolicy) !void {
            if (!msgSend(self, bool, Sel.init("setActivationPolicy:"), .{activation_policy})) {
                return error.activation_policy_failed_to_set;
            }
        }

        // TODO: Implement NSApplication class's "Scripting Your App" section
        // TODO: Implement NSApplication class's "Notifications" section
        // TODO: Implement NSApplication class's "Loading Cocoa Bundles" section
    };
}

/// A Manatee Binding Mixin for the Objective-C Runtime's NSResponder class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn ResponderMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectMixin(Self);
        pub usingnamespace inherited_methods;
    };

    // TODO: Implement NSResponder class's "Changing the First Responder" section
    // TODO: Implement NSResponder class's "Managing the Next Responder" section
    // TODO: Implement NSResponder class's "Responding to Mouse Events" section
    // TODO: Implement NSResponder class's "Responding to Key Events" section
    // TODO: Implement NSResponder class's "Responding to Pressure Changes" section
    // TODO: Implement NSResponder class's "Responding to Other Kinds of Events" section
    // TODO: Implement NSResponder class's "Responding to Action Messages" section
    // TODO: Implement NSResponder class's "Handling Window Restoration" section
    // TODO: Implement NSResponder class's "Supporting User Activities" section
    // TODO: Implement NSResponder class's "Presenting and Customizing Error Information" section
    // TODO: Implement NSResponder class's "Dispatching Messages" section
    // TODO: Implement NSResponder class's "Managing a Responder's Menu" section
    // TODO: Implement NSResponder class's "Updating the Services Menu" section
    // TODO: Implement NSResponder class's "Getting the Undo Manager" section
    // TODO: Implement NSResponder class's "Testing Events" section
    // TODO: Implement NSResponder class's "Terminating the Responder Chain" section
    // TODO: Implement NSResponder class's "Setting the Interface Style" section
    // TODO: Implement NSResponder class's "Touch and Gesture Events" section
    // TODO: Implement NSResponder class's "Supporting the Touch Bar" section
    // TODO: Implement NSResponder class's "Performing Text Find Actions" section
    // TODO: Implement NSResponder class's "Supporting Tabbed Windows" section
    // TODO: Implement NSResponder class's "Creating Responders" section
    // TODO: Implement NSResponder class's "Instance Methods" section
}

/// A Manatee Binding Mixin for the Objective-C Runtime's NSView class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn ViewMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ResponderMixin(Self);
        pub usingnamespace inherited_methods;

        // TODO: Implement NSView class's "Creating a View Object" section

        // Methods defined under the NSView class's "Configuring the View" section

        /// Retrieves the Boolean value indicating whether the view uses a layer as its backing
        /// store.
        /// Original: `NSView.wantsLayer`
        /// See: https://developer.apple.com/documentation/appkit/nsview/wantslayer
        pub fn getWantsLayer(self: *Self) bool {
            return msgSend(self, bool, Sel.init("wantsLayer"), .{});
        }

        /// Sets the Boolean value indicating whether the view uses a layer as its backing
        /// store.
        /// Original: `NSView.wantsLayer`
        /// See: https://developer.apple.com/documentation/appkit/nsview/wantslayer
        pub fn setWantsLayer(self: *Self, wants_layer: bool) void {
            return msgSend(self, void, Sel.init("setWantsLayer:"), .{wants_layer});
        }

        /// Retrieves the Core Animation layer that the view uses as its backing store.
        /// Original: `NSView.layer`
        /// See: https://developer.apple.com/documentation/appkit/nsview/wantslayer
        pub fn getLayer(self: *Self) *anyopaque {
            return msgSend(self, *anyopaque, Sel.init("layer"), .{});
        }

        /// Sets the Core Animation layer that the view uses as its backing store.
        /// Original: `NSView.layer`
        /// See: https://developer.apple.com/documentation/appkit/nsview/wantslayer
        pub fn setLayer(self: *Self, layer: *anyopaque) void {
            return msgSend(self, void, Sel.init("setLayer:"), .{layer});
        }

        // TODO: Implement remaining items in NSView class's "Configuring the View" section

        // TODO: Implement NSView class's "Managing the View's Content" section
        // TODO: Implement NSView class's "Managing Interactions" section
        // TODO: Implement NSView class's "Instance Properties" section
        // TODO: Implement NSView class's "Instance Methods" section
    };
}

/// A Manatee Binding Mixin for the Objective-C Runtime's NSWindow class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn WindowMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ResponderMixin(Self);
        pub usingnamespace inherited_methods;

        // Methods defined under the NSWindow class's "Creating a Window" section

        // TODO: Implement wrapper for windowWithContentViewController:

        /// Initializes the window with the specified values.
        /// Original: `NSWindow.initWithContentRect:styleMask:backing:defer:`
        /// See: https://developer.apple.com/documentation/appkit/nswindow/init(contentrect:stylemask:backing:defer:)
        pub fn initWithContentRectStyleMaskBackingDefer(self: *Self, content_rect: Rect, style_mask: WindowStyleMask, backing_store_type: BackingStoreType, flag: bool) *Self {
            return msgSend(self, *Self, Sel.init("initWithContentRect:styleMask:backing:defer:"), .{ content_rect, style_mask, backing_store_type, flag });
        }

        // TODO: Implement wrapper for initWithContentRect:styleMask:backing:defer:screen:

        // TODO: Implement NSWindow class's "Managing a Window's Behavior" section

        // Methods defined under the NSWindow class's "Configuring the Window's Content" section

        /// Retrieves the window’s content view, the highest accessible view object in the window’s
        /// view hierarchy.
        /// Original: `NSWindow.contentView`
        /// See: https://developer.apple.com/documentation/appkit/nswindow/contentview
        pub fn getContentView(self: *Self) *anyopaque {
            return msgSend(self, *anyopaque, Sel.init("contentView"), .{});
        }

        /// Sets the window’s content view, the highest accessible view object in the window’s view
        /// hierarchy.
        /// Original: `NSWindow.contentView`
        /// See: https://developer.apple.com/documentation/appkit/nswindow/contentview
        pub fn setWantsLayer(self: *Self, content_view: *anyopaque) void {
            return msgSend(self, bool, Sel.init("setContentView:"), .{content_view});
        }

        // TODO: Implement NSWindow class's "Configuring the Window's Appearance" section
        // TODO: Implement NSWindow class's "Accessing Window Information" section
        // TODO: Implement NSWindow class's "Getting Layout Information" section
        // TODO: Implement NSWindow class's "Managing Windows" section
        // TODO: Implement NSWindow class's "Managing Sheets" section
        // TODO: Implement NSWindow class's "Creating a Window" section
        // TODO: Implement NSWindow class's "Sizing Windows" section
        // TODO: Implement NSWindow class's "Sizing Content" section
        // TODO: Implement NSWindow class's "Managing Window Layers" section
        // TODO: Implement NSWindow class's "Managing Window Visibility and Occlusion State"
        // section
        // TODO: Implement NSWindow class's "Managing Window Frames in User Defaults" section

        // Methods defined under the NSWindow class's "Managing Key Status" section

        // TODO: Implement wrapper for keyWindow
        // TODO: Implement wrapper for canBecomeKeyWindow
        // TODO: Implement wrapper for makeKeyWindow

        pub fn makeKeyAndOrderFront(self: *Self) void {
            return msgSend(self, void, Sel.init("makeKeyAndOrderFront:"), .{});
        }

        // TODO: Implement wrapper for becomeKeyWindow
        // TODO: Implement wrapper for resignKeyWindow

        // TODO: Implement NSWindow class's "Managing Main Status" section
        // TODO: Implement NSWindow class's "Managing Toolbars" section
        // TODO: Implement NSWindow class's "Managing Attached Windows" section
        // TODO: Implement NSWindow class's "Managing Default Buttons" section
        // TODO: Implement NSWindow class's "Managing Field Editors" section
        // TODO: Implement NSWindow class's "Managing the Window Menu" section
        // TODO: Implement NSWindow class's "Managing Cursor Rectangles" section
        // TODO: Implement NSWindow class's "Managing Title Bars" section
        // TODO: Implement NSWindow class's "Managing Title Bar Accessories" section
        // TODO: Implement NSWindow class's "Managing Window Tabs" section
        // TODO: Implement NSWindow class's "Managing Tooltips" section
        // TODO: Implement NSWindow class's "Handling Events" section
        // TODO: Implement NSWindow class's "Managing Responders" section
        // TODO: Implement NSWindow class's "Managing the Key View Loop" section
        // TODO: Implement NSWindow class's "Managing Window Sharing" section
        // TODO: Implement NSWindow class's "Handling Mouse Events" section
        // TODO: Implement NSWindow class's "Handling Window Restoration" section
        // TODO: Implement NSWindow class's "Drawing Windows" section
        // TODO: Implement NSWindow class's "Window Animation" section
        // TODO: Implement NSWindow class's "Updating Windows" section
        // TODO: Implement NSWindow class's "Dragging Items" section
        // TODO: Implement NSWindow class's "Accessing Edited Status" section
        // TODO: Implement NSWindow class's "Converting Coordinates" section
        // TODO: Implement NSWindow class's "Managing Titles" section
        // TODO: Implement NSWindow class's "Accessing Screen Information" section
        // TODO: Implement NSWindow class's "Moving Windows" section
        // TODO: Implement NSWindow class's "Closing Windows" section
        // TODO: Implement NSWindow class's "Minimizing Windows" section
        // TODO: Implement NSWindow class's "Getting the Dock Tile" section
        // TODO: Implement NSWindow class's "Printing Windows" section
        // TODO: Implement NSWindow class's "Providing Services" section
        // TODO: Implement NSWindow class's "Trigger Constraint-Based Layout" section
        // TODO: Implement NSWindow class's "Debugging Constraint-Based Layout" section
        // TODO: Implement NSWindow class's "Constraint-Based Layouts" section
        // TODO: Implement NSWindow class's "Working with Window Depths" section
        // TODO: Implement NSWindow class's "Getting Information About Scripting Attributes"
        // section
        // TODO: Implement NSWindow class's "Setting Scripting Attributes" section
        // TODO: Implement NSWindow class's "Handling Script Commands" section
    };
}

/// Constants that specify the style of a window, conveniently rewritten into a Zig packed struct.
/// Original: `NSWindowStyleMask`
/// See: https://developer.apple.com/documentation/appkit/nswindow/stylemask-swift.struct
pub const WindowStyleMask = packed struct(u32) {
    const Self = @This();

    // _reserved_bit_0: u1 = 0,
    titled_enabled: bool = false,
    closable_enabled: bool = false,
    miniaturizable_enabled: bool = false,
    resizable_enabled: bool = false,
    utility_window_enabled: bool = false,
    _reserved_bit_6: u1 = 0,
    modal_window_enabled: bool = false,
    nonactivating_panel_enabled: bool = false,
    textured_background_enabled: bool = false,
    _reserved_bit_10: u1 = 0,
    _reserved_bit_11: u1 = 0,
    _reserved_bit_12: u1 = 0,
    unified_title_and_toolbar_enabled: bool = false,
    hud_window_enabled: bool = false,
    full_screen_enabled: bool = false,
    full_size_content_view_enabled: bool = false,
    _reserved_bit_17: u1 = 0,
    _reserved_bit_18: u1 = 0,
    _reserved_bit_19: u1 = 0,
    _reserved_bit_20: u1 = 0,
    _reserved_bit_21: u1 = 0,
    _reserved_bit_22: u1 = 0,
    _reserved_bit_23: u1 = 0,
    _reserved_bit_24: u1 = 0,
    _reserved_bit_25: u1 = 0,
    _reserved_bit_26: u1 = 0,
    _reserved_bit_27: u1 = 0,
    _reserved_bit_28: u1 = 0,
    _reserved_bit_29: u1 = 0,
    _reserved_bit_30: u1 = 0,
    _reserved_bit_31: u1 = 0,
    _reserved_bit_32: u1 = 0,

    /// The window displays none of the usual peripheral elements.
    pub const borderless = Self{};
    /// The window displays a title bar.
    pub const titled = Self{ .titled_enabled = true };
    /// The window displays a close button.
    pub const closable = Self{ .closable_enabled = true };
    /// The window displays a minimize button.
    pub const miniaturizable = Self{ .miniaturizable_enabled = true };
    /// The window can be resized by the user.
    pub const resizable = Self{ .resizable_enabled = true };
    /// DEPRECATED: The window uses a textured background that darkens when the window is key or
    /// main and lightens when it is inactive, and may have a second gradient in the section below
    /// the window content.
    pub const textured_background = Self{ .textured_background_enabled = true };
    /// This constant has no effect, because all windows that include a toolbar use the unified
    /// style.
    pub const unified_title_and_toolbar = Self{ .unified_title_and_toolbar_enabled = true };
    /// The window can appear full screen.
    pub const full_screen = Self{ .full_screen_enabled = true };
    /// When set, the window’s contentView consumes the full size of the window.
    pub const full_size_content_view = Self{ .full_size_content_view_enabled = true };
    /// The window is a panel or a subclass of NSPanel.
    pub const utility_window = Self{ .utility_window_enabled = true };
    /// The window is a document-modal panel (or a subclass of NSPanel).
    pub const doc_modal_window = Self{ .modal_window_enabled = true };
    /// The window is a panel or a subclass of NSPanel that does not activate the owning app.
    pub const nonactivating_panel = Self{ .nonactivating_panel_enabled = true };
    /// The window is a HUD panel.
    pub const hud_window = Self{ .hud_window_enabled = true };
};
