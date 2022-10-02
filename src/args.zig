const std = @import("std");
const eql = std.mem.eql;

pub const argsStruct = struct {
    uwu:       bool,
    color:     bool,
    compact:   bool,
    argsError: bool,
    options:   options,
    //parse:     []u8,
};

pub const options = struct {
    help:    bool,
    version: bool,
};

pub fn mainArgs(args: [][]u8, argStr: *argsStruct) !void {
    var i: usize = 0;
    while (i < args.len) {
        if (isUwu(args[i])) {
            argStr.uwu = true;
            i += 1;
            continue;
        }
        if (isColor(args[i])) {
            argStr.color = true;
            i += 1;
            continue;
        }
        if (isCompact(args[i])) {
            argStr.compact = true;
            i += 1;
            continue;
        }
        if (isHelp(args[i])) {
            argStr.options.help = true;
            i += 1;
            continue;
        }
        if (isVersion(args[i])) {
            argStr.options.version = true;
            i += 1;
            continue;
        }
        argStr.argsError = true;
        return;
    }
}

fn isColor(str: []u8) bool {
    var flag: bool = eql(u8, str, "color") or eql(u8, str, "--color");
    return flag;
}

fn isUwu(str: []u8) bool {
    var flag: bool = eql(u8, str, "uwu") or eql(u8, str, "--uwu");
    return flag;
}

fn isCompact(str: []u8) bool {
    var flag: bool = eql(u8, str, "-c") or eql(u8, str, "compact") or eql(u8, str, "--compact");
    return flag;
}

fn isHelp(str: []u8) bool {
    var flag: bool = eql(u8, str, "-h") or eql(u8, str, "help") or eql(u8, str, "--help");
    return flag;
}

fn isVersion(str: []u8) bool {
    var flag: bool = eql(u8, str, "-v") or eql(u8, str, "version") or eql(u8, str, "--version");
    return flag;
}
