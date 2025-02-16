//! Context for the Manatee Build System.
//!
//! ## Remarks
//! This handles the creation of build steps for Manatee, including setting up check steps for all
//! given outputs.

const std = @import("std");

const BuildConfig = @import("BuildConfig.zig");
const CheckedStep = @import("CheckedStep.zig");
const ManateeEngineModule = @import("ManateeEngineModule.zig");

const Self = @This();

/// A Zig Build Step used by the Zig VS Code extension to check compilation on-save.
check_step: *std.Build.Step,
/// A pointer to the Manatee Build Config.
config: *const BuildConfig,
/// A pointer to the Manatee Engine Zig Module.
engine_module: *const ManateeEngineModule,
/// A Zig Build Step used to run the Manatee editor.
run_step: *std.Build.Step,
/// A Zig Build Step used to run Manatee's unit tests.
test_step: *std.Build.Step,

/// Creates a `BuildContext` with the specified `BuildConfig` pointer.
pub fn init(config: *const BuildConfig, engine_module: *const ManateeEngineModule) Self {
    const check_step = config.b.step(
        "check",
        "Used by the Zig VS Code extension to check compilation on-save.",
    );

    const run_step = config.b.step(
        "run",
        "Runs the Manatee editor",
    );

    const tests = config.b.addTest(.{
        .root_source_file = config.b.path("src/main_module.zig"),
        .target = config.target,
        .optimize = config.optimize,
    });

    const test_cmd = config.b.addRunArtifact(tests);
    const test_step = config.b.step(
        "test",
        "Runs Manatee's Test Suite",
    );
    test_step.dependOn(&test_cmd.step);

    return Self{
        .check_step = check_step,
        .config = config,
        .engine_module = engine_module,
        .run_step = run_step,
        .test_step = test_step,
    };
}

/// Links a `CheckedStep` to the context's check and run steps.
pub fn linkCheckedStep(self: *Self, checked_step: *const CheckedStep) void {
    self.config.b.installArtifact(checked_step.step);

    self.config.linkSharedDependencies(checked_step.step);
    self.config.linkSharedDependencies(checked_step.step_check);
    self.engine_module.linkToStep(checked_step.step);
    self.engine_module.linkToStep(checked_step.step_check);

    if (checked_step.step.kind == .exe) {
        const run_cmd = self.config.b.addRunArtifact(checked_step.step);
        if (self.config.b.args) |args| {
            run_cmd.addArgs(args);
        }
        self.run_step.dependOn(&run_cmd.step);
    }
}
