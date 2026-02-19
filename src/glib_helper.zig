const std = @import("std");
const glib = @import("glib");
const go = @import("gobject");

pub inline fn signalConnectSwapped(p_instance: *go.Object, p_detailed_signal: [*:0]const u8, p_c_handler: go.Callback, p_data: ?*anyopaque) void {
    go.signalConnectData(p_instance, p_detailed_signal, p_c_handler, p_data, null, 2); // 1 << 1
}
