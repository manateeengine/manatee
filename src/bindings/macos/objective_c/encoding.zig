//! SHAMELESSLY copied from Mitchell Hashimoto's zig-objc, will rewrite this from scratch in the
//! future to follow Manatee's model of "zero dependencies" but also to learn how it works

const std = @import("std");

const c = @import("c.zig");
const Class = @import("class.zig").Class;
const Object = @import("object.zig").Object;
const Protocol = @import("protocol.zig").Protocol;
const Sel = @import("sel.zig").Sel;

/// Encoding union which parses type information and turns it into Obj-C
/// runtime Type Encodings.
///
/// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
pub const Encoding = union(enum) {
    char,
    int,
    short,
    long,
    longlong,
    uchar,
    uint,
    ushort,
    ulong,
    ulonglong,
    float,
    double,
    bool,
    void,
    char_string,
    object,
    class,
    selector,
    array: struct { arr_type: type, len: usize },
    structure: struct { struct_type: type, show_type_spec: bool },
    @"union": struct { union_type: type, show_type_spec: bool },
    bitfield: u32,
    pointer: struct { ptr_type: type, size: std.builtin.Type.Pointer.Size },
    function: std.builtin.Type.Fn,
    unknown,

    pub fn init(comptime T: type) Encoding {
        return switch (T) {
            i8, c_char => .char,
            c_short => .short,
            i32, c_int => .int,
            c_long => .long,
            i64, c_longlong => .longlong,
            u8 => .uchar,
            c_ushort => .ushort,
            u32, c_uint => .uint,
            c_ulong => .ulong,
            u64, c_ulonglong => .ulonglong,
            f32 => .float,
            f64 => .double,
            bool => .bool,
            void, anyopaque => .void,
            ?*anyopaque, ?*const anyopaque, *anyopaque, *const anyopaque => .{ .pointer = .{ .ptr_type = void, .size = .One } },
            [*c]u8,
            [*c]const u8,
            [*]u8,
            [*:0]u8,
            [*]const u8,
            [*:0]const u8,
            ?[*]u8,
            ?[*:0]u8,
            ?[*]const u8,
            ?[*:0]const u8,
            => .char_string,
            *c.SEL, ?*Sel => .selector,
            *c.Class, ?*Class, *c.Protocol, ?*Protocol => .class,
            *c.id, ?*Object => .object,
            else => switch (@typeInfo(T)) {
                .array => |arr| .{ .array = .{ .len = arr.len, .arr_type = arr.child } },
                .@"struct" => |str| if (str.backing_integer) |S| Encoding.init(S) else .{ .structure = .{ .struct_type = T, .show_type_spec = true } },
                .@"union" => .{ .@"union" = .{
                    .union_type = T,
                    .show_type_spec = true,
                } },
                .pointer => |ptr| ptr: {
                    const child_info = @typeInfo(ptr.child);
                    if (child_info == .Opaque and @hasDecl(ptr.child, "encoding")) break :ptr ptr.child.encoding();
                    break :ptr .{ .pointer = .{ .ptr_type = T, .size = ptr.size } };
                },
                .@"fn" => |fn_info| .{ .function = fn_info },
                .@"enum" => |enum_info| Encoding.init(enum_info.tag_type),
                else => @compileError("unsupported type: " ++ @typeName(T)),
            },
        };
    }

    pub fn format(
        comptime self: Encoding,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        switch (self) {
            .char => try writer.writeAll("c"),
            .int => try writer.writeAll("i"),
            .short => try writer.writeAll("s"),
            .long => try writer.writeAll("l"),
            .longlong => try writer.writeAll("q"),
            .uchar => try writer.writeAll("C"),
            .uint => try writer.writeAll("I"),
            .ushort => try writer.writeAll("S"),
            .ulong => try writer.writeAll("L"),
            .ulonglong => try writer.writeAll("Q"),
            .float => try writer.writeAll("f"),
            .double => try writer.writeAll("d"),
            .bool => try writer.writeAll("B"),
            .void => try writer.writeAll("v"),
            .char_string => try writer.writeAll("*"),
            .object => try writer.writeAll("@"),
            .class => try writer.writeAll("#"),
            .selector => try writer.writeAll(":"),
            .array => |a| {
                try writer.print("[{}", .{a.len});
                const encode_type = init(a.arr_type);
                try encode_type.format(fmt, options, writer);
                try writer.writeAll("]");
            },
            .structure => |s| {
                const struct_info = @typeInfo(s.struct_type);
                std.debug.assert(struct_info.Struct.layout == .@"extern");

                // Strips the fully qualified type name to leave just the
                // type name. Used in naming the Struct in an encoding.
                var type_name_iter = std.mem.splitBackwardsScalar(u8, @typeName(s.struct_type), '.');
                const type_name = type_name_iter.first();
                try writer.print("{{{s}", .{type_name});

                // if the encoding should show the internal type specification
                // of the struct (determined by levels of pointer indirection)
                if (s.show_type_spec) {
                    try writer.writeAll("=");
                    inline for (struct_info.Struct.fields) |field| {
                        const field_encode = init(field.type);
                        try field_encode.format(fmt, options, writer);
                    }
                }

                try writer.writeAll("}");
            },
            .@"union" => |u| {
                const union_info = @typeInfo(u.union_type);
                std.debug.assert(union_info.Union.layout == .@"extern");

                // Strips the fully qualified type name to leave just the
                // type name. Used in naming the Union in an encoding
                var type_name_iter = std.mem.splitBackwardsScalar(u8, @typeName(u.union_type), '.');
                const type_name = type_name_iter.first();
                try writer.print("({s}", .{type_name});

                // if the encoding should show the internal type specification
                // of the Union (determined by levels of pointer indirection)
                if (u.show_type_spec) {
                    try writer.writeAll("=");
                    inline for (union_info.Union.fields) |field| {
                        const field_encode = init(field.type);
                        try field_encode.format(fmt, options, writer);
                    }
                }

                try writer.writeAll(")");
            },
            .bitfield => |b| try writer.print("b{}", .{b}), // not sure if needed from Zig -> Obj-C
            .pointer => |p| {
                switch (p.size) {
                    .One => {
                        // get the pointer info (count of levels of direction
                        // and the underlying type)
                        const pointer_info = indirectionCountAndType(p.ptr_type);
                        for (0..pointer_info.indirection_levels) |_| {
                            try writer.writeAll("^");
                        }

                        // create a new Encoding union from the pointers child
                        // type, giving an encoding of the underlying pointer type
                        comptime var encoding = init(pointer_info.child);

                        // if the indirection levels are greater than 1, for
                        // certain types that means getting rid of it's
                        // internal type specification
                        //
                        // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100
                        if (pointer_info.indirection_levels > 1) {
                            switch (encoding) {
                                .structure => |*s| s.show_type_spec = false,
                                .@"union" => |*u| u.show_type_spec = false,
                                else => {},
                            }
                        }

                        // call this format function again, this time with the child type encoding
                        try encoding.format(fmt, options, writer);
                    },
                    else => @compileError("Pointer size not supported for encoding"),
                }
            },
            .function => |fn_info| {
                // Return type is first in a method encoding
                const ret_type_enc = init(fn_info.return_type.?);
                try ret_type_enc.format(fmt, options, writer);
                inline for (fn_info.params) |param| {
                    const param_enc = init(param.type.?);
                    try param_enc.format(fmt, options, writer);
                }
            },
            .unknown => {},
        }
    }
};

/// This comptime function gets the levels of indirection from a type. If the type is a pointer type it
/// returns the underlying type from the pointer (the child) by walking the pointer to that child.
/// Returns the type and 0 for count if the type isn't a pointer
fn indirectionCountAndType(comptime T: type) struct {
    child: type,
    indirection_levels: comptime_int,
} {
    var WalkType = T;
    var count: usize = 0;
    while (@typeInfo(WalkType) == .Pointer) : (count += 1) {
        WalkType = @typeInfo(WalkType).Pointer.child;
    }

    return .{ .child = WalkType, .indirection_levels = count };
}

fn getComptimeStringSize(comptime T: type) usize {
    comptime {
        const encoding = Encoding.init(T);
        // Figure out how much space we need
        var counting = std.io.countingWriter(std.io.null_writer);
        try std.fmt.format(counting.writer(), "{}", .{encoding});
        return counting.bytes_written;
    }
}

/// Encode a type into a comptime string.
pub fn encodeTypeToComptimeString(comptime T: type) [getComptimeStringSize(T):0]u8 {
    comptime {
        const encoding = Encoding.init(T);

        // Build our final signature
        var buf: [getComptimeStringSize(T) + 1]u8 = undefined;
        var fbs = std.io.fixedBufferStream(buf[0 .. buf.len - 1]);
        try std.fmt.format(fbs.writer(), "{}", .{encoding});
        buf[buf.len - 1] = 0;

        return buf[0 .. buf.len - 1 :0].*;
    }
}
