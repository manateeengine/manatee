//! The Apple AppKit Framework
//! See: https://developer.apple.com/documentation/appkit

pub const application = @import("app_kit/application.zig");
pub const application_delegate = @import("app_kit/application_delegate.zig");
pub const event = @import("app_kit/event.zig");
pub const menu = @import("app_kit/menu.zig");
pub const responder = @import("app_kit/responder.zig");
pub const window = @import("app_kit/window.zig");

pub const Application = application.Application;
pub const ApplicationDelegateProtocol = application_delegate.ApplicationDelegateProtocol;
pub const ApplicationDelegateMixin = application_delegate.ApplicationDelegateProtocolMixin;
pub const Event = event.Event;
pub const Menu = menu.Menu;
pub const Responder = responder.Responder;
pub const Window = window.Window;
