/// A structure that contains a point in a two-dimensional coordinate system.
/// Original: `CGPoint`
/// See: https://developer.apple.com/documentation/corefoundation/cgpoint
pub const Point = extern struct {
    /// The x-coordinate of the point.
    /// See: https://developer.apple.com/documentation/corefoundation/cgpoint/1456040-x
    /// Note: In the Core Graphics Framework, this value is of type `CGFloat`, which is equal to
    /// C's `double` type, which is equal to Zig's `f64` type
    x: f64,
    /// The y-coordinate of the point.
    /// See: https://developer.apple.com/documentation/corefoundation/cgpoint/1454718-y
    /// Note: In the Core Graphics Framework, this value is of type `CGFloat`, which is equal to
    /// C's `double` type, which is equal to Zig's `f64` type
    y: f64,
};

/// A structure that contains the location and dimensions of a rectangle.
/// Original: `CGRect`
/// See: https://developer.apple.com/documentation/corefoundation/cgrect
pub const Rect = extern struct {
    /// A point that specifies the coordinates of the rectangle’s origin.
    /// See: https://developer.apple.com/documentation/corefoundation/cgrect/1454354-origin
    origin: Point,
    /// A size that specifies the height and width of the rectangle.
    /// See: https://developer.apple.com/documentation/corefoundation/cgrect/1455155-size
    size: Size,
};

/// A structure that contains width and height values.
/// Original: `CGSize`
/// See: https://developer.apple.com/documentation/corefoundation/cgsize
pub const Size = extern struct {
    /// A width value.
    /// See: https://developer.apple.com/documentation/corefoundation/cgsize/1454308-width
    /// Note: In the Core Graphics Framework, this value is of type `CGFloat`, which is equal to
    /// C's `double` type, which is equal to Zig's `f64` type
    width: f64,
    /// A height value.
    /// See: https://developer.apple.com/documentation/corefoundation/cgsize/1455076-height
    /// Note: In the Core Graphics Framework, this value is of type `CGFloat`, which is equal to
    /// C's `double` type, which is equal to Zig's `f64` type
    height: f64,
};
