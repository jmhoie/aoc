const std = @import("std");

fn sol1() !u16 {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var sum: u16 = 0;
    while(try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var d1: u8 = 0;
        var d2: u8 = 0;
        for (line) |char| {
            if (char >= '0' and char <= '9') {
                if (d1 == 0) d1 = char - '0';
                d2 = char - '0';
            }
        }
        sum += d1*10 + d2;
    }
    return sum;
}

pub fn main() !void {
    // Solution 1
    const ans1 = try sol1();
    std.debug.print("{d}\n", .{ans1});
}
