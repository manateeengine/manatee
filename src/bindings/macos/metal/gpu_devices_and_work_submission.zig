const c = @import("c.zig");

pub const Device = struct {
    value: *c.MTLDevice,
};

/// Returns the device instance Metal selects as the default.
/// See: https://developer.apple.com/documentation/metal/1433401-mtlcreatesystemdefaultdevice
pub fn createSystemDefaultDevice() Device {
    return Device{
        .value = c.MTLCreateSystemDefaultDevice().?,
    };
}
