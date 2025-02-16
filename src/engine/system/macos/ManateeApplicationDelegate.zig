const std = @import("std");

const apple = @import("../../bindings/apple.zig");

const Self = @This();
pub usingnamespace apple.objective_c.object.ObjectMixin(Self);
pub usingnamespace apple.app_kit.ApplicationDelegateMixin(Self);

pub fn init() !*Self {
    // Get the NSApplicationDelegate Protocol
    const application_delegate_protocol = try apple.app_kit.ApplicationDelegateProtocol.init();

    // Create a new Objective-C Class based off of NSObject. This class will act as our custom
    // delegate, so we'll name it ManateeApplicationDelegate
    const delegate_class = try apple.objective_c.Class.allocateClassPair(try apple.objective_c.Class.init("NSObject"), "ManateeApplicationDelegate", null);

    // Add NSApplicationDelegate and register the class
    try delegate_class.addProtocol(application_delegate_protocol);

    // Register all required functions from mixin
    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationWillFinishLaunching:"),
        Self.applicationWillFinishLaunching,
        "v@:@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationShouldTerminateAfterLastWindowClosed:"),
        Self.applicationShouldTerminateAfterLastWindowClosed,
        "b@:@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationWillHide:"),
        Self.applicationWillHide,
        "v@:@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationWillUnhide:"),
        Self.applicationWillUnhide,
        "v@:@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationWillUpdate:"),
        Self.applicationWillUpdate,
        "v@:@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationDockMenu:"),
        Self.applicationDockMenu,
        "@@:@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationShouldAutomaticallyLocalizeKeyEquivalents:"),
        Self.applicationShouldAutomaticallyLocalizeKeyEquivalents,
        "b@:@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("application:willPresentError:"),
        Self.applicationWillPresentError,
        "@@:@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("application:continueUserActivity:restorationHandler:"),
        Self.applicationContinueUserActivityRestorationHandler,
        "b@:@@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("application:didRegisterForRemoteNotificationsWithDeviceToken:"),
        Self.applicationDidRegisterForRemoteNotificationsWithDeviceToken,
        "v@:@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("application:didFailToRegisterForRemoteNotificationsWithError:"),
        Self.applicationDidFailToRegisterForRemoteNotificationsWithError,
        "v@:@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("application:didReceiveRemoteNotification:"),
        Self.applicationDidReceiveRemoteNotification,
        "v@:@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("application:userDidAcceptCloudKitShareWithMetadata:"),
        Self.applicationUserDidAcceptCloudKitShareWithMetadata,
        "v@:@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("application:handlerForIntent:"),
        Self.applicationHandlerForIntent,
        "@@:@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("application:openURLs:"),
        Self.applicationOpenURLs,
        "v@:@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("application:openFile:"),
        Self.applicationOpenFile,
        "v@:@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationOpenUntitledFile:"),
        Self.applicationOpenUntitledFile,
        "b@:@@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationProtectedDataWillBecomeUnavailable:"),
        Self.applicationOpenUntitledFile,
        "b@:@",
    );

    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationDidChangeOcclusionState:"),
        Self.applicationDidChangeOcclusionState,
        "b@:@",
    );

    // Register Optional Methods that are used by Manatee
    try delegate_class.addMethod(
        apple.objective_c.Sel.init("applicationDidFinishLaunching:"),
        Self.applicationDidFinishLaunching,
        "v@:@",
    );

    delegate_class.registerClassPair();
    return try Self.new("ManateeApplicationDelegate");
}

pub fn applicationDidFinishLaunching(_: *Self, _: *apple.objective_c.Sel, _: *apple.foundation.Notification) void {
    const shared_application = apple.app_kit.Application.init() catch @panic("Failed to get shared application");
    // _ = apple.app_kit.Event.init() catch @panic("Unable to post empty event");
    shared_application.stop(null);
}

pub fn deinit(self: *Self) void {
    self.release();
    const class = apple.objective_c.Class.getClass("ManateeApplicationDelegate");
    return class.?.disposeClassPair();
}
