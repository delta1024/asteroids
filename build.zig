const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const opts = b.addOptions();
    opts.addOption([:0]const u8, "title", "asteroids");
    opts.addOption(i32, "default_height", 450);
    opts.addOption(i32, "default_width", 800);
    opts.addOption(f32, "player_width", 20);

    const raylib_dep = b.dependency("raylib", .{});
    const raylib = raylib_dep.module("raylib");

    const exe = b.addExecutable(.{
        .name = "asteroids",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addOptions("opts", opts);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
