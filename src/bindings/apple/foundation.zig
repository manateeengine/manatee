//! The Apple Foundation Framework
//! See: https://developer.apple.com/documentation/foundation

pub const date = @import("foundation/date.zig");
pub const notification = @import("foundation/notification.zig");
pub const string = @import("foundation/string.zig");

pub const Date = date.Date;
pub const Notification = notification.Notification;
pub const String = string.String;
