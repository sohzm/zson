const std = @import("std");
const files = @import("files.zig");

const log = std.log;
const eql = std.mem.eql;
const ArrayList = std.ArrayList;

pub const token = enum { num, eq, string, braceO, braceC, bracketO, bracketC, separator, nullValue, boolValue };

pub const Token = struct {
    token: token,
    value: []u8,
};

pub fn lexer(text: []u8, alloc: std.mem.Allocator) ![]Token {
    log.info("Lexer started", .{});

    var list = ArrayList(Token).init(alloc);

    var i: usize = 0;
    var last: usize = 0;
    var size: usize = text.len;
    var lineNumber: usize = 1;
    var lastNextLine: usize = 0;

    while (i < size) {
        if (isWhitespace(text[i])) {
            var flag = eql(u8, text[i .. i + 1], "\n");
            if (flag) {
                lineNumber += 1;
                lastNextLine = i;
            }
            i += 1;
        } else if (isCurly(text[i])) {
            if (text[i] == '{') {
                try list.append(.{ .token = token.braceO, .value = text[i .. i + 1] });
            } else {
                try list.append(.{ .token = token.braceC, .value = text[i .. i + 1] });
            }
            i += 1;
        } else if (isSquare(text[i])) {
            if (text[i] == '[') {
                try list.append(.{ .token = token.bracketO, .value = text[i .. i + 1] });
            } else {
                try list.append(.{ .token = token.bracketC, .value = text[i .. i + 1] });
            }
            i += 1;
        } else if (isEqual(text[i])) {
            try list.append(.{ .token = token.eq, .value = text[i .. i + 1] });
            i += 1;
        } else if (isSeparator(text[i])) {
            try list.append(.{ .token = token.separator, .value = text[i .. i + 1] });
            i += 1;
        } else if (isDigit(text[i])) {
            last = i;
            while (isDigit(text[i])) {
                i += 1;
            }
            try list.append(.{ .token = token.num, .value = text[last..i] });
        } else if (isString(text[i])) {
            last = i;
            i += 1;
            while (!isString(text[i])) {
                if (eql(u8, text[i .. i + 1], "\\")) {
                    i += 1;
                }
                i += 1;
            }
            i += 1;
            try list.append(.{ .token = token.string, .value = text[last..i] });
        } else if (isBoolean(text[i])) {
            var flag1 = eql(u8, text[i .. i + 4], "true");
            var flag2 = eql(u8, text[i .. i + 5], "false");
            if (flag1) {
                try list.append(.{ .token = token.boolValue, .value = text[i .. i + 4] });
                i += 4;
            } else if (flag2) {
                try list.append(.{ .token = token.boolValue, .value = text[i .. i + 5] });
                i += 5;
            } else {
                log.err("Illegal syntax: '{c}' at line: {}, column: {}", .{ text[i], lineNumber, (i - lastNextLine) });
                std.os.exit(1);
                std.os.exit(1);
            }
        } else if (isEmpty(text[i])) {
            var flag = eql(u8, text[i .. i + 4], "null");
            if (flag) {
                try list.append(.{ .token = token.nullValue, .value = text[i .. i + 4] });
                i += 4;
            } else {
                log.err("Illegal syntax: '{c}' at line: {}, column: {}", .{ text[i], lineNumber, (i - lastNextLine) });
                std.os.exit(1);
            }
        } else {
            log.err("Illegal syntax: '{c}' at line: {}, column: {}", .{ text[i], lineNumber, (i - lastNextLine) });
            std.os.exit(1);
        }
    }

    log.info("Lexer Finished without errors", .{});
    return list.toOwnedSlice();
}

fn isDigit(char: u8) bool {
    var flag: bool = (char == '.') or (char == '-') or ((char >= '0') and (char <= '9'));
    if (flag)
        return true;
    return false;
}

fn isWhitespace(char: u8) bool {
    var flag: bool = (char == ' ') or (char == '\n') or (char == '\t') or (char == '\r');
    if (flag)
        return true;
    return false;
}

fn isCurly(char: u8) bool {
    var flag: bool = (char == '{') or (char == '}');
    if (flag)
        return true;
    return false;
}

fn isSquare(char: u8) bool {
    var flag: bool = (char == '[') or (char == ']');
    if (flag)
        return true;
    return false;
}

fn isString(char: u8) bool {
    // should single quote (') also be considered string?
    var flag: bool = char == '"';
    if (flag)
        return true;
    return false;
}

fn isBoolean(char: u8) bool {
    var flag: bool = (char == 't') or (char == 'f');
    if (flag)
        return true;
    return false;
}

fn isEqual(char: u8) bool {
    var flag: bool = char == ':';
    if (flag)
        return true;
    return false;
}

fn isSeparator(char: u8) bool {
    var flag: bool = char == ',';
    if (flag)
        return true;
    return false;
}

fn isEmpty(char: u8) bool {
    var flag: bool = char == 'n';
    if (flag)
        return true;
    return false;
}
