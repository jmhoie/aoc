const std = @import("std");
const input = @embedFile("input.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const reports = try parseFile(allocator);
    const safeCount = try countSafeReports(allocator, reports);
    try std.io.getStdOut().writer().print("Answer 1: {d}\nAnswer 2: {d}\n", .{ safeCount.sum, safeCount.sumWithDelete });
}

fn countSafeReports(allocator: std.mem.Allocator, reports: std.ArrayList(std.ArrayList(i16))) !struct { sum: u16, sumWithDelete: u16 } {
    var sum: u16 = 0;
    var sumWithDelete: u16 = 0;
    for (reports.items) |report| {
        if (isSafe(report.items)) sum += 1;
        if (try isSafeWithDelete(allocator, report.items)) sumWithDelete += 1;
    }
    return .{ .sum = sum, .sumWithDelete = sumWithDelete };
}

fn isSafe(report: []i16) bool {
    // checks if sorted both ascending and descending, returns false if not sorted
    if (!std.sort.isSorted(i16, report, {}, std.sort.asc(i16)) and !std.sort.isSorted(i16, report, {}, std.sort.desc(i16))) return false;

    for (report[1..], 1..) |curr, i| {
        const prev = report[i - 1];
        const diff = @abs(curr - prev);
        if (diff < 1 or diff > 3) return false;
    }
    return true;
}

fn isSafeWithDelete(allocator: std.mem.Allocator, report: []i16) !bool {
    if (isSafe(report)) return true;
    for (0..report.len) |i| {
        const reportElementRemoved = try std.mem.concat(allocator, i16, &.{ report[0..i], report[i + 1 ..] });
        if (isSafe(reportElementRemoved)) return true;
    }
    return false;
}

fn parseFile(allocator: std.mem.Allocator) !std.ArrayList(std.ArrayList(i16)) {
    // 2D ArrayList to contain the other ArrayLists
    var reports = std.ArrayList(std.ArrayList(i16)).init(allocator);

    var f_iter = std.mem.tokenizeScalar(u8, input, '\n'); // file iterator
    while (f_iter.next()) |line| {
        var report = std.ArrayList(i16).init(allocator); // sub-list

        var l_iter = std.mem.tokenizeScalar(u8, line, ' '); // line iterator
        while (l_iter.next()) |tok| {
            const num = try std.fmt.parseInt(i16, tok, 10);
            try report.append(num);
        }
        try reports.append(report);
    }
    return reports;
}
