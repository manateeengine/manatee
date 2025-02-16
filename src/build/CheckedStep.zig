//! A Zig Build Step that has a duplicated `step_check` property

const std = @import("std");

/// A Zig build system Compile Step.
step: *std.Build.Step.Compile,
/// A Zig build system Compile Step for the Manatee editor, only used for Check operations.
step_check: *std.Build.Step.Compile,
