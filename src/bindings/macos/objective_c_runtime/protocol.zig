const std = @import("std");

const c = @import("c.zig");

/// A struct that contains all functions prefixed by `protocol_` in the Objective-C Runtime, while
/// also providing storage for the raw Objective-C protocol.
pub const Protocol = struct {
    /// A pointer to the internal Objective-C Runtime value representing the Protocol.
    value: *c.Protocol,
};
