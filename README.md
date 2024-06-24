This is a Langton's ant simulation written in Zig using Raylib

If you'd like to run the simulation download [Raylib](https://github.com/raysan5/raylib/releases) and read the comments in `build.zig`
Then just run
```sh
zig build run
```

If you'd like to you can edit the main file too:
```zig
const CELL_SIZE = 5;
const WINDOW_WIDTH = 1000;
const WINDOW_HEIGHT = 800;
```
The names should be self explanatory
`CELL_SIZE` is the size of the ant and the cells it creates
`WINDOW_WIDTH` width of the program window (can not be resized)
`WINDOW_HEIGHT` hight of the program window (can not be resized)
