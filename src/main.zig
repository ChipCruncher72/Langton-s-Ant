const rl = @cImport({
    @cInclude("raylib.h");
    @cInclude("raymath.h");
    @cInclude("rlgl.h");
});

const CELL_SIZE = 5;
const WINDOW_WIDTH = 1000;
const WINDOW_HEIGHT = 800;
const GRID_WIDTH = WINDOW_WIDTH/CELL_SIZE;
const GRID_HEIGHT = WINDOW_HEIGHT/CELL_SIZE;

pub fn drawGrid(grid: [GRID_HEIGHT][GRID_WIDTH]bool) void {
    for (grid, 0..) |line, y| {
        for (line, 0..) |item, x| {
            rl.DrawRectangle(@intCast(x*CELL_SIZE), @intCast(y*CELL_SIZE), CELL_SIZE, CELL_SIZE, if (item) rl.BLACK else rl.WHITE);
        }
    }
}

const Direction = enum {
    north,
    south,
    east,
    west,
};

pub fn main() !void {
    rl.SetTraceLogLevel(rl.LOG_NONE);
    rl.SetConfigFlags(rl.FLAG_WINDOW_ALWAYS_RUN);

    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Ant");
    defer rl.CloseWindow();
    rl.SetTargetFPS(rl.GetMonitorRefreshRate(rl.GetCurrentMonitor()));

    var grid: [GRID_HEIGHT][GRID_WIDTH]bool = [_][GRID_WIDTH]bool{[_]bool{false} ** GRID_WIDTH} ** GRID_HEIGHT;

    var pos = @Vector(2, c_int){GRID_WIDTH/2, GRID_HEIGHT/2};
    var pos_facing = Direction.north;
    var run_auto = false;
    while (!rl.WindowShouldClose()) {
        if (rl.IsKeyPressed(rl.KEY_SPACE)) {
            run_auto = !run_auto;
        }

        if (run_auto or rl.IsKeyPressed(rl.KEY_RIGHT)) {
            if (pos[0] >= GRID_WIDTH) {
                pos[0] = 0;
            }
            if (pos[0] <= -1) {
                pos[0] = GRID_WIDTH-1;
            }
            if (pos[1] >= GRID_HEIGHT) {
                pos[1] = 0;
            }
            if (pos[1] <= -1) {
                pos[1] = GRID_HEIGHT-1;
            }

            grid[@intCast(pos[1])][@intCast(pos[0])] = !grid[@intCast(pos[1])][@intCast(pos[0])];
            if (!grid[@intCast(pos[1])][@intCast(pos[0])]) {
                switch (pos_facing) {
                    .north => {
                        pos +%= [_]c_int{1, 0};
                        pos_facing = .east;
                    },
                    .east => {
                        pos +%= [_]c_int{0, 1};
                        pos_facing = .south;
                    },
                    .south => {
                        pos -%= [_]c_int{1, 0};
                        pos_facing = .west;
                    },
                    .west => {
                        pos -%= [_]c_int{0, 1};
                        pos_facing = .north;
                    },
                }
            } else {
                switch (pos_facing) {
                    .north => {
                        pos -%= [_]c_int{1, 0};
                        pos_facing = .west;
                    },
                    .east => {
                        pos -%= [_]c_int{0, 1};
                        pos_facing = .north;
                    },
                    .south => {
                        pos +%= [_]c_int{1, 0};
                        pos_facing = .east;
                    },
                    .west => {
                        pos +%= [_]c_int{0, 1};
                        pos_facing = .south;
                    },
                }
            }
        }

        rl.BeginDrawing();
        defer rl.EndDrawing();

        drawGrid(grid);

        rl.DrawRectangle(pos[0]*%CELL_SIZE, pos[1]*%CELL_SIZE, CELL_SIZE, CELL_SIZE, rl.RED);
    }
}
