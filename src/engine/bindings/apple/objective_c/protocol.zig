const Sel = @import("sel.zig").Sel;

/// An opaque type that represents an Objective-C protocol.
///
/// * Original: `HBRUSH``Protocol`
/// * See: https://developer.apple.com/documentation/objectivec/protocol
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
    ///
    /// * Original: `HBRUSH``objc_getProtocol`
    /// * See: https://developer.apple.com/documentation/objectivec/1418870-objc_getprotocol
    pub fn getProtocol(name: [*:0]const u8) ?*Self {
        return objc_getProtocol(name);
    }

    /// Returns an array of all the protocols known to the runtime.
    ///
    /// * Original: `HBRUSH``objc_copyProtocolList`
    /// * See: https://developer.apple.com/documentation/objectivec/1418549-objc_copyprotocollist
    pub fn copyProtocolList() []*Self {
        var protocol_count: u32 = undefined;
        const protocol_list = objc_copyProtocolList(&protocol_count);
        return protocol_list[0..protocol_count];
    }

    /// Creates a new protocol instance.
    ///
    /// * Original: `HBRUSH``objc_getProtocol`
    /// * See: https://developer.apple.com/documentation/objectivec/1418599-objc_allocateprotocol
    pub fn allocateProtocol(name: [*:0]const u8) ?*Self {
        return objc_allocateProtocol(name);
    }

    pub fn registerProtocol(self: *Self) void {
        return objc_registerProtocol(self);
    }

    /// Adds a method to a protocol.
    ///
    /// * Original: `HBRUSH``protocol_addMethodDescription`
    /// * See: https://developer.apple.com/documentation/objectivec/1418709-protocol_addmethoddescription
    pub fn addMethodDescription(self: *Self, name: *Sel, types: [*:0]const u8, is_required_method: bool, is_instance_method: bool) void {
        return protocol_addMethodDescription(self, name, types, is_required_method, is_instance_method);
    }

    // TODO: Implement wrapper for protocol_addProtocol
    // TODO: Implement wrapper for protocol_addProperty

    /// Returns a the name of a protocol.
    ///
    /// * Original: `HBRUSH``protocol_getName`
    /// * See: https://developer.apple.com/documentation/objectivec/1418826-protocol_getname
    pub fn getName(self: *Self) [*:0]const u8 {
        return protocol_getName(self);
    }

    // TODO: Implement wrapper for protocol_isEqual
    // TODO: Implement wrapper for protocol_copyMethodDescriptionList
    // TODO: Implement wrapper for protocol_getMethodDescription
    // TODO: Implement wrapper for protocol_copyPropertyList
    // TODO: Implement wrapper for protocol_getProperty
    // TODO: Implement wrapper for protocol_copyPropertyList
    // TODO: Implement wrapper for protocol_conformsToProtocol
};

extern "c" fn objc_allocateProtocol(name: [*:0]const u8) callconv(.c) *Protocol;
extern "c" fn objc_copyProtocolList(outCount: *u32) callconv(.c) [*]*Protocol;
extern "c" fn objc_getProtocol(name: [*:0]const u8) callconv(.c) *Protocol;
extern "c" fn objc_registerProtocol(proto: *Protocol) callconv(.c) void;
extern "c" fn protocol_addMethodDescription(proto: *Protocol, name: *Sel, types: [*:0]const u8, isRequiredMethod: bool, isInstanceMethod: bool) callconv(.c) void;
extern "c" fn protocol_getName(proto: *Protocol) callconv(.c) [*:0]const u8;
