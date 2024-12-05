//! All relevant headers from the Windows SDK
//!
//! Note: Although Manatee has a rule of never using 3rd party packages, this file is an exception.
//! Normally, I'd import the system headers and build a more idiomatic abstraction from there. This
//! is the pattern that I used to build `macos.zig`. Unfortunately, Zig is unable to compile
//! windows.zig when imported, so we're stuck at a bit of an impasse here. Because of this issue,
//! this file brings in the package zig-win32 and exports the subset of that package that's
//! required for Manatee. I generally trust this package, as it's generated based off of
//! reference material created by Microsoft, however it's still massively bloated and I'd love to
//! eventually remove it so Manatee can maintain the same pattern across operating systems.

// TODO: Replace this with the same pattern found in objective_c_runtime/c.zig once Zig can handle
// importing windows.h without compile errors, for now I'll keep using Zigwin32 though
const zigwin32 = @import("zigwin32");

pub usingnamespace zigwin32;
