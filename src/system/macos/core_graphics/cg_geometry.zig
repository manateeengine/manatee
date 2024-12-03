//! Apple's CoreGraphics Framework's CGGeometry API Collection
//! See: https://developer.apple.com/documentation/coregraphics/cggeometry

/// The basic type for all floating-point values.
/// See: https://developer.apple.com/documentation/corefoundation/cgfloat
pub const CGFloat = f64;

/// A structure that contains a point in a two-dimensional coordinate system.
/// See: https://developer.apple.com/documentation/corefoundation/cgpoint
pub const CGPoint = extern struct {
    x: CGFloat,
    y: CGFloat,
};

/// A structure that contains width and height values.
/// See: https://developer.apple.com/documentation/corefoundation/cgsize
pub const CGSize = extern struct {
    width: CGFloat,
    height: CGFloat,
};

/// A structure that contains the location and dimensions of a rectangle.
/// See: https://developer.apple.com/documentation/corefoundation/cgrect
pub const CGRect = extern struct {
    origin: CGPoint,
    size: CGSize,
};
