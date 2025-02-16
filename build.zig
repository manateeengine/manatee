const builtin = @import("builtin");
const std = @import("std");

const manatee_build = @import("src/build/main.zig");

pub fn build(b: *std.Build) !void {
    // Setup Config and Manatee Zig Module
    const build_config = manatee_build.BuildConfig.init(b);
    const engine_module = manatee_build.ManateeEngineModule.init(&build_config);
    var build_context = manatee_build.BuildContext.init(&build_config, &engine_module);

    const editor_exe = manatee_build.ManateeEditorExe.init(&build_config);
    const engine_lib = manatee_build.ManateeEngineLib.init(&build_config);

    build_context.linkCheckedStep(&editor_exe);
    build_context.linkCheckedStep(&engine_lib);

    // Currently this generates docs only for the editor exe. This should probably be for the lib
    // instead, but I don't know enough about writing those to be comfortable using that, so I'm
    // settling on using the exe until I know better!
    _ = manatee_build.ManateeEngineDocs.init(&build_config, &editor_exe);
    _ = manatee_build.ManateeEngineTests.init(&build_config);
}
