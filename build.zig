const builtin = @import("builtin");
const std = @import("std");

const manatee_build = @import("src/build/main.zig");

pub fn build(b: *std.Build) !void {
    // Setup Config and Manatee Zig Module
    const build_config = manatee_build.BuildConfig.init(b);
    const engine_module = manatee_build.ManateeEngineModule.init(&build_config);
    var build_context = manatee_build.BuildContext.init(&build_config, &engine_module);

    const editor_exe = manatee_build.ManateeEditorExe.init(&build_config);

    build_context.linkCheckedStep(&editor_exe);
}
