const std = @import("std");
const lex = @import("lexer.zig");
const fls = @import("files.zig");
const prt = @import("print.zig");

const stdout = std.io.getStdOut().writer();

pub fn main() anyerror!void {
    const a = std.heap.page_allocator;

    const args = try std.process.argsAlloc(a);
    defer a.free(args);

    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer alloc.deinit();

    if (args.len > 1) {
        var fileName = args[1];
        var fileContent = try fls.returnContent(fileName, alloc.allocator());
        var listOfTokens = try lex.lexer(fileContent, alloc.allocator());

        try prt.printJSON(listOfTokens);
    } else {
        try stdout.print("No files provided\n", .{});
    }
}
