const std = @import("std");
const PriorityDequeue = std.PriorityDequeue;
const LinkedList = std.TailQueue;
const Order = std.math.Order;
const PQPathLessThan = PriorityDequeue(Path, void, pathLessThan);

const Path = struct {
    streetMap: *StreetMap,
    heatLoss: usize,
    lastDirection: Direction,
    lastDirectionCount: usize,
    currentRow: usize,
    currentCol: usize,
    seen: []bool,

    fn deinit(self: *Path) void {
        const allocator = self.StreetMap.allocator;
        allocator.free(self.seen);
    }

    fn new(streetMap: *StreetMap) !Path {
        var seen: []bool = try streetMap.allocator.alloc(bool, streetMap.height * streetMap.width);
        streetMap.seen[0] = 0;
        return Path{
            .streetMap = streetMap,
            .heatLoss = 0,
            .seen = seen,
            .lastDirection = Direction.E,
            .lastDirectionCount = 0,
            .currentRow = 0,
            .currentCol = 0,
            // .parent = null,
        };
    }
    fn clone(parent: *Path, dir: Direction) !?Path {
        var row: usize = undefined;
        var col: usize = undefined;
        switch (dir) {
            Direction.E => {
                if (parent.currentCol == parent.streetMap.width - 1) {
                    return null;
                }
                row = parent.currentRow;
                col = parent.currentCol + 1;
            },
            Direction.W => {
                if (parent.currentCol == 0) {
                    return null;
                }
                row = parent.currentRow;
                col = parent.currentCol - 1;
            },
            Direction.S => {
                if (parent.currentRow == parent.streetMap.height - 1) {
                    return null;
                }
                row = parent.currentRow + 1;
                col = parent.currentCol;
            },
            Direction.N => {
                if (parent.currentRow == 0) {
                    return null;
                }
                row = parent.currentRow - 1;
                col = parent.currentCol;
            },
        }
        // var cursor: ?*Path = parent;

        // var depth:usize = 0;
        // std.log.debug("begin loop.", .{});

        // std.log.debug("cursor {*}", .{cursor});
        // while (cursor != null) : (cursor = cursor.?.parent) {
        //     if (cursor.?.currentRow == row and cursor.?.currentCol == col) {
        //         return null;
        //     }
        //     // std.log.debug("looping", .{});
        // }

        // std.log.debug("exit loop.", .{});
        if (parent.seen[row * parent.streetMap.width + col]) {
            return null;
        }

        if ((parent.lastDirection == dir) and (parent.lastDirectionCount == 3)) {
            // std.log.debug("pruned per straight line rule.", .{});
            return null;
        }

        const newHeatLoss = parent.streetMap.accessGrid(row, col) + parent.heatLoss;
        if (newHeatLoss >= parent.streetMap.currentWinner) {
            // std.log.debug("pruned per not a winner rule. me: {} currentWinner: {}", .{ newHeatLoss, parent.streetMap.currentWinner });

            return null;
        }
        const seenValue = parent.streetMap.seen[row * parent.streetMap.width + col];

        // std.log.debug("seen value {}, my value {}", .{seenValue, newHeatLoss,  });
        if (seenValue + 0 < newHeatLoss) {
            // std.log.debug("pruned per give up rule.", .{});

            return null; //give up
        }
        // if (seenValue > newHeatLoss) {
        // std.log.debug("resetting seen to {}", .{newHeatLoss});
        parent.streetMap.seen[row * parent.streetMap.width + col] = newHeatLoss;
        // }

        // std.log.debug("clone to ({},{}): {}", .{ row, col, newHeatLoss });

        var seen = try parent.streetMap.allocator.dupe(bool, parent.seen);
        seen[row * parent.streetMap.width + col] = true;

        const ret = try parent.streetMap.allocator.create(Path);
        ret.streetMap = parent.streetMap;
        ret.heatLoss = newHeatLoss;
        ret.lastDirection = dir;
        ret.lastDirectionCount = if (parent.lastDirection == dir) parent.lastDirectionCount + 1 else 1;
        ret.currentRow = row;
        ret.currentCol = col;
        ret.seen = seen;
        //     // .seen = seen,
        //     .heatLoss = newHeatLoss,
        //     .lastDirection = dir,
        //     .lastDirectionCount = if (parent.lastDirection == dir) parent.lastDirectionCount + 1 else 1,
        //     .currentRow = row,
        //     .currentCol = col,
        //     .parent = parent,
        // };
        // std.log.debug("ret {*}", .{&ret});

        return ret.*;
    }
    fn print(self: *Path) !void {
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();
        var row: usize = 0;

        while (row < self.streetMap.height) : (row += 1) {
            var col: usize = 0;
            while (col < self.streetMap.width) : (col += 1) {
                var c = self.seen[row * self.streetMap.width + col];
                if (c) {
                    try stdout.print("#", .{});
                } else {
                    try stdout.print(" ", .{});
                }
            }
            try stdout.print("\n", .{});
        }
        try bw.flush();
    }
};
fn pathLessThan(context: void, l: Path, r: Path) Order {
    _ = context;
    const firstEval = std.math.order((l.currentCol + l.currentRow + 1), (r.currentCol + r.currentRow + 1));
    if (firstEval.compare(std.math.CompareOperator.eq)) {
        return std.math.order(l.heatLoss, r.heatLoss).invert();
    }
    return firstEval;
}

const StreetMap = struct {
    seen: []usize,
    grid: []const u8,
    width: usize,
    height: usize,
    allocator: std.mem.Allocator,
    currentWinner: usize,
    currentWinnerPath: ?Path,
    //   fn deinit(self: *StreetMap) void {
    // 	const allocator = game.allocator;
    // 	allocator.free(game.players);
    // 	allocator.free(game.history);
    // }
    fn accessGrid(self: *StreetMap, row: usize, col: usize) u8 {
        return self.grid[row * self.width + col];
    }

    fn print(self: *StreetMap) !void {
        var row: usize = 0;
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        while (row < self.height) : (row += 1) {
            var col: usize = 0;
            while (col < self.width) : (col += 1) {
                var char = self.accessGrid(row, col);
                try stdout.print("{}", .{char});
            }
            try stdout.print("\n", .{});
        }
        try bw.flush();
    }
    // fn printSeen(self: *StreetMap, seen: []bool) void {
    //     var row: usize = 0;

    //     while (row < self.height) : (row += 1) {
    //         var col: usize = 0;
    //         while (col < self.width) : (col += 1) {
    //             var tile = seen[row * self.width + col];
    //             if (tile) {
    //                 std.debug.print("#", .{});
    //             } else {
    //                 std.debug.print(" ", .{});
    //             }
    //         }
    //         std.debug.print("\n", .{});
    //     }
    // }
    // recursive forward. cons: can't be tail recursive (need to eval lt/gt), is memoization an option in zig? <<< trying it
    // backwards distancelabel. cons: won't work?
    // iterate paths then filter: path list will get huge
    fn navigate(self: *StreetMap) !void {
        // std.debug.print("navigate: ({}, {})\n", .{ row, col });
        // var dq = PQPathLessThan.init(self.allocator, {});
        var dq = PQPathLessThan.init(self.allocator, {});
        defer dq.deinit();
        // try dq.add(try Path.new(self));
        try dq.add(try Path.new(self));
        var i: u128 = 0;
        while (dq.len > 0) {
            i += 1;
            // std.log.debug("{}: queue count {}", .{i, dq.len});
            // var path: Path = dq.removeMax();
            var path: Path = dq.removeMax();

            // std.log.debug("{} - pulling path ({},{}). mem: {*}", .{ i, path.currentRow, path.currentCol, &path });
            if ((path.currentCol == self.width - 1) and (path.currentRow == self.height - 1)) {
                if (self.currentWinner > path.heatLoss) {
                    self.currentWinner = path.heatLoss;
                    self.currentWinnerPath = path;
                    std.log.debug("!!  new winner {}", .{self.currentWinner});
                    try path.print();
                }
                continue;
            }

            var east: ?Path = try path.clone(Direction.E);
            if (east != null) {
                try dq.add(east.?);
            }
            var south: ?Path = try path.clone(Direction.S);
            if (south != null) {
                try dq.add(south.?);
            }
            var west: ?Path = try path.clone(Direction.W);
            if (west != null) {
                try dq.add(west.?);
            }
            var north: ?Path = try path.clone(Direction.N);
            if (north != null) {
                try dq.add(north.?);
            }
            if (i % 100000 == 0) {
                std.log.debug("iterations: {}. queue depth: {}, lowest: {}", .{ i, dq.len, self.currentWinner });
            }
        }
        std.log.debug("iterations: {}", .{i});
    }
};

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var streetMap = try readFile(allocator);
    try streetMap.print();

    // var seen: []bool = try streetMap.allocator.alloc(bool, @intCast(streetMap.width * streetMap.height));
    // defer streetMap.allocator.free(seen);

    // try streetMap.navigate();

    // _ = nav;
    try stdout.print("min heat loss: {s}\n", .{"fuck zig"});
    try bw.flush(); // don't forget to flush!
}

fn readFile(allocator: std.mem.Allocator) !StreetMap {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    var file = try std.fs.cwd().openFile(args[1], .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var height: usize = 0;
    var width: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        height += 1;
        width = @truncate(line.len);
    }
    std.debug.print("size: {}, {}\n", .{ width, height });
    try file.seekTo(0);

    buf_reader = std.io.bufferedReader(file.reader());
    in_stream = buf_reader.reader();
    const grid = try allocator.alloc(u8, width * height);
    var row: usize = 0;

    while (row < height) : (row += 1) {
        var line = try in_stream.readUntilDelimiterOrEof(&buf, '\n');
        var col: usize = 0;

        while (col < width) : (col += 1) {
            grid[row * width + col] = line.?[col] - '0';
        }
    }
    var seen: []usize = try allocator.alloc(usize, width * height);
    const maxTraversal = (width + height) * 9;
    @memset(seen, maxTraversal);

    const ret = StreetMap{
        .width = width,
        .height = height,
        .grid = grid,
        .allocator = allocator,
        .currentWinner = 1089,
        .seen = seen,
        .currentWinnerPath = null,
    };

    return ret;
}

// var gpa = std.heap.GeneralPurposeAllocator(.{}){};
// const allocator = gpa.allocator();
// defer {
//     const deinit_status = gpa.deinit();
//     //fail test; can't try in defer as defer is executed after we return
//     if (deinit_status == .leak) expect(false) catch @panic("TEST FAIL");
// }

// const bytes = try allocator.alloc(u8, 100);
// defer allocator.free(bytes);
const Direction = enum {
    N,
    W,
    S,
    E,
};
