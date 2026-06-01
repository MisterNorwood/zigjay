const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const generated = addGeneratedBindings(b, target, optimize);

    const root_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .imports = &.{
            .{ .name = "wp", .module = generated.wp0 },
            .{ .name = "glib", .module = generated.glib2 },
            .{ .name = "gobject", .module = generated.gobject2 },
        },
    });

    const exe = b.addExecutable(.{
        .name = "zigjay",
        .root_module = root_mod,
        .use_llvm = true,
        .use_lld = true,
    });

    b.installArtifact(exe);

    const install_bindings = b.addInstallDirectory(.{
        .source_dir = generated.output_dir,
        .install_dir = .prefix,
        .install_subdir = "bindings",
    });
    const codegen_step = b.step("codegen", "Generate GIR bindings");
    codegen_step.dependOn(&install_bindings.step);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run zigjay");
    run_step.dependOn(&run_cmd.step);
}

const GeneratedBindings = struct {
    output_dir: std.Build.LazyPath,
    wp0: *std.Build.Module,
    gio2: *std.Build.Module,
    gobject2: *std.Build.Module,
    glib2: *std.Build.Module,
    gmodule2: *std.Build.Module,
};

fn addGeneratedBindings(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) GeneratedBindings {
    const zig_gobject_dep = b.dependency("zig-gobject", .{
        .target = b.graph.host,
        .optimize = .Debug,
    });

    const codegen = b.addRunArtifact(zig_gobject_dep.artifact("translate-gir"));
    codegen.addPrefixedDirectoryArg("--gir-dir=", .{ .cwd_relative = "/usr/share/gir-1.0" });
    codegen.addPrefixedDirectoryArg("--gir-fixes-dir=", zig_gobject_dep.path("gir-fixes"));
    codegen.addPrefixedDirectoryArg("--bindings-dir=", zig_gobject_dep.path("binding-overrides"));
    codegen.addPrefixedDirectoryArg("--extensions-dir=", zig_gobject_dep.path("extensions"));
    const output_dir = codegen.addPrefixedOutputDirectoryArg("--output-dir=", "bindings");
    _ = codegen.addPrefixedDepFileOutputArg("--dependency-file=", "codegen-deps");
    codegen.addArgs(&.{
        "Wp-0.5",
        "Gio-2.0",
        "GObject-2.0",
        "GLib-2.0",
        "GModule-2.0",
    });
    codegen.expectExitCode(0);

    const compat = b.createModule(.{
        .root_source_file = output_dir.path(b, "src/compat/compat.zig"),
        .target = target,
        .optimize = optimize,
    });

    const wp0 = b.createModule(.{
        .root_source_file = output_dir.path(b, "src/wp0/wp0.zig"),
        .target = target,
        .optimize = optimize,
    });
    linkLibraries(wp0, &.{"wireplumber-0.5"});
    wp0.addImport("compat", compat);

    const gio2 = b.createModule(.{
        .root_source_file = output_dir.path(b, "src/gio2/gio2.zig"),
        .target = target,
        .optimize = optimize,
    });
    linkLibraries(gio2, &.{"gio-2.0"});
    gio2.addImport("compat", compat);

    const gobject2 = b.createModule(.{
        .root_source_file = output_dir.path(b, "src/gobject2/gobject2.zig"),
        .target = target,
        .optimize = optimize,
    });
    linkLibraries(gobject2, &.{"gobject-2.0"});
    gobject2.addImport("compat", compat);

    const glib2 = b.createModule(.{
        .root_source_file = output_dir.path(b, "src/glib2/glib2.zig"),
        .target = target,
        .optimize = optimize,
    });
    linkLibraries(glib2, &.{"glib-2.0"});
    glib2.addImport("compat", compat);

    const gmodule2 = b.createModule(.{
        .root_source_file = output_dir.path(b, "src/gmodule2/gmodule2.zig"),
        .target = target,
        .optimize = optimize,
    });
    linkLibraries(gmodule2, &.{"gmodule-2.0"});
    gmodule2.addImport("compat", compat);

    wp0.addImport("gio2", gio2);
    wp0.addImport("gobject2", gobject2);
    wp0.addImport("glib2", glib2);
    wp0.addImport("gmodule2", gmodule2);
    wp0.addImport("wp0", wp0);

    gio2.addImport("gobject2", gobject2);
    gio2.addImport("glib2", glib2);
    gio2.addImport("gmodule2", gmodule2);
    gio2.addImport("gio2", gio2);

    gobject2.addImport("glib2", glib2);
    gobject2.addImport("gobject2", gobject2);

    glib2.addImport("glib2", glib2);

    gmodule2.addImport("glib2", glib2);
    gmodule2.addImport("gmodule2", gmodule2);

    return .{
        .output_dir = output_dir,
        .wp0 = wp0,
        .gio2 = gio2,
        .gobject2 = gobject2,
        .glib2 = glib2,
        .gmodule2 = gmodule2,
    };
}

fn linkLibraries(module: *std.Build.Module, libraries: []const []const u8) void {
    module.link_libc = true;
    for (libraries) |library| {
        module.linkSystemLibrary(library, .{ .use_pkg_config = .force });
    }
}
