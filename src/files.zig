const std = @import("std");
const mem = @import("mem");

const fs = std.fs;
const io = std.io;
const log = std.log;
const ArrayList = std.ArrayList;

const MaxFileSize: usize = 10000;

pub fn returnContent(str: []u8, alloc: std.mem.Allocator) ![]u8 {
    log.info("Reading File, file_name = {s}", .{str});
    const file: fs.File = try fs.cwd().openFile(
        str,
        .{ .read = true },
    );
    defer file.close();

    const reader = file.reader();
    var buf = ArrayList(u8).init(alloc);

    reader.readUntilDelimiterArrayList(&buf, "\x00"[0], MaxFileSize) catch log.info("File Read Over", .{});
    return buf.toOwnedSlice();
}
