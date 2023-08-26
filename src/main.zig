const std = @import("std");

const ZLexer = @import("lexer.zig");
const ZFiles = @import("files.zig");
const ZPrint = @import("print.zig");
const ZArgs = @import("args.zig");
const ZTypeCheck = @import("type_check.zig");

const stdout = std.io.getStdOut().writer();

// json explorer, like ranger but for json
var arguments = ZArgs.argsStruct{
    .argsError = false,
    .compact = false,
    .disableColor = false,
    .options = ZArgs.options{
        .help = false,
        .version = false,
    },
    .showIndents = false,
    .showStructure = false,
    .uwu = false,
    .explorer = false,
};

pub fn main() anyerror!void {
    const a = std.heap.page_allocator;
    const args = try std.process.argsAlloc(a);
    defer a.free(args);

    try ZArgs.mainArgs(args, &arguments);
    var alloc = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer alloc.deinit();

    try stdout.print("VERSION: 5\n", .{});

    // TODO should be able to provide the file name
    //    var fileName = args[1];
    //    var fileContent = try ZFiles.readFile(fileName, alloc.allocator());
    //    var listOfTokens = try ZLexer.lexer(fileContent, alloc.allocator());
    //    try ZPrint.printJSON(listOfTokens);

    var fileContent = try ZFiles.readStdin(alloc.allocator());
    var listOfTokens = try ZLexer.lexer(fileContent, alloc.allocator());
    try ZPrint.printJSON(listOfTokens);

    std.log.info("TYPE {}", .{ZTypeCheck.checkParens(listOfTokens)});
    std.log.info("TYPE {}", .{ZTypeCheck.checkObject(listOfTokens)});
    std.log.info("{}: Program finished successfully.", .{std.time.milliTimestamp()});
}
