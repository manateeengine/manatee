//! Zig function wrappers for all functions prefixed by `objc_` in the Objective-C Runtime.
//!
//! Note: the following methods have not yet been implemented as they haven't been required for
//! Manatee functionality:
//!
//! * `objc_allocateClassPair`
//! * `objc_disposeClassPair`
//! * `objc_registerClassPair`
//! * `objc_duplicateClass`
//! * `objc_getClassList`
//! * `objc_copyClassList`
//! * `objc_lookUpClass`
//! * `objc_getClass`
//! * `objc_getRequiredClass`
//! * `objc_getMetaClass`
//! * `objc_setAssociatedObject`
//! * `objc_getAssociatedObject`
//! * `objc_removeAssociatedObjects`
//! * `objc_copyImageNames`
//! * `objc_copyClassNamesForImage`
//! * `objc_getProtocol`
//! * `objc_copyProtocolList`
//! * `objc_allocateProtocol`
//! * `objc_registerProtocol`
//! * `objc_enumerateMutation`
//! * `objc_setEnumerationMutationHandler`
//! * `objc_loadWeak`
//! * `objc_storeWeak`

const std = @import("std");

const c = @import("c.zig");
const Class = @import("class.zig").Class;
const Object = @import("object.zig").Object;
const Sel = @import("sel.zig").Sel;

/// Sends a message with a simple return value to an instance of a class.
/// See:
///
/// This function contains a lot of additional supporting code in order to make it work properly
/// with Zig's typing system. That code can be found in `./msg_send.zig`.
pub fn msgSend(target: anytype, comptime ReturnType: type, raw_sel: anytype, args: anytype) ReturnType {
    // The Objective-C runtime docs note that selectors must use the value returned from the
    // sel_registerName function rather than a string. In order to build a better DX, we're going
    // to allow strings to be passed into our objc_msgSend wrapper, and handle converting them into
    // SEL names when calling the function. To do this, we'll call Sel.registerName for anything
    // passed into here that's not already of type `Sel`
    const sel: Sel = switch (@TypeOf(raw_sel)) {
        Sel => raw_sel,
        else => Sel.registerName(raw_sel),
    };

    // Since we're following Mitchell Hashimoto's pattern of storing Objective-C internal values in
    // structs, we'll have a special case if one of our objects is passed into ReturnType. To
    // compensate for this, we'll have to modify our return type if ReturnType is `Object`
    const is_object = ReturnType == Object;
    const ParsedReturnType = if (is_object) c.id else ReturnType;

    // We still have a couple more steps before we can call the actual objc_msgSend function. The
    // next thing on our list is to create a Zig-compatible typing for our function by calling our
    // helper function `BuildMsgSendFnType` (what a mouthful, but at least you know what the helper
    // does!)
    const MsgSendFnType = BuildMsgSendFnType(ParsedReturnType, @TypeOf(target.value), @TypeOf(args));

    // Other Zig Objective-C wrappers support both x86_64 (Intel-based machines) and aarch64 (Apple
    // Silicone-based machines). Given the fact that Apple won't be releasing anymore new machines
    // with Intel CPUs (hopefully), and the lack of gaming power for Intel-based Macs, I'm making
    // the executive decision to only support aarch64. This has the added benefit of significantly
    // reducing the complexity of calling objc_msgSend, as with x86_64 machines, objc_msgSend
    // actually has multiple different pointers based on the desired return type, which is
    // awful. Anyway, let's grab the pointer to that function.
    const msg_send_ptr: *const MsgSendFnType = comptime @ptrCast(&c.objc_msgSend);

    // We have the pointer to objc_msgSend, and we have our return type, now let's use Zig's
    // `@call` functionality to override the incompatible C AST typings and call that function!
    const res = @call(.auto, msg_send_ptr, .{ target.value, sel.value } ++ args);

    if (is_object) {
        return .{ .value = res };
    }
    return res;
}

/// Returns the class definition of a specified class.
/// See: https://developer.apple.com/documentation/objectivec/1418952-objc_getclass
pub fn getClass(name: []const u8) Class {
    return Class{
        .value = c.objc_getClass(name.ptr),
    };
}

/// Creates a Zig-compatible function body typing for objc_msgSend based off of the provided return
/// type, target type, and additional args type
///
/// This is where my lack of traditional computer science knowledge really starts to fuck with me.
/// From all of the research I've done, objc_msgSend has to be called via the C ABI. This creates
/// a huge headache for me since I can't simply call this like any other C function wrapped in
/// Zig. This code was heavily inspired by both objz and zig-objectivec, and realistically is a
/// healthy mix of both approaches, as well as various StackOverflow posts regarding writing MacOS
/// desktop apps in native C.
pub fn BuildMsgSendFnType(comptime ReturnType: type, comptime TargetType: type, comptime ArgsType: type) type {
    // Target for objc_msgSend must be of Objective-C type "id", which can be a plethora of
    // different Objective-C types under the hood, such as `Class`, `Object`, etc.
    // Because of this case, let's start off by asserting that TargetType is the same size as
    // Objective-C's id type
    std.debug.assert(@sizeOf(TargetType) == @sizeOf(c.id));

    // Args for objc_msgSend can only be a tuple, so let's assert that since args is AnyType
    const argsTypeInfo = @typeInfo(ArgsType).@"struct";
    std.debug.assert(argsTypeInfo.is_tuple);

    // Now that we've double checked our inputs, let's build our arg types
    const FnType = std.builtin.Type.Fn;
    const params: []FnType.Param = params: {
        // Let's set up an array of parameters with a length of target + selector + all other args
        var params_arr: [argsTypeInfo.fields.len + 2]FnType.Param = undefined;

        // The first param of objc_msgSend will always be the target type
        params_arr[0] = .{ .is_generic = false, .is_noalias = false, .type = TargetType };

        // The second param of objc_msgSend will always be a raw Objective-C selector
        params_arr[1] = .{ .is_generic = false, .is_noalias = false, .type = c.SEL };

        // All remaining params will be based off of the args provided, in the exact order of the
        // tuple
        for (argsTypeInfo.fields, 0..) |field, i| {
            params_arr[i + 2] = .{
                .type = field.type,
                .is_generic = false,
                .is_noalias = false,
            };
        }

        break :params &params_arr;
    };

    // Now that we have our function type and params figured out, let's build our final typing
    return @Type(.{
        .@"fn" = .{
            .calling_convention = .C,
            .is_generic = false,
            .is_var_args = false,
            .return_type = ReturnType,
            .params = params,
        },
    });
}
