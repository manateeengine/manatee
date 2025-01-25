//! The Apple Foundation Framework
//! See: https://developer.apple.com/documentation/foundation

pub const dates_times = @import("foundation/dates_times.zig");
pub const strings_text = @import("foundation/strings_text.zig");

pub const Date = dates_times.Date;
pub const String = strings_text.String;
