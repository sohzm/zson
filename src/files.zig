const std = @import("std");
const mem = @import("mem");

const fs = std.fs;
const io = std.io;
const log = std.log;
const ArrayList = std.ArrayList;

const MaxFileSize: usize = 30000000;

pub fn returnContent(str: []u8, alloc: std.mem.Allocator) ![]u8 {
    log.info("{}: Reading File, file_name = {s}", .{ std.time.milliTimestamp(), str });
    const file: fs.File = try fs.cwd().openFile(
        str,
        .{},
    );
    defer file.close();

    const reader = file.reader();
    var buf = try ArrayList(u8).initCapacity(alloc, MaxFileSize);

    reader.readUntilDelimiterArrayList(&buf, "\x00"[0], MaxFileSize) catch log.info("{}: File Read Over", .{std.time.milliTimestamp()});
    return buf.toOwnedSlice();
}

pub fn readStdin(alloc: std.mem.Allocator) ![]u8 {
    log.info("{}: Reading stdin", .{std.time.milliTimestamp()});
    const stdin = std.io.getStdIn().reader();
    //var buf = ArrayList(u8).init(alloc);
    var buf = try ArrayList(u8).initCapacity(alloc, MaxFileSize);

    stdin.readUntilDelimiterArrayList(&buf, "\x00"[0], MaxFileSize) catch log.info("{}: File Read Over", .{std.time.milliTimestamp()});
    return buf.toOwnedSlice();
}
