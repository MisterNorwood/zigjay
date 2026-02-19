const std = @import("std");
const wp = @import("wp");
const glib = @import("glib");
const go = @import("gobject");
const gio = @import("gio");
const logly = @import("logly");
const goh = @import("glib_helper.zig");

const WpError = error{ConnectionFailed};

const StationContext = struct {
    default_volume: f64,
    small_volume: f64,
};

pub const ZjContext = struct {
    core: ?*wp.Core,
    loop: ?*glib.MainLoop,
    om: ?*wp.ObjectManager,
    pending_pugins: u8,
    gpa: std.heap.GeneralPurposeAllocator(.{}),
    allocator: ?std.mem.Allocator,
    log: ?*logly.Logger,

    pub fn init() ZjContext {
        return ZjContext{
            .core = null,
            .loop = null,
            .om = null,
            .pending_pugins = 0,
            .allocator = undefined,
            .gpa = std.heap.GeneralPurposeAllocator(.{}){},
            .log = null,
        };
    }

    pub fn deinit(self: *ZjContext) void {
        if (self.om) |om| _ = om.unref();
        if (self.core) |core| {
            core.disconnect();
            core.unref();
        }
        if (self.loop) |loop| loop.unref();
        if (self.log) |log| log.deinit();
        _ = self.gpa.deinit();

        std.log.info("\nExiting...", .{});
    }

    pub fn onAddPlugin(_: ?*go.Object, res: ?*gio.AsyncResult, p_input: ?*anyopaque) callconv(.c) void {
        const zj: *ZjContext = @ptrCast(@alignCast(p_input.?));
        var err: ?*glib.Error = null;
        if (zj.core.?.loadComponentFinish(res.?, &err) <= 0) {
            if (err) |e| {
                const errFmt = std.fmt.allocPrint(zj.allocator.?, "Load failed: {s}", .{e.f_message orelse "null"}) catch "OutOfMemory!";
                defer zj.allocator.?.free(errFmt);
                zj.log.?.err(errFmt, null) catch {};
                defer zj.log.?.flush() catch {};

                defer err.?.free();
            }
            return;
        }
        zj.pending_pugins -= 1;
        if (zj.pending_pugins == 0) {
            const mixer = wp.Plugin.find(zj.core.?, "mixer-api");
            const gobj: *go.Object = @ptrCast(mixer.?);
            gobj.set("scale", @as(c_int, 1), @as(?*anyopaque, null));

            zj.core.?.installObjectManager(zj.om.?);
        }
    }
};

const unull = @as(usize, 0);

fn onSigInt(p_data: ?*anyopaque) callconv(.c) c_int {
    const zj: *ZjContext = @ptrCast(@alignCast(p_data.?));
    zj.log.?.info("\nSIGINT recieved, stopping loop", @src()) catch {};
    zj.log.?.flush() catch {};
    zj.loop.?.quit();

    return 0;
}

pub fn main() !void {
    wp.init(wp.InitFlags.flags_pipewire);
    var zj = ZjContext.init();
    zj.allocator = zj.gpa.allocator();
    zj.log = try logly.Logger.init(zj.allocator.?);
    defer zj.deinit();

    var buf: [64]u8 = undefined;
    const version = wp.getLibraryVersion();
    const wpVer = try std.fmt.bufPrint(&buf, "WirePlumber version: {s}", .{version});

    try zj.log.?.info(wpVer, null);

    zj.loop = glib.MainLoop.new(null, 0);
    zj.core = wp.Core.new(null, null, null);
    zj.om = wp.ObjectManager.new();

    const client_type = wp.Client.getGObjectType();
    zj.om.?.addInterest(client_type, unull);
    zj.om.?.requestObjectFeatures(client_type, 31);

    if (zj.core.?.connect() < 0) {
        return WpError.ConnectionFailed;
    }
    zj.pending_pugins += 1;
    zj.core.?.loadComponent("libwireplumber-module-default-nodes-api", "module", null, null, null, &ZjContext.onAddPlugin, &zj);
    zj.pending_pugins += 1;
    zj.core.?.loadComponent("libwireplumber-module-mixer-api", "module", null, null, null, &ZjContext.onAddPlugin, &zj);

    //zj.core.?.loadComponent("libwireplumber-module-mixer-api", "module", null);

    try zj.log.?.info("Successfully connected to WirePlumber!", @src());
    _ = glib.unixSignalAdd(2, &onSigInt, &zj);

    goh.signalConnectSwapped(@ptrCast(@alignCast(zj.core.?)), "disconnected", &zj.loop.?.quit(), &zj);
    try zj.log.?.flush();
    zj.loop.?.run();
}
