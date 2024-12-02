const std = @import("std");

pub fn main() !void {
    try parseFile("input.txt");
}

fn parseFile(filename: []const u8) !void {
    const f = try std.fs.cwd().openFile(filename, .{});
    defer f.close();

    var buf_reader = std.io.bufferedReader(f.reader());
    var in_stream = buf_reader.reader();

    var buf: [256]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{ line });
    }
}
