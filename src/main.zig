const std = @import("std");
const wp = @import("wp");
const glib = @import("glib");
const go = @import("gobject");

const AppError = error{
    ConnectionFailed,
    CollectionFailed,
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
    name: []const u8,
    nickname: []const u8,
    description: []const u8,
    media_name: []const u8,
    media_class: []const u8,
    application_name: []const u8,
    process_binary: []const u8,
    state: wp.NodeState,
};

const Cli = struct {
    mode: Mode,
    node_name: ?[]const u8 = null,
    change: ?VolumeChange = null,
};

const Collector = struct {
    core: ?*wp.Core,
    object_manager: ?*wp.ObjectManager,
    nodes: std.ArrayList(NodeInfo),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) Collector {
        return .{
            .core = null,
            .object_manager = null,
            .nodes = .empty,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Collector) void {
        for (self.nodes.items) |node| {
            self.allocator.free(node.name);
            self.allocator.free(node.nickname);
            self.allocator.free(node.description);
            self.allocator.free(node.media_name);
            self.allocator.free(node.media_class);
            self.allocator.free(node.application_name);
            self.allocator.free(node.process_binary);
        }
        self.nodes.deinit(self.allocator);

        if (self.object_manager) |object_manager| {
            object_manager.unref();
        }
        if (self.core) |core| {
            core.disconnect();
            core.unref();
        }
    }
};

fn cstr(value: ?[*:0]const u8) []const u8 {
    return if (value) |ptr| std.mem.span(ptr) else "";
}

fn dupOrEmpty(allocator: std.mem.Allocator, value: ?[*:0]const u8) ![]const u8 {
    return allocator.dupe(u8, cstr(value));
}

fn isAudioNode(node: *wp.Node) bool {
    const media_class = cstr(node.as(wp.PipewireObject).getProperty("media.class"));
    return std.mem.indexOf(u8, media_class, "Audio") != null;
}

fn appendNode(collector: *Collector, node: *wp.Node) void {
    if (!isAudioNode(node)) {
        return;
    }

    const allocator = collector.allocator;
    const owned = NodeInfo{
        .id = node.as(wp.Proxy).getBoundId(),
        .name = dupOrEmpty(allocator, node.as(wp.PipewireObject).getProperty("node.name")) catch return,
        .nickname = dupOrEmpty(allocator, node.as(wp.PipewireObject).getProperty("node.nick")) catch return,
        .description = dupOrEmpty(allocator, node.as(wp.PipewireObject).getProperty("node.description")) catch return,
        .media_name = dupOrEmpty(allocator, node.as(wp.PipewireObject).getProperty("media.name")) catch return,
        .media_class = dupOrEmpty(allocator, node.as(wp.PipewireObject).getProperty("media.class")) catch return,
        .application_name = dupOrEmpty(allocator, node.as(wp.PipewireObject).getProperty("application.name")) catch return,
        .process_binary = dupOrEmpty(allocator, node.as(wp.PipewireObject).getProperty("application.process.binary")) catch return,
        .state = node.getState(null),
    };
    collector.nodes.append(allocator, owned) catch {
        allocator.free(owned.name);
        allocator.free(owned.nickname);
        allocator.free(owned.description);
        allocator.free(owned.media_name);
        allocator.free(owned.media_class);
        allocator.free(owned.application_name);
        allocator.free(owned.process_binary);
    };
}

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
    if (text.len == 0) return AppError.InvalidVolume;

    if (text[0] == '+' or text[0] == '-') {
        const value = try parseU8(text[1..]);
        if (value > 100) return AppError.InvalidVolume;
        return .{
            .kind = .relative,
            .value = value,
            .sign = text[0],
        };
    }

    const value = try parseU8(text);
    if (value > 100) return AppError.InvalidVolume;
    return .{
        .kind = .set,
        .value = value,
        .sign = 0,
    };
}

fn parseCli(args: []const [:0]const u8) !Cli {
    if (args.len < 2) return AppError.MissingMode;

    if (std.mem.eql(u8, args[1], "-l")) {
        if (args.len != 2) return AppError.InvalidArguments;
        return .{ .mode = .list };
    }

    if (std.mem.eql(u8, args[1], "-c")) {
        if (args.len != 4) return AppError.InvalidArguments;
        return .{
            .mode = .change,
            .node_name = args[2],
            .change = try parseChange(args[3]),
        };
    }

    return AppError.InvalidArguments;
}

fn collectActiveNodes(collector: *Collector, object_manager: *wp.ObjectManager) void {
    var iter = object_manager.newIterator();
    defer iter.unref();

    while (true) {
        var value = std.mem.zeroes(go.Value);
        defer value.unset();

        if (iter.next(&value) == 0) {
            break;
        }

        const object = value.getObject() orelse continue;
        appendNode(collector, @ptrCast(@alignCast(object)));
    }
}

fn collectNodes(collector: *Collector) !void {
    const no_constraints: usize = 0;
    const object_features: wp.ObjectFeatures = @bitCast(wp.ProxyFeatures.flags_pipewire_object_features_minimal);

    wp.init(wp.InitFlags.flags_all);

    collector.core = wp.Core.new(null, null, null);
    collector.object_manager = wp.ObjectManager.new();

    collector.object_manager.?.addInterest(wp.Node.getGObjectType(), no_constraints);
    collector.object_manager.?.requestObjectFeatures(wp.GlobalProxy.getGObjectType(), object_features);

    if (collector.core.?.connect() < 0) {
        return AppError.ConnectionFailed;
    }

    collector.core.?.installObjectManager(collector.object_manager.?);

    for (0..5000) |_| {
        if (collector.object_manager.?.isInstalled() != 0) {
            collectActiveNodes(collector, collector.object_manager.?);
            return;
        }

        while (glib.MainContext.pending(null) != 0) {
            _ = glib.MainContext.iteration(null, 0);
        }
    }

    if (collector.object_manager.?.isInstalled() == 0) {
        return AppError.CollectionFailed;
    }
}

fn stateLabel(state: wp.NodeState) []const u8 {
    return switch (state) {
        .creating => "creating",
        .suspended => "suspended",
        .idle => "idle",
        .running => "running",
        .@"error" => "error",
        else => "unknown",
    };
}

fn displayLabel(node: NodeInfo) []const u8 {
    if (node.description.len != 0) return node.description;
    if (node.media_name.len != 0) return node.media_name;
    if (node.application_name.len != 0) return node.application_name;
    if (node.nickname.len != 0) return node.nickname;
    if (node.name.len != 0) return node.name;
    return "(unnamed)";
}

fn processLabel(node: NodeInfo) []const u8 {
    if (node.application_name.len != 0) return node.application_name;
    if (node.process_binary.len != 0) return node.process_binary;
    return "-";
}

fn listNodes(collector: *Collector) void {
    for (collector.nodes.items) |node| {
        std.debug.print(
            "{d}\t{s}\t{s}\t{s}\t{s}\t{s}\n",
            .{
                node.id,
                stateLabel(node.state),
                if (node.media_class.len != 0) node.media_class else "(no-class)",
                displayLabel(node),
                processLabel(node),
                if (node.name.len != 0) node.name else "-",
            },
        );
    }
}

fn findNodeByName(collector: *Collector, needle: []const u8) ?NodeInfo {
    const maybe_id = std.fmt.parseInt(u32, needle, 10) catch null;
    for (collector.nodes.items) |node| {
        if (maybe_id) |id| {
            if (node.id == id) return node;
        }
        if (std.mem.eql(u8, node.name, needle)) return node;
        if (std.mem.eql(u8, node.nickname, needle)) return node;
        if (std.mem.eql(u8, node.description, needle)) return node;
        if (std.mem.eql(u8, node.media_name, needle)) return node;
        if (std.mem.eql(u8, node.application_name, needle)) return node;
        if (std.mem.eql(u8, node.process_binary, needle)) return node;
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
            if (code != 0) return AppError.VolumeCommandFailed;
        },
        else => return AppError.VolumeCommandFailed,
    }

    if (change.kind == .set and change.value == 0) {
        const mute_result = try std.process.run(allocator, io, .{
            .argv = &.{ "wpctl", "set-mute", id_arg, "1" },
        });
        defer allocator.free(mute_result.stdout);
        defer allocator.free(mute_result.stderr);

        switch (mute_result.term) {
            .exited => |code| if (code != 0) return AppError.VolumeCommandFailed,
            else => return AppError.VolumeCommandFailed,
        }
    } else if (change.kind == .set) {
        const unmute_result = try std.process.run(allocator, io, .{
            .argv = &.{ "wpctl", "set-mute", id_arg, "0" },
        });
        defer allocator.free(unmute_result.stdout);
        defer allocator.free(unmute_result.stderr);

        switch (unmute_result.term) {
            .exited => |code| if (code != 0) return AppError.VolumeCommandFailed,
            else => return AppError.VolumeCommandFailed,
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

    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();

    var collector = Collector.init(arena_state.allocator());
    defer collector.deinit();

    try collectNodes(&collector);

    switch (cli.mode) {
        .list => listNodes(&collector),
        .change => {
            const node = findNodeByName(&collector, cli.node_name.?) orelse return AppError.NodeNotFound;
            try applyVolumeChange(arena, init.io, node, cli.change.?);
            std.debug.print("updated {s}\n", .{node.name});
        },
    }
}
