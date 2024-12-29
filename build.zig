const builtin = @import("builtin");
const std = @import("std");

// Manatee is composed of three main pieces, all defined in the below build function:
// 1. A Zig package that can be used in existing Zig codebase (named "manatee")
// 2. A static library that can be used in any other language (named "manatee-lib")
// 3. A game / map editor, compiled to an executable (named "manatee-editor")
// As a note, the static lib and editor exe will be duplicated in the build script with suffix
// "_check" in order to get more useful information from ZLS. For more information as to why this
// is done, see https://zigtools.org/zls/guides/build-on-save

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Get All Environment Variables (We'll use these later to link the Vulkan SDK)
    const env_map = try std.process.getEnvMap(b.allocator);

    // Setup Zig Module
    const module = b.addModule("manatee", .{
        .root_source_file = b.path("src/manatee.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Setup Static Lib
    const lib = b.addStaticLibrary(.{
        .name = "manatee",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    const lib_check = b.addStaticLibrary(.{
        .name = "manatee",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Setup Editor Exe
    const exe = b.addExecutable(.{
        .name = "manatee-editor",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const exe_check = b.addExecutable(.{
        .name = "manatee-editor",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Add Vulkan SDK Paths to Library / Include Paths
    if (env_map.get("VK_SDK_PATH")) |path| {
        module.addLibraryPath(.{ .cwd_relative = try std.fmt.allocPrint(b.allocator, "{s}/lib", .{path}) });
        module.addIncludePath(.{ .cwd_relative = try std.fmt.allocPrint(b.allocator, "{s}/include", .{path}) });
    } else {
        std.debug.panic("Env var VK_SDK_PATH not found. Please ensure you've installed the Vulkan SDK and added it to your PATH", .{});
    }

    // Link System-Specific Libraries to Module
    switch (builtin.os.tag) {
        .macos => {
            module.linkSystemLibrary("objc", .{});
            module.linkFramework("AppKit", .{});
            module.linkFramework("Metal", .{});
            // If I try to link Vulkan, everything breaks, but linking MoltenVK by itself works
            module.linkSystemLibrary("MoltenVK", .{});
        },
        .windows => {
            const zigwin32 = b.dependency("zigwin32", .{});
            module.addImport("zigwin32", zigwin32.module("zigwin32"));

            // This is only added so ZLS autocomplete will actually work lol
            exe_check.root_module.addImport("zigwin32", zigwin32.module("zigwin32"));
            exe.root_module.addImport("zigwin32", zigwin32.module("zigwin32"));

            module.linkSystemLibrary("vulkan-1", .{});
        },
        else => {},
    }

    // Add Module to Exe
    exe.root_module.addImport("manatee", module);
    exe_check.root_module.addImport("manatee", module);

    // Add Module to Lib
    lib.root_module.addImport("manatee", module);
    lib_check.root_module.addImport("manatee", module);

    // Setup Check Step
    const check = b.step("check", "Check Compilation for ZLS");
    check.dependOn(&lib_check.step);
    check.dependOn(&exe_check.step);

    // Setup Install Step
    b.installArtifact(lib);
    b.installArtifact(exe);

    // Setup Run Step
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the Manatee editor");
    run_step.dependOn(&run_cmd.step);

    // Setup Test Step
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/manatee.zig"),
        .target = target,
        .optimize = optimize,
    });

    const test_cmd = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&test_cmd.step);
}
