//! Zig Build System Configuration for the Manatee Engine Zig module.

const std = @import("std");

const BuildConfig = @import("BuildConfig.zig");

const Self = @This();

/// A Zig build system Module for the Manatee engine.
module: *std.Build.Module,

/// Creates a `ManateeEngineModule` with the specified `BuildConfig` pointer.
pub fn init(config: *const BuildConfig) Self {
    const module = config.b.createModule(.{
        .root_source_file = config.b.path("src/main_module.zig"),
        .target = config.target,
        .optimize = config.optimize,
    });

    return Self{
        .module = module,
    };
}

/// Links the Manatee Engine Zig module to the provided Zig Build Step with a root module import
/// named `"manatee"`.
pub fn linkToStep(self: *const Self, step: *std.Build.Step.Compile) void {
    step.root_module.addImport("manatee", self.module);
}
