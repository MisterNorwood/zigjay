const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const gobject = b.dependency("wireplumber", .{
        .target = target,
        .optimize = optimize,
    });

    const mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "wp", .module = gobject.module("wp0") },
            .{ .name = "glib", .module = gobject.module("glib2") },
            .{ .name = "gobject", .module = gobject.module("gobject2") },
            .{ .name = "gio", .module = gobject.module("gio2") },
            .{ .name = "gmodule", .module = gobject.module("gmodule2") },
        },
    });
    const logly_dep = b.dependency("logly", .{
        .target = target,
        .optimize = optimize,
    });

    mod.addImport("logly", logly_dep.module("logly"));

    const exe = b.addExecutable(.{
        .name = "zigjay",
        .root_module = mod,
    });

    b.installArtifact(exe);

    const exe_run = b.addRunArtifact(exe);
    exe_run.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        exe_run.addArgs(args);
    }

    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&exe_run.step);
}
