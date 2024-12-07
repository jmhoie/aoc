const std = @import("std");
const input = @embedFile("input.txt");
const example = @embedFile("example.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const res = try parseFile(allocator);
    const sum = sumCorrect(res.r, res.s);
    //
    // ONLY TASK 1
    //
    std.debug.print("Answer 1: {d}\n", .{sum});
}

fn sumCorrect(page_rules: std.AutoArrayHashMap(i16, []i16), page_sequences: [][]i16) i32 {
    var sum: i32 = 0;
    var i: usize = 0;
    blk: while (i < page_sequences.len) : (i += 1) {
        const page_sequence = page_sequences[i];
        var j: usize = 0;
        while (j < page_sequence.len) : (j += 1) {
            const page = page_sequence[j];
            const rules = page_rules.get(page) orelse continue;
            for (rules) |r| {
                var k: usize = 0;
                while (k < j) : (k += 1) {
                    if (page_sequence[k] == r) continue :blk; // true => order is not correct
                }
            }
        }
        sum += page_sequence[page_sequence.len / 2];
    }
    return sum;
}

fn parseFile(allocator: std.mem.Allocator) !struct { r: std.AutoArrayHashMap(i16, []i16), s: [][]i16 } {
    var rules = std.AutoArrayHashMap(i16, std.ArrayList(i16)).init(allocator);
    var page_sequences = std.ArrayList([]i16).init(allocator);

    var brk = false;
    var f_iter = std.mem.splitScalar(u8, input, '\n');
    var i: usize = 0;
    while (f_iter.next()) |line| : (i += 1) {
        if (std.mem.eql(u8, line, "")) {
            brk = true;
            continue;
        }
        if (!brk) {
            var s_iter = std.mem.tokenizeScalar(u8, line, '|');
            const x1 = try std.fmt.parseInt(i16, s_iter.next().?, 10);
            const x2 = try std.fmt.parseInt(i16, s_iter.next().?, 10);
            if (rules.contains(x1)) {
                var l = rules.get(x1).?;
                try l.append(x2);
                try rules.put(x1, l);
            } else {
                var l = std.ArrayList(i16).init(allocator);
                try l.append(x2);
                try rules.put(x1, l);
            }
        } else {
            var s = std.ArrayList(i16).init(allocator);
            var s_iter = std.mem.tokenizeScalar(u8, line, ',');
            while (s_iter.next()) |tok| {
                const x = try std.fmt.parseInt(i16, tok, 10);
                try s.append(x);
            }
            try page_sequences.append(s.items);
        }
    }
    var r = std.AutoArrayHashMap(i16, []i16).init(allocator);
    for (rules.keys()) |k| {
        const l = rules.get(k).?;
        try r.put(k, l.items);
    }

    return .{ .r = r, .s = page_sequences.items };
}
