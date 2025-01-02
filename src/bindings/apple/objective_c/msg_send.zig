const std = @import("std");

const Sel = @import("sel.zig").Sel;

/// Sends a message with a simple return value to an instance of a class.
/// See:
///
/// This function contains a lot of additional supporting code in order to make it work properly
/// with Zig's typing system. For more information, see `BuildMsgSendFnType` below
pub fn msgSend(target: anytype, comptime ReturnType: type, sel: *Sel, args: anytype) ReturnType {
    // We still have a couple more steps before we can call the actual objc_msgSend function. The
    // next thing on our list is to create a Zig-compatible typing for our function by calling our
    // helper function `BuildMsgSendFnType` (what a mouthful, but at least you know what the helper
    // does!)
    const MsgSendFnType = BuildMsgSendFnType(ReturnType, @TypeOf(target), @TypeOf(args));

    // Other Zig Objective-C wrappers support both x86_64 (Intel-based machines) and aarch64 (Apple
    // Silicone-based machines). Given the fact that Apple won't be releasing anymore new machines
    // with Intel CPUs (hopefully), and the lack of gaming power for Intel-based Macs, I'm making
    // the executive decision to only support aarch64. This has the added benefit of significantly
    // reducing the complexity of calling objc_msgSend, as with x86_64 machines, objc_msgSend
    // actually has multiple different pointers based on the desired return type, which is
    // awful. Anyway, let's grab the pointer to that function.
    const msg_send_ptr: *const MsgSendFnType = comptime @ptrCast(&objc_msgSend);

    // We have the pointer to objc_msgSend, and we have our return type, now let's use Zig's
    // `@call` functionality to override the incompatible C AST typings and call that function!
    const res = @call(.auto, msg_send_ptr, .{ target, sel } ++ args);

    return res;
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
fn BuildMsgSendFnType(comptime ReturnType: type, comptime TargetType: type, comptime ArgsType: type) type {
    // Target for objc_msgSend must be of Objective-C type "id", which can be a plethora of
    // different Objective-C types under the hood, such as `Class`, `Object`, etc.
    // Because of this case, let's start off by asserting that TargetType is the same size as
    // Objective-C's id type
    // std.debug.assert(@sizeOf(TargetType) == @sizeOf(c.id));

    // Args for objc_msgSend can only be a tuple, so let's assert that since args is AnyType
    const args_type_info = @typeInfo(ArgsType).@"struct";
    std.debug.assert(args_type_info.is_tuple);

    // Now that we've double checked our inputs, let's build our arg types
    const FnType = std.builtin.Type.Fn;
    const params: []FnType.Param = params: {
        // Let's set up an array of parameters with a length of target + selector + all other args
        var params_arr: [args_type_info.fields.len + 2]FnType.Param = undefined;

        // The first param of objc_msgSend will always be the target type
        params_arr[0] = .{ .is_generic = false, .is_noalias = false, .type = TargetType };

        // The second param of objc_msgSend will always be a raw Objective-C selector
        params_arr[1] = .{ .is_generic = false, .is_noalias = false, .type = *Sel };

        // All remaining params will be based off of the args provided, in the exact order of the
        // tuple
        for (args_type_info.fields, 0..) |field, i| {
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

// Note: Typings for this external function are intentionally sparse. See the above comments in
// msgSend for more information
extern "c" fn objc_msgSend() callconv(.c) void;
