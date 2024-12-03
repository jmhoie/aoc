const std = @import("std");
const input = @embedFile("input.txt");

const Factors = struct {
    f1: u32, // first factor
    f2: u32, // second factor
    do: bool, // bool flag for task 2
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const factors = try parseFile(allocator);
    const sums = sumProducts(factors);
    try std.io.getStdOut().writer().print("Answer 1: {d}\nAnswer 2: {d}\n", .{ sums.sum, sums.cond });
}

fn sumProducts(pairs: std.ArrayList(Factors)) struct { sum: u32, cond: u32 } {
    var sum: u32 = 0;
    var sum_cond: u32 = 0;

    for (pairs.items) |f| {
        sum += f.f1 * f.f2;
        if (f.do) sum_cond += f.f1 * f.f2;
    }
    return .{ .sum = sum, .cond = sum_cond };
}

fn parseFile(allocator: std.mem.Allocator) !std.ArrayList(Factors) {
    // list that contains two factors + a bool flag for task 2
    var factors = std.ArrayList(Factors).init(allocator);
    const mul_str_prefix = "mul(";

    var do = true; // flag for task 2
    var f_iter = std.mem.tokenizeScalar(u8, input, '\n');
    while (f_iter.next()) |line| {
        var i: u16 = 0;
        while (i < line.len) : (i += 1) {
            // check if new do flag
            if (std.mem.startsWith(u8, line[i..], "don't()")) {
                do = false;
                i += 7; // skip over the characters in "don't()"
            } else if (std.mem.startsWith(u8, line[i..], "do()")) {
                do = true;
                i += 4; // skip over the characters in "do()"
            }
            // check if substr starts with "mul("
            if (std.mem.startsWith(u8, line[i..], mul_str_prefix)) {
                // check for numbers separated by a single comma that ends with a ')', e.g. "231,970)"
                for (line[i + mul_str_prefix.len ..], 0..) |c, j| {
                    if (c != ',' and c != ')' and !std.ascii.isDigit(c)) break;
                    if (c == ')') {
                        // num_str contains the substring of two numbers separated by a comma, e.g. "231,970"
                        const num_str = line[i + mul_str_prefix.len .. i + mul_str_prefix.len + j];

                        // split string on ',' and extract the two numbers into f1 and f2. "231,970" ==> f1=231; f2=970;
                        var num_iter = std.mem.tokenizeScalar(u8, num_str, ',');
                        const f1 = try std.fmt.parseInt(u32, num_iter.next().?, 10);
                        const f2 = try std.fmt.parseInt(u32, num_iter.next().?, 10);
                        try factors.append(.{ .f1 = f1, .f2 = f2, .do = do }); // instantiate Factors struct and append to list

                        i += @intCast(4 + j); // skip over the characters in the product string
                        break;
                    }
                }
            }
        }
    }
    return factors;
}
