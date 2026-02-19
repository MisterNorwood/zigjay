const std = @import("std");
const glib = @import("glib");
const go = @import("gobject");

pub inline fn signalConnectSwapped(p_instance: *go.Object, p_detailed_signal: [*:0]const u8, p_c_handler: go.Callback, p_data: ?*anyopaque) void {
    _ = go.signalConnectData(p_instance, p_detailed_signal, p_c_handler, p_data, null, go.ConnectFlags.flags_swapped);
}

pub fn Wrap(comptime T: type, comptime func: fn (*T) void) type {
    return struct {
        pub fn wrapper(instance: *anyopaque, data: *anyopaque) callconv(.c) void {
            _ = instance;
            const context: *T = @ptrCast(@alignCast(data));
            func(context);
        }
    };
}

pub fn WrapEmpty(comptime func: fn () void) type {
    return struct {
        pub fn wrapper() callconv(.c) void {
            func();
        }
    };
}
