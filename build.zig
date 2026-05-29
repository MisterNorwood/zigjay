const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const logly_dep = b.dependency("logly", .{
        .target = target,
        .optimize = optimize,
    });

    const root_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .imports = &.{
            .{
                .name = "logly",
                .module = logly_dep.module("logly"),
            },
        },
    });

    root_mod.addIncludePath(.{ .cwd_relative = "/usr/include/pipewire-0.3" });
    root_mod.addIncludePath(.{ .cwd_relative = "/usr/include/spa-0.2" });
    root_mod.linkSystemLibrary("pipewire-0.3", .{ .use_pkg_config = .force });

    const exe = b.addExecutable(.{
        .name = "zigjay",
        .root_module = root_mod,
        .use_llvm = true,
        .use_lld = true,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run zigjay");
    run_step.dependOn(&run_cmd.step);
}
