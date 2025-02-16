//! Zig Build System Configuration for Manatee's automatically generated documentation.
//!
//! ## Remarks
//! I hate the way that Zig's auto generated docs work, like fundamentally. As a career web dev it
//! bugs the fuck outta me, but making a better doc gen isn't currently on my list of immediate
//! priorities while building this engine, so I'm using it for now. I'm leaving this disclaimer in
//! here to let everyone know that I'm not happy, and this will NOT help get me to my goal of an
//! engine with better docs than any other engine on the market.

const std = @import("std");

const BuildConfig = @import("BuildConfig.zig");
const CheckedStep = @import("CheckedStep.zig");

const Self = @This();

/// Creates a Zig Build `Step` to generate Manatee docs with the specified `BuildConfig` pointer
/// and `CheckedStep` pointer.
pub fn init(config: *const BuildConfig, checked_step: *const CheckedStep) *std.Build.Step {
    const install_dir = config.b.addInstallDirectory(.{
        .source_dir = checked_step.step.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    const step = config.b.step("docs", "Generates Manatee Documentation into zig-out/docs");
    step.dependOn(&install_dir.step);

    return step;
}
