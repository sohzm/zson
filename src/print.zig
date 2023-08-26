const std = @import("std");
const ZLexer = @import("lexer.zig");
const fmt = @import("format.zig");

const stdout = std.io.getStdOut().writer();

const indentLen: u32 = 4;

pub fn printJSON(tokenArr: []ZLexer.Token) !void {
    var indents: u32 = 0;
    var before: bool = false;
    for (tokenArr) |element| {
        try stdout.print("{s}", .{fmt.reset});
        if (element.token == ZLexer.token.ARRAY_OPEN or element.token == ZLexer.token.OBJECT_OPEN) {
            indents += 1;
            before = true;
            try stdout.print("{s}{s}\n", .{ fmt.bold, element.value });
            try printIndent(indents);
            continue;
        }
        if (element.token == ZLexer.token.ARRAY_CLOSE or element.token == ZLexer.token.OBJECT_CLOSE) {
            indents -= 1;
            try stdout.print("\n", .{});
            try printIndent(indents);
            try stdout.print("{s}{s}", .{ fmt.bold, element.value });
            continue;
        }
        if (element.token == ZLexer.token.STRING) {
            if (before) {
                try stdout.print("{s}{s}{s}", .{ fmt.bold, fmt.blue, element.value });
            } else {
                try stdout.print("{s}{s}", .{ fmt.green, element.value });
            }
            continue;
        }
        if (element.token == ZLexer.token.NUMBER) {
            try stdout.print("{s}{s}", .{ fmt.cyan, element.value });
            continue;
        }
        if (element.token == ZLexer.token.NULL_VALUE) {
            try stdout.print("{s}{s}", .{ fmt.magenta, element.value });
            continue;
        }
        if (element.token == ZLexer.token.BOOL_VALUE) {
            try stdout.print("{s}{s}", .{ fmt.red, element.value });
            continue;
        }
        if (element.token == ZLexer.token.EQUAL) {
            before = false;
            try stdout.print("{s}: ", .{fmt.bold});
            continue;
        }
        if (element.token == ZLexer.token.SEPARATOR) {
            before = true;
            try stdout.print("{s},\n", .{fmt.bold});
            try printIndent(indents);
            continue;
        }
    }
    try stdout.print("{s}\n", .{fmt.reset});
}

fn printIndent(indents: u32) !void {
    const num = indents * indentLen;
    var i: usize = 0;
    while (i < num) : (i += 1) {
        try stdout.print(" ", .{});
    }
}
