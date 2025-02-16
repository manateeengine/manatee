//! Configuration for the Manatee Build System.

const builtin = @import("builtin");
const std = @import("std");

const Self = @This();

/// A pointer to the Zig build instance.
b: *std.Build,
/// Zig build system optimization options.
optimize: std.builtin.OptimizeMode,
/// Zig build system target options.
target: std.Build.ResolvedTarget,

/// Creates a `BuildConfig` with the specified `std.Build` pointer.
pub fn init(b: *std.Build) Self {
    // Get the target and optimize options. For now, the standard ones will suffice.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    return Self{
        .b = b,
        .optimize = optimize,
        .target = target,
    };
}

/// Links any required frameworks, libraries, and Zig packages to the provided Zig Build Step.
pub fn linkSharedDependencies(self: *const Self, step: *std.Build.Step.Compile) void {
    // Unused for now, but may eventually be required for linking Zig deps
    _ = self;

    // Link all required operating system dependencies
    switch (builtin.target.os.tag) {
        .macos => {
            // Manatee requires that Objective-C and AppKit are linked on MacOS
            step.linkSystemLibrary2("objc", .{});
            step.linkFramework("AppKit");
        },
        else => {
            // For unsupported operating systems, do nothing
        },
    }
}
