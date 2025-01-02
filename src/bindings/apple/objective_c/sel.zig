/// Defines an opaque type that represents a method selector.
/// See: https://developer.apple.com/documentation/objectivec/sel
pub const Sel = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(name: [*:0]const u8) *Self {
        return registerName(name);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        self.* = undefined;
    }

    // Methods defined under the Objective-C runtime's "Working with Selectors" section

    /// Returns the name of the method specified by a given selector.
    /// Original: `sel_getName`
    /// https://developer.apple.com/documentation/objectivec/1418571-sel_getname
    pub fn getName(self: *Self) [*:0]const u8 {
        return sel_getName(self);
    }

    /// Registers a method with the Objective-C runtime system, maps the method name to a selector,
    /// and returns the selector value.
    /// Original: `sel_registerName`
    /// See: https://developer.apple.com/documentation/objectivec/1418557-sel_registername
    pub fn registerName(name: [*:0]const u8) *Self {
        return sel_registerName(name);
    }

    /// Registers a method name with the Objective-C runtime system.
    /// Original: `sel_getUid`
    /// See: https://developer.apple.com/documentation/objectivec/1418625-sel_getuid
    /// Note: The implementation of this method is identical to the implementation of registerName.
    pub fn getUid(name: [*:0]const u8) *Self {
        return sel_getUid(name);
    }

    /// Returns a Boolean value that indicates whether two selectors are equal.
    /// Original: `sel_isEqual`
    /// See: https://developer.apple.com/documentation/objectivec/1418736-sel_isequal
    pub fn isEqual(left_sel: *Self, right_sel: *Self) *Self {
        return sel_isEqual(left_sel, right_sel);
    }
};

extern "c" fn sel_getName(sel: *Sel) callconv(.c) [*:0]const u8;
extern "c" fn sel_getUid(str: [*:0]const u8) callconv(.c) *Sel;
extern "c" fn sel_isEqual(lhs: *Sel, rhs: *Sel) callconv(.c) bool;
extern "c" fn sel_registerName(str: [*:0]const u8) callconv(.c) *Sel;
