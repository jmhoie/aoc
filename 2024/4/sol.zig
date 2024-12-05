const std = @import("std");
const input = @embedFile("input.txt");

const Point = struct {
    x: i32,
    y: i32,
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const r = try parseFile(allocator);
    const xmas_count = countXmas(r.m, r.xs);
    const mas_count = countMas(r.m, r.as);
    std.debug.print("Answer 1: {d}\nAnswer 2: {d}\n", .{ xmas_count, mas_count });
}

// I LOVE IF STATEMENTS
fn countXmas(m: std.array_hash_map.AutoArrayHashMap(Point, u8), xs: std.ArrayList(Point)) i32 {
    var sum: i32 = 0;
    for (xs.items) |p| {
        const x = p.x;
        const y = p.y;
        // check horizontal (both directions)
        if (m.get(.{ .x = x + 1, .y = y }) == 'M' and m.get(.{ .x = x + 2, .y = y }) == 'A' and m.get(.{ .x = x + 3, .y = y }) == 'S') sum += 1;
        if (m.get(.{ .x = x - 1, .y = y }) == 'M' and m.get(.{ .x = x - 2, .y = y }) == 'A' and m.get(.{ .x = x - 3, .y = y }) == 'S') sum += 1;
        // check vertical (both directions)
        if (m.get(.{ .x = x, .y = y + 1 }) == 'M' and m.get(.{ .x = x, .y = y + 2 }) == 'A' and m.get(.{ .x = x, .y = y + 3 }) == 'S') sum += 1;
        if (m.get(.{ .x = x, .y = y - 1 }) == 'M' and m.get(.{ .x = x, .y = y - 2 }) == 'A' and m.get(.{ .x = x, .y = y - 3 }) == 'S') sum += 1;
        // check diagonals (all 4 directions)
        if (m.get(.{ .x = x + 1, .y = y + 1 }) == 'M' and m.get(.{ .x = x + 2, .y = y + 2 }) == 'A' and m.get(.{ .x = x + 3, .y = y + 3 }) == 'S') sum += 1;
        if (m.get(.{ .x = x - 1, .y = y + 1 }) == 'M' and m.get(.{ .x = x - 2, .y = y + 2 }) == 'A' and m.get(.{ .x = x - 3, .y = y + 3 }) == 'S') sum += 1;
        if (m.get(.{ .x = x + 1, .y = y - 1 }) == 'M' and m.get(.{ .x = x + 2, .y = y - 2 }) == 'A' and m.get(.{ .x = x + 3, .y = y - 3 }) == 'S') sum += 1;
        if (m.get(.{ .x = x - 1, .y = y - 1 }) == 'M' and m.get(.{ .x = x - 2, .y = y - 2 }) == 'A' and m.get(.{ .x = x - 3, .y = y - 3 }) == 'S') sum += 1;
    }
    return sum;
}

fn countMas(m: std.array_hash_map.AutoArrayHashMap(Point, u8), as: std.ArrayList(Point)) i32 {
    var sum: i32 = 0;
    for (as.items) |p| {
        const top_left: Point = .{ .x = p.x - 1, .y = p.y - 1 };
        const top_right: Point = .{ .x = p.x + 1, .y = p.y - 1 };
        const bot_left: Point = .{ .x = p.x - 1, .y = p.y + 1 };
        const bot_right: Point = .{ .x = p.x + 1, .y = p.y + 1 };

        if (m.get(top_left) == 'M') {
            if (m.get(top_right) == 'M' and m.get(bot_right) == 'S' and m.get(bot_left) == 'S') {
                sum += 1;
            } else if (m.get(top_right) == 'S' and m.get(bot_right) == 'S' and m.get(bot_left) == 'M') {
                sum += 1;
            }
        } else if (m.get(top_left) == 'S') {
            if (m.get(top_right) == 'M' and m.get(bot_right) == 'M' and m.get(bot_left) == 'S') {
                sum += 1;
            } else if (m.get(top_right) == 'S' and m.get(bot_right) == 'M' and m.get(bot_left) == 'M') {
                sum += 1;
            }
        }
    }
    return sum;
}

fn parseFile(allocator: std.mem.Allocator) !struct { m: std.array_hash_map.AutoArrayHashMap(Point, u8), xs: std.ArrayList(Point), as: std.ArrayList(Point) } {
    var m = std.array_hash_map.AutoArrayHashMap(Point, u8).init(allocator);
    var xs = std.ArrayList(Point).init(allocator);
    var as = std.ArrayList(Point).init(allocator);

    var f_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var y: u16 = 0;
    while (f_iter.next()) |line| : (y += 1) {
        var x: u16 = 0;
        while (x < line.len) : (x += 1) {
            switch (line[x]) {
                'X' => try xs.append(.{ .x = x, .y = y }),
                'A' => {
                    try as.append(.{ .x = x, .y = y });
                    try m.put(.{ .x = x, .y = y }, 'A');
                },
                'M', 'S' => |c| try m.put(.{ .x = x, .y = y }, c),
                else => continue,
            }
        }
    }
    return .{ .m = m, .xs = xs, .as = as };
}
