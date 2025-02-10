const objective_c = @import("../objective_c.zig");

const Rect = @import("../core_graphics.zig").Rect;
const String = @import("../foundation.zig").String;
const ResponderMixin = @import("responder.zig").ResponderMixin;

const Class = objective_c.Class;
const Sel = objective_c.Sel;
const msgSend = objective_c.msgSend;

/// A window that an app displays on the screen.
/// Original: `NSWindow`
/// See: https://developer.apple.com/documentation/appkit/nswindow
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
        return self.release();
    }
};

/// Constants that specify how the window device buffers the drawing done in a window.
/// Original: `NSBackingStoreType`
/// See: https://developer.apple.com/documentation/appkit/nswindow/backingstoretype
pub const BackingStoreType = enum(u64) {
    /// DEPRECATED: The window uses a buffer, but draws directly to the screen where possible and
    /// to the buffer for obscured portions.
    retained = 0,
    /// DEPRECATED: The window draws directly to the screen without using any buffer.
    nonretained = 1,
    /// The window renders all drawing into a display buffer and then flushes it to the screen.
    buffered = 2,
};

/// A Manatee Binding Mixin for AppKit's NSWindow class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn WindowMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ResponderMixin(Self);
        pub usingnamespace inherited_methods;

        /// Initializes the window with the specified values.
        /// Original: `NSWindow.initWithContentRect:styleMask:backing:defer:`
        /// See: https://developer.apple.com/documentation/appkit/nswindow/init(contentrect:stylemask:backing:defer:)
        pub fn initWithContentRectStyleMaskBackingDefer(self: *Self, content_rect: Rect, style_mask: WindowStyleMask, backing_store_type: BackingStoreType, flag: bool) *Self {
            return msgSend(self, *Self, Sel.init("initWithContentRect:styleMask:backing:defer:"), .{ content_rect, style_mask, backing_store_type, flag });
        }

        /// Moves the window to the front of the screen list, within its level, and makes it the
        /// key window; that is, it shows the window.
        /// Original: `NSWindow.makeKeyAndOrderFront:`
        /// See: https://developer.apple.com/documentation/appkit/nswindow/makekeyandorderfront(_:)
        pub fn makeKeyAndOrderFront(self: *Self, sender: *anyopaque) void {
            return msgSend(self, void, Sel.init("makeKeyAndOrderFront:"), .{sender});
        }

        /// Sets a Boolean value that indicates whether the window accepts mouse-moved events.
        /// Original: `NSWindow.acceptsMouseMovedEvents`
        /// See: https://developer.apple.com/documentation/appkit/nswindow/acceptsmousemovedevents
        pub fn setAcceptsMouseMovedEvents(self: *Self, accepts_mouse_moved_events: bool) void {
            return msgSend(self, void, Sel.init("setAcceptsMouseMovedEvents:"), .{accepts_mouse_moved_events});
        }

        /// Sets a Boolean value that indicates whether the window is released when it receives the
        /// close message.
        /// Original: `NSWindow.releasedWhenClosed`
        /// See: https://developer.apple.com/documentation/appkit/nswindow/isreleasedwhenclosed
        pub fn setReleasedWhenClosed(self: *Self, released_when_closed: bool) void {
            return msgSend(self, void, Sel.init("setReleasedWhenClosed:"), .{released_when_closed});
        }

        pub fn setTitle(self: *Self, title: [*:0]const u8) !void {
            const title_string = try String.init(title);
            defer title_string.deinit();
            return msgSend(self, void, Sel.init("setTitle:"), .{title_string});
        }
    };
}

/// Constants that specify the style of a window, conveniently rewritten into a Zig packed struct.
/// Original: `NSWindowStyleMask`
/// See: https://developer.apple.com/documentation/appkit/nswindow/stylemask-swift.struct
pub const WindowStyleMask = packed struct(u64) {
    const Self = @This();

    titled_enabled: bool = false,
    closable_enabled: bool = false,
    miniaturizable_enabled: bool = false,
    resizable_enabled: bool = false,
    utility_window_enabled: bool = false,
    _reserved_bit_5: u1 = 0,
    modal_window_enabled: bool = false,
    nonactivating_panel_enabled: bool = false,
    textured_background_enabled: bool = false,
    _reserved_bit_9: u1 = 0,
    _reserved_bit_10: u1 = 0,
    _reserved_bit_11: u1 = 0,
    unified_title_and_toolbar_enabled: bool = false,
    hud_window_enabled: bool = false,
    full_screen_enabled: bool = false,
    full_size_content_view_enabled: bool = false,
    _reserved_bit_16: u1 = 0,
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
    _reserved_bit_33: u1 = 0,
    _reserved_bit_34: u1 = 0,
    _reserved_bit_35: u1 = 0,
    _reserved_bit_36: u1 = 0,
    _reserved_bit_37: u1 = 0,
    _reserved_bit_38: u1 = 0,
    _reserved_bit_39: u1 = 0,
    _reserved_bit_40: u1 = 0,
    _reserved_bit_41: u1 = 0,
    _reserved_bit_42: u1 = 0,
    _reserved_bit_43: u1 = 0,
    _reserved_bit_44: u1 = 0,
    _reserved_bit_45: u1 = 0,
    _reserved_bit_46: u1 = 0,
    _reserved_bit_47: u1 = 0,
    _reserved_bit_48: u1 = 0,
    _reserved_bit_49: u1 = 0,
    _reserved_bit_50: u1 = 0,
    _reserved_bit_51: u1 = 0,
    _reserved_bit_52: u1 = 0,
    _reserved_bit_53: u1 = 0,
    _reserved_bit_54: u1 = 0,
    _reserved_bit_55: u1 = 0,
    _reserved_bit_56: u1 = 0,
    _reserved_bit_57: u1 = 0,
    _reserved_bit_58: u1 = 0,
    _reserved_bit_59: u1 = 0,
    _reserved_bit_60: u1 = 0,
    _reserved_bit_61: u1 = 0,
    _reserved_bit_62: u1 = 0,
    _reserved_bit_63: u1 = 0,

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
