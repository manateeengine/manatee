//! Zig Build System Configuration for Manatee's test suite.

const std = @import("std");

const BuildConfig = @import("BuildConfig.zig");

const Self = @This();

/// Creates a Zig Build `Step` to run Manatee's tests with the specified `BuildConfig` pointer.
pub fn init(
    config: *const BuildConfig,
) *std.Build.Step {
    const tests = config.b.addTest(.{
        .root_source_file = config.b.path("src/main_module.zig"),
        .target = config.target,
        .optimize = config.optimize,
    });

    const test_cmd = config.b.addRunArtifact(tests);
    const step = config.b.step(
        "test",
        "Runs Manatee's Test Suite",
    );
    step.dependOn(&test_cmd.step);

    return step;
}
