//! The Objective-C Runtime
//!
//! This codebase is heavily inspired by the following works from others, and I couldn't have built
//! the majority of this without heavily pouring over their code and docs:
//! * https://github.com/colbyhall/objective-zig
//! * https://github.com/robbielyman/objz
//! * https://github.com/mitchellh/zig-objc
//! * https://github.com/ryanmcgrath/cacao

pub const c = @import("objective_c_runtime/c.zig");
pub const class = @import("objective_c_runtime/class.zig");
pub const data_types = @import("objective_c_runtime/data_types.zig");
pub const helpers = @import("objective_c_runtime/helpers.zig");
pub const ns_object = @import("objective_c_runtime/ns_object.zig");
pub const objc = @import("objective_c_runtime/objc.zig");
pub const object = @import("objective_c_runtime/object.zig");
pub const sel = @import("objective_c_runtime/sel.zig");

pub const Class = class.Class;
pub const NSObject = ns_object.NSObject;
pub const Object = object.Object;
pub const Sel = sel.Sel;
