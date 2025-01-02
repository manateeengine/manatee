/// An opaque type that represents an Objective-C protocol.
/// Original: `Protocol`
/// See: https://developer.apple.com/documentation/objectivec/protocol
pub const Protocol = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(name: [*:0]const u8) !*Self {
        // First let's attempt to get the protocol, assuming it's already registered
        const maybe_protocol = Self.getProtocol(name);
        if (maybe_protocol != null) {
            return maybe_protocol.?;
        }

        // If the protocol is null, we need to allocate it first
        const allocated_protocol = Self.allocateProtocol(name);
        if (allocated_protocol == null) {
            return error.unable_to_allocate_protocol;
        }
        return allocated_protocol.?;
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    // pub fn deinit(self: *Self) void {
    //     self.* = undefined;
    // }

    // Methods defined under the Objective-C runtime's "Working with Protocols" section

    /// Returns a specified protocol.
    /// Original: `objc_getProtocol`
    /// See: https://developer.apple.com/documentation/objectivec/1418870-objc_getprotocol
    pub fn getProtocol(name: [*:0]const u8) ?*Self {
        return objc_getProtocol(name);
    }

    // TODO: Implement wrapper for objc_copyProtocolList

    /// Creates a new protocol instance.
    /// Original: `objc_getProtocol`
    /// See: https://developer.apple.com/documentation/objectivec/1418599-objc_allocateprotocol
    pub fn allocateProtocol(name: [*:0]const u8) ?*Self {
        return objc_allocateProtocol(name);
    }

    // TODO: Implement wrapper for objc_registerProtocol
    // TODO: Implement wrapper for protocol_addMethodDescription
    // TODO: Implement wrapper for protocol_addProtocol
    // TODO: Implement wrapper for protocol_addProperty
    // TODO: Implement wrapper for protocol_getName
    // TODO: Implement wrapper for protocol_isEqual
    // TODO: Implement wrapper for protocol_copyMethodDescriptionList
    // TODO: Implement wrapper for protocol_getMethodDescription
    // TODO: Implement wrapper for protocol_copyPropertyList
    // TODO: Implement wrapper for protocol_getProperty
    // TODO: Implement wrapper for protocol_copyProtocolList
    // TODO: Implement wrapper for protocol_conformsToProtocol
};

extern "c" fn objc_allocateProtocol(name: [*:0]const u8) callconv(.c) *Protocol;
extern "c" fn objc_getProtocol(name: [*:0]const u8) callconv(.c) *Protocol;
