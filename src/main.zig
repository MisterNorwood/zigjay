const std = @import("std");
const wp = @import("wp");
const glib = @import("glib");
const go = @import("gobject");

const WpError = error{ConnectionFailed};

const StationContext = struct {
    default_volume: f64,
    small_volume: f64,
};

fn onObjectAdded(manager: *wp.ObjectManager, p_object: *go.Object, _: *StationContext) callconv(.c) void {
    const node: *wp.Node = @ptrCast(p_object);
    _ = manager;

    const props = wp.PipewireObject.getProperties(@ptrCast(node));
    const station = wp.Properties.get(props, "custom.station.index");

    std.debug.print("Station detected: {s}\n", .{station orelse "none"});
}

pub fn main() !void {
    wp.init(wp.InitFlags.flags_pipewire);

    const loop = glib.MainLoop.new(null, 0);
    const wp_core = wp.Core.new(null, null, null);
    const obj_manager = wp.ObjectManager.new();
    wp.ObjectManager.addInterest(obj_manager, wp.Node.getGObjectType());

    var settings = StationContext{
        .default_volume = 1.0,
        .small_volume = 0.5,
    };

    obj_manager.requestObjectFeatures(wp.Node.getGObjectType(), 15);

    _ = wp.ObjectManager.signals.object_added.connect(obj_manager, *StationContext, &onObjectAdded, &settings, .{});
    wp.Core.installObjectManager(wp_core, obj_manager);

    if (wp.Core.connect(wp_core) < 0) {
        return WpError.ConnectionFailed;
    }
    std.debug.print("Successfully connected to WirePlumber!\n", .{});
    glib.MainLoop.run(loop);

    defer wp_core.disconnect();

    const version = wp.getLibraryVersion();
    std.debug.print("WirePlumber version: {s}\n", .{version});
}
