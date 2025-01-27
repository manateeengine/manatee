const std = @import("std");

const apple = @import("../../../bindings.zig").apple;

/// A Custom Objective-C Application Delegate for Manatee
pub const ManateeApplicationDelegate = opaque {
    const Self = @This();
    pub usingnamespace apple.objective_c.object.ObjectMixin(Self);

    pub fn init() !*Self {
        // Get the NSApplicationDelegate Protocol
        const application_delegate_protocol = try apple.objective_c.Protocol.init("NSApplicationDelegate");

        // Create a new Objective-C Class based off of NSObject. This class will act as our custom
        // delegate, so we'll name it ManateeApplicationDelegate
        const delegate_class = try apple.objective_c.Class.allocateClassPair(try apple.objective_c.Class.init("NSObject"), "ManateeApplicationDelegate", null);

        // Add NSApplicationDelegate and register the class
        try delegate_class.addProtocol(application_delegate_protocol);

        // Add any custom methods to the class

        // try delegate_class.addMethod(
        //     apple.objective_c.Sel.init("applicationWillFinishLaunching:"),
        //     applicationWillFinishLaunching,
        //     "v@:@",
        // );

        // Optional but used in Manatee
        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationDidFinishLaunching:"),
            applicationDidFinishLaunching,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationWillBecomeActive:"),
            applicationWillBecomeActive,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationDidBecomeActive:"),
            applicationDidBecomeActive,
            "v@:@",
        );

        // try delegate_class.addMethod(
        //     apple.objective_c.Sel.init("applicationWillResignActive:"),
        //     applicationWillResignActive,
        //     "v@:@",
        // );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationDidResignActive:"),
            applicationDidResignActive,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationShouldTerminate:"),
            applicationShouldTerminate,
            "i@:@",
        );

        // try delegate_class.addMethod(
        //     apple.objective_c.Sel.init("applicationShouldTerminateAfterLastWindowClosed:"),
        //     applicationShouldTerminateAfterLastWindowClosed,
        //     "b@:",
        // );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationWillTerminate:"),
            applicationWillTerminate,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationWillHide:"),
            applicationWillHide,
            "v@:@",
        );

        // try delegate_class.addMethod(
        //     apple.objective_c.Sel.init("applicationDidHide:"),
        //     applicationDidHide,
        //     "v@:@",
        // );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationWillUnhide:"),
            applicationWillUnhide,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationDidUnhide:"),
            applicationDidUnhide,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationWillUpdate:"),
            applicationWillUpdate,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationDidUpdate:"),
            applicationDidUpdate,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationShouldHandleReopenHasVisibleWindows:"),
            applicationShouldHandleReopenHasVisibleWindows,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationDockMenu:"),
            applicationDockMenu,
            "@@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationDidChangeScreenParameters:"),
            applicationDidChangeScreenParameters,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("application:continueUserActivity:restorationHandler:"),
            applicationContinueUserActivityRestorationHandler,
            "b@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("application:didUpdateUserActivity:"),
            applicationDidUpdateUserActivity,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("application:didReceiveRemoteNotification:"),
            applicationDidReceiveRemoteNotification,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("application:userDidAcceptCloudKitShareWithMetadata:"),
            applicationUserDidAcceptCloudKitShareWithMetadata,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("application:handlerForIntent:"),
            applicationHandlerForIntent,
            "@@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("application:openURLs:"),
            applicationOpenUrls,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("application:openFileWithoutUI:"),
            applicationOpenFileWithoutUi,
            "b@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationShouldOpenUntitledFile:"),
            applicationShouldOpenUntitledFile,
            "b@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationOpenUntitledFile:"),
            applicationOpenUntitledFile,
            "b@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("application:printFiles:withSettings:showPrintPanels:"),
            applicationPrintFilesWithSettingsShowPrintPanels,
            "i@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationProtectedDataDidBecomeAvailable:"),
            applicationProtectedDataDidBecomeAvailable,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("applicationDidChangeOcclusionState:"),
            applicationDidChangeOcclusionState,
            "v@:@",
        );

        try delegate_class.addMethod(
            apple.objective_c.Sel.init("application:delegateHandlesKey:"),
            applicationDelegateHandlesKey,
            "b@:@",
        );

        delegate_class.registerClassPair();
        return try Self.new("ManateeApplicationDelegate");
    }

    pub fn deinit(self: *Self) void {
        return self.release();
    }

    // fn applicationWillFinishLaunching(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
    //     _ = _self;
    //     _ = _cmd;
    //     _ = _ns_notification;
    // }

    fn applicationDidFinishLaunching(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDidFinishLaunching\n", .{});

        // It may look like we're creating another application here, but under the hood the Manatee
        // Application.init() call actually fetches the AppKit sharedApplication, which returns the
        // existing instance if it's already been created!

        // As a note, we can't use Zig error returns inside of App Delegate functions, so if the
        // delegate can't get the NSApplication class, it panics, which is a little ugly but eh,
        // it's not like I have another more Zig-friendly choice here (that I know if, that is)
        const shared_app_instance = apple.app_kit.Application.init() catch @panic("Unable to get sharedApplication in Manatee App Delegate");
        shared_app_instance.stop(null);

        const empty_event = apple.app_kit.Event.init();

        shared_app_instance.postEventAtStart(empty_event, true);
    }

    fn applicationWillBecomeActive(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationWillBecomeActive\n", .{});
    }

    fn applicationDidBecomeActive(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDidBecomeActive\n", .{});
    }

    // fn applicationWillResignActive(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
    //     _ = _self;
    //     _ = _cmd;
    //     _ = _ns_notification;

    //     std.debug.print("applicationWillResignActive\n", .{});
    // }

    fn applicationDidResignActive(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDidResignActive\n", .{});
    }

    fn applicationShouldTerminate(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) apple.app_kit.ApplicationTerminateReply {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationShouldTerminate\n", .{});

        return apple.app_kit.ApplicationTerminateReply.now;
    }

    // fn applicationShouldTerminateAfterLastWindowClosed(_self: *Self, _cmd: *apple.objective_c.Sel, _application: *anyopaque) callconv(.c) bool {
    //     _ = _self;
    //     _ = _cmd;
    //     _ = _application;

    //     std.debug.print("applicationShouldTerminateAfterLastWindowClosed\n", .{});

    //     return true;
    // }

    fn applicationWillTerminate(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationWillTerminate\n", .{});
    }

    fn applicationWillHide(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationWillHide\n", .{});
    }

    // fn applicationDidHide(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
    //     _ = _self;
    //     _ = _cmd;
    //     _ = _ns_notification;

    //     std.debug.print("applicationDidHide\n", .{});
    // }

    fn applicationWillUnhide(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationWillUnhide\n", .{});
    }

    fn applicationDidUnhide(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDidUnhide\n", .{});
    }

    fn applicationWillUpdate(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationWillUpdate\n", .{});
    }

    fn applicationDidUpdate(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDidUpdate\n", .{});
    }

    fn applicationShouldHandleReopenHasVisibleWindows(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) bool {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationShouldHandleReopenHasVisibleWindows\n", .{});

        return true;
    }

    fn applicationDockMenu(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) ?*anyopaque {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDockMenu\n", .{});

        return null;
    }

    fn applicationDidChangeScreenParameters(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDidChangeScreenParameters\n", .{});
    }

    fn applicationContinueUserActivityRestorationHandler(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) bool {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationContinueUserActivityRestorationHandler\n", .{});

        return false;
    }

    fn applicationDidUpdateUserActivity(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDidUpdateUserActivity\n", .{});
    }

    fn applicationDidReceiveRemoteNotification(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDidReceiveRemoteNotification\n", .{});
    }

    fn applicationUserDidAcceptCloudKitShareWithMetadata(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationUserDidAcceptCloudKitShareWithMetadata\n", .{});
    }

    fn applicationHandlerForIntent(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) ?*anyopaque {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationHandlerForIntent\n", .{});

        return null;
    }

    fn applicationOpenUrls(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationOpenUrls\n", .{});
    }

    fn applicationOpenFileWithoutUi(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) bool {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationOpenFileWithoutUi\n", .{});

        return false;
    }

    fn applicationShouldOpenUntitledFile(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) bool {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationShouldOpenUntitledFile\n", .{});

        return false;
    }

    fn applicationOpenUntitledFile(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) bool {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationOpenUntitledFile\n", .{});

        return false;
    }

    // TODO: Return NSApplicationPrintReply
    fn applicationPrintFilesWithSettingsShowPrintPanels(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) i32 {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationPrintFilesWithSettingsShowPrintPanels\n", .{});

        return 0;
    }

    fn applicationProtectedDataDidBecomeAvailable(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationProtectedDataDidBecomeAvailable\n", .{});
    }

    fn applicationDidChangeOcclusionState(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDidChangeOcclusionState\n", .{});
    }

    fn applicationDelegateHandlesKey(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) bool {
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("applicationDelegateHandlesKey\n", .{});

        return false;
    }
};
