const foundation = @import("../foundation.zig");
const objective_c = @import("../objective_c.zig");

const Notification = foundation.Notification;
const String = foundation.String;
const ObjectProtocolMixin = objective_c.object.ObjectProtocolMixin;
const Protocol = objective_c.Protocol;
const Sel = objective_c.Sel;

/// A set of methods that manage your app’s life cycle and its interaction with common system services.
/// Original: `NSApplicationDelegate`
/// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate
/// Note: The Objective-C runtime only registers protocols if they're directly imported by an
/// Objective-C file. Given that this is Zig, and we can't do that, we have to get a little bit
/// creative here and create a stub definition of the protocol, which is exactly what this is. I
/// hope that in the future we'll find a better way around this limitation, as this is painful and
/// incredibly unsustainable.
pub const ApplicationDelegateProtocol = opaque {
    const Self = @This();

    pub fn init() !*Protocol {
        const maybe_protocol = Protocol
            .getProtocol("NSApplicationDelegate");

        if (maybe_protocol != null) {
            return maybe_protocol.?;
        }

        const allocated_protocol = Protocol.allocateProtocol("NSApplicationDelegate");

        if (allocated_protocol == null) {
            return error.unable_to_allocate_protocol;
        }

        const self = allocated_protocol.?;

        // Launching Applications
        self.addMethodDescription(Sel.init("applicationWillFinishLaunching:"), "v@:@", true, true);
        self.addMethodDescription(Sel.init("applicationDidFinishLaunching:"), "v@:@", false, true);

        // Managing Active Status
        self.addMethodDescription(Sel.init("applicationWillBecomeActive:"), "v@:@", false, true);
        self.addMethodDescription(Sel.init("applicationDidBecomeActive:"), "v@:@", false, true);
        self.addMethodDescription(Sel.init("applicationWillResignActive:"), "v@:@", false, true);
        self.addMethodDescription(Sel.init("applicationDidResignActive:"), "v@:@", false, true);

        // Terminating Applications
        self.addMethodDescription(Sel.init("applicationShouldTerminate:"), "v@:@", false, true);
        self.addMethodDescription(Sel.init("applicationShouldTerminateAfterLastWindowClosed:"), "v@:@", true, true);
        self.addMethodDescription(Sel.init("applicationWillTerminate:"), "v@:@", false, true);

        // Hiding Applications
        self.addMethodDescription(Sel.init("applicationWillHide:"), "v@:@", true, true);
        self.addMethodDescription(Sel.init("applicationDidHide:"), "v@:@", false, true);
        self.addMethodDescription(Sel.init("applicationWillUnhide:"), "v@:@", true, true);
        self.addMethodDescription(Sel.init("applicationDidUnhide:"), "v@:@", false, true);

        // Managing Windows
        self.addMethodDescription(Sel.init("applicationWillUpdate:"), "v@:@", true, true);
        self.addMethodDescription(Sel.init("applicationDidUpdate:"), "v@:@", false, true);
        self.addMethodDescription(Sel.init("applicationShouldHandleReopen:hasVisibleWindows:"), "b@:@b", false, true);

        // Managing the Dock Menu
        self.addMethodDescription(Sel.init("applicationDockMenu:"), "v@:@", true, true);

        // Localizing Keyboard Shortcuts
        self.addMethodDescription(Sel.init("applicationShouldAutomaticallyLocalizeKeyEquivalents:"), "b@:@", true, true);

        // Displaying Errors
        self.addMethodDescription(Sel.init("application:willPresentError:"), "@@:@@", true, true);

        // Managing the Screen
        self.addMethodDescription(Sel.init("applicationDidChangeScreenParameters:"), "v@:@", false, true);

        // Continuing User Activities
        self.addMethodDescription(Sel.init("application:willContinueUserActivityWithType:"), "v@:@@", false, true);
        self.addMethodDescription(Sel.init("application:continueUserActivity:restorationHandler:"), "b@:@@@", true, true);
        self.addMethodDescription(Sel.init("application:didFailToContinueUserActivityWithType:error:"), "v@:@@@", false, true);
        self.addMethodDescription(Sel.init("applicationDidChangeScreenParameters:"), "v@:@@", false, true);

        // Handling Push Notifications
        self.addMethodDescription(Sel.init("application:didRegisterForRemoteNotificationsWithDeviceToken:"), "v@:@@", true, true);
        self.addMethodDescription(Sel.init("application:didFailToRegisterForRemoteNotificationsWithError:"), "v@:@@", true, true);
        self.addMethodDescription(Sel.init("application:didReceiveRemoteNotification:"), "v@:@@", true, true);

        // Handling CloudKit Invitations
        self.addMethodDescription(Sel.init("application:userDidAcceptCloudKitShareWithMetadata:"), "v@:@@", true, true);

        // Handling SiriKit Intents
        self.addMethodDescription(Sel.init("application:handlerForIntent:"), "v@:@@", true, true);

        // Opening Files
        self.addMethodDescription(Sel.init("application:openURLs:"), "v@:@@", true, true);
        self.addMethodDescription(Sel.init("application:openFile:"), "b@:@@", true, true);
        self.addMethodDescription(Sel.init("application:openFileWithoutUI:"), "b@:@@", false, true);
        self.addMethodDescription(Sel.init("application:openTempFile:"), "b@:@@", false, true);
        self.addMethodDescription(Sel.init("application:openFiles:"), "v@:@@", false, true);
        self.addMethodDescription(Sel.init("applicationShouldOpenUntitledFile:"), "b@:@@", false, true);
        self.addMethodDescription(Sel.init("applicationOpenUntitledFile:"), "b@:@@", true, true);

        // Printing
        self.addMethodDescription(Sel.init("application:printFile:"), "b@:@@", false, true);
        self.addMethodDescription(Sel.init("application:printFiles:withSettings:showPrintPanels:"), "@@:@@@b", false, true);

        // Restoring Application State
        self.addMethodDescription(Sel.init("applicationSupportsSecureRestorableState:"), "b@:@", false, true);
        self.addMethodDescription(Sel.init("applicationProtectedDataDidBecomeAvailable:"), "v@:@", false, true);
        self.addMethodDescription(Sel.init("applicationProtectedDataWillBecomeUnavailable:"), "v@:@", true, true);
        self.addMethodDescription(Sel.init("application:willEncodeRestorableState:"), "v@:@@", false, true);
        self.addMethodDescription(Sel.init("application:didDecodeRestorableState:"), "v@:@@", false, true);

        // Handling Changes to the Occlusion State
        self.addMethodDescription(Sel.init("applicationDidChangeOcclusionState:"), "v@:@", true, true);

        // Scripting Your App
        self.addMethodDescription(Sel.init("application:delegateHandlesKey:"), "v@:@@", false, true);

        self.registerProtocol();

        return self;
    }
};

/// Constants that determine whether an app should terminate.
/// Original: `NSApplicationTerminateReply`
/// See: https://developer.apple.com/documentation/appkit/nsapplication/terminatereply
pub const ApplicationTerminateReply = enum(u64) {
    /// The app should not be terminated.
    cancel = 0,
    /// It is OK to proceed with termination.
    now = 1,
    /// It may be OK to proceed with termination later.
    later = 2,
};

/// A Manatee Binding Mixin for AppKit's NSApplicationDelegate protocol and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
/// TODO: This currently only implements methods marked as "required" in the NSApplicationDelegate
/// protocol. The others should eventually be implemented as well. These methods are implemented in
/// this mixin due to Objective-C not including the NSApplicationDelegate protocol at runtime, so
/// when we use it, we need to manually re-create it and its required methods in order for apps to
/// work properly.
pub fn ApplicationDelegateProtocolMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectProtocolMixin(Self);
        pub usingnamespace inherited_methods;

        // Methods defined under the NSApplicationDelegate protocol's "Launching Applications"
        // section

        /// Tells the delegate that the app’s initialization is about to complete.
        /// Original: `@protocol NSApplicationDelegate.applicationWillFinishLaunching:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationwillfinishlaunching(_:)
        pub fn applicationWillFinishLaunching(_: *Self, _: *Sel, _: *Notification) void {}

        // Methods defined under the NSApplicationDelegate protocol's "Managing Active Status"
        // section

        // TODO: Implement wrapper for applicationWillBecomeActive:
        // TODO: Implement wrapper for applicationDidBecomeActive:
        // TODO: Implement wrapper for applicationWillResignActive:
        // TODO: Implement wrapper for applicationDidResignActive:

        // Methods defined under the NSApplicationDelegate protocol's "Terminating Applications"
        // section

        // TODO: Implement wrapper for applicationShouldTerminate:

        /// Returns a Boolean value that indicates if the app terminates once the last window closes.
        /// Original: `@protocol NSApplicationDelegate.applicationShouldTerminateAfterLastWindowClosed:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationshouldterminateafterlastwindowclosed(_:)
        pub fn applicationShouldTerminateAfterLastWindowClosed(_: *Self, _: *Sel, _: *anyopaque) bool {
            return false;
        }

        // TODO: Implement wrapper for applicationWillTerminate:

        // Methods defined under the NSApplicationDelegate protocol's "Hiding Applications" section

        /// Tells the delegate that the app is about to be hidden.
        /// Original: `@protocol NSApplicationDelegate.applicationWillHide:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationwillhide(_:)
        pub fn applicationWillHide(_: *Self, _: *Sel, _: *Notification) void {}

        // TODO: Implement wrapper for applicationDidHide:

        /// Tells the delegate that the app is about to become visible.
        /// Original: `@protocol NSApplicationDelegate.applicationWillUnhide:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationwillhide(_:)
        pub fn applicationWillUnhide(_: *Self, _: *Sel, _: *Notification) void {}

        // TODO: Implement wrapper for applicationDidUnhide:

        // Methods defined under the NSApplicationDelegate protocol's "Managing Windows" section

        /// Tells the delegate that the app is about to update its windows.
        /// Original: `@protocol NSApplicationDelegate.applicationWillUpdate:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationwillupdate(_:)
        pub fn applicationWillUpdate(_: *Self, _: *Sel, _: *Notification) void {}

        // TODO: Implement wrapper for applicationDidUpdate:
        // TODO: Implement wrapper for applicationShouldHandleReopen:hasVisibleWindows:

        // Methods defined under the NSApplicationDelegate protocol's "Managing the Dock Menu"
        // section

        /// Returns the app’s dock menu.
        /// Original: `@protocol NSApplicationDelegate.applicationDockMenu:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationdockmenu(_:)
        /// Note: This is probably not implemented correctly lol
        pub fn applicationDockMenu(_: *Self, _: *Sel, _: *anyopaque) ?*anyopaque {
            return null;
        }

        // Methods defined under the NSApplicationDelegate protocol's Localizing Keyboard
        // Shortcuts" section

        /// Returns a Boolean value that tells the system whether to remap menu shortcuts to
        /// support localized keyboards.
        /// Original: `@protocol NSApplicationDelegate.applicationShouldAutomaticallyLocalizeKeyEquivalents:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationshouldautomaticallylocalizekeyequivalents(_:)
        pub fn applicationShouldAutomaticallyLocalizeKeyEquivalents(_: *Self, _: *Sel, _: *anyopaque) bool {
            return true;
        }

        // Methods defined under the NSApplicationDelegate protocol's "Displaying Errors" section

        /// Returns an error for the app to display to the user.
        /// Original: `@protocol NSApplicationDelegate.application:willPresentError:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/application(_:willpresenterror:)
        pub fn applicationWillPresentError(_: *Self, _: *Sel, _: *anyopaque, ns_error: *anyopaque) *anyopaque {
            return ns_error;
        }

        // Methods defined under the NSApplicationDelegate protocol's "Managing the Screen" section

        // TODO: Implement wrapper for applicationDidChangeScreenParameters:

        // Methods defined under the NSApplicationDelegate protocol's "Continuing User Activities"
        // section

        // TODO: Implement wrapper for application:willContinueUserActivityWithType:

        /// Returns a Boolean value that indicates if the app successfully recreates the specified activity.
        /// Original: `@protocol NSApplicationDelegate.application:continueUserActivity:restorationHandler:`
        pub fn applicationContinueUserActivityRestorationHandler(_: *Self, _: *Sel, _: *anyopaque, _: *anyopaque, _: *anyopaque) bool {
            return false;
        }

        // TODO: Implement wrapper for application:didFailToContinueUserActivityWithType:error:
        // TODO: Implement wrapper for application:didUpdateUserActivity:

        // Methods defined under the NSApplicationDelegate protocol's "Handling Push Notifications"
        // section

        /// Tells the delegate that the app registered for Apple Push Services.
        /// Original: `@protocol NSApplicationDelegate.application:didRegisterForRemoteNotificationsWithDeviceToken:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/application(_:didregisterforremotenotificationswithdevicetoken:)
        pub fn applicationDidRegisterForRemoteNotificationsWithDeviceToken(_: *Self, _: *Sel, _: *anyopaque, _: *anyopaque) void {}

        /// Tells the delegate that the app was unable to register for Apple Push Services.
        /// Original: `@protocol NSApplicationDelegate.application:didFailToRegisterForRemoteNotificationsWithError:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/application(_:didfailtoregisterforremotenotificationswitherror:)
        pub fn applicationDidFailToRegisterForRemoteNotificationsWithError(_: *Self, _: *Sel, _: *anyopaque, _: *anyopaque) void {}

        /// Tells the delegate when the app receives a remote notification.
        /// Original: `@protocol NSApplicationDelegate.application:didReceiveRemoteNotification:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/application(_:didreceiveremotenotification:)
        pub fn applicationDidReceiveRemoteNotification(_: *Self, _: *Sel, _: *anyopaque, _: *anyopaque) void {}

        // Methods defined under the NSApplicationDelegate protocol's "Handling CloudKit
        // Invitations" section

        /// Tells the delegate when the user accepts a CloudKit sharing invitation.
        /// Original: `@protocol NSApplicationDelegate.application:userDidAcceptCloudKitShareWithMetadata:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/application(_:userdidacceptcloudkitsharewith:)
        pub fn applicationUserDidAcceptCloudKitShareWithMetadata(_: *Self, _: *Sel, _: *Notification) void {}

        // Methods defined under the NSApplicationDelegate protocol's "Handling SiriKit Intents"
        // section

        /// Returns an intent handler that’s capable of handling the specified intent.
        /// Original: `@protocol NSApplicationDelegate.application:application:handlerForIntent:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/application(_:handlerfor:)
        pub fn applicationHandlerForIntent(_: *Self, _: *Sel, _: *anyopaque, _: *anyopaque) ?*anyopaque {
            return null;
        }

        // Methods defined under the NSApplicationDelegate protocol's "Opening Files" section

        /// Tells the delegate to open the resource at the specified URL.
        /// Original: `@protocol NSApplicationDelegate.application:openURLs:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/application(_:open:)
        pub fn applicationOpenURLs(_: *Self, _: *Sel, _: *anyopaque, _: *anyopaque) void {}

        /// Returns a Boolean value that indicates if the app opens the specified file.
        /// Original: `@protocol NSApplicationDelegate.application:openFile:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/application(_:openfile:)
        pub fn applicationOpenFile(_: *Self, _: *Sel, _: *anyopaque, _: *String) bool {
            // I'll leave the implementation of "did the file open correctly" to whoever is making
            // a delegate, and return false here
            return false;
        }

        // TODO: Implement wrapper for application:openFileWithoutUI:

        // TODO: Implement wrapper for application:openTempFile:

        // TODO: Implement wrapper for application:openFiles:

        // TODO: Implement wrapper for applicationShouldOpenUntitledFile:

        /// Returns a Boolean value that indicates if the app opens an untitled file.
        /// Original: `@protocol NSApplicationDelegate.applicationOpenUntitledFile:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationopenuntitledfile(_:)
        pub fn applicationOpenUntitledFile(_: *Self, _: *Sel, _: *anyopaque) bool {
            // I'll leave the implementation of "should this open untitled files" to whoever is
            // making a delegate, and return false here
            return false;
        }

        // Methods defined under the NSApplicationDelegate protocol's "Printing" section

        // TODO: Implement wrapper for application:printFile:

        // TODO: Implement wrapper for application:printFiles:withSettings:showPrintPanels:

        // Methods defined under the NSApplicationDelegate protocol's "Restoring Application State"
        // section

        // TODO: Implement wrapper for applicationSupportsSecureRestorableState:

        // TODO: Implement wrapper for applicationProtectedDataDidBecomeAvailable:

        /// Tells the delegate that protected data is about to become unavailable.
        /// Original: `@protocol NSApplicationDelegate.applicationProtectedDataWillBecomeUnavailable:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationprotecteddatawillbecomeunavailable(_:)
        pub fn applicationProtectedDataWillBecomeUnavailable(_: *Self, _: *Sel, _: *anyopaque) void {}

        // TODO: Implement wrapper for application:willEncodeRestorableState:

        // TODO: Implement wrapper for application:didDecodeRestorableState:

        // Methods defined under the NSApplicationDelegate protocol's "Handling Changes to the
        // Occlusion State" section

        /// Tells the delegate about changes to the app’s occlusion state.
        /// Original: `@protocol NSApplicationDelegate.applicationDidChangeOcclusionState:`
        /// See: https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationdidchangeocclusionstate(_:)
        pub fn applicationDidChangeOcclusionState(_: *Self, _: *Sel, _: *Notification) bool {
            return false;
        }

        // Methods defined under the NSApplicationDelegate protocol's "Scripting Your App" section

        // TODO: Implement wrapper for application:delegateHandlesKey:
    };
}
