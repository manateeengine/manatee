const objective_c = @import("../objective_c.zig");

const foundation = @import("../foundation.zig");

const Event = @import("event.zig").Event;
const ResponderMixin = @import("responder.zig").ResponderMixin;

const Date = foundation.Date;
const String = foundation.String;
const Class = objective_c.Class;
const Sel = objective_c.Sel;
const Protocol = objective_c.Protocol;
const msgSend = objective_c.msgSend;

/// An object that manages an app’s main event loop and resources used by all of that app’s
/// objects.
///
/// * Original: `HBRUSH``NSApplication`
/// * See: https://developer.apple.com/documentation/appkit/nsapplication
pub const Application = opaque {
    const Self = @This();
    pub usingnamespace ApplicationMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() !*Self {
        return try Self.getSharedApplication("NSApplication");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.release();
    }
};

/// Activation policies (used by activationPolicy) that control whether and how an app may be
/// activated.
///
/// * Original: `HBRUSH``NSApplicationActivationPolicy`
/// * See: https://developer.apple.com/documentation/appkit/nsapplication/activationpolicy-swift.enum
pub const ApplicationActivationPolicy = enum(u32) {
    /// The application is an ordinary app that appears in the Dock and may have a user interface.
    regular = 0,
    /// The application doesn’t appear in the Dock and doesn’t have a menu bar, but it may be
    /// activated programmatically or by clicking on one of its windows.
    accessory = 1,
    /// The application doesn’t appear in the Dock and may not create windows or be activated.
    prohibited = 2,
};

/// A Manatee Binding Mixin for the Objective-C Runtime's NSApplication class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn ApplicationMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ResponderMixin(Self);
        pub usingnamespace inherited_methods;

        /// Makes the receiver the active app.
        ///
        /// * Original: `HBRUSH``NSApplication.activateIgnoringOtherApps:`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/activate(ignoringotherapps:)
        /// DEPRECATED: Use NSApplication method `activate` instead.
        pub fn activateIgnoringOtherApps(self: *Self, ignore_other_apps: bool) void {
            return msgSend(self, void, Sel.init("activateIgnoringOtherApps:"), .{ignore_other_apps});
        }

        /// Activates the app, opens any files specified by the `Open` user default, and
        /// unhighlights the app’s icon.
        ///
        /// * Original: `HBRUSH``NSApplication.finishLaunching`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/finishlaunching()
        pub fn finishLaunching(self: *Self) void {
            return msgSend(self, void, Sel.init("finishLaunching"), .{});
        }

        /// Returns the application instance, creating it if it doesn’t exist yet.
        ///
        /// * Original: `HBRUSH``NSApplication.sharedApplication`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/shared
        pub fn getSharedApplication(class_name: [*:0]const u8) !*Self {
            const class = try Class.init(class_name);
            return msgSend(class, *Self, Sel.init("sharedApplication"), .{});
        }

        /// Returns the next event matching a given mask, or nil if no such event is found before a specified expiration date.
        ///
        /// * Original: `HBRUSH``NSApplication.nextEventMatchingMask:untilDate:inMode:dequeue:`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/nextevent(matching:until:inmode:dequeue:)
        pub fn nextEventMatchingMaskUntilDateInModeDequeue(self: *Self, mask: u64, expiration: ?*Date, mode: [*:0]const u8, dequeue_flag: bool) !?*Event {
            const mode_string = try String.init(mode);
            defer mode_string.deinit();
            return msgSend(self, ?*Event, Sel.init("nextEventMatchingMask:untilDate:inMode:dequeue:"), .{ mask, expiration, mode_string, dequeue_flag });
        }

        /// Starts the main event loop.
        ///
        /// * Original: `HBRUSH``NSApplication.run`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/run()
        pub fn run(self: *Self) void {
            return msgSend(self, void, Sel.init("run"), .{});
        }

        /// Dispatches an event to other objects.
        ///
        /// * Original: `HBRUSH``NSApplication.sendEvent:`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/sendevent(_:)
        pub fn sendEvent(self: *Self, event: *anyopaque) void {
            return msgSend(self, void, Sel.init("sendEvent:"), .{event});
        }

        /// Attempts to modify the app’s activation policy.
        ///
        /// * Original: `HBRUSH``NSApplication.setActivationPolicy:`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/setactivationpolicy(_:)
        pub fn setActivationPolicy(self: *Self, activation_policy: ApplicationActivationPolicy) !void {
            if (!msgSend(self, bool, Sel.init("setActivationPolicy:"), .{activation_policy})) {
                return error.set_activation_policy_failed;
            }
        }

        /// Sets the application's delegate.
        ///
        /// * Original: `HBRUSH``NSApplication.delegate`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/delegate
        pub fn setDelegate(self: *Self, delegate: anytype) !void {
            const delegate_protocol = try Protocol.init("NSApplicationDelegate");
            if (!delegate.conformsToProtocol(delegate_protocol)) {
                return error.invalid_delegate_protocol;
            }

            return msgSend(self, void, Sel.init("setDelegate:"), .{delegate});
        }

        /// Sets the app’s main menu bar.
        ///
        /// * Original: `HBRUSH``NSApplication.mainMenu`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/mainmenu
        pub fn setMainMenu(self: *Self, main_menu: *anyopaque) void {
            return msgSend(self, void, Sel.init("setMainMenu:"), .{main_menu});
        }

        /// Stops the main event loop.
        ///
        /// * Original: `HBRUSH``NSApplication.stop:`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/stop(_:)
        pub fn stop(self: *Self, sender: ?*anyopaque) void {
            return msgSend(self, void, Sel.init("stop:"), .{sender});
        }

        /// Sends an `update` message to each onscreen window.
        ///
        /// * Original: `HBRUSH``NSApplication.updateWindows`
        /// * See: https://developer.apple.com/documentation/appkit/nsapplication/updatewindows()?changes=_9
        pub fn updateWindows(self: *Self) void {
            return msgSend(self, void, Sel.init("updateWindows"), .{});
        }
    };
}
