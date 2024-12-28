//! All relevant headers from the Objective-C Runtime
//! TODO: This should probably be hand-maintained for now, as Zig's @cImport support is flaky at
//! best and we can't use this strategy on other operating systems, such as Windows

pub const c = @cImport({
    @cInclude("objc/objc-runtime.h");
});

pub usingnamespace c;
