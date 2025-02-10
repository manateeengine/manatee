const std = @import("std");

const objective_c = @import("../objective_c.zig");

const Point = @import("../core_graphics.zig").Point;

const Class = objective_c.Class;
const ObjectMixin = objective_c.object.ObjectMixin;
const Sel = objective_c.Sel;
const msgSend = objective_c.msgSend;

/// An object that contains information about an input action, such as a mouse click or a key
/// press.
/// Original: `NSEvent`
/// See: https://developer.apple.com/documentation/appkit/nsevent
pub const Event = opaque {
    const Self = @This();
    pub usingnamespace EventMixin(Self);

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init() !*Self {
        // This effectively creates an empty event
        return try Self.otherEventWithTypeLocationModifierFlagsTimestampWindowNumberContextSubtypeData1Data2(
            "NSEvent",
            .application_defined,
            .{ .x = 0, .y = 0 },
            .any,
            0,
            0,
            null,
            0,
            0,
            0,
        );
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        return self.release();
    }
};

/// Flags that represent key states in an event object.
/// Original: `NSEventModifierFlags`
/// See: https://developer.apple.com/documentation/appkit/nsevent/modifierflags-swift.struct
pub const EventModifierFlags = enum(u64) {
    /// The Caps Lock key has been pressed.
    caps_lock = 65536,
    /// The Shift key has been pressed.
    shift = 131072,
    /// The Control key has been pressed.
    control = 262144,
    /// The Option or Alt key has been pressed.
    option = 524288,
    /// The Command key has been pressed.
    command = 1048576,
    /// A key in the numeric keypad or an arrow key has been pressed.
    numeric_pad = 2097152,
    /// The Help key has been pressed.
    help = 4194304,
    /// A function key has been pressed.
    function = 8388608,
    /// Device-independent modifier flags are masked.
    device_independent_flags_mask = 4294901760,
    any = std.math.maxInt(u64),
};

/// Constants for the types of events that responder objects can handle.
/// Original: `NSEventType`
/// See: https://developer.apple.com/documentation/appkit/nsevent/eventtype
pub const EventType = enum(u64) {
    left_mouse_down = 1,
    left_mouse_up = 2,
    right_mouse_down = 3,
    right_mouse_up = 4,
    mouse_moved = 5,
    left_mouse_dragged = 6,
    right_mouse_dragged = 7,
    mouse_entered = 8,
    mouse_exited = 9,
    key_down = 10,
    key_up = 11,
    flags_changed = 12,
    app_kit_defined = 13,
    system_defined = 14,
    application_defined = 15,
    periodic = 16,
    cursor_update = 17,
    scroll_wheel = 22,
    tablet_point = 23,
    tablet_proximity = 24,
    other_mouse_down = 25,
    other_mouse_up = 26,
    other_mouse_dragged = 27,
    gesture = 29,
    magnify = 30,
    swipe = 31,
    rotate = 18,
    begin_gesture = 19,
    end_gesture = 20,
    unknown,
};

/// A Manatee Binding Mixin for AppKit's NSEvent class and its instances
/// For more information on the mixin pattern, see `bindings/README.md`
pub fn EventMixin(comptime Self: type) type {
    return struct {
        const inherited_methods = ObjectMixin(Self);
        pub usingnamespace inherited_methods;

        pub fn otherEventWithTypeLocationModifierFlagsTimestampWindowNumberContextSubtypeData1Data2(class_name: [*:0]const u8, event_type: EventType, location: Point, flags: EventModifierFlags, time: f64, window_num: i32, unused_pass_nil: ?*anyopaque, sub_type: i16, d1: u64, d2: u64) !*Self {
            const class = Class.init(class_name) catch @panic("Unable to allocate class NSEvent");
            return msgSend(class, *Self, Sel.init("otherEventWithType:location:modifierFlags:timestamp:windowNumber:context:subtype:data1:data2:"), .{ event_type, location, flags, time, window_num, unused_pass_nil, sub_type, d1, d2 });
        }
    };
}
