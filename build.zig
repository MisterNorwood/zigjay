const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Dependencies
    const logly_dep = b.dependency("logly", .{
        .target = target,
        .optimize = optimize,
    });

    const zig_gobject_dep = b.dependency("zig-gobject", .{
        .target = target,
        .optimize = optimize,
    });

    // GIR generator
    const girgen = zig_gobject_dep.artifact("translate-gir");

    const gen = b.addRunArtifact(girgen);

    const generated_dir = gen.addOutputDirectoryArg("generated");

    gen.addArgs(&.{
        "--gir-path",
        "/usr/share/gir-1.0",
    });

    // Namespaces
    gen.addArgs(&.{
        "--namespace", "GLib-2.0",
        "--namespace", "GObject-2.0",
        "--namespace", "Gio-2.0",
        "--namespace", "WirePlumber-0.5",
    });

    // Generated binding modules
    const glib_mod = b.createModule(.{
        .root_source_file = generated_dir.path(b, "glib2.zig"),
        .target = target,
        .optimize = optimize,
    });

    const gobject_mod = b.createModule(.{
        .root_source_file = generated_dir.path(b, "gobject2.zig"),
        .target = target,
        .optimize = optimize,
    });

    const gio_mod = b.createModule(.{
        .root_source_file = generated_dir.path(b, "gio2.zig"),
        .target = target,
        .optimize = optimize,
    });

    const wp_mod = b.createModule(.{
        .root_source_file = generated_dir.path(b, "wp0.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Root module
    const root_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .link_libc = true,
        .optimize = optimize,
        .imports = &.{
            .{
                .name = "glib",
                .module = glib_mod,
            },
            .{
                .name = "gobject",
                .module = gobject_mod,
            },
            .{
                .name = "gio",
                .module = gio_mod,
            },
            .{
                .name = "wp",
                .module = wp_mod,
            },
            .{
                .name = "logly",
                .module = logly_dep.module("logly"),
            },
        },
    });

    root_mod.linkSystemLibrary("glib-2.0", .{});
    root_mod.linkSystemLibrary("gobject-2.0", .{});
    root_mod.linkSystemLibrary("gio-2.0", .{});
    root_mod.linkSystemLibrary("wireplumber-0.5", .{});

    // Executable
    const exe = b.addExecutable(.{
        .name = "zigjay",
        .root_module = root_mod,
    });

    exe.step.dependOn(&gen.step);

    //
    // Install
    //
    b.installArtifact(exe);

    //
    // Run step
    //
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step(
        "run",
        "Run zigjay",
    );

    run_step.dependOn(&run_cmd.step);
}
