const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});


    const exe = b.addExecutable(.{
        .name = "ant_simulation",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    // These are the required system libraries for Raylib for Windows
    // Replace them with your OS's libraries if need be
    exe.linkSystemLibrary("opengl32");
    exe.linkSystemLibrary("winmm");
    exe.linkSystemLibrary("gdi32");
    /////////////////////////////////////////////////////////////////
    // No Raylib files are supplied in this repo
    // Get them at Raylib's releases page
    exe.addObjectFile(b.path("./lib/raylib/lib/libraylib.a"));
    exe.addIncludePath(b.path("./lib/raylib/include"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
