const std = @import("std");
const logly = @import("logly");

extern fn pw_init(argc: ?*c_int, argv: ?*?[*]u8) void;
extern fn pw_deinit() void;

const pw = @cImport({
    @cInclude("pipewire/main-loop.h");
    @cInclude("pipewire/context.h");
    @cInclude("pipewire/core.h");
    @cInclude("pipewire/proxy.h");
    @cInclude("pipewire/node.h");
    @cInclude("pipewire/keys.h");
    @cInclude("spa/utils/dict.h");
    @cInclude("spa/utils/hook.h");
});

const PipewireError = error{
    MainLoopInitFailed,
    ContextInitFailed,
    CoreConnectFailed,
    RegistryInitFailed,
    MissingMode,
    InvalidArguments,
    NodeNotFound,
    InvalidVolume,
    VolumeCommandFailed,
};

const Mode = enum {
    list,
    change,
};

const ChangeKind = enum {
    set,
    relative,
};

const VolumeChange = struct {
    kind: ChangeKind,
    value: u8,
    sign: u8,
};

const NodeInfo = struct {
    id: u32,
    permissions: u32,
    @"type": []const u8,
    version: u32,
    name: []const u8,
    nickname: []const u8,
    description: []const u8,
    media_class: []const u8,
};

const Cli = struct {
    mode: Mode,
    node_name: ?[]const u8 = null,
    change: ?VolumeChange = null,
};

pub const ZjContext = struct {
    loop: ?*pw.pw_main_loop,
    context: ?*pw.pw_context,
    core: ?*pw.pw_core,
    registry: ?*pw.pw_registry,
    registry_listener: pw.spa_hook,
    core_listener: pw.spa_hook,
    sync_seq: c_int,
    initial_sync_done: bool,
    nodes: std.ArrayList(NodeInfo),
    gpa: std.heap.DebugAllocator(.{}),
    allocator: ?std.mem.Allocator,
    log: ?*logly.Logger,

    pub fn init() ZjContext {
        return .{
            .loop = null,
            .context = null,
            .core = null,
            .registry = null,
            .registry_listener = std.mem.zeroes(pw.spa_hook),
            .core_listener = std.mem.zeroes(pw.spa_hook),
            .sync_seq = -1,
            .initial_sync_done = false,
            .nodes = .empty,
            .gpa = .init,
            .allocator = undefined,
            .log = null,
        };
    }

    pub fn deinit(self: *ZjContext) void {
        for (self.nodes.items) |node| {
            self.allocator.?.free(node.@"type");
            self.allocator.?.free(node.name);
            self.allocator.?.free(node.nickname);
            self.allocator.?.free(node.description);
            self.allocator.?.free(node.media_class);
        }
        self.nodes.deinit(self.allocator.?);

        if (self.registry) |registry| pw.pw_proxy_destroy(@ptrCast(registry));
        if (self.core) |core| _ = pw.pw_core_disconnect(core);
        if (self.context) |context| pw.pw_context_destroy(context);
        if (self.loop) |loop| pw.pw_main_loop_destroy(loop);
        pw_deinit();

        if (self.log) |log| log.deinit();
        std.debug.assert(self.gpa.deinit() == .ok);
    }
};

fn cstr(value: ?[*:0]const u8) []const u8 {
    return if (value) |ptr| std.mem.span(ptr) else "";
}

fn dictLookup(props: ?*const pw.spa_dict, key: [*:0]const u8) []const u8 {
    const dict = props orelse return "";
    return cstr(pw.spa_dict_lookup(dict, key));
}

fn dupOrEmpty(allocator: std.mem.Allocator, value: []const u8) ![]const u8 {
    return allocator.dupe(u8, value);
}

fn appendNode(zj: *ZjContext, node: NodeInfo) void {
    const allocator = zj.allocator.?;
    const owned = NodeInfo{
        .id = node.id,
        .permissions = node.permissions,
        .@"type" = dupOrEmpty(allocator, node.@"type") catch return,
        .version = node.version,
        .name = dupOrEmpty(allocator, node.name) catch return,
        .nickname = dupOrEmpty(allocator, node.nickname) catch return,
        .description = dupOrEmpty(allocator, node.description) catch return,
        .media_class = dupOrEmpty(allocator, node.media_class) catch return,
    };
    zj.nodes.append(allocator, owned) catch {
        allocator.free(owned.@"type");
        allocator.free(owned.name);
        allocator.free(owned.nickname);
        allocator.free(owned.description);
        allocator.free(owned.media_class);
    };
}

fn onRegistryGlobal(data: ?*anyopaque, id: u32, permissions: u32, type_name: ?[*:0]const u8, version: u32, props: ?*const pw.spa_dict) callconv(.c) void {
    const zj: *ZjContext = @ptrCast(@alignCast(data.?));
    const iface = cstr(type_name);

    if (!std.mem.eql(u8, iface, cstr(pw.PW_TYPE_INTERFACE_Node))) {
        return;
    }

    appendNode(zj, .{
        .id = id,
        .permissions = permissions,
        .@"type" = iface,
        .version = version,
        .name = dictLookup(props, pw.PW_KEY_NODE_NAME),
        .nickname = dictLookup(props, pw.PW_KEY_NODE_NICK),
        .description = dictLookup(props, pw.PW_KEY_NODE_DESCRIPTION),
        .media_class = dictLookup(props, pw.PW_KEY_MEDIA_CLASS),
    });
}

fn onRegistryGlobalRemove(_: ?*anyopaque, _: u32) callconv(.c) void {}

fn onCoreDone(data: ?*anyopaque, _: u32, seq: c_int) callconv(.c) void {
    const zj: *ZjContext = @ptrCast(@alignCast(data.?));
    if (seq != zj.sync_seq or zj.initial_sync_done) return;

    zj.initial_sync_done = true;
    _ = pw.pw_main_loop_quit(zj.loop.?);
}

fn onCoreError(data: ?*anyopaque, id: u32, seq: c_int, res: c_int, message: ?[*:0]const u8) callconv(.c) void {
    const zj: *ZjContext = @ptrCast(@alignCast(data.?));
    const line = std.fmt.allocPrint(
        zj.allocator.?,
        "PipeWire core error: id={d} seq={d} res={d} msg={s}",
        .{ id, seq, res, cstr(message) },
    ) catch return;
    defer zj.allocator.?.free(line);

    zj.log.?.err(line, @src()) catch {};
    _ = pw.pw_main_loop_quit(zj.loop.?);
}

const registry_events = pw.pw_registry_events{
    .version = pw.PW_VERSION_REGISTRY_EVENTS,
    .global = onRegistryGlobal,
    .global_remove = onRegistryGlobalRemove,
};

const core_events = pw.pw_core_events{
    .version = pw.PW_VERSION_CORE_EVENTS,
    .info = null,
    .done = onCoreDone,
    .ping = null,
    .@"error" = onCoreError,
    .remove_id = null,
    .bound_id = null,
    .add_mem = null,
    .remove_mem = null,
    .bound_props = null,
};

fn printUsage() void {
    std.debug.print(
        \\Usage:
        \\  zigjay -l
        \\  zigjay -c <node name> <+/-><number>
        \\
        \\Examples:
        \\  zigjay -l
        \\  zigjay -c "alsa_output.pci-0000_03_00.6.analog-stereo" +5
        \\  zigjay -c "alsa_output.pci-0000_03_00.6.analog-stereo" -10
        \\  zigjay -c "alsa_output.pci-0000_03_00.6.analog-stereo" 0
        \\  zigjay -c "alsa_output.pci-0000_03_00.6.analog-stereo" 50
        \\
    , .{});
}

fn parseU8(text: []const u8) !u8 {
    return try std.fmt.parseInt(u8, text, 10);
}

fn parseChange(text: []const u8) !VolumeChange {
    if (text.len == 0) return PipewireError.InvalidVolume;

    if (text[0] == '+' or text[0] == '-') {
        const value = try parseU8(text[1..]);
        if (value > 100) return PipewireError.InvalidVolume;
        return .{
            .kind = .relative,
            .value = value,
            .sign = text[0],
        };
    }

    const value = try parseU8(text);
    if (value > 100) return PipewireError.InvalidVolume;
    return .{
        .kind = .set,
        .value = value,
        .sign = 0,
    };
}

fn parseCli(args: []const [:0]const u8) !Cli {
    if (args.len < 2) return PipewireError.MissingMode;

    if (std.mem.eql(u8, args[1], "-l")) {
        if (args.len != 2) return PipewireError.InvalidArguments;
        return .{ .mode = .list };
    }

    if (std.mem.eql(u8, args[1], "-c")) {
        if (args.len != 4) return PipewireError.InvalidArguments;
        return .{
            .mode = .change,
            .node_name = args[2],
            .change = try parseChange(args[3]),
        };
    }

    return PipewireError.InvalidArguments;
}

fn collectNodes(zj: *ZjContext) !void {
    pw_init(null, null);

    zj.loop = pw.pw_main_loop_new(null) orelse return PipewireError.MainLoopInitFailed;
    zj.context = pw.pw_context_new(pw.pw_main_loop_get_loop(zj.loop.?), null, 0) orelse return PipewireError.ContextInitFailed;
    zj.core = pw.pw_context_connect(zj.context.?, null, 0) orelse return PipewireError.CoreConnectFailed;
    zj.registry = pw.pw_core_get_registry(zj.core.?, pw.PW_VERSION_REGISTRY, 0) orelse return PipewireError.RegistryInitFailed;

    _ = pw.pw_core_add_listener(zj.core.?, &zj.core_listener, &core_events, @ptrCast(zj));
    _ = pw.pw_registry_add_listener(zj.registry.?, &zj.registry_listener, &registry_events, @ptrCast(zj));

    zj.sync_seq = pw.pw_core_sync(zj.core.?, pw.PW_ID_CORE, 0);
    _ = pw.pw_main_loop_run(zj.loop.?);
}

fn listNodes(zj: *ZjContext) !void {
    for (zj.nodes.items) |node| {
        std.debug.print(
            "{d}\t{s}\t{s}\t{s}\n",
            .{
                node.id,
                if (node.name.len != 0) node.name else "(unnamed)",
                if (node.media_class.len != 0) node.media_class else "(no-class)",
                if (node.description.len != 0) node.description else node.nickname,
            },
        );
    }
}

fn findNodeByName(zj: *ZjContext, needle: []const u8) ?NodeInfo {
    for (zj.nodes.items) |node| {
        if (std.mem.eql(u8, node.name, needle)) return node;
        if (std.mem.eql(u8, node.nickname, needle)) return node;
        if (std.mem.eql(u8, node.description, needle)) return node;
    }
    return null;
}

fn formatWpctlArg(buf: []u8, change: VolumeChange) ![]const u8 {
    return switch (change.kind) {
        .set => std.fmt.bufPrint(buf, "{d}%", .{change.value}),
        .relative => std.fmt.bufPrint(buf, "{d}%{c}", .{ change.value, change.sign }),
    };
}

fn applyVolumeChange(allocator: std.mem.Allocator, io: std.Io, node: NodeInfo, change: VolumeChange) !void {
    var id_buf: [32]u8 = undefined;
    const id_arg = try std.fmt.bufPrint(&id_buf, "{d}", .{node.id});

    var vol_buf: [32]u8 = undefined;
    const vol_arg = try formatWpctlArg(&vol_buf, change);

    const result = try std.process.run(allocator, io, .{
        .argv = &.{ "wpctl", "set-volume", id_arg, vol_arg },
    });
    defer allocator.free(result.stdout);
    defer allocator.free(result.stderr);

    switch (result.term) {
        .exited => |code| {
            if (code != 0) return PipewireError.VolumeCommandFailed;
        },
        else => return PipewireError.VolumeCommandFailed,
    }

    if (change.kind == .set and change.value == 0) {
        const mute_result = try std.process.run(allocator, io, .{
            .argv = &.{ "wpctl", "set-mute", id_arg, "1" },
        });
        defer allocator.free(mute_result.stdout);
        defer allocator.free(mute_result.stderr);

        switch (mute_result.term) {
            .exited => |code| if (code != 0) return PipewireError.VolumeCommandFailed,
            else => return PipewireError.VolumeCommandFailed,
        }
    } else if (change.kind == .set) {
        const unmute_result = try std.process.run(allocator, io, .{
            .argv = &.{ "wpctl", "set-mute", id_arg, "0" },
        });
        defer allocator.free(unmute_result.stdout);
        defer allocator.free(unmute_result.stderr);

        switch (unmute_result.term) {
            .exited => |code| if (code != 0) return PipewireError.VolumeCommandFailed,
            else => return PipewireError.VolumeCommandFailed,
        }
    }
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    const cli = parseCli(args) catch |err| {
        printUsage();
        return err;
    };

    var zj = ZjContext.init();
    zj.allocator = zj.gpa.allocator();
    zj.log = try logly.Logger.init(zj.allocator.?);
    defer zj.deinit();

    try collectNodes(&zj);

    switch (cli.mode) {
        .list => try listNodes(&zj),
        .change => {
            const node = findNodeByName(&zj, cli.node_name.?) orelse return PipewireError.NodeNotFound;
            try applyVolumeChange(arena, init.io, node, cli.change.?);
            std.debug.print("updated {s}\n", .{node.name});
        },
    }
}
