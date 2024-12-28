//! All relevant headers from the Objective-C Runtime

pub const MTLDevice = opaque {};

pub extern fn MTLCreateSystemDefaultDevice() ?*MTLDevice;
