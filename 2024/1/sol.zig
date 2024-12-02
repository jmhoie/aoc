const std = @import("std");
const input = @embedFile("input.txt");

pub fn main() !void {
    const arrs = try parseFile();
    const totalDistance = sumShortestDistance(arrs.left, arrs.right);
    const similarityScore = calcSimilarityScore(arrs.left, arrs.right);
    try std.io.getStdOut().writer().print("Answer 1: {d}\nAnswer 2: {d}\n", .{ totalDistance, similarityScore });
}

fn sumShortestDistance(left: []i32, right: []i32) i32 {
    var sum: u32 = 0;
    for (left, right) |l, r| {
        sum += @abs(l - r);
    }
    return @intCast(sum);
}

fn calcSimilarityScore(left: []i32, right: []i32) i32 {
    var sum: i32 = 0;
    for (left) |left_num| {
        for (right) |right_num| {
            if (right_num > left_num) break;
            if (left_num == right_num) sum += left_num;
        }
    }
    return sum;
}

fn parseFile() !struct {
    left: []i32,
    right: []i32,
} {
    var left: [1000]i32 = undefined;
    var right: [1000]i32 = undefined;

    var file_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var i: usize = 0;
    while (file_iter.next()) |line| : (i += 1) {
        var num_iter = std.mem.tokenizeScalar(u8, line, ' ');

        const left_num = try std.fmt.parseInt(i32, num_iter.next().?, 10);
        left[i] = left_num;
        const right_num = try std.fmt.parseInt(i32, num_iter.next().?, 10);
        right[i] = right_num;
    }
    std.mem.sort(i32, &left, {}, std.sort.asc(i32));
    std.mem.sort(i32, &right, {}, std.sort.asc(i32));

    return .{
        .left = &left,
        .right = &right,
    };
}
