//! The Apple Objective-C Runtime
//! See: https://developer.apple.com/documentation/objectivec/objective-c_runtime
//!
//! This portion of Manatee's Apple bindings is heavily inspired by the open source work of others,
//! and there's no way I could've built this without drawing inspiration from them and pouring over
//! their code, as I'd never written a line of Objective-C in my life (and hardly any Zig) before
//! starting this project. A HUGE thank you to the following projects:
//!
//! * https://github.com/colbyhall/objective-zig
//! * https://github.com/robbielyman/objz
//! * https://github.com/mitchellh/zig-objc
//! * https://github.com/ryanmcgrath/cacao
//!
//! Note: There's a chance that these bindings will also work with the GNU GCC Objective-C runtime,
//! but I don't really have a use-case for targeting / testing that. If a use-case arises, I'll
//! probably move this out of the Apple SDK bindings and into its own separate binding

pub const class = @import("objective_c/class.zig");
pub const msg_send = @import("objective_c/msg_send.zig");
pub const object = @import("objective_c/object.zig");
pub const protocol = @import("objective_c/protocol.zig");
pub const sel = @import("objective_c/sel.zig");

pub const Class = class.Class;
pub const Object = object.Object;
pub const Protocol = protocol.Protocol;
pub const Sel = sel.Sel;
pub const msgSend = msg_send.msgSend;
