const std = @import("std");

const apple = @import("../../bindings.zig").apple;
const window = @import("../window.zig");

const App = @import("../app.zig").App;

const Window = window.Window;
const WindowConfig = window.WindowConfig;
const WindowDimensions = window.WindowDimensions;

/// A MacOS implementation of the Manatee `Window` interface.
pub const MacosWindow = struct {
    allocator: std.mem.Allocator,
    app: *App,
    delegate: *ManateeWindowDelegate,
    dimensions: WindowDimensions,
    metal_layer: *apple.core_animation.MetalLayer,
    native_window: *apple.app_kit.Window,

    pub fn init(allocator: std.mem.Allocator, app: *App, config: WindowConfig) !MacosWindow {
        // Let's start off by creating our window and setting it as the app's default (key) window
        const window_instance = try apple.app_kit.Window.init(
            .{
                .origin = .{
                    .x = 0,
                    .y = 0,
                },
                .size = .{
                    .height = @floatFromInt(config.height),
                    .width = @floatFromInt(config.width),
                },
            },
            .{ .titled_enabled = true, .closable_enabled = true, .miniaturizable_enabled = true, .resizable_enabled = true },
            .buffered,
            false,
        );
        errdefer window_instance.deinit();

        // Create a Window Delegate to allow us to customize the window's behavior
        const delegate_instance = try ManateeWindowDelegate.init();
        errdefer delegate_instance.deinit();

        // Now that we've set up our delegate, let's apply it to our app!
        try window_instance.setDelegate(delegate_instance);

        // Now that we have our window, let's go ahead and create a MetalLayer for the window. This
        // will let us render GPU content into the window either via MoltenVK or the Metal API!
        const metal_layer = try apple.core_animation.MetalLayer.init();

        // Let's assign the metal layer to the window's layer
        const window_content_view: *apple.app_kit.View = @ptrCast(window_instance.getContentView());
        window_content_view.setWantsLayer(true);
        window_content_view.setLayer(metal_layer);

        window_instance.makeKeyAndOrderFront();

        return MacosWindow{
            .allocator = allocator,
            .app = app,
            .delegate = delegate_instance,
            .dimensions = WindowDimensions{
                .height = config.height,
                .width = config.width,
            },
            .metal_layer = metal_layer,
            .native_window = window_instance,
        };
    }

    pub fn window(self: *MacosWindow) Window {
        return Window{
            .app = self.app,
            .ptr = @ptrCast(self),
            .vtable = &vtable,
        };
    }

    const vtable = Window.VTable{
        .deinit = &deinit,
        .getDimensions = &getDimensions,
        .getNativeWindow = &getNativeWindow,
    };

    fn deinit(ctx: *anyopaque) void {
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        // I'm commenting this out for now, but I'm not sure if I even need it? Idk, we'll see if
        // this causes memory leaks down the road, but whenever I run it I get this super ugly
        // "Assertion Failed" error saying that the app's _openWindows property doesn't contain an
        // identical window??? Idk, probably an easy fix, but it's causing me to lose transparency
        // with my deinit calls, so I'm commenting it for now
        // TODO: Figure out wtf I'm doing wrong here
        // self.native_window.deinit();
        self.allocator.destroy(self);
    }

    fn getDimensions(ctx: *anyopaque) WindowDimensions {
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        return self.dimensions;
    }

    fn getNativeWindow(ctx: *anyopaque) *anyopaque {
        const self: *MacosWindow = @ptrCast(@alignCast(ctx));
        return self.native_window;
    }
};

/// A Custom Objective-C Window Delegate for Manatee
const ManateeWindowDelegate = opaque {
    const Self = @This();
    pub usingnamespace apple.objective_c.object.ObjectMixin(Self);

    /// Registers an Objective-C class named ManateeWindowDelegate that has all locally-defined Zig
    /// struct functions linked, and allocates an instance of that class.
    pub fn init() !*Self {
        // Get the NSWindowDelegate Protocol
        const application_delegate_protocol = try apple.objective_c.Protocol.init("NSWindowDelegate");

        // Create a new Objective-C Class based off of NSObject. This class will act as our custom
        // delegate, so we'll name it ManateeWindowDelegate
        const delegate_class = try apple.objective_c.Class.allocateClassPair(try apple.objective_c.Class.init("NSObject"), "ManateeWindowDelegate", null);

        // Add the protocol to our newly defined class
        try delegate_class.addProtocol(application_delegate_protocol);

        // Link the locally-defined Zig functions to the delegate's class methods
        try delegate_class.addMethod(
            apple.objective_c.Sel.init("windowWillClose:"),
            windowWillClose,
            "v@:@",
        );

        // Register the class with the Objective-C runtime and create an instance of it
        delegate_class.registerClassPair();
        return try Self.new("ManateeWindowDelegate");
    }

    /// Deallocate the instance of the Objective-C ManateeWindowDelegate class
    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }

    /// Function executed when the delegate receives a `windowWillClose:` message from the WIndow
    fn windowWillClose(_self: *Self, _cmd: *apple.objective_c.Sel, _ns_notification: *anyopaque) callconv(.c) void {
        // These params are required by the Objective-C runtime but we don't use them here
        _ = _self;
        _ = _cmd;
        _ = _ns_notification;

        std.debug.print("Window Will Close\n", .{});
    }
};
