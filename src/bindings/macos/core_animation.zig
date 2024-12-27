// //! Apple's CoreAnimation Framework
// //! See: https://developer.apple.com/documentation/appkit

const std = @import("std");

const Device = @import("../metal.zig").gpu_devices_and_work_submission.Device;

const objective_c_runtime = @import("objective_c_runtime.zig");
const Class = objective_c_runtime.Class;
const helpers = objective_c_runtime.helpers;
const Id = objective_c_runtime.Id;
const NSInteger = objective_c_runtime.data_types.NSInteger;
const NsObjectMixin = objective_c_runtime.ns_object.NsObjectMixin;
const NSUInteger = objective_c_runtime.data_types.NSUInteger;
const Object = objective_c_runtime.Object;
const objc = objective_c_runtime.objc;

/// An object that manages image-based content and allows you to perform animations on that
/// content.
/// See: https://developer.apple.com/documentation/quartzcore/calayer
pub const CALayer = struct {
    /// The internal Objective-C Runtime value representing the CALayer
    value: Id,
    const ca_layer_mixin = CaLayerMixin(CALayer, "CALayer");
    pub usingnamespace ca_layer_mixin;

    pub fn init() CALayer {
        return ca_layer_mixin.alloc();
    }

    pub fn deinit(self: *CALayer) void {
        ca_layer_mixin.dealloc(self);
        self.* = undefined;
    }
};

pub fn CaLayerMixin(comptime Self: type, class_name: []const u8) type {
    return struct {
        const ns_object_mixin = NsObjectMixin(Self, class_name);
        pub usingnamespace ns_object_mixin;
    };
}

/// A Core Animation layer that Metal can render into, typically displayed onscreen.
/// See: https://developer.apple.com/documentation/quartzcore/cametallayer
pub const CAMetalLayer = struct {
    /// The internal Objective-C Runtime value representing the CAMetalLayer
    value: Id,
    const ca_metal_layer_mixin = CaMetalLayerMixin(CAMetalLayer, "CAMetalLayer");
    pub usingnamespace ca_metal_layer_mixin;

    pub fn init() CAMetalLayer {
        return ca_metal_layer_mixin.alloc();
    }

    pub fn deinit(self: *CAMetalLayer) void {
        ca_metal_layer_mixin.dealloc(self);
        self.* = undefined;
    }
};

pub fn CaMetalLayerMixin(comptime Self: type, class_name: []const u8) type {
    return struct {
        const ca_layer_mixin = CaLayerMixin(Self, class_name);
        pub usingnamespace ca_layer_mixin;

        /// Sets the Metal device responsible for the layer’s drawable resources.
        /// See: https://developer.apple.com/documentation/quartzcore/cametallayer/device
        pub fn setDevice(self: *Self, device: Device) void {
            return objc.msgSend(self, void, "setDevice:", .{device});
        }
    };
}
