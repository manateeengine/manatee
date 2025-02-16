//! Apple's Foundation Framework's Numbers, Data, and Basic Values API Collection
//! See: https://developer.apple.com/documentation/coregraphics/cggeometry

const core_graphics = @import("../core_graphics.zig");

/// A rectangle.
/// See: https://developer.apple.com/documentation/foundation/nsrect
pub const NSRect = core_graphics.cg_geometry.CGRect;
