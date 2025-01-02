//! The Apple Core Animation Framework
//! See: https://developer.apple.com/documentation/quartzcore

const objective_c = @import("objective_c.zig");

const ObjectMixin = objective_c.object.ObjectMixin;
const Sel = objective_c.Sel;
const msg_send = objective_c.msgSend;

// Opaque Types

/// An object that manages image-based content and allows you to perform animations on that
/// content.
/// Original: `CALayer`
/// See: https://developer.apple.com/documentation/quartzcore/calayer
pub const Layer = opaque {
    const Self = @This();
    pub usingnamespace LayerMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() *Self {
        return Self.new("CALayer");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }
};

/// A Core Animation layer that Metal can render into, typically displayed onscreen.
/// Original: `CAMetalLayer`
/// See: https://developer.apple.com/documentation/quartzcore/cametallayer
pub const MetalLayer = opaque {
    const Self = @This();
    pub usingnamespace MetalLayerMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() !*Self {
        return try Self.new("CAMetalLayer");
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.dealloc();
    }
};

// Structs / Mixins

/// A Manatee Binding Mixin for the Objective-C Runtime's CALayer class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn LayerMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectMixin(Self);
        pub usingnamespace inherited_methods;
    };

    // TODO: Implement CALayer class's "Creating a Layer" section
    // TODO: Implement CALayer class's "Accessing Related Layer Objects" section
    // TODO: Implement CALayer class's "Accessing the Delegate" section
    // TODO: Implement CALayer class's "Providing the Layer's Contents" section
    // TODO: Implement CALayer class's "Modifying the Layer's Appearance" section
    // TODO: Implement CALayer class's "Layer Filters" section
    // TODO: Implement CALayer class's "Configuring the Layer's Rendering Behavior" section
    // TODO: Implement CALayer class's "Modifying the Layer Geometry" section
    // TODO: Implement CALayer class's "Managing the Layer's Transform" section
    // TODO: Implement CALayer class's "Managing the Layer Hierarchy" section
    // TODO: Implement CALayer class's "Updating Layer Display" section
    // TODO: Implement CALayer class's "Layer Animations" section
    // TODO: Implement CALayer class's "Managing Layer Resizing and Layout" section
    // TODO: Implement CALayer class's "Managing Layer Constraints" section
    // TODO: Implement CALayer class's "Getting the Layer's Actions" section
    // TODO: Implement CALayer class's "Mapping Between Coordinate and Time Spaces" section
    // TODO: Implement CALayer class's "Hit Testing" section
    // TODO: Implement CALayer class's "Scrolling" section
    // TODO: Implement CALayer class's "Identifying the Layer" section
    // TODO: Implement CALayer class's "Key-Value Coding Extensions" section
    // TODO: Implement CALayer class's "Constraints" section
    // TODO: Implement CALayer class's "Instance Properties" section
    // TODO: Implement CALayer class's "Type Methods" section
    // TODO: Implement CALayer class's "Instance Methods" section
}

/// A Manatee Binding Mixin for the Objective-C Runtime's CAMetalLayer class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn MetalLayerMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = LayerMixin(Self);
        pub usingnamespace inherited_methods;
    };

    // TODO: Implement CAMetalLayer class's "Configuring the Metal Device" section
    // TODO: Implement CAMetalLayer class's "Configuring the Layer's Drawable Objects" section
    // TODO: Implement CAMetalLayer class's "Configuring Presentation Behavior" section
    // TODO: Implement CAMetalLayer class's "Configuring Extended Dynamic Range Behavior" section
    // TODO: Implement CAMetalLayer class's "Obtaining a Metal Drawable" section
    // TODO: Implement CAMetalLayer class's "Configuring the Metal Performance HUD" section
}
