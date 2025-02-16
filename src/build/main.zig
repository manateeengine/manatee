//! The Manatee Build System
//!
//! ## Remarks
//! In order to simplify our top-level build.zig file, as well as to provide reusable, tested build
//! code for Manatee's various modules, the vast majority of Manatee's build code is located in
//! this module. Hopefully in the future Zig's build API will be a little less verbose and we'll be
//! able to get rid of the build module entirely. This module is inspired by the wat Ghostty
//! handles its build system.
//!
//! ## See
//! * [Ghostty on GitHub](https://github.com/ghostty-org/ghostty)

pub const BuildConfig = @import("BuildConfig.zig");
pub const BuildContext = @import("BuildContext.zig");
pub const CheckedStep = @import("CheckedStep.zig");
pub const ManateeEditorExe = @import("ManateeEditorExe.zig");
pub const ManateeEngineLib = @import("ManateeEngineLib.zig");
pub const ManateeEngineModule = @import("ManateeEngineModule.zig");
