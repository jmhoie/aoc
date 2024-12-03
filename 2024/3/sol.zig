const std = @import("std");
const input = @embedFile("input.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const factor_pairs = try parseFile(allocator);
    const sums = sumProducts(factor_pairs.factors, factor_pairs.factors_cond);
    try std.io.getStdOut().writer().print("Answer 1: {d}\nAnswer 2: {d}\n", .{ sums.sum, sums.cond });
}

fn sumProducts(pairs: std.ArrayList(struct { u32, u32 }), pairs_cond: std.ArrayList(struct { u32, u32 })) struct { sum: u32, cond: u32 } {
    var sum: u32 = 0;
    var sum_cond: u32 = 0;

    for (pairs.items) |factors| {
        sum += factors[0] * factors[1];
    }
    for (pairs_cond.items) |factors| {
        sum_cond += factors[0] * factors[1];
    }

    return .{ .sum = sum, .cond = sum_cond };
}

fn parseFile(allocator: std.mem.Allocator) !struct { factors: std.ArrayList(struct { u32, u32 }), factors_cond: std.ArrayList(struct { u32, u32 }) } {
    // list of pairs of factors -> [(2, 4), (5, 5), (11, 8), (8, 5), ..]
    var factors = std.ArrayList(struct { u32, u32 }).init(allocator);
    var factors_cond = std.ArrayList(struct { u32, u32 }).init(allocator); // for task 2
    const mul_str_prefix = "mul(";

    var do = true;
    var f_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (f_iter.next()) |line| {
        var i: u16 = 0;
        blk: while (i < line.len) : (i += 1) {
            if (std.mem.startsWith(u8, line[i..], "don't()")) {
                do = false;
                i += 7; // skip over the characters in "don't()"
            } else if (std.mem.startsWith(u8, line[i..], "do()")) {
                do = true;
                i += 4; // skip over the characters in "do()"
            }

            if (std.mem.startsWith(u8, line[i..], mul_str_prefix)) {
                for (line[i + mul_str_prefix.len ..], 0..) |c, j| {
                    if (c != ',' and c != ')' and !std.ascii.isDigit(c)) continue :blk;
                    if (c == ')') {
                        const num_str = line[i + mul_str_prefix.len .. i + mul_str_prefix.len + j];
                        var num_iter = std.mem.tokenizeScalar(u8, num_str, ',');

                        const a = try std.fmt.parseInt(u32, num_iter.next().?, 10);
                        const b = try std.fmt.parseInt(u32, num_iter.next().?, 10);

                        try factors.append(.{ a, b });
                        if (do) try factors_cond.append(.{ a, b });

                        i += @intCast(4 + j); // skip over the characters in the product string
                        continue :blk;
                    }
                }
            }
        }
    }
    return .{ .factors = factors, .factors_cond = factors_cond };
}
