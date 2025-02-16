//! Zig Build System Configuration for the Manatee Engine lib.

const BuildConfig = @import("BuildConfig.zig");
const CheckedStep = @import("CheckedStep.zig");

const Self = @This();

/// Creates a `CheckedStep` for the Manatee Engine Lib with the specified `BuildConfig` pointer.
pub fn init(config: *const BuildConfig) CheckedStep {
    const step_name: []const u8 = "manatee-editor";
    const step_root_source_file = config.b.path("src/main_lib.zig");

    const step = config.b.addExecutable(.{
        .name = step_name,
        .root_source_file = step_root_source_file,
        .target = config.target,
        .optimize = config.optimize,
    });

    const step_check = config.b.addExecutable(.{
        .name = step_name,
        .root_source_file = step_root_source_file,
        .target = config.target,
        .optimize = config.optimize,
    });

    return CheckedStep{
        .step = step,
        .step_check = step_check,
    };
}
