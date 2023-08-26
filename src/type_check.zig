const ZLexer = @import("lexer.zig");
const std = @import("std");
const ArrayList = std.ArrayList;

pub const values = enum {
    NUMBER,
    STRING,
    NULL_VALUE,
    BOOL_VALUE,
    OBJECT,
    ARRAY,
};

pub const paren = enum {};

pub fn checkParens(tokens: []ZLexer.Token) !bool {
    var i: usize = 0;
    var len = tokens.len;

    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer alloc.deinit();
    var list = ArrayList(ZLexer.token).init(alloc.allocator());

    while (i < len) {
        if (tokens[i].token == ZLexer.token.ARRAY_OPEN or tokens[i].token == ZLexer.token.OBJECT_OPEN) {
            try list.append(tokens[i].token);
        }
        if (tokens[i].token == ZLexer.token.OBJECT_CLOSE) {
            if (list.items[list.items.len - 1] == ZLexer.token.OBJECT_OPEN) {
                try list.pop();
            } else {
                return false;
            }
        }
        if (tokens[i].token == ZLexer.token.ARRAY_CLOSE) {
            if (list.items[list.items.len - 1] == ZLexer.token.ARRAY_OPEN) {
                try list.pop();
            } else {
                return false;
            }
        }
    }
    return true;
}

pub fn checkObject(tokens: []ZLexer.Token) bool {
    var i: usize = 0;
    var len = tokens.len;

    // Check if the first token is an object open brace
    if (len == 0 or (tokens[i].token != .OBJECT_OPEN)) {
        return false;
    }
    i += 1;

    // Loop through the tokens and check if they follow the correct syntax
    while (i < len) {
        // Check if the token is a string
        if (tokens[i].token != .STRING) {
            return false;
        }
        i += 1;

        // Check if the token is a colon
        if (i >= len or (tokens[i].token != .EQUAL)) {
            return false;
        }
        i += 1;

        // Check if the token is a value (string, number, boolean, null, or object/array)
        if (i >= len) {
            return false;
        }
        var token = tokens[i].token;
        if ((token != .STRING) and (token != .NUMBER) and (token != .BOOL_VALUE) and (token != .NULL_VALUE) and (token != .OBJECT_OPEN) and (token != .ARRAY_OPEN)) {
            return false;
        }
        i += 1;

        // Check if the token is a separator or object close brace
        if (i >= len) {
            return false;
        }
        token = tokens[i].token;
        if (token == .OBJECT_CLOSE) {
            return true;
        } else if (token != .SEPARATOR) {
            return false;
        }
        i += 1;
    }

    // If we reach the end of the tokens without finding a closing brace, it's not a valid object
    return false;
}
