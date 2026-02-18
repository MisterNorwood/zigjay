const std = @import("std");
const wp = @import("wp");
const glib = @import("glib");
const go = @import("gobject");
const gio = @import("gio");

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
    pub fn init() ZjContext {
        return ZjContext{
            .core = null,
            .loop = null,
            .om = null,
            .pending_pugins = 0,
        };
    }

    pub fn deinit(self: *ZjContext) void {
        if (self.om) |om| _ = om.unref();
        if (self.core) |core| {
            core.disconnect();
            core.unref();
        }
        if (self.loop) |loop| loop.unref();

        std.debug.print("\nExiting...", .{});
    }

    pub fn onAddPlugin(_: ?*go.Object, res: ?*gio.AsyncResult, p_input: ?*anyopaque) callconv(.c) void {
        const zj: *ZjContext = @ptrCast(@alignCast(p_input.?));
        var err: ?*glib.Error = null;
        if (zj.core.?.loadComponentFinish(res.?, &err) <= 0) {
            if (err) |e| {
                std.debug.print("Load failed: {s}\n", .{e.f_message orelse "null"});
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

//Basically null for anything that requires GType, TODO: Fix up bindings
const unull = @as(usize, 0);

fn onSigInt(p_data: ?*anyopaque) callconv(.c) c_int {
    const zj: *ZjContext = @ptrCast(@alignCast(p_data.?));

    std.debug.print("\nSIGINT recieved, stopping loop", .{});
    zj.loop.?.quit();

    return 0;
}

pub fn main() !void {
    wp.init(wp.InitFlags.flags_pipewire);
    var zj = ZjContext.init();
    defer zj.deinit();
    const version = wp.getLibraryVersion();
    std.debug.print("WirePlumber version: {s}\n", .{version});

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

    std.debug.print("Successfully connected to WirePlumber!\n", .{});
    _ = glib.unixSignalAdd(2, &onSigInt, &zj);

    zj.loop.?.run();
}
