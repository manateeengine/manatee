//! All relevant headers from the Objective-C Runtime

pub const c = @cImport({
    @cInclude("objc/objc-runtime.h");
});

pub usingnamespace c;
