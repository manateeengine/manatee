const std = @import("std");

const c = @import("c.zig");

/// A struct that contains all functions prefixed by `sel_` in the Objective-C Runtime, while
/// also providing storage for the raw Objective-C selector.
///
/// Note: the following methods have not yet been implemented as they haven't been required for
/// Manatee functionality:
///
/// * `sel_getUid`
/// * `sel_isEqual`
pub const Sel = struct {
    /// The internal Objective-C Runtime value representing the Sel.
    value: c.SEL,

    /// Returns the name of the method specified by a given selector.
    /// See: https://developer.apple.com/documentation/objectivec/1418571-sel_getname
    pub fn getName(sel: *Sel) []const u8 {
        return std.mem.sliceTo(c.sel_getName(sel), 0);
    }

    /// Registers a method with the Objective-C runtime system, maps the method name to a selector,
    /// and returns the selector value.
    /// See: https://developer.apple.com/documentation/objectivec/1418557-sel_registername
    pub fn registerName(name: []const u8) Sel {
        return Sel{
            .value = c.sel_registerName(name.ptr),
        };
    }
};
