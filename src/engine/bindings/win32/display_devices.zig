/// Defines a rectangle by the coordinates of its upper-left and lower-right corners.
///
/// * Original: `HBRUSH``tagRECT`
/// * See: https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-rect
pub const Rect = extern struct {
    /// Specifies the x-coordinate of the upper-left corner of the rectangle.
    left: u32,
    /// Specifies the y-coordinate of the upper-left corner of the rectangle.
    top: u32,
    /// Specifies the x-coordinate of the lower-right corner of the rectangle.
    right: u32,
    /// Specifies the y-coordinate of the lower-right corner of the rectangle.
    bottom: u32,
};
