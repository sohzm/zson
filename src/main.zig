const std = @import("std");
const lex = @import("lexer.zig");
const fls = @import("files.zig");
const prt = @import("print.zig");
const arg = @import("args.zig");

const stdout = std.io.getStdOut().writer();

pub fn main() anyerror!void {
    const a = std.heap.page_allocator;

    const args = try std.process.argsAlloc(a);
    var arguments = arg.argsStruct{
        .uwu = false,
        .color = true,
        .compact = false,
        .argsError = false,
        .options = arg.options{
            .help = false,
            .version = false,
        },
    };
    try arg.mainArgs(args, &arguments);
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
