const std = @import("std");
const eql = std.mem.eql;

pub const argsStruct = struct {
    uwu: bool, // change text to uwu
    compact: bool,
    argsError: bool,
    showIndents: bool,
    disableColor: bool, //
    showStructure: bool,
    options: options,
    explorer: bool,
    //parse:     []u8,
};

pub const options = struct {
    help: bool,
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
            argStr.disableColor = true;
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
    var flag: bool = eql(u8, str, "-d") or eql(u8, str, "disableColor") or eql(u8, str, "--disable-color");
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

fn isStructure(str: []u8) bool {
    var flag: bool = eql(u8, str, "-s") or eql(u8, str, "structure") or eql(u8, str, "--structure");
    return flag;
}

fn isIndent(str: []u8) bool {
    var flag: bool = eql(u8, str, "-i") or eql(u8, str, "indent") or eql(u8, str, "--indent");
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
