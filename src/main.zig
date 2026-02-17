const std = @import("std");
const wp = @import("wp");
const glib = @import("glib");
const go = @import("gobject");

const WpError = error{ConnectionFailed};

const StationContext = struct {
    default_volume: f64,
    small_volume: f64,
};

pub const ZjContext = struct {
    core: ?*wp.Core,
    loop: ?*glib.MainLoop,
    om: ?*wp.ObjectManager,
    pub fn init() ZjContext {
        return ZjContext{
            .core = null,
            .loop = null,
            .om = null,
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
};

fn onSigInt(p_data: ?*anyopaque) callconv(.c) c_int {
    const zj: *ZjContext = @ptrCast(@alignCast(p_data orelse return -1));

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
    zj.om.?.addInterest(client_type, @as(usize, 0));
    zj.om.?.requestObjectFeatures(client_type, 31);

    zj.core.?.installObjectManager(zj.om.?);

    if (zj.core.?.connect() < 0) {
        return WpError.ConnectionFailed;
    }

    std.debug.print("Successfully connected to WirePlumber!\n", .{});
    _ = glib.unixSignalAdd(2, &onSigInt, &zj);

    zj.loop.?.run();
}
