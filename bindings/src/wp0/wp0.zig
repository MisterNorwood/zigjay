pub const ext = @import("ext.zig");
const wp = @This();

const std = @import("std");
const compat = @import("compat");
const gio = @import("gio2");
const gobject = @import("gobject2");
const glib = @import("glib2");
const gmodule = @import("gmodule2");
pub const ObjectFeatures = c_uint;

pub const SpaIdTable = *const anyopaque;

pub const SpaIdValue = *const anyopaque;

/// An event hook that runs a WpTransition, implemented with closures.
pub const AsyncEventHook = opaque {
    pub const Parent = wp.InterestEventHook;
    pub const Implements = [_]type{};
    pub const Class = wp.AsyncEventHookClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const execute_step = struct {
            pub const name = "execute-step";

            pub const Type = ?*gobject.Closure;
        };

        pub const get_next_step = struct {
            pub const name = "get-next-step";

            pub const Type = ?*gobject.Closure;
        };
    };

    pub const signals = struct {};

    extern fn wp_async_event_hook_new(p_name: [*:0]const u8, p_before: *[*:0]const u8, p_after: *[*:0]const u8, p_get_next_step: *gobject.Closure, p_execute_step: *gobject.Closure) *wp.AsyncEventHook;
    pub const new = wp_async_event_hook_new;

    extern fn wp_async_event_hook_get_type() usize;
    pub const getGObjectType = wp_async_event_hook_get_type;

    extern fn g_object_ref(p_self: *wp.AsyncEventHook) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.AsyncEventHook) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *AsyncEventHook, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The WpClient class allows accessing the properties and methods of a PipeWire client object (struct pw_client). A WpClient is constructed internally when a new client connects to PipeWire and it is made available through the WpObjectManager API.
pub const Client = opaque {
    pub const Parent = wp.GlobalProxy;
    pub const Implements = [_]type{wp.PipewireObject};
    pub const Class = wp.ClientClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Send an error to the client.
    extern fn wp_client_send_error(p_self: *Client, p_id: u32, p_res: c_int, p_message: [*:0]const u8) void;
    pub const sendError = wp_client_send_error;

    /// Update client's permissions on a list of objects.
    ///
    ///
    /// An object id of -1 can be used to set the default object permissions for this client
    extern fn wp_client_update_permissions(p_self: *Client, p_n_perm: c_uint, ...) void;
    pub const updatePermissions = wp_client_update_permissions;

    /// Update client's permissions on a list of objects.
    ///
    ///
    /// An object id of -1 can be used to set the default object permissions for this client
    extern fn wp_client_update_permissions_array(p_self: *Client, p_n_perm: c_uint, p_permissions: [*]const @compileError("not enough type information available")) void;
    pub const updatePermissionsArray = wp_client_update_permissions_array;

    /// Updates the properties of `self`.
    ///
    ///
    /// This requires W and X permissions on the client.
    extern fn wp_client_update_properties(p_self: *Client, p_updates: *wp.Properties) void;
    pub const updateProperties = wp_client_update_properties;

    extern fn wp_client_get_type() usize;
    pub const getGObjectType = wp_client_get_type;

    extern fn g_object_ref(p_self: *wp.Client) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Client) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Client, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// WpConf allows accessing the different sections of the wireplumber configuration.
pub const Conf = opaque {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.ConfClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const name = struct {
            pub const name = "name";

            pub const Type = ?[*:0]u8;
        };

        pub const properties = struct {
            pub const name = "properties";

            pub const Type = ?*wp.Properties;
        };
    };

    pub const signals = struct {};

    /// Creates a new WpConf object.
    ///
    ///
    /// This does not open the files, it only creates the object. For most use cases, you should use `wp.Conf.newOpen` instead.
    extern fn wp_conf_new(p_name: [*:0]const u8, p_properties: ?*wp.Properties) *wp.Conf;
    pub const new = wp_conf_new;

    /// Creates a new WpConf object and opens the configuration file and its fragments, keeping them mapped in memory for further access.
    extern fn wp_conf_new_open(p_name: [*:0]const u8, p_properties: ?*wp.Properties, p_error: ?*?*glib.Error) ?*wp.Conf;
    pub const newOpen = wp_conf_new_open;

    /// Closes the configuration file and its fragments.
    extern fn wp_conf_close(p_self: *Conf) void;
    pub const close = wp_conf_close;

    /// Gets the name of the configuration file.
    extern fn wp_conf_get_name(p_self: *Conf) [*:0]const u8;
    pub const getName = wp_conf_get_name;

    /// This method will get the JSON value of a specific section from the configuration. If the same section is defined in multiple locations, the sections with the same name will be either merged in case of arrays and objects, or overridden in case of boolean, int, double and strings.
    extern fn wp_conf_get_section(p_self: *Conf, p_section: [*:0]const u8) ?*wp.SpaJson;
    pub const getSection = wp_conf_get_section;

    /// Tests if the configuration files are open.
    extern fn wp_conf_is_open(p_self: *Conf) c_int;
    pub const isOpen = wp_conf_is_open;

    /// Opens the configuration file and its fragments and keeps them mapped in memory for further access.
    extern fn wp_conf_open(p_self: *Conf, p_error: ?*?*glib.Error) c_int;
    pub const open = wp_conf_open;

    /// Parses standard pw_context sections from `conf`.
    extern fn wp_conf_parse_pw_context_sections(p_self: *Conf, p_context: ?*anyopaque) void;
    pub const parsePwContextSections = wp_conf_parse_pw_context_sections;

    /// Updates the given properties with the values of a specific section from the configuration.
    extern fn wp_conf_section_update_props(p_self: *Conf, p_section: [*:0]const u8, p_props: *wp.Properties) c_int;
    pub const sectionUpdateProps = wp_conf_section_update_props;

    extern fn wp_conf_get_type() usize;
    pub const getGObjectType = wp_conf_get_type;

    extern fn g_object_ref(p_self: *wp.Conf) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Conf) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Conf, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The core is the central object around which everything operates. It is essential to create a WpCore before using any other WirePlumber API.
/// The core object has the following responsibilities:
///  - it initializes the PipeWire library
///  - it creates a pw_context and allows connecting to the PipeWire server, creating a local pw_core
///  - it glues the PipeWire library's event loop system with GMainLoop
///  - it maintains a list of registered objects, which other classes use to keep objects loaded permanently into memory
///  - it watches the PipeWire registry and keeps track of remote and local objects that appear in the registry, making them accessible through the WpObjectManager API.
///
/// The core is also responsible for loading components, which are defined in the main configuration file. Components are loaded when WP_CORE_FEATURE_COMPONENTS is activated.
/// The main configuration file needs to be created and opened before the core is created, using the WpConf API. It is then passed to the core as an argument in the constructor.
/// If a configuration file is not provided, the core will let the underlying pw_context load its own configuration, based on the rules that apply to all pipewire clients (e.g. it respects the PIPEWIRE_CONFIG_NAME environment variable and loads "client.conf" as a last resort).
/// If a configuration file is provided, the core does not let the underlying pw_context load any configuration and instead uses the provided WpConf object.
pub const Core = opaque {
    pub const Parent = wp.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.CoreClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const conf = struct {
            pub const name = "conf";

            pub const Type = ?*wp.Conf;
        };

        pub const g_main_context = struct {
            pub const name = "g-main-context";

            pub const Type = ?*glib.MainContext;
        };

        pub const properties = struct {
            pub const name = "properties";

            pub const Type = ?*wp.Properties;
        };

        pub const pw_context = struct {
            pub const name = "pw-context";

            pub const Type = ?*anyopaque;
        };

        pub const pw_core = struct {
            pub const name = "pw-core";

            pub const Type = ?*anyopaque;
        };
    };

    pub const signals = struct {
        pub const connected = struct {
            pub const name = "connected";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Core, p_instance))),
                    gobject.signalLookup("connected", Core.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        pub const disconnected = struct {
            pub const name = "disconnected";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Core, p_instance))),
                    gobject.signalLookup("disconnected", Core.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Creates a new core object.
    extern fn wp_core_new(p_context: ?*glib.MainContext, p_conf: ?*wp.Conf, p_properties: ?*wp.Properties) *wp.Core;
    pub const new = wp_core_new;

    /// Clones a core with the same context as `self`.
    extern fn wp_core_clone(p_self: *Core) *wp.Core;
    pub const clone = wp_core_clone;

    /// Connects this core to the PipeWire server.
    ///
    ///
    /// When connection succeeds, the WpCore "connected" signal is emitted.
    extern fn wp_core_connect(p_self: *Core) c_int;
    pub const connect = wp_core_connect;

    /// Connects this core to the PipeWire server on the given socket.
    ///
    ///
    /// When connection succeeds, the WpCore "connected" signal is emitted.
    extern fn wp_core_connect_fd(p_self: *Core, p_fd: c_int) c_int;
    pub const connectFd = wp_core_connect_fd;

    /// Disconnects this core from the PipeWire server.
    ///
    ///
    /// This also effectively destroys all WpCore objects that were created through the registry, destroys the pw_core and finally emits the WpCore "disconnected" signal.
    extern fn wp_core_disconnect(p_self: *Core) void;
    pub const disconnect = wp_core_disconnect;

    /// Finds a registered object.
    extern fn wp_core_find_object(p_self: *Core, p_func: glib.EqualFunc, p_data: ?*const anyopaque) ?*gobject.Object;
    pub const findObject = wp_core_find_object;

    /// Gets the main configuration file of the core.
    extern fn wp_core_get_conf(p_self: *Core) ?*wp.Conf;
    pub const getConf = wp_core_get_conf;

    /// Returns the special WpCore that is used to maintain a secondary connection to PipeWire, for exporting objects.
    ///
    ///
    /// The export core is enabled by loading the built-in "export-core" component.
    extern fn wp_core_get_export_core(p_self: *Core) *wp.Core;
    pub const getExportCore = wp_core_get_export_core;

    /// Gets the GMainContext of the core.
    extern fn wp_core_get_g_main_context(p_self: *Core) ?*glib.MainContext;
    pub const getGMainContext = wp_core_get_g_main_context;

    /// Gets the bound id of the client object that is created as a result of this core being connected to the PipeWire daemon.
    extern fn wp_core_get_own_bound_id(p_self: *Core) u32;
    pub const getOwnBoundId = wp_core_get_own_bound_id;

    /// Gets the properties of the core.
    extern fn wp_core_get_properties(p_self: *Core) *wp.Properties;
    pub const getProperties = wp_core_get_properties;

    /// Gets the internal PipeWire context of the core.
    extern fn wp_core_get_pw_context(p_self: *Core) ?*anyopaque;
    pub const getPwContext = wp_core_get_pw_context;

    /// Gets the internal PipeWire core of the core.
    extern fn wp_core_get_pw_core(p_self: *Core) ?*anyopaque;
    pub const getPwCore = wp_core_get_pw_core;

    /// Gets the cookie of the core's connected PipeWire instance.
    extern fn wp_core_get_remote_cookie(p_self: *Core) u32;
    pub const getRemoteCookie = wp_core_get_remote_cookie;

    /// Gets the host name of the core's connected PipeWire instance.
    extern fn wp_core_get_remote_host_name(p_self: *Core) [*:0]const u8;
    pub const getRemoteHostName = wp_core_get_remote_host_name;

    /// Gets the name of the core's connected PipeWire instance.
    extern fn wp_core_get_remote_name(p_self: *Core) [*:0]const u8;
    pub const getRemoteName = wp_core_get_remote_name;

    /// Gets the properties of the core's connected PipeWire instance.
    extern fn wp_core_get_remote_properties(p_self: *Core) *wp.Properties;
    pub const getRemoteProperties = wp_core_get_remote_properties;

    /// Gets the user name of the core's connected PipeWire instance.
    extern fn wp_core_get_remote_user_name(p_self: *Core) [*:0]const u8;
    pub const getRemoteUserName = wp_core_get_remote_user_name;

    /// Gets the version of the core's connected PipeWire instance.
    extern fn wp_core_get_remote_version(p_self: *Core) [*:0]const u8;
    pub const getRemoteVersion = wp_core_get_remote_version;

    /// Gets the virtual machine type of the core.
    extern fn wp_core_get_vm_type(p_self: *Core) ?[*:0]u8;
    pub const getVmType = wp_core_get_vm_type;

    /// Adds an idle callback to be called in the same GMainContext as the one used by this core.
    ///
    ///
    /// This is essentially the same as `glib.idleAddFull`, but it adds the created GSource on the GMainContext used by this core instead of the default context.
    extern fn wp_core_idle_add(p_self: *Core, p_source: ?**glib.Source, p_function: glib.SourceFunc, p_data: ?*anyopaque, p_destroy: ?glib.DestroyNotify) void;
    pub const idleAdd = wp_core_idle_add;

    /// Adds an idle callback to be called in the same GMainContext as the one used by this core.
    ///
    ///
    /// This is the same as `wp.Core.idleAdd`, but it allows you to specify a GClosure instead of a C callback.
    extern fn wp_core_idle_add_closure(p_self: *Core, p_source: ?**glib.Source, p_closure: *gobject.Closure) void;
    pub const idleAddClosure = wp_core_idle_add_closure;

    /// Installs the object manager on this core, activating its internal management engine.
    ///
    ///
    /// This will immediately emit signals about objects added on `om` if objects that the `om` is interested in were in existence already.
    extern fn wp_core_install_object_manager(p_self: *Core, p_om: *wp.ObjectManager) void;
    pub const installObjectManager = wp_core_install_object_manager;

    /// Checks if the core is connected to PipeWire.
    extern fn wp_core_is_connected(p_self: *Core) c_int;
    pub const isConnected = wp_core_is_connected;

    /// Loads the specified `component` on `self`.
    ///
    ///
    /// The `type` will determine which component loader to use. The following types are built-in and will always work without a component loader:
    ///  - "module" - Loads a WirePlumber module
    ///  - "array" - Loads multiple components interpreting the `args` as a JSON array with component definitions, as they would appear in the configuration file. When this type is used, `component` is ignored and can be NULL
    extern fn wp_core_load_component(p_self: *Core, p_component: ?[*:0]const u8, p_type: [*:0]const u8, p_args: ?*wp.SpaJson, p_provides: ?[*:0]const u8, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) void;
    pub const loadComponent = wp_core_load_component;

    /// Finishes the operation started by `wp.Core.loadComponent`. This is meant to be called in the callback that was passed to that method.
    extern fn wp_core_load_component_finish(p_self: *Core, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int;
    pub const loadComponentFinish = wp_core_load_component_finish;

    /// Registers `obj` with the core, making it appear on WpObjectManager instances as well.
    ///
    ///
    /// The core will also maintain a ref to that object until it is removed.
    extern fn wp_core_register_object(p_self: *Core, p_obj: *gobject.Object) void;
    pub const registerObject = wp_core_register_object;

    /// Detaches and unrefs the specified object from this core.
    extern fn wp_core_remove_object(p_self: *Core, p_obj: *gobject.Object) void;
    pub const removeObject = wp_core_remove_object;

    /// Asks the PipeWire server to call the `callback` via an event.
    ///
    ///
    /// Since methods are handled in-order and events are delivered in-order, this can be used as a barrier to ensure all previous methods and the resulting events have been handled.
    /// In both success and error cases, `callback` is always called. Use `wp.Core.syncFinish` from within the `callback` to determine whether the operation completed successfully or if an error occurred.
    extern fn wp_core_sync(p_self: *Core, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_user_data: ?*anyopaque) c_int;
    pub const sync = wp_core_sync;

    /// Asks the PipeWire server to invoke the `closure` via an event.
    ///
    ///
    /// Since methods are handled in-order and events are delivered in-order, this can be used as a barrier to ensure all previous methods and the resulting events have been handled.
    /// In both success and error cases, `closure` is always invoked. Use `wp.Core.syncFinish` from within the `closure` to determine whether the operation completed successfully or if an error occurred.
    extern fn wp_core_sync_closure(p_self: *Core, p_cancellable: ?*gio.Cancellable, p_closure: *gobject.Closure) c_int;
    pub const syncClosure = wp_core_sync_closure;

    /// This function is meant to be called from within the callback of `wp.Core.sync` in order to determine the success or failure of the operation.
    extern fn wp_core_sync_finish(p_self: *Core, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int;
    pub const syncFinish = wp_core_sync_finish;

    /// Test if a global feature is provided.
    extern fn wp_core_test_feature(p_self: *Core, p_feature: [*:0]const u8) c_int;
    pub const testFeature = wp_core_test_feature;

    /// Adds a timeout callback to be called at regular intervals in the same GMainContext as the one used by this core.
    ///
    ///
    /// The function is called repeatedly until it returns FALSE, at which point the timeout is automatically destroyed and the function will not be called again. The first call to the function will be at the end of the first interval.
    /// This is essentially the same as `glib.timeoutAddFull`, but it adds the created GSource on the GMainContext used by this core instead of the default context.
    extern fn wp_core_timeout_add(p_self: *Core, p_source: ?**glib.Source, p_timeout_ms: c_uint, p_function: glib.SourceFunc, p_data: ?*anyopaque, p_destroy: ?glib.DestroyNotify) void;
    pub const timeoutAdd = wp_core_timeout_add;

    /// Adds a timeout callback to be called at regular intervals in the same GMainContext as the one used by this core.
    ///
    ///
    /// This is the same as `wp.Core.timeoutAdd`, but it allows you to specify a GClosure instead of a C callback.
    extern fn wp_core_timeout_add_closure(p_self: *Core, p_source: ?**glib.Source, p_timeout_ms: c_uint, p_closure: *gobject.Closure) void;
    pub const timeoutAddClosure = wp_core_timeout_add_closure;

    /// Updates the properties of `self` on the connection, making them appear on the client object that represents this connection.
    ///
    ///
    /// If `self` is not connected yet, these properties are stored and passed to `pw_context_connect` when connecting.
    extern fn wp_core_update_properties(p_self: *Core, p_updates: *wp.Properties) void;
    pub const updateProperties = wp_core_update_properties;

    extern fn wp_core_get_type() usize;
    pub const getGObjectType = wp_core_get_type;

    extern fn g_object_ref(p_self: *wp.Core) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Core) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Core, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The WpDevice class allows accessing the properties and methods of a PipeWire device object (struct pw_device).
/// A WpDevice is constructed internally when a new device appears on the PipeWire registry and it is made available through the WpObjectManager API. Alternatively, a WpDevice can also be constructed using `wp.Device.newFromFactory`, which creates a new device object on the remote PipeWire server by calling into a factory.
pub const Device = opaque {
    pub const Parent = wp.GlobalProxy;
    pub const Implements = [_]type{wp.PipewireObject};
    pub const Class = wp.DeviceClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Constructs a device on the PipeWire server by asking the remote factory `factory_name` to create it.
    ///
    ///
    /// Because of the nature of the PipeWire protocol, this operation completes asynchronously at some point in the future. In order to find out when this is done, you should call `wp.Object.activate`, requesting at least WP_PROXY_FEATURE_BOUND. When this feature is ready, the device is ready for use on the server. If the device cannot be created, this activation operation will fail.
    extern fn wp_device_new_from_factory(p_core: *wp.Core, p_factory_name: [*:0]const u8, p_properties: ?*wp.Properties) ?*wp.Device;
    pub const newFromFactory = wp_device_new_from_factory;

    extern fn wp_device_get_type() usize;
    pub const getGObjectType = wp_device_get_type;

    extern fn g_object_ref(p_self: *wp.Device) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Device) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Device, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The event dispatcher holds all the events and hooks and dispatches them. It orchestras the show on event stack.
pub const EventDispatcher = opaque {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.EventDispatcherClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Returns the event dispatcher instance that is associated with the given core.
    ///
    ///
    /// This method will also create the instance and register it with the core, if it had not been created before.
    extern fn wp_event_dispatcher_get_instance(p_core: *wp.Core) *wp.EventDispatcher;
    pub const getInstance = wp_event_dispatcher_get_instance;

    /// Returns an iterator to iterate over the registered hooks for a particular event type.
    extern fn wp_event_dispatcher_new_hooks_for_event_type_iterator(p_self: *EventDispatcher, p_event_type: [*:0]const u8) *wp.Iterator;
    pub const newHooksForEventTypeIterator = wp_event_dispatcher_new_hooks_for_event_type_iterator;

    /// Returns an iterator to iterate over all the registered hooks.
    extern fn wp_event_dispatcher_new_hooks_iterator(p_self: *EventDispatcher) *wp.Iterator;
    pub const newHooksIterator = wp_event_dispatcher_new_hooks_iterator;

    /// Pushes a new event onto the event stack for dispatching only if there are any hooks are available for it.
    extern fn wp_event_dispatcher_push_event(p_self: *EventDispatcher, p_event: *wp.Event) void;
    pub const pushEvent = wp_event_dispatcher_push_event;

    /// Registers an event hook.
    extern fn wp_event_dispatcher_register_hook(p_self: *EventDispatcher, p_hook: *wp.EventHook) void;
    pub const registerHook = wp_event_dispatcher_register_hook;

    /// Unregisters an event hook.
    extern fn wp_event_dispatcher_unregister_hook(p_self: *EventDispatcher, p_hook: *wp.EventHook) void;
    pub const unregisterHook = wp_event_dispatcher_unregister_hook;

    extern fn wp_event_dispatcher_get_type() usize;
    pub const getGObjectType = wp_event_dispatcher_get_type;

    extern fn g_object_ref(p_self: *wp.EventDispatcher) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.EventDispatcher) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *EventDispatcher, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The event hook is a structure that describes some executable action that an event dispatcher will run when a matching event has been received.
pub const EventHook = extern struct {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.EventHookClass;
    f_parent_instance: gobject.Object,

    pub const virtual_methods = struct {
        /// Finishes the async operation that was started by `wp.EventHook.run`.
        pub const finish = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int {
                return gobject.ext.as(EventHook.Class, p_class).f_finish.?(gobject.ext.as(EventHook, p_self), p_res, p_error);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) c_int) void {
                gobject.ext.as(EventHook.Class, p_class).f_finish = @ptrCast(p_implementation);
            }
        };

        /// Gets all the matching event types for this hook if any.
        pub const get_matching_event_types = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) ?*glib.PtrArray {
                return gobject.ext.as(EventHook.Class, p_class).f_get_matching_event_types.?(gobject.ext.as(EventHook, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) ?*glib.PtrArray) void {
                gobject.ext.as(EventHook.Class, p_class).f_get_matching_event_types = @ptrCast(p_implementation);
            }
        };

        /// Runs the hook on the given event.
        pub const run = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_event: *wp.Event, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_callback_data: ?*anyopaque) void {
                return gobject.ext.as(EventHook.Class, p_class).f_run.?(gobject.ext.as(EventHook, p_self), p_event, p_cancellable, p_callback, p_callback_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_event: *wp.Event, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_callback_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(EventHook.Class, p_class).f_run = @ptrCast(p_implementation);
            }
        };

        /// Checks if the hook should be executed for a given event.
        pub const runs_for_event = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_event: *wp.Event) c_int {
                return gobject.ext.as(EventHook.Class, p_class).f_runs_for_event.?(gobject.ext.as(EventHook, p_self), p_event);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_event: *wp.Event) callconv(.c) c_int) void {
                gobject.ext.as(EventHook.Class, p_class).f_runs_for_event = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const dispatcher = struct {
            pub const name = "dispatcher";

            pub const Type = ?*wp.EventDispatcher;
        };

        pub const name = struct {
            pub const name = "name";

            pub const Type = ?[*:0]u8;
        };

        pub const runs_after_hooks = struct {
            pub const name = "runs-after-hooks";

            pub const Type = ?[*][*:0]u8;
        };

        pub const runs_before_hooks = struct {
            pub const name = "runs-before-hooks";

            pub const Type = ?[*][*:0]u8;
        };
    };

    pub const signals = struct {};

    /// Finishes the async operation that was started by `wp.EventHook.run`.
    extern fn wp_event_hook_finish(p_self: *EventHook, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int;
    pub const finish = wp_event_hook_finish;

    /// Returns the associated event dispatcher.
    extern fn wp_event_hook_get_dispatcher(p_self: *EventHook) ?*wp.EventDispatcher;
    pub const getDispatcher = wp_event_hook_get_dispatcher;

    /// Gets all the matching event types for this hook if any.
    extern fn wp_event_hook_get_matching_event_types(p_self: *EventHook) ?*glib.PtrArray;
    pub const getMatchingEventTypes = wp_event_hook_get_matching_event_types;

    /// Returns the name of the hook.
    extern fn wp_event_hook_get_name(p_self: *EventHook) [*:0]const u8;
    pub const getName = wp_event_hook_get_name;

    /// Returns the names of the hooks that should run before this hook, or in other words, this hook should run after them.
    extern fn wp_event_hook_get_runs_after_hooks(p_self: *EventHook) [*]const [*:0]const u8;
    pub const getRunsAfterHooks = wp_event_hook_get_runs_after_hooks;

    /// Returns the names of the hooks that should run after this hook, or in other words, this hook should run before them.
    extern fn wp_event_hook_get_runs_before_hooks(p_self: *EventHook) [*]const [*:0]const u8;
    pub const getRunsBeforeHooks = wp_event_hook_get_runs_before_hooks;

    /// Runs the hook on the given event.
    extern fn wp_event_hook_run(p_self: *EventHook, p_event: *wp.Event, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_callback_data: ?*anyopaque) void;
    pub const run = wp_event_hook_run;

    /// Checks if the hook should be executed for a given event.
    extern fn wp_event_hook_runs_for_event(p_self: *EventHook, p_event: *wp.Event) c_int;
    pub const runsForEvent = wp_event_hook_runs_for_event;

    /// Sets the associated event dispatcher.
    extern fn wp_event_hook_set_dispatcher(p_self: *EventHook, p_dispatcher: *wp.EventDispatcher) void;
    pub const setDispatcher = wp_event_hook_set_dispatcher;

    extern fn wp_event_hook_get_type() usize;
    pub const getGObjectType = wp_event_hook_get_type;

    extern fn g_object_ref(p_self: *wp.EventHook) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.EventHook) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *EventHook, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The WpFactory class allows accessing the properties and methods of PipeWire Factory objects (struct pw_factory).
/// A WpFactory is constructed internally by wireplumber, when the pipewire constructed factory objects are reported in by PipeWire registry and it is made available for wireplumber clients through the WpObjectManager API.
pub const Factory = opaque {
    pub const Parent = wp.GlobalProxy;
    pub const Implements = [_]type{wp.PipewireObject};
    pub const Class = wp.FactoryClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn wp_factory_get_type() usize;
    pub const getGObjectType = wp_factory_get_type;

    extern fn g_object_ref(p_self: *wp.Factory) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Factory) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Factory, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A WpTransition that is used by WpObject to implement feature activation.
pub const FeatureActivationTransition = opaque {
    pub const Parent = wp.Transition;
    pub const Implements = [_]type{gio.AsyncResult};
    pub const Class = wp.FeatureActivationTransitionClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Gets the features requested to be activated in this transition.
    extern fn wp_feature_activation_transition_get_requested_features(p_self: *FeatureActivationTransition) wp.ObjectFeatures;
    pub const getRequestedFeatures = wp_feature_activation_transition_get_requested_features;

    extern fn wp_feature_activation_transition_get_type() usize;
    pub const getGObjectType = wp_feature_activation_transition_get_type;

    extern fn g_object_ref(p_self: *wp.FeatureActivationTransition) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.FeatureActivationTransition) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *FeatureActivationTransition, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A proxy that represents a PipeWire global object, i.e. an object that is made available through the PipeWire registry.
pub const GlobalProxy = extern struct {
    pub const Parent = wp.Proxy;
    pub const Implements = [_]type{};
    pub const Class = wp.GlobalProxyClass;
    f_parent_instance: wp.Proxy,

    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const factory_name = struct {
            pub const name = "factory-name";

            pub const Type = ?[*:0]u8;
        };

        pub const global = struct {
            pub const name = "global";

            pub const Type = @compileError("no type information available");
        };

        pub const global_properties = struct {
            pub const name = "global-properties";

            pub const Type = ?*wp.Properties;
        };

        pub const permissions = struct {
            pub const name = "permissions";

            pub const Type = c_uint;
        };
    };

    pub const signals = struct {};

    /// Binds to the global and creates the underlying pw_proxy.
    ///
    ///
    /// This is mostly meant to be called internally. It will create the pw_proxy and will activate the WP_PROXY_FEATURE_BOUND feature.
    /// This may only be called if there is no pw_proxy associated with this object yet.
    extern fn wp_global_proxy_bind(p_self: *GlobalProxy) c_int;
    pub const bind = wp_global_proxy_bind;

    /// Gets the global properties of a pipewire global.
    extern fn wp_global_proxy_get_global_properties(p_self: *GlobalProxy) *wp.Properties;
    pub const getGlobalProperties = wp_global_proxy_get_global_properties;

    /// Gets the permissions of a pipewire global.
    extern fn wp_global_proxy_get_permissions(p_self: *GlobalProxy) u32;
    pub const getPermissions = wp_global_proxy_get_permissions;

    /// Requests the PipeWire server to destroy the object represented by this proxy.
    ///
    ///
    /// If the server allows it, the object will be destroyed and the WpProxy's pw-proxy-destroyed signal will be emitted. If the server does not allow it, nothing will happen.
    /// This is mostly useful for destroying WpLink objects.
    extern fn wp_global_proxy_request_destroy(p_self: *GlobalProxy) void;
    pub const requestDestroy = wp_global_proxy_request_destroy;

    extern fn wp_global_proxy_get_type() usize;
    pub const getGObjectType = wp_global_proxy_get_type;

    extern fn g_object_ref(p_self: *wp.GlobalProxy) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.GlobalProxy) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *GlobalProxy, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Implementation of the metadata object.
/// Activate this object with at least WP_PROXY_FEATURE_BOUND to export it to PipeWire.
pub const ImplMetadata = opaque {
    pub const Parent = wp.Metadata;
    pub const Implements = [_]type{};
    pub const Class = wp.ImplMetadataClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const name = struct {
            pub const name = "name";

            pub const Type = ?[*:0]u8;
        };

        pub const properties = struct {
            pub const name = "properties";

            pub const Type = ?*wp.Properties;
        };
    };

    pub const signals = struct {};

    /// Creates a new metadata implementation.
    extern fn wp_impl_metadata_new(p_core: *wp.Core) *wp.ImplMetadata;
    pub const new = wp_impl_metadata_new;

    /// Creates a new metadata implementation with name and properties.
    extern fn wp_impl_metadata_new_full(p_core: *wp.Core, p_name: ?[*:0]const u8, p_properties: ?*wp.Properties) *wp.ImplMetadata;
    pub const newFull = wp_impl_metadata_new_full;

    extern fn wp_impl_metadata_get_type() usize;
    pub const getGObjectType = wp_impl_metadata_get_type;

    extern fn g_object_ref(p_self: *wp.ImplMetadata) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.ImplMetadata) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *ImplMetadata, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Used to load PipeWire modules within the WirePlumber process. This is slightly different from other objects in that the module is not exported to PipeWire, but it may create an export objects itself.
pub const ImplModule = opaque {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.ImplModuleClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const arguments = struct {
            pub const name = "arguments";

            pub const Type = ?[*:0]u8;
        };

        pub const core = struct {
            pub const name = "core";

            pub const Type = ?*anyopaque;
        };

        pub const name = struct {
            pub const name = "name";

            pub const Type = ?[*:0]u8;
        };

        pub const properties = struct {
            pub const name = "properties";

            pub const Type = ?*wp.Properties;
        };

        pub const pw_impl_module = struct {
            pub const name = "pw-impl-module";

            pub const Type = ?*anyopaque;
        };
    };

    pub const signals = struct {};

    /// Loads a PipeWire module into the WirePlumber process.
    extern fn wp_impl_module_load(p_core: *wp.Core, p_name: [*:0]const u8, p_arguments: ?[*:0]const u8, p_properties: ?*wp.Properties) ?*wp.ImplModule;
    pub const load = wp_impl_module_load;

    extern fn wp_impl_module_get_type() usize;
    pub const getGObjectType = wp_impl_module_get_type;

    extern fn g_object_ref(p_self: *wp.ImplModule) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.ImplModule) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *ImplModule, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A WpImplNode allows running a node implementation (struct pw_impl_node) locally, loading the implementation from factory or wrapping a manually constructed pw_impl_node. This object can then be exported to PipeWire by requesting WP_PROXY_FEATURE_BOUND.
pub const ImplNode = opaque {
    pub const Parent = wp.Proxy;
    pub const Implements = [_]type{wp.PipewireObject};
    pub const Class = wp.ImplNodeClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const pw_impl_node = struct {
            pub const name = "pw-impl-node";

            pub const Type = ?*anyopaque;
        };
    };

    pub const signals = struct {};

    /// Constructs a new node, locally on this process, using the specified `factory_name`.
    ///
    ///
    /// To export this node to the PipeWire server, you need to call `wp.Object.activate` requesting WP_PROXY_FEATURE_BOUND and wait for the operation to complete.
    extern fn wp_impl_node_new_from_pw_factory(p_core: *wp.Core, p_factory_name: [*:0]const u8, p_properties: ?*wp.Properties) ?*wp.ImplNode;
    pub const newFromPwFactory = wp_impl_node_new_from_pw_factory;

    /// Constructs a node object from an existing pw_impl_node.
    extern fn wp_impl_node_new_wrap(p_core: *wp.Core, p_node: ?*anyopaque) *wp.ImplNode;
    pub const newWrap = wp_impl_node_new_wrap;

    extern fn wp_impl_node_get_type() usize;
    pub const getGObjectType = wp_impl_node_get_type;

    extern fn g_object_ref(p_self: *wp.ImplNode) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.ImplNode) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *ImplNode, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An event hook that declares interest in specific events. This subclass implements the WpEventHook.`runs_for_event` vmethod and returns TRUE from that method if the given event has properties that match one of the declared interests.
pub const InterestEventHook = extern struct {
    pub const Parent = wp.EventHook;
    pub const Implements = [_]type{};
    pub const Class = wp.InterestEventHookClass;
    f_parent_instance: wp.EventHook,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Equivalent to:
    ///
    ///
    ///
    /// ```
    ///   WpObjectInterest *i = wp_object_interest_new (WP_TYPE_EVENT, ...);
    ///   wp_interest_event_hook_add_interest_full (self, i);
    /// ```
    /// The constraints specified in the variable arguments must follow the rules documented in `wp.ObjectInterest.new`.
    extern fn wp_interest_event_hook_add_interest(p_self: *InterestEventHook, ...) void;
    pub const addInterest = wp_interest_event_hook_add_interest;

    extern fn wp_interest_event_hook_add_interest_full(p_self: *InterestEventHook, p_interest: *wp.ObjectInterest) void;
    pub const addInterestFull = wp_interest_event_hook_add_interest_full;

    extern fn wp_interest_event_hook_get_type() usize;
    pub const getGObjectType = wp_interest_event_hook_get_type;

    extern fn g_object_ref(p_self: *wp.InterestEventHook) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.InterestEventHook) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *InterestEventHook, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The WpLink class allows accessing the properties and methods of a PipeWire link object (struct pw_link).
/// A WpLink is constructed internally when a new link appears on the PipeWire registry and it is made available through the WpObjectManager API. Alternatively, a WpLink can also be constructed using `wp.Link.newFromFactory`, which creates a new link object on the remote PipeWire server by calling into a factory.
pub const Link = opaque {
    pub const Parent = wp.GlobalProxy;
    pub const Implements = [_]type{wp.PipewireObject};
    pub const Class = wp.LinkClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const state = struct {
            pub const name = "state";

            pub const Type = wp.LinkState;
        };
    };

    pub const signals = struct {
        pub const state_changed = struct {
            pub const name = "state-changed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: wp.LinkState, p_p0: wp.LinkState, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Link, p_instance))),
                    gobject.signalLookup("state-changed", Link.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Constructs a link on the PipeWire server by asking the remote factory `factory_name` to create it.
    ///
    ///
    /// Because of the nature of the PipeWire protocol, this operation completes asynchronously at some point in the future. In order to find out when this is done, you should call `wp.Object.activate`, requesting at least WP_PROXY_FEATURE_BOUND. When this feature is ready, the link is ready for use on the server. If the link cannot be created, this activation operation will fail.
    extern fn wp_link_new_from_factory(p_core: *wp.Core, p_factory_name: [*:0]const u8, p_properties: ?*wp.Properties) ?*wp.Link;
    pub const newFromFactory = wp_link_new_from_factory;

    /// Retrieves the ids of the objects that are linked by this link.
    ///
    ///
    /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
    extern fn wp_link_get_linked_object_ids(p_self: *Link, p_output_node: ?*u32, p_output_port: ?*u32, p_input_node: ?*u32, p_input_port: ?*u32) void;
    pub const getLinkedObjectIds = wp_link_get_linked_object_ids;

    /// Gets the current state of the link.
    extern fn wp_link_get_state(p_self: *Link, p_error: ?*[*:0]const u8) wp.LinkState;
    pub const getState = wp_link_get_state;

    extern fn wp_link_get_type() usize;
    pub const getGObjectType = wp_link_get_type;

    extern fn g_object_ref(p_self: *wp.Link) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Link) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Link, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The WpMetadata class allows accessing the properties and methods of PipeWire metadata object (struct pw_metadata).
/// A WpMetadata is constructed internally when a new metadata object appears on the PipeWire registry and it is made available through the WpObjectManager API.
pub const Metadata = extern struct {
    pub const Parent = wp.GlobalProxy;
    pub const Implements = [_]type{};
    pub const Class = wp.MetadataClass;
    f_parent_instance: wp.GlobalProxy,

    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {
        pub const changed = struct {
            pub const name = "changed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: c_uint, p_p0: [*:0]u8, p_p1: [*:0]u8, p_p2: [*:0]u8, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Metadata, p_instance))),
                    gobject.signalLookup("changed", Metadata.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Clears permanently all stored metadata.
    extern fn wp_metadata_clear(p_self: *Metadata) void;
    pub const clear = wp_metadata_clear;

    /// Finds the metadata value given its `subject` and `key`.
    extern fn wp_metadata_find(p_self: *Metadata, p_subject: u32, p_key: [*:0]const u8, p_type: ?*[*:0]const u8) [*:0]const u8;
    pub const find = wp_metadata_find;

    /// Iterates over metadata items that matches the given `subject`.
    ///
    ///
    /// If no constraints are specified, the returned iterator iterates over all the stored metadata.
    /// Note that this method works on cached metadata. When you change metadata with `wp.Metadata.set`, this cache will be updated on the next round-trip with the pipewire server.
    extern fn wp_metadata_new_iterator(p_self: *Metadata, p_subject: u32) *wp.Iterator;
    pub const newIterator = wp_metadata_new_iterator;

    /// Sets the metadata associated with the given `subject` and `key`. Use NULL as a value to unset the given `key` and use NULL in both `key` and `value` to remove all metadata associated with the given `subject`.
    extern fn wp_metadata_set(p_self: *Metadata, p_subject: u32, p_key: ?[*:0]const u8, p_type: ?[*:0]const u8, p_value: ?[*:0]const u8) void;
    pub const set = wp_metadata_set;

    extern fn wp_metadata_get_type() usize;
    pub const getGObjectType = wp_metadata_get_type;

    extern fn g_object_ref(p_self: *wp.Metadata) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Metadata) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Metadata, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The WpNode class allows accessing the properties and methods of a PipeWire node object (struct pw_node).
/// A WpNode is constructed internally when a new node appears on the PipeWire registry and it is made available through the WpObjectManager API. Alternatively, a WpNode can also be constructed using `wp.Node.newFromFactory`, which creates a new node object on the remote PipeWire server by calling into a factory.
pub const Node = opaque {
    pub const Parent = wp.GlobalProxy;
    pub const Implements = [_]type{wp.PipewireObject};
    pub const Class = wp.NodeClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const max_input_ports = struct {
            pub const name = "max-input-ports";

            pub const Type = c_uint;
        };

        pub const max_output_ports = struct {
            pub const name = "max-output-ports";

            pub const Type = c_uint;
        };

        pub const n_input_ports = struct {
            pub const name = "n-input-ports";

            pub const Type = c_uint;
        };

        pub const n_output_ports = struct {
            pub const name = "n-output-ports";

            pub const Type = c_uint;
        };

        pub const state = struct {
            pub const name = "state";

            pub const Type = wp.NodeState;
        };
    };

    pub const signals = struct {
        pub const ports_changed = struct {
            pub const name = "ports-changed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Node, p_instance))),
                    gobject.signalLookup("ports-changed", Node.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        pub const state_changed = struct {
            pub const name = "state-changed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: wp.NodeState, p_p0: wp.NodeState, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Node, p_instance))),
                    gobject.signalLookup("state-changed", Node.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Constructs a node on the PipeWire server by asking the remote factory `factory_name` to create it.
    ///
    ///
    /// Because of the nature of the PipeWire protocol, this operation completes asynchronously at some point in the future. In order to find out when this is done, you should call `wp.Object.activate`, requesting at least WP_PROXY_FEATURE_BOUND. When this feature is ready, the node is ready for use on the server. If the node cannot be created, this activation operation will fail.
    extern fn wp_node_new_from_factory(p_core: *wp.Core, p_factory_name: [*:0]const u8, p_properties: ?*wp.Properties) ?*wp.Node;
    pub const newFromFactory = wp_node_new_from_factory;

    /// Gets the number of input ports of this node.
    ///
    ///
    /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
    extern fn wp_node_get_n_input_ports(p_self: *Node, p_max: ?*c_uint) c_uint;
    pub const getNInputPorts = wp_node_get_n_input_ports;

    /// Gets the number of output ports of this node.
    ///
    ///
    /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
    extern fn wp_node_get_n_output_ports(p_self: *Node, p_max: ?*c_uint) c_uint;
    pub const getNOutputPorts = wp_node_get_n_output_ports;

    /// Gets the number of ports of this node.
    ///
    ///
    /// Note that this number may not add up to `wp.Node.getNInputPorts` + `wp.Node.getNOutputPorts` because it is discovered by looking at the number of available ports in the registry, however ports may appear there with a delay or may not appear at all if this client does not have permission to read them
    /// Requires WP_NODE_FEATURE_PORTS
    extern fn wp_node_get_n_ports(p_self: *Node) c_uint;
    pub const getNPorts = wp_node_get_n_ports;

    /// Gets the current state of the node.
    extern fn wp_node_get_state(p_self: *Node, p_error: ?*[*:0]const u8) wp.NodeState;
    pub const getState = wp_node_get_state;

    /// Retrieves the first port that matches the constraints.
    ///
    ///
    /// The constraints specified in the variable arguments must follow the rules documented in `wp.ObjectInterest.new`.
    /// Requires WP_NODE_FEATURE_PORTS
    extern fn wp_node_lookup_port(p_self: *Node, ...) ?*wp.Port;
    pub const lookupPort = wp_node_lookup_port;

    /// Retrieves the first port that matches the `interest`.
    ///
    ///
    /// Requires WP_NODE_FEATURE_PORTS
    extern fn wp_node_lookup_port_full(p_self: *Node, p_interest: *wp.ObjectInterest) ?*wp.Port;
    pub const lookupPortFull = wp_node_lookup_port_full;

    /// Gets a new iterator that iterates over all the ports that belong to this node and match the constraints.
    ///
    ///
    /// The constraints specified in the variable arguments must follow the rules documented in `wp.ObjectInterest.new`.
    /// Requires WP_NODE_FEATURE_PORTS
    extern fn wp_node_new_ports_filtered_iterator(p_self: *Node, ...) *wp.Iterator;
    pub const newPortsFilteredIterator = wp_node_new_ports_filtered_iterator;

    /// Gets a new iterator that iterates over all the ports that belong to this node and match the `interest`.
    ///
    ///
    /// Requires WP_NODE_FEATURE_PORTS
    extern fn wp_node_new_ports_filtered_iterator_full(p_self: *Node, p_interest: *wp.ObjectInterest) *wp.Iterator;
    pub const newPortsFilteredIteratorFull = wp_node_new_ports_filtered_iterator_full;

    /// Gets a new iterator that iterates over all the ports that belong to this node.
    ///
    ///
    /// Requires WP_NODE_FEATURE_PORTS
    extern fn wp_node_new_ports_iterator(p_self: *Node) *wp.Iterator;
    pub const newPortsIterator = wp_node_new_ports_iterator;

    /// Sends a command to a node.
    ///
    ///
    /// Valid commands are the short string reprepsentations of enum spa_node_command. For example, "Suspend" or "Flush" are valid commands
    extern fn wp_node_send_command(p_self: *Node, p_command: [*:0]const u8) void;
    pub const sendCommand = wp_node_send_command;

    extern fn wp_node_get_type() usize;
    pub const getGObjectType = wp_node_get_type;

    extern fn g_object_ref(p_self: *wp.Node) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Node) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Node, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Base class for objects that have activatable features.
pub const Object = extern struct {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.ObjectClass;
    f_parent_instance: gobject.Object,

    pub const virtual_methods = struct {
        pub const activate_execute_step = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.FeatureActivationTransition, p_step: c_uint, p_missing: wp.ObjectFeatures) void {
                return gobject.ext.as(Object.Class, p_class).f_activate_execute_step.?(gobject.ext.as(Object, p_self), p_transition, p_step, p_missing);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.FeatureActivationTransition, p_step: c_uint, p_missing: wp.ObjectFeatures) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_activate_execute_step = @ptrCast(p_implementation);
            }
        };

        pub const activate_get_next_step = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.FeatureActivationTransition, p_step: c_uint, p_missing: wp.ObjectFeatures) c_uint {
                return gobject.ext.as(Object.Class, p_class).f_activate_get_next_step.?(gobject.ext.as(Object, p_self), p_transition, p_step, p_missing);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.FeatureActivationTransition, p_step: c_uint, p_missing: wp.ObjectFeatures) callconv(.c) c_uint) void {
                gobject.ext.as(Object.Class, p_class).f_activate_get_next_step = @ptrCast(p_implementation);
            }
        };

        /// Deactivates the given `features`, leaving the object in the state it was before they were enabled.
        ///
        ///
        /// This is seldom needed to call manually, but it can be used to save resources if some features are no longer needed.
        pub const deactivate = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_features: wp.ObjectFeatures) void {
                return gobject.ext.as(Object.Class, p_class).f_deactivate.?(gobject.ext.as(Object, p_self), p_features);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_features: wp.ObjectFeatures) callconv(.c) void) void {
                gobject.ext.as(Object.Class, p_class).f_deactivate = @ptrCast(p_implementation);
            }
        };

        /// Gets the supported features of this object.
        pub const get_supported_features = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) wp.ObjectFeatures {
                return gobject.ext.as(Object.Class, p_class).f_get_supported_features.?(gobject.ext.as(Object, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) wp.ObjectFeatures) void {
                gobject.ext.as(Object.Class, p_class).f_get_supported_features = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const active_features = struct {
            pub const name = "active-features";

            pub const Type = c_uint;
        };

        pub const core = struct {
            pub const name = "core";

            pub const Type = ?*wp.Core;
        };

        pub const id = struct {
            pub const name = "id";

            pub const Type = c_uint;
        };

        pub const supported_features = struct {
            pub const name = "supported-features";

            pub const Type = c_uint;
        };
    };

    pub const signals = struct {};

    /// Aborts the current object activation by returning a transition error if any transitions are pending.
    ///
    ///
    /// This is usually used to stop any pending activation if an error happened.
    extern fn wp_object_abort_activation(p_self: *Object, p_msg: [*:0]const u8) void;
    pub const abortActivation = wp_object_abort_activation;

    /// Callback version of `wp.Object.activateClosure`.
    extern fn wp_object_activate(p_self: *Object, p_features: wp.ObjectFeatures, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_user_data: ?*anyopaque) void;
    pub const activate = wp_object_activate;

    /// Activates the requested `features` and invokes `closure` when this is done. `features` may contain unsupported or already active features. The operation will filter them and activate only ones that are supported and inactive.
    ///
    ///
    /// If multiple calls to this method is done, the operations will be executed one after the other to ensure features only get activated once.
    /// `closure` may be invoked in sync while this method is being called, if there are no features to activate.
    extern fn wp_object_activate_closure(p_self: *Object, p_features: wp.ObjectFeatures, p_cancellable: ?*gio.Cancellable, p_closure: *gobject.Closure) void;
    pub const activateClosure = wp_object_activate_closure;

    /// Finishes the async operation that was started with `wp.Object.activate`.
    extern fn wp_object_activate_finish(p_self: *Object, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int;
    pub const activateFinish = wp_object_activate_finish;

    /// Deactivates the given `features`, leaving the object in the state it was before they were enabled.
    ///
    ///
    /// This is seldom needed to call manually, but it can be used to save resources if some features are no longer needed.
    extern fn wp_object_deactivate(p_self: *Object, p_features: wp.ObjectFeatures) void;
    pub const deactivate = wp_object_deactivate;

    /// Gets the active features of this object.
    extern fn wp_object_get_active_features(p_self: *Object) wp.ObjectFeatures;
    pub const getActiveFeatures = wp_object_get_active_features;

    /// Gets the core associated with this object.
    extern fn wp_object_get_core(p_self: *Object) *wp.Core;
    pub const getCore = wp_object_get_core;

    /// Gets the unique wireplumber Id of this object.
    extern fn wp_object_get_id(p_self: *Object) c_uint;
    pub const getId = wp_object_get_id;

    /// Gets the supported features of this object.
    extern fn wp_object_get_supported_features(p_self: *Object) wp.ObjectFeatures;
    pub const getSupportedFeatures = wp_object_get_supported_features;

    /// Checks if the given features are active on this object.
    extern fn wp_object_test_active_features(p_self: *Object, p_features: wp.ObjectFeatures) c_int;
    pub const testActiveFeatures = wp_object_test_active_features;

    /// Checks if the given features are supported on this object.
    extern fn wp_object_test_supported_features(p_self: *Object, p_features: wp.ObjectFeatures) c_int;
    pub const testSupportedFeatures = wp_object_test_supported_features;

    /// Allows subclasses to update the currently active features.
    ///
    ///
    /// `activated` should contain new features and `deactivated` should contain features that were just deactivated. Calling this method also advances the activation transitions.
    /// Private method to be called by subclasses only.
    extern fn wp_object_update_features(p_self: *Object, p_activated: wp.ObjectFeatures, p_deactivated: wp.ObjectFeatures) void;
    pub const updateFeatures = wp_object_update_features;

    extern fn wp_object_get_type() usize;
    pub const getGObjectType = wp_object_get_type;

    extern fn g_object_ref(p_self: *wp.Object) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Object) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Object, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The WpObjectManager class provides a way to collect a set of objects and be notified when objects that fulfill a certain set of criteria are created or destroyed.
/// There are 4 kinds of objects that can be managed by a WpObjectManager:
///  - remote PipeWire global objects that are advertised on the registry; these are bound locally to subclasses of WpGlobalProxy
///  - remote PipeWire global objects that are created by calling a remote factory through the WirePlumber API; these are very similar to other global objects but it should be noted that the same WpGlobalProxy instance that created them appears in the WpObjectManager (as soon as its WP_PROXY_FEATURE_BOUND is enabled)
///  - local PipeWire objects that are being exported to PipeWire (WpImplMetadata, WpImplNode, etc); these appear in the WpObjectManager as soon as they are exported (so, when their WP_PROXY_FEATURE_BOUND is enabled)
///  - WirePlumber-specific objects, such as plugins, factories and session items
///
/// To start an object manager, you first need to declare interest in a certain kind of object by calling `wp.ObjectManager.addInterest` and then install it on the WpCore with `wp.Core.installObjectManager`.
/// Upon installing a WpObjectManager on a WpCore, any pre-existing objects that match the interests of this WpObjectManager will immediately become available to get through `wp.ObjectManager.newIterator` and the WpObjectManager object-added signal will be emitted for all of them. However, note that if these objects need to be prepared (to activate some features on them), the emission of object-added will be delayed. To know when it is safe to access the initial set of objects, wait until the installed signal has been emitted. That signal is emitted asynchronously after all the initial objects have been prepared.
pub const ObjectManager = opaque {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.ObjectManagerClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const core = struct {
            pub const name = "core";

            pub const Type = ?*wp.Core;
        };
    };

    pub const signals = struct {
        pub const installed = struct {
            pub const name = "installed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(ObjectManager, p_instance))),
                    gobject.signalLookup("installed", ObjectManager.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        pub const object_added = struct {
            pub const name = "object-added";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: *gobject.Object, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(ObjectManager, p_instance))),
                    gobject.signalLookup("object-added", ObjectManager.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        pub const object_removed = struct {
            pub const name = "object-removed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: *gobject.Object, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(ObjectManager, p_instance))),
                    gobject.signalLookup("object-removed", ObjectManager.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        pub const objects_changed = struct {
            pub const name = "objects-changed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(ObjectManager, p_instance))),
                    gobject.signalLookup("objects-changed", ObjectManager.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Constructs a new object manager.
    extern fn wp_object_manager_new() *wp.ObjectManager;
    pub const new = wp_object_manager_new;

    /// Adds a global object to the object manager.
    ///
    ///
    /// caller must also call `wp.ObjectManager.maybeObjectsChanged` after
    extern fn wp_object_manager_add_global(p_self: *ObjectManager, p_global: *wp.Global) void;
    pub const addGlobal = wp_object_manager_add_global;

    /// Equivalent to:
    ///
    ///
    ///
    /// ```
    ///   WpObjectInterest *i = wp_object_interest_new (gtype, ...);
    ///   wp_object_manager_add_interest_full (self, i);
    /// ```
    /// The constraints specified in the variable arguments must follow the rules documented in `wp.ObjectInterest.new`.
    extern fn wp_object_manager_add_interest(p_self: *ObjectManager, p_gtype: usize, ...) void;
    pub const addInterest = wp_object_manager_add_interest;

    /// Declares interest in a certain kind of object.
    ///
    ///
    /// Interest consists of a GType that the object must be an ancestor of (`gobject.typeIsA` must match) and optionally, a set of additional constraints on certain properties of the object. Refer to WpObjectInterest for more details.
    extern fn wp_object_manager_add_interest_full(p_self: *ObjectManager, p_interest: *wp.ObjectInterest) void;
    pub const addInterestFull = wp_object_manager_add_interest_full;

    /// Adds an object to the object manager.
    ///
    ///
    /// caller must also call `wp.ObjectManager.maybeObjectsChanged` after
    extern fn wp_object_manager_add_object(p_self: *ObjectManager, p_object: ?*anyopaque) void;
    pub const addObject = wp_object_manager_add_object;

    /// Gets the number of objects managed by the object manager.
    extern fn wp_object_manager_get_n_objects(p_self: *ObjectManager) c_uint;
    pub const getNObjects = wp_object_manager_get_n_objects;

    /// Checks if an object manager is installed.
    extern fn wp_object_manager_is_installed(p_self: *ObjectManager) c_int;
    pub const isInstalled = wp_object_manager_is_installed;

    /// Equivalent to:
    ///
    ///
    ///
    /// ```
    ///   WpObjectInterest *i = wp_object_interest_new (gtype, ...);
    ///   return wp_object_manager_lookup_full (self, i);
    /// ```
    /// The constraints specified in the variable arguments must follow the rules documented in `wp.ObjectInterest.new`.
    extern fn wp_object_manager_lookup(p_self: *ObjectManager, p_gtype: usize, ...) ?*gobject.Object;
    pub const lookup = wp_object_manager_lookup;

    /// Searches for an object that matches the specified `interest` and returns it, if found.
    ///
    ///
    /// If more than one objects match, only the first one is returned. To find multiple objects that match certain criteria, `wp.ObjectManager.newFilteredIterator` is more suitable.
    extern fn wp_object_manager_lookup_full(p_self: *ObjectManager, p_interest: *wp.ObjectInterest) ?*gobject.Object;
    pub const lookupFull = wp_object_manager_lookup_full;

    /// Checks if the object manager should emit the 'objects-changed' signal.
    extern fn wp_object_manager_maybe_objects_changed(p_self: *ObjectManager) void;
    pub const maybeObjectsChanged = wp_object_manager_maybe_objects_changed;

    /// Equivalent to:
    ///
    ///
    ///
    /// ```
    ///   WpObjectInterest *i = wp_object_interest_new (gtype, ...);
    ///   return wp_object_manager_new_filtered_iterator_full (self, i);
    /// ```
    /// The constraints specified in the variable arguments must follow the rules documented in `wp.ObjectInterest.new`.
    extern fn wp_object_manager_new_filtered_iterator(p_self: *ObjectManager, p_gtype: usize, ...) *wp.Iterator;
    pub const newFilteredIterator = wp_object_manager_new_filtered_iterator;

    /// Iterates through all the objects managed by this object manager that match the specified `interest`.
    extern fn wp_object_manager_new_filtered_iterator_full(p_self: *ObjectManager, p_interest: *wp.ObjectInterest) *wp.Iterator;
    pub const newFilteredIteratorFull = wp_object_manager_new_filtered_iterator_full;

    /// Iterates through all the objects managed by this object manager.
    extern fn wp_object_manager_new_iterator(p_self: *ObjectManager) *wp.Iterator;
    pub const newIterator = wp_object_manager_new_iterator;

    /// Requests the object manager to automatically prepare the `wanted_features` on any managed object that is of the specified `object_type`.
    ///
    ///
    /// These features will always be prepared before the object appears on the object manager.
    extern fn wp_object_manager_request_object_features(p_self: *ObjectManager, p_object_type: usize, p_wanted_features: wp.ObjectFeatures) void;
    pub const requestObjectFeatures = wp_object_manager_request_object_features;

    /// Removes an object from the object manager.
    ///
    ///
    /// caller must also call `wp.ObjectManager.maybeObjectsChanged` after
    extern fn wp_object_manager_rm_object(p_self: *ObjectManager, p_object: ?*anyopaque) void;
    pub const rmObject = wp_object_manager_rm_object;

    extern fn wp_object_manager_get_type() usize;
    pub const getGObjectType = wp_object_manager_get_type;

    extern fn g_object_ref(p_self: *wp.ObjectManager) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.ObjectManager) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *ObjectManager, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// WpPlugin is a base class for objects that provide functionality to the WirePlumber daemon.
/// Typically, a plugin is created within a module and then registered to make it available for use by the daemon. The daemon is responsible for calling `wp.Object.activate` on it after all modules have been loaded, the core is connected and the initial discovery of global objects is done.
/// Being a WpObject subclass, the plugin inherits WpObject's activation system. For most implementations, there is only need for activating one feature, WP_PLUGIN_FEATURE_ENABLED, and this can be done by implementing only WpPluginClass::`enable` and WpPluginClass::`disable`. For more advanced plugins that need to have more features, you may implement directly the functions of WpObjectClass and ignore the ones of WpPluginClass.
pub const Plugin = extern struct {
    pub const Parent = wp.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.PluginClass;
    f_parent_instance: wp.Object,

    pub const virtual_methods = struct {
        pub const disable = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Plugin.Class, p_class).f_disable.?(gobject.ext.as(Plugin, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Plugin.Class, p_class).f_disable = @ptrCast(p_implementation);
            }
        };

        pub const enable = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.Transition) void {
                return gobject.ext.as(Plugin.Class, p_class).f_enable.?(gobject.ext.as(Plugin, p_self), p_transition);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.Transition) callconv(.c) void) void {
                gobject.ext.as(Plugin.Class, p_class).f_enable = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const name = struct {
            pub const name = "name";

            pub const Type = ?[*:0]u8;
        };
    };

    pub const signals = struct {};

    /// Looks up a plugin.
    extern fn wp_plugin_find(p_core: *wp.Core, p_plugin_name: [*:0]const u8) ?*wp.Plugin;
    pub const find = wp_plugin_find;

    /// Retrieves the name of a plugin.
    extern fn wp_plugin_get_name(p_self: *Plugin) [*:0]const u8;
    pub const getName = wp_plugin_get_name;

    extern fn wp_plugin_get_type() usize;
    pub const getGObjectType = wp_plugin_get_type;

    extern fn g_object_ref(p_self: *wp.Plugin) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Plugin) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Plugin, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The WpPort class allows accessing the properties and methods of a PipeWire port object (struct pw_port).
/// A WpPort is constructed internally when a new port appears on the PipeWire registry and it is made available through the WpObjectManager API.
pub const Port = opaque {
    pub const Parent = wp.GlobalProxy;
    pub const Implements = [_]type{wp.PipewireObject};
    pub const Class = wp.PortClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Gets the current direction of the port.
    ///
    ///
    /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
    extern fn wp_port_get_direction(p_self: *Port) wp.Direction;
    pub const getDirection = wp_port_get_direction;

    extern fn wp_port_get_type() usize;
    pub const getGObjectType = wp_port_get_type;

    extern fn g_object_ref(p_self: *wp.Port) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Port) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Port, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Base class for all objects that expose PipeWire objects using pw_proxy underneath.
/// This base class cannot be instantiated. It provides handling of pw_proxy's events and exposes common functionality.
pub const Proxy = extern struct {
    pub const Parent = wp.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.ProxyClass;
    f_parent_instance: wp.Object,

    pub const virtual_methods = struct {
        pub const bound = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_id: u32) void {
                return gobject.ext.as(Proxy.Class, p_class).f_bound.?(gobject.ext.as(Proxy, p_self), p_id);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_id: u32) callconv(.c) void) void {
                gobject.ext.as(Proxy.Class, p_class).f_bound = @ptrCast(p_implementation);
            }
        };

        pub const @"error" = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_seq: c_int, p_res: c_int, p_message: [*:0]const u8) void {
                return gobject.ext.as(Proxy.Class, p_class).f_error.?(gobject.ext.as(Proxy, p_self), p_seq, p_res, p_message);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_seq: c_int, p_res: c_int, p_message: [*:0]const u8) callconv(.c) void) void {
                gobject.ext.as(Proxy.Class, p_class).f_error = @ptrCast(p_implementation);
            }
        };

        pub const pw_proxy_created = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_proxy: ?*anyopaque) void {
                return gobject.ext.as(Proxy.Class, p_class).f_pw_proxy_created.?(gobject.ext.as(Proxy, p_self), p_proxy);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_proxy: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(Proxy.Class, p_class).f_pw_proxy_created = @ptrCast(p_implementation);
            }
        };

        pub const pw_proxy_destroyed = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(Proxy.Class, p_class).f_pw_proxy_destroyed.?(gobject.ext.as(Proxy, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(Proxy.Class, p_class).f_pw_proxy_destroyed = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const bound_id = struct {
            pub const name = "bound-id";

            pub const Type = c_uint;
        };

        pub const pw_proxy = struct {
            pub const name = "pw-proxy";

            pub const Type = ?*anyopaque;
        };
    };

    pub const signals = struct {
        pub const bound = struct {
            pub const name = "bound";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: c_uint, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Proxy, p_instance))),
                    gobject.signalLookup("bound", Proxy.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        pub const @"error" = struct {
            pub const name = "error";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: c_int, p_p0: c_int, p_p1: [*:0]u8, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Proxy, p_instance))),
                    gobject.signalLookup("error", Proxy.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        pub const pw_proxy_created = struct {
            pub const name = "pw-proxy-created";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: ?*anyopaque, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Proxy, p_instance))),
                    gobject.signalLookup("pw-proxy-created", Proxy.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        pub const pw_proxy_destroyed = struct {
            pub const name = "pw-proxy-destroyed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(Proxy, p_instance))),
                    gobject.signalLookup("pw-proxy-destroyed", Proxy.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Returns the proxy bound id.
    ///
    ///
    /// The bound id is the id that this object has on the PipeWire registry (a.k.a. the global id). The object must have the WP_PROXY_FEATURE_BOUND feature before this method can be called.
    /// Requires WP_PROXY_FEATURE_BOUND
    extern fn wp_proxy_get_bound_id(p_self: *Proxy) u32;
    pub const getBoundId = wp_proxy_get_bound_id;

    /// Gets the interface type of the proxied object.
    extern fn wp_proxy_get_interface_type(p_self: *Proxy, p_version: ?*u32) [*:0]const u8;
    pub const getInterfaceType = wp_proxy_get_interface_type;

    /// Gets the pw_proxy wrapped by this proxy object.
    extern fn wp_proxy_get_pw_proxy(p_self: *Proxy) ?*anyopaque;
    pub const getPwProxy = wp_proxy_get_pw_proxy;

    /// Private method to be used by subclasses to set the pw_proxy pointer when it is available.
    ///
    ///
    /// This can be called only if there is no pw_proxy already set. Takes ownership of `proxy`.
    extern fn wp_proxy_set_pw_proxy(p_self: *Proxy, p_proxy: ?*anyopaque) void;
    pub const setPwProxy = wp_proxy_set_pw_proxy;

    extern fn wp_proxy_get_type() usize;
    pub const getGObjectType = wp_proxy_get_type;

    extern fn g_object_ref(p_self: *wp.Proxy) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Proxy) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Proxy, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Session items are high level objects that wrap underlying PipeWire objects and manage them. For example, a session item may be managing a node, taking responsibility for configuring the PortConfig and Format parameters of the node. Or another may be managing links between two nodes.
/// All the implementations are provided by modules and instantiated via the WpSiFactory class.
pub const SessionItem = extern struct {
    pub const Parent = wp.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.SessionItemClass;
    f_parent_instance: wp.Object,

    pub const virtual_methods = struct {
        /// Configures the session item with a set of properties.
        pub const configure = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_props: *wp.Properties) c_int {
                return gobject.ext.as(SessionItem.Class, p_class).f_configure.?(gobject.ext.as(SessionItem, p_self), p_props);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_props: *wp.Properties) callconv(.c) c_int) void {
                gobject.ext.as(SessionItem.Class, p_class).f_configure = @ptrCast(p_implementation);
            }
        };

        pub const disable_active = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(SessionItem.Class, p_class).f_disable_active.?(gobject.ext.as(SessionItem, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(SessionItem.Class, p_class).f_disable_active = @ptrCast(p_implementation);
            }
        };

        pub const disable_exported = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(SessionItem.Class, p_class).f_disable_exported.?(gobject.ext.as(SessionItem, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(SessionItem.Class, p_class).f_disable_exported = @ptrCast(p_implementation);
            }
        };

        pub const enable_active = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.Transition) void {
                return gobject.ext.as(SessionItem.Class, p_class).f_enable_active.?(gobject.ext.as(SessionItem, p_self), p_transition);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.Transition) callconv(.c) void) void {
                gobject.ext.as(SessionItem.Class, p_class).f_enable_active = @ptrCast(p_implementation);
            }
        };

        pub const enable_exported = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.Transition) void {
                return gobject.ext.as(SessionItem.Class, p_class).f_enable_exported.?(gobject.ext.as(SessionItem, p_self), p_transition);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_transition: *wp.Transition) callconv(.c) void) void {
                gobject.ext.as(SessionItem.Class, p_class).f_enable_exported = @ptrCast(p_implementation);
            }
        };

        pub const get_associated_proxy = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_proxy_type: usize) ?*anyopaque {
                return gobject.ext.as(SessionItem.Class, p_class).f_get_associated_proxy.?(gobject.ext.as(SessionItem, p_self), p_proxy_type);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_proxy_type: usize) callconv(.c) ?*anyopaque) void {
                gobject.ext.as(SessionItem.Class, p_class).f_get_associated_proxy = @ptrCast(p_implementation);
            }
        };

        /// Resets the session item.
        ///
        ///
        /// This essentially removes the configuration and deactivates all active features.
        pub const reset = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) void {
                return gobject.ext.as(SessionItem.Class, p_class).f_reset.?(gobject.ext.as(SessionItem, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) void) void {
                gobject.ext.as(SessionItem.Class, p_class).f_reset = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const properties = struct {
            pub const name = "properties";

            pub const Type = ?*wp.Properties;
        };
    };

    pub const signals = struct {};

    /// Helper callback for sub-classes that defers and unexports the session item.
    ///
    ///
    /// Only meant to be used when the pipewire proxy destroyed signal is triggered.
    extern fn wp_session_item_handle_proxy_destroyed(p_proxy: *wp.Proxy, p_item: *wp.SessionItem) void;
    pub const handleProxyDestroyed = wp_session_item_handle_proxy_destroyed;

    /// Finds the factory associated with the given `name` from the `core` and uses it to construct a new WpSessionItem.
    extern fn wp_session_item_make(p_core: *wp.Core, p_factory_name: [*:0]const u8) ?*wp.SessionItem;
    pub const make = wp_session_item_make;

    /// Configures the session item with a set of properties.
    extern fn wp_session_item_configure(p_self: *SessionItem, p_props: *wp.Properties) c_int;
    pub const configure = wp_session_item_configure;

    /// An associated proxy is a WpProxy subclass instance that is somehow related to this item.
    extern fn wp_session_item_get_associated_proxy(p_self: *SessionItem, p_proxy_type: usize) ?*wp.Proxy;
    pub const getAssociatedProxy = wp_session_item_get_associated_proxy;

    /// Gets the bound id of a proxy associated with the session item.
    extern fn wp_session_item_get_associated_proxy_id(p_self: *SessionItem, p_proxy_type: usize) u32;
    pub const getAssociatedProxyId = wp_session_item_get_associated_proxy_id;

    /// Gets the properties of a session item.
    extern fn wp_session_item_get_properties(p_self: *SessionItem) *wp.Properties;
    pub const getProperties = wp_session_item_get_properties;

    /// Looks up a named session item property value for a given key.
    extern fn wp_session_item_get_property(p_self: *SessionItem, p_key: [*:0]const u8) [*:0]const u8;
    pub const getProperty = wp_session_item_get_property;

    /// Checks if the session item is configured.
    extern fn wp_session_item_is_configured(p_self: *SessionItem) c_int;
    pub const isConfigured = wp_session_item_is_configured;

    /// Registers the session item to its associated core.
    extern fn wp_session_item_register(p_self: *SessionItem) void;
    pub const register = wp_session_item_register;

    /// Removes the session item from its associated core.
    extern fn wp_session_item_remove(p_self: *SessionItem) void;
    pub const remove = wp_session_item_remove;

    /// Resets the session item.
    ///
    ///
    /// This essentially removes the configuration and deactivates all active features.
    extern fn wp_session_item_reset(p_self: *SessionItem) void;
    pub const reset = wp_session_item_reset;

    /// Sets the item's properties.
    ///
    ///
    /// This should only be done by sub-classes after the configuration has been done.
    extern fn wp_session_item_set_properties(p_self: *SessionItem, p_props: *wp.Properties) void;
    pub const setProperties = wp_session_item_set_properties;

    extern fn wp_session_item_get_type() usize;
    pub const getGObjectType = wp_session_item_get_type;

    extern fn g_object_ref(p_self: *wp.SessionItem) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.SessionItem) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *SessionItem, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// WpSettings loads and parses the "sm-settings" (default value) metadata, which contains wireplumber settings, and provides APIs to its clients (modules, lua scripts etc) to access them.
/// Being a WpObject subclass, the settings inherits WpObject's activation system.
pub const Settings = opaque {
    pub const Parent = wp.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.SettingsClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const metadata_name = struct {
            pub const name = "metadata-name";

            pub const Type = ?[*:0]u8;
        };
    };

    pub const signals = struct {};

    /// Finds a registered WpSettings object by its metadata name.
    extern fn wp_settings_find(p_core: *wp.Core, p_metadata_name: ?[*:0]const u8) ?*wp.Settings;
    pub const find = wp_settings_find;

    /// Creates a new WpSettings object.
    extern fn wp_settings_new(p_core: *wp.Core, p_metadata_name: ?[*:0]const u8) *wp.Settings;
    pub const new = wp_settings_new;

    /// Deletes a saved setting to not make it persistent after reboot.
    extern fn wp_settings_delete(p_self: *Settings, p_name: [*:0]const u8) c_int;
    pub const delete = wp_settings_delete;

    /// Deletes all saved setting to not make them persistent after reboot.
    extern fn wp_settings_delete_all(p_self: *Settings) void;
    pub const deleteAll = wp_settings_delete_all;

    /// Gets the WpSpaJson value of a setting.
    extern fn wp_settings_get(p_self: *Settings, p_name: [*:0]const u8) ?*wp.SpaJson;
    pub const get = wp_settings_get;

    /// Gets the WpSpaJson saved value of a setting.
    extern fn wp_settings_get_saved(p_self: *Settings, p_name: [*:0]const u8) ?*wp.SpaJson;
    pub const getSaved = wp_settings_get_saved;

    /// Gets the specification of a setting.
    extern fn wp_settings_get_spec(p_self: *Settings, p_name: [*:0]const u8) ?*wp.SettingsSpec;
    pub const getSpec = wp_settings_get_spec;

    /// Iterates over settings.
    extern fn wp_settings_new_iterator(p_self: *Settings) *wp.Iterator;
    pub const newIterator = wp_settings_new_iterator;

    /// Resets the setting to its default value.
    extern fn wp_settings_reset(p_self: *Settings, p_name: [*:0]const u8) c_int;
    pub const reset = wp_settings_reset;

    /// Resets all the settings to their default value.
    extern fn wp_settings_reset_all(p_self: *Settings) void;
    pub const resetAll = wp_settings_reset_all;

    /// Saves a setting to make it persistent after reboot.
    extern fn wp_settings_save(p_self: *Settings, p_name: [*:0]const u8) c_int;
    pub const save = wp_settings_save;

    /// Saves all the settings to make them persistent after reboot.
    extern fn wp_settings_save_all(p_self: *Settings) void;
    pub const saveAll = wp_settings_save_all;

    /// Sets a new setting value.
    extern fn wp_settings_set(p_self: *Settings, p_name: [*:0]const u8, p_value: *wp.SpaJson) c_int;
    pub const set = wp_settings_set;

    /// Subscribes callback for a given setting pattern(a glob-style pattern matched using g_pattern_match_simple), this allows clients to look for any changes made in settings through metadata.
    extern fn wp_settings_subscribe(p_self: *Settings, p_pattern: [*:0]const u8, p_callback: wp.SettingsChangedCallback, p_user_data: ?*anyopaque) usize;
    pub const subscribe = wp_settings_subscribe;

    /// Subscribes callback for a given setting pattern(a glob-style pattern matched using g_pattern_match_simple), this allows clients to look for any changes made in settings through metadata.
    extern fn wp_settings_subscribe_closure(p_self: *Settings, p_pattern: [*:0]const u8, p_closure: ?*gobject.Closure) usize;
    pub const subscribeClosure = wp_settings_subscribe_closure;

    /// Unsubscribes callback for a given subscription_id.
    extern fn wp_settings_unsubscribe(p_self: *Settings, p_subscription_id: usize) c_int;
    pub const unsubscribe = wp_settings_unsubscribe;

    extern fn wp_settings_get_type() usize;
    pub const getGObjectType = wp_settings_get_type;

    extern fn g_object_ref(p_self: *wp.Settings) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Settings) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Settings, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A factory for session items.
/// The most simple way to register a new item implementation would be:
/// ```
///   wp_si_factory_register (core,
///      wp_si_factory_new_simple (
/// ```
/// And the most simple way to construct an item from a registered factory:
/// ```
///   item = wp_session_item_make (core,
/// ```
pub const SiFactory = extern struct {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.SiFactoryClass;
    f_parent_instance: gobject.Object,

    pub const virtual_methods = struct {
        /// Creates a new instance of the session item that is constructed by this factory.
        pub const construct = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_core: *wp.Core) *wp.SessionItem {
                return gobject.ext.as(SiFactory.Class, p_class).f_construct.?(gobject.ext.as(SiFactory, p_self), p_core);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_core: *wp.Core) callconv(.c) *wp.SessionItem) void {
                gobject.ext.as(SiFactory.Class, p_class).f_construct = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const name = struct {
            pub const name = "name";

            pub const Type = ?[*:0]u8;
        };
    };

    pub const signals = struct {};

    /// Looks up a factory matching a name.
    extern fn wp_si_factory_find(p_core: *wp.Core, p_factory_name: [*:0]const u8) ?*wp.SiFactory;
    pub const find = wp_si_factory_find;

    /// Creates a simple factory that constructs objects of a given GType.
    extern fn wp_si_factory_new_simple(p_factory_name: [*:0]const u8, p_si_type: usize) *wp.SiFactory;
    pub const newSimple = wp_si_factory_new_simple;

    /// Creates a new instance of the session item that is constructed by this factory.
    extern fn wp_si_factory_construct(p_self: *SiFactory, p_core: *wp.Core) *wp.SessionItem;
    pub const construct = wp_si_factory_construct;

    /// Gets the name of the factory.
    extern fn wp_si_factory_get_name(p_self: *SiFactory) [*:0]const u8;
    pub const getName = wp_si_factory_get_name;

    extern fn wp_si_factory_get_type() usize;
    pub const getGObjectType = wp_si_factory_get_type;

    extern fn g_object_ref(p_self: *wp.SiFactory) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.SiFactory) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *SiFactory, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An event hook that runs a GClosure, synchronously.
pub const SimpleEventHook = opaque {
    pub const Parent = wp.InterestEventHook;
    pub const Implements = [_]type{};
    pub const Class = wp.SimpleEventHookClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const closure = struct {
            pub const name = "closure";

            pub const Type = ?*gobject.Closure;
        };
    };

    pub const signals = struct {};

    extern fn wp_simple_event_hook_new(p_name: [*:0]const u8, p_before: *[*:0]const u8, p_after: *[*:0]const u8, p_closure: *gobject.Closure) *wp.SimpleEventHook;
    pub const new = wp_simple_event_hook_new;

    extern fn wp_simple_event_hook_get_type() usize;
    pub const getGObjectType = wp_simple_event_hook_get_type;

    extern fn g_object_ref(p_self: *wp.SimpleEventHook) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.SimpleEventHook) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *SimpleEventHook, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A WpSpaDevice allows running a spa_device object locally, loading the implementation from a SPA factory. This is useful to run device monitors inside the session manager and have control over creating the actual nodes that the spa_device requests to create.
/// To enable the spa device, call `wp.Object.activate` requesting WP_SPA_DEVICE_FEATURE_ENABLED.
/// For actual devices (not device monitors) it also possible and desirable to export the device to PipeWire, which can be done by requesting WP_PROXY_FEATURE_BOUND from `wp.Object.activate`. When exporting, the export should be done before enabling the device, by requesting both features at the same time.
pub const SpaDevice = opaque {
    pub const Parent = wp.Proxy;
    pub const Implements = [_]type{};
    pub const Class = wp.SpaDeviceClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const properties = struct {
            pub const name = "properties";

            pub const Type = ?*wp.Properties;
        };

        pub const spa_device_handle = struct {
            pub const name = "spa-device-handle";

            pub const Type = ?*anyopaque;
        };
    };

    pub const signals = struct {
        pub const create_object = struct {
            pub const name = "create-object";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: c_uint, p_p0: [*:0]u8, p_p1: [*:0]u8, p_p2: *wp.Properties, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(SpaDevice, p_instance))),
                    gobject.signalLookup("create-object", SpaDevice.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };

        pub const object_removed = struct {
            pub const name = "object-removed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: c_uint, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(SpaDevice, p_instance))),
                    gobject.signalLookup("object-removed", SpaDevice.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Constructs a SPA_TYPE_INTERFACE_Device by loading the given SPA `factory_name`.
    ///
    ///
    /// To export this device to the PipeWire server, you need to call `wp.Object.activate` requesting WP_PROXY_FEATURE_BOUND and wait for the operation to complete.
    extern fn wp_spa_device_new_from_spa_factory(p_core: *wp.Core, p_factory_name: [*:0]const u8, p_properties: ?*wp.Properties) ?*wp.SpaDevice;
    pub const newFromSpaFactory = wp_spa_device_new_from_spa_factory;

    /// Constructs an SPA Device object from an existing device handle.
    extern fn wp_spa_device_new_wrap(p_core: *wp.Core, p_spa_device_handle: ?*anyopaque, p_properties: ?*wp.Properties) *wp.SpaDevice;
    pub const newWrap = wp_spa_device_new_wrap;

    /// Gets one of the objects managed by this device.
    extern fn wp_spa_device_get_managed_object(p_self: *SpaDevice, p_id: c_uint) *gobject.Object;
    pub const getManagedObject = wp_spa_device_get_managed_object;

    /// Gets the properties of this device.
    extern fn wp_spa_device_get_properties(p_self: *SpaDevice) *wp.Properties;
    pub const getProperties = wp_spa_device_get_properties;

    /// Iterates through all the objects managed by this device.
    extern fn wp_spa_device_new_managed_object_iterator(p_self: *SpaDevice) *wp.Iterator;
    pub const newManagedObjectIterator = wp_spa_device_new_managed_object_iterator;

    /// Marks a managed object id pending.
    ///
    ///
    /// When an object id is pending, Props from received ObjectConfig events for the id are saved. When wp_spa_device_store_managed_object later sets an object for the id, the saved Props are immediately set on the object and pending status is cleared.
    /// If an object is already set for the id, this has no effect.
    extern fn wp_spa_device_set_managed_pending(p_self: *SpaDevice, p_id: c_uint) void;
    pub const setManagedPending = wp_spa_device_set_managed_pending;

    /// Stores or removes a managed object into/from a device.
    extern fn wp_spa_device_store_managed_object(p_self: *SpaDevice, p_id: c_uint, p_object: ?*gobject.Object) void;
    pub const storeManagedObject = wp_spa_device_store_managed_object;

    extern fn wp_spa_device_get_type() usize;
    pub const getGObjectType = wp_spa_device_get_type;

    extern fn g_object_ref(p_self: *wp.SpaDevice) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.SpaDevice) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *SpaDevice, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SpaType = opaque {
    pub const Parent = gobject.TypeInstance;
    pub const Implements = [_]type{};
    pub const Class = opaque {
        pub const Instance = SpaType;
    };
    pub const virtual_methods = struct {};

    pub const properties = struct {};

    pub const signals = struct {};

    /// Looks up the type id from a given type name.
    extern fn wp_spa_type_from_name(p_name: [*:0]const u8) wp.SpaType;
    pub const fromName = wp_spa_type_from_name;

    /// Gets the table with the values that can be stored in the special "id" field of an object of the given `type`.
    ///
    ///
    /// Object pods (see WpSpaPod) always have a special "id" field along with other fields that can be defined. This "id" field can only store values of a specific SPA_TYPE_Id type. This function returns the table that contains the possible values for that field.
    extern fn wp_spa_type_get_object_id_values_table(p_type: SpaType) wp.SpaIdTable;
    pub const getObjectIdValuesTable = wp_spa_type_get_object_id_values_table;

    /// Gets the values table of an SPA type.
    extern fn wp_spa_type_get_values_table(p_type: SpaType) wp.SpaIdTable;
    pub const getValuesTable = wp_spa_type_get_values_table;

    /// Checks if an SPA type is a fundamental type.
    extern fn wp_spa_type_is_fundamental(p_type: SpaType) c_int;
    pub const isFundamental = wp_spa_type_is_fundamental;

    /// Checks if an SPA type is an Id type.
    extern fn wp_spa_type_is_id(p_type: SpaType) c_int;
    pub const isId = wp_spa_type_is_id;

    /// Checks if an SPA type is an Object type.
    extern fn wp_spa_type_is_object(p_type: SpaType) c_int;
    pub const isObject = wp_spa_type_is_object;

    /// Gets the name of an SPA type.
    extern fn wp_spa_type_name(p_type: SpaType) [*:0]const u8;
    pub const name = wp_spa_type_name;

    /// Gets the parent type of an SPA type.
    extern fn wp_spa_type_parent(p_type: SpaType) wp.SpaType;
    pub const parent = wp_spa_type_parent;

    extern fn wp_spa_type_get_type() usize;
    pub const getGObjectType = wp_spa_type_get_type;

    pub fn as(p_instance: *SpaType, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// The WpState class saves and loads properties from a file
pub const State = opaque {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{};
    pub const Class = wp.StateClass;
    pub const virtual_methods = struct {};

    pub const properties = struct {
        pub const name = struct {
            pub const name = "name";

            pub const Type = ?[*:0]u8;
        };

        pub const timeout = struct {
            pub const name = "timeout";

            pub const Type = c_uint;
        };
    };

    pub const signals = struct {};

    /// Constructs a new state object.
    extern fn wp_state_new(p_name: [*:0]const u8) *wp.State;
    pub const new = wp_state_new;

    /// Clears the state removing its file.
    extern fn wp_state_clear(p_self: *State) void;
    pub const clear = wp_state_clear;

    /// Gets the location of a state object.
    extern fn wp_state_get_location(p_self: *State) [*:0]const u8;
    pub const getLocation = wp_state_get_location;

    /// Gets the name of a state object.
    extern fn wp_state_get_name(p_self: *State) [*:0]const u8;
    pub const getName = wp_state_get_name;

    /// Loads the state data from the file system.
    ///
    ///
    /// This function will never fail. If it cannot load the state, for any reason, it will simply return an empty WpProperties, behaving as if there was no previous state stored.
    extern fn wp_state_load(p_self: *State) *wp.Properties;
    pub const load = wp_state_load;

    /// Saves new properties in the state, overwriting all previous data.
    extern fn wp_state_save(p_self: *State, p_props: *wp.Properties, p_error: ?*?*glib.Error) c_int;
    pub const save = wp_state_save;

    /// Saves new properties in the state, overwriting all previous data, after a timeout.
    ///
    ///
    /// This is similar to `wp.State.save` but it will save the state after a timeout has elapsed. If the state is saved again before the timeout elapses, the timeout is reset.
    /// This function is useful to avoid saving the state too often. When called consecutively, it will save the state only once. Every time it is called, it will cancel the previous timer and start a new one, resulting in timing out only after the last call.
    extern fn wp_state_save_after_timeout(p_self: *State, p_core: *wp.Core, p_props: *wp.Properties) void;
    pub const saveAfterTimeout = wp_state_save_after_timeout;

    extern fn wp_state_get_type() usize;
    pub const getGObjectType = wp_state_get_type;

    extern fn g_object_ref(p_self: *wp.State) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.State) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *State, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A transition is an asynchronous operation, like GTask, that contains an internal state machine, where a series of 'steps' are executed in order to complete the operation.
/// For every step, _WpTransitionClass::`get_next_step` is called in order to determine the next step to execute. Afterwards, _WpTransitionClass::`execute_step` is called to perform any actions necessary to complete this step. When execution of the step is done, the operation's code must call `wp.Transition.advance` in order to continue to the next step. If an error occurs, the operation's code must call `wp.Transition.returnError` instead, in which case the transition completes immediately and `wp.Transition.hadError` returns TRUE.
/// Typically, every step will start an asynchronous operation. Although it is possible, the WpTransition base class does not expect _WpTransitionClass::`execute_step` to call `wp.Transition.advance` directly. Instead, it is expected that `wp.Transition.advance` will be called from the callback that the step's asynchronous operation will call when it is completed.
pub const Transition = extern struct {
    pub const Parent = gobject.Object;
    pub const Implements = [_]type{gio.AsyncResult};
    pub const Class = wp.TransitionClass;
    f_parent_instance: gobject.Object,

    pub const virtual_methods = struct {
        pub const execute_step = struct {
            pub fn call(p_class: anytype, p_transition: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_step: c_uint) void {
                return gobject.ext.as(Transition.Class, p_class).f_execute_step.?(gobject.ext.as(Transition, p_transition), p_step);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_transition: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_step: c_uint) callconv(.c) void) void {
                gobject.ext.as(Transition.Class, p_class).f_execute_step = @ptrCast(p_implementation);
            }
        };

        pub const get_next_step = struct {
            pub fn call(p_class: anytype, p_transition: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_step: c_uint) c_uint {
                return gobject.ext.as(Transition.Class, p_class).f_get_next_step.?(gobject.ext.as(Transition, p_transition), p_step);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_transition: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_step: c_uint) callconv(.c) c_uint) void {
                gobject.ext.as(Transition.Class, p_class).f_get_next_step = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const completed = struct {
            pub const name = "completed";

            pub const Type = c_int;
        };
    };

    pub const signals = struct {};

    /// Returns the final return status of the transition and its error, if there was one.
    ///
    ///
    /// This is meant to be called from within the GAsyncReadyCallback that was specified in `wp.Transition.new`.
    extern fn wp_transition_finish(p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int;
    pub const finish = wp_transition_finish;

    /// Creates a WpTransition acting on `source_object`.
    ///
    ///
    /// When the transition is done, `callback` will be invoked.
    /// The transition does not automatically start executing steps. You must call `wp.Transition.advance` after creating it in order to start it.
    /// The transition is automatically unref'ed after the `callback` has been executed. If you wish to keep an additional reference on it, you need to ref it explicitly.
    extern fn wp_transition_new(p_type: usize, p_source_object: ?*gobject.Object, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_callback_data: ?*anyopaque) *wp.Transition;
    pub const new = wp_transition_new;

    /// Creates a WpTransition acting on `source_object`. When the transition is done, `closure` will be invoked.
    ///
    ///
    /// The transition does not automatically start executing steps. You must call `wp.Transition.advance` after creating it in order to start it.
    /// Note that the transition is automatically unref'ed after the `closure` has been executed. If you wish to keep an additional reference on it, you need to ref it explicitly.
    extern fn wp_transition_new_closure(p_type: usize, p_source_object: ?*gobject.Object, p_cancellable: ?*gio.Cancellable, p_closure: ?*gobject.Closure) *wp.Transition;
    pub const newClosure = wp_transition_new_closure;

    /// Advances the transition to the next step.
    ///
    ///
    /// This initially calls _WpTransitionClass::`get_next_step` in order to determine what the next step is. If _WpTransitionClass::`get_next_step` returns a step different than the previous one, it calls _WpTransitionClass::`execute_step` to execute it.
    /// The very first time that _WpTransitionClass::`get_next_step` is called, its `step` parameter equals WP_TRANSITION_STEP_NONE.
    /// When _WpTransitionClass::`get_next_step` returns WP_TRANSITION_STEP_NONE this function completes the transition, calling the transition's callback and then unref-ing the transition.
    /// When _WpTransitionClass::`get_next_step` returns WP_TRANSITION_STEP_ERROR, this function calls `wp.Transition.returnError`, unless it has already been called directly by _WpTransitionClass::`get_next_step`.
    /// In error conditions, _WpTransitionClass::`execute_step` is called once with `step` being WP_TRANSITION_STEP_ERROR, allowing the implementation to rollback any changes or cancel underlying jobs, if necessary.
    extern fn wp_transition_advance(p_self: *Transition) void;
    pub const advance = wp_transition_advance;

    /// Checks if the transition completed.
    extern fn wp_transition_get_completed(p_self: *Transition) c_int;
    pub const getCompleted = wp_transition_get_completed;

    /// Gets `self` 's data.
    ///
    ///
    /// See `wp.Transition.setData`.
    extern fn wp_transition_get_data(p_self: *Transition) ?*anyopaque;
    pub const getData = wp_transition_get_data;

    /// Gets the source object from the transition.
    ///
    ///
    /// Like `gio.AsyncResult.getSourceObject`, but does not ref the object.
    extern fn wp_transition_get_source_object(p_self: *Transition) *gobject.Object;
    pub const getSourceObject = wp_transition_get_source_object;

    /// Gets `self` 's source tag.
    ///
    ///
    /// See `wp.Transition.setSourceTag`.
    extern fn wp_transition_get_source_tag(p_self: *Transition) ?*anyopaque;
    pub const getSourceTag = wp_transition_get_source_tag;

    /// Checks if the transition completed with an error.
    extern fn wp_transition_had_error(p_self: *Transition) c_int;
    pub const hadError = wp_transition_had_error;

    /// Checks if `self` has the given `tag` (generally a function pointer indicating the function `self` was created by).
    extern fn wp_transition_is_tagged(p_self: *Transition, p_tag: ?*anyopaque) c_int;
    pub const isTagged = wp_transition_is_tagged;

    /// Completes the transition with an error.
    ///
    ///
    /// This can be called anytime from within any virtual function or an async job handler.
    /// In most cases this will also unref the transition, so it is not safe to access it after this function has been called.
    extern fn wp_transition_return_error(p_self: *Transition, p_error: *glib.Error) void;
    pub const returnError = wp_transition_return_error;

    /// Sets `self` 's data (freeing the existing data, if any). This can be an arbitrary user structure that holds data associated with this transition.
    extern fn wp_transition_set_data(p_self: *Transition, p_data: ?*anyopaque, p_data_destroy: ?glib.DestroyNotify) void;
    pub const setData = wp_transition_set_data;

    /// Sets `self` 's source tag.
    ///
    ///
    /// You can use this to tag a transition's return value with a particular pointer (usually a pointer to the function doing the tagging) and then later check it using `wp.Transition.getSourceTag` (or `gio.AsyncResult.isTagged`) in the transition's "finish" function, to figure out if the response came from a particular place.
    extern fn wp_transition_set_source_tag(p_self: *Transition, p_tag: ?*anyopaque) void;
    pub const setSourceTag = wp_transition_set_source_tag;

    extern fn wp_transition_get_type() usize;
    pub const getGObjectType = wp_transition_get_type;

    extern fn g_object_ref(p_self: *wp.Transition) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.Transition) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *Transition, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An interface that provides the ability to load components.
/// Components can be:
///  - WirePlumber modules (libraries that provide WpPlugin and WpSiFactory objects)
///  - Scripts (ex. lua scripts)
///
/// The WirePlumber library provides built-in support for loading WirePlumber modules, without a component loader. For other kinds of components, a component loader is meant to be provided in by some WirePlumber module. For Lua scripts specifically, a component loader is provided by the lua scripting module.
pub const ComponentLoader = opaque {
    pub const Prerequisites = [_]type{gobject.Object};
    pub const Iface = wp.ComponentLoaderInterface;
    pub const virtual_methods = struct {
        pub const load = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_core: *wp.Core, p_component: [*:0]const u8, p_type: [*:0]const u8, p_args: *wp.SpaJson, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) void {
                return gobject.ext.as(ComponentLoader.Iface, p_class).f_load.?(gobject.ext.as(ComponentLoader, p_self), p_core, p_component, p_type, p_args, p_cancellable, p_callback, p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_core: *wp.Core, p_component: [*:0]const u8, p_type: [*:0]const u8, p_args: *wp.SpaJson, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(ComponentLoader.Iface, p_class).f_load = @ptrCast(p_implementation);
            }
        };

        pub const load_finish = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) ?*gobject.Object {
                return gobject.ext.as(ComponentLoader.Iface, p_class).f_load_finish.?(gobject.ext.as(ComponentLoader, p_self), p_res, p_error);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) ?*gobject.Object) void {
                gobject.ext.as(ComponentLoader.Iface, p_class).f_load_finish = @ptrCast(p_implementation);
            }
        };

        pub const supports_type = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_type: [*:0]const u8) c_int {
                return gobject.ext.as(ComponentLoader.Iface, p_class).f_supports_type.?(gobject.ext.as(ComponentLoader, p_self), p_type);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_type: [*:0]const u8) callconv(.c) c_int) void {
                gobject.ext.as(ComponentLoader.Iface, p_class).f_supports_type = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {};

    extern fn wp_component_loader_get_type() usize;
    pub const getGObjectType = wp_component_loader_get_type;

    extern fn g_object_ref(p_self: *wp.ComponentLoader) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.ComponentLoader) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *ComponentLoader, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An interface for standard PipeWire objects.
/// The common characteristic of all objects that implement this interface is the presence of an "info" structure that contains additional properties for this object (in the form of a spa_dict / pw_properties) and optionally also some parameters that can be enumerated and set on the object.
pub const PipewireObject = opaque {
    pub const Prerequisites = [_]type{wp.Proxy};
    pub const Iface = wp.PipewireObjectInterface;
    pub const virtual_methods = struct {
        /// Enumerate object parameters.
        ///
        ///
        /// This will asynchronously return the result, or an error, by calling the given `callback`. The result is going to be a WpIterator containing WpSpaPod objects, which can be retrieved with `wp.PipewireObject.enumParamsFinish`.
        pub const enum_params = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_id: ?[*:0]const u8, p_filter: ?*wp.SpaPod, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_user_data: ?*anyopaque) void {
                return gobject.ext.as(PipewireObject.Iface, p_class).f_enum_params.?(gobject.ext.as(PipewireObject, p_self), p_id, p_filter, p_cancellable, p_callback, p_user_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_id: ?[*:0]const u8, p_filter: ?*wp.SpaPod, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_user_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(PipewireObject.Iface, p_class).f_enum_params = @ptrCast(p_implementation);
            }
        };

        /// Finishes an asynchronous parameter enumeration operation.
        pub const enum_params_finish = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) ?*wp.Iterator {
                return gobject.ext.as(PipewireObject.Iface, p_class).f_enum_params_finish.?(gobject.ext.as(PipewireObject, p_self), p_res, p_error);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) ?*wp.Iterator) void {
                gobject.ext.as(PipewireObject.Iface, p_class).f_enum_params_finish = @ptrCast(p_implementation);
            }
        };

        /// This method can be used to retrieve object parameters in a synchronous way (in contrast with `wp.PipewireObject.enumParams`, which is async).
        ///
        ///
        /// The WP_PIPEWIRE_OBJECT_FEATURE_PARAM_<something> feature that corresponds to the specified `id` must have been activated earlier. These features enable monitoring and caching of params underneath, so that they are always available for retrieval with this method.
        /// Note, however, that cached params may be out-of-date if they have changed very recently on the remote object and the caching mechanism hasn't been able to update them yet, so if you really need up-to-date information you should only rely on `wp.PipewireObject.enumParams` instead.
        pub const enum_params_sync = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_id: [*:0]const u8, p_filter: ?*wp.SpaPod) ?*wp.Iterator {
                return gobject.ext.as(PipewireObject.Iface, p_class).f_enum_params_sync.?(gobject.ext.as(PipewireObject, p_self), p_id, p_filter);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_id: [*:0]const u8, p_filter: ?*wp.SpaPod) callconv(.c) ?*wp.Iterator) void {
                gobject.ext.as(PipewireObject.Iface, p_class).f_enum_params_sync = @ptrCast(p_implementation);
            }
        };

        /// Retrieves the native info structure of this object (pw_node_info, pw_port_info, etc...).
        ///
        ///
        /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
        pub const get_native_info = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) ?*const anyopaque {
                return gobject.ext.as(PipewireObject.Iface, p_class).f_get_native_info.?(gobject.ext.as(PipewireObject, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) ?*const anyopaque) void {
                gobject.ext.as(PipewireObject.Iface, p_class).f_get_native_info = @ptrCast(p_implementation);
            }
        };

        /// Returns the available parameters of this pipewire object.
        ///
        ///
        /// The return value is a GVariant of type a{ss}, where the key of each map entry is a spa param type id (the same ids that you can pass in `wp.PipewireObject.enumParams`) and the value is a string that can contain the following letters, each of them representing a flag:
        ///  - r: the param is readable (SPA_PARAM_INFO_READ)
        ///  - w: the param is writable (SPA_PARAM_INFO_WRITE)
        ///
        /// For params that are readable, you can query them with `wp.PipewireObject.enumParams`
        /// Params that are writable can be set with `wp.PipewireObject.setParam`
        /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
        pub const get_param_info = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) ?*glib.Variant {
                return gobject.ext.as(PipewireObject.Iface, p_class).f_get_param_info.?(gobject.ext.as(PipewireObject, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) ?*glib.Variant) void {
                gobject.ext.as(PipewireObject.Iface, p_class).f_get_param_info = @ptrCast(p_implementation);
            }
        };

        /// Retrieves the PipeWire properties of this object.
        ///
        ///
        /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
        pub const get_properties = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) *wp.Properties {
                return gobject.ext.as(PipewireObject.Iface, p_class).f_get_properties.?(gobject.ext.as(PipewireObject, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) *wp.Properties) void {
                gobject.ext.as(PipewireObject.Iface, p_class).f_get_properties = @ptrCast(p_implementation);
            }
        };

        /// Sets a parameter on the object.
        pub const set_param = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_id: [*:0]const u8, p_flags: u32, p_param: *wp.SpaPod) c_int {
                return gobject.ext.as(PipewireObject.Iface, p_class).f_set_param.?(gobject.ext.as(PipewireObject, p_self), p_id, p_flags, p_param);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_id: [*:0]const u8, p_flags: u32, p_param: *wp.SpaPod) callconv(.c) c_int) void {
                gobject.ext.as(PipewireObject.Iface, p_class).f_set_param = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {
        pub const native_info = struct {
            pub const name = "native-info";

            pub const Type = ?*anyopaque;
        };

        pub const param_info = struct {
            pub const name = "param-info";

            pub const Type = ?*glib.Variant;
        };

        pub const properties = struct {
            pub const name = "properties";

            pub const Type = ?*wp.Properties;
        };
    };

    pub const signals = struct {
        pub const params_changed = struct {
            pub const name = "params-changed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: [*:0]u8, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(PipewireObject, p_instance))),
                    gobject.signalLookup("params-changed", PipewireObject.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Enumerate object parameters.
    ///
    ///
    /// This will asynchronously return the result, or an error, by calling the given `callback`. The result is going to be a WpIterator containing WpSpaPod objects, which can be retrieved with `wp.PipewireObject.enumParamsFinish`.
    extern fn wp_pipewire_object_enum_params(p_self: *PipewireObject, p_id: ?[*:0]const u8, p_filter: ?*wp.SpaPod, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_user_data: ?*anyopaque) void;
    pub const enumParams = wp_pipewire_object_enum_params;

    /// Finishes an asynchronous parameter enumeration operation.
    extern fn wp_pipewire_object_enum_params_finish(p_self: *PipewireObject, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) ?*wp.Iterator;
    pub const enumParamsFinish = wp_pipewire_object_enum_params_finish;

    /// This method can be used to retrieve object parameters in a synchronous way (in contrast with `wp.PipewireObject.enumParams`, which is async).
    ///
    ///
    /// The WP_PIPEWIRE_OBJECT_FEATURE_PARAM_<something> feature that corresponds to the specified `id` must have been activated earlier. These features enable monitoring and caching of params underneath, so that they are always available for retrieval with this method.
    /// Note, however, that cached params may be out-of-date if they have changed very recently on the remote object and the caching mechanism hasn't been able to update them yet, so if you really need up-to-date information you should only rely on `wp.PipewireObject.enumParams` instead.
    extern fn wp_pipewire_object_enum_params_sync(p_self: *PipewireObject, p_id: [*:0]const u8, p_filter: ?*wp.SpaPod) ?*wp.Iterator;
    pub const enumParamsSync = wp_pipewire_object_enum_params_sync;

    /// Retrieves the native info structure of this object (pw_node_info, pw_port_info, etc...).
    ///
    ///
    /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
    extern fn wp_pipewire_object_get_native_info(p_self: *PipewireObject) ?*const anyopaque;
    pub const getNativeInfo = wp_pipewire_object_get_native_info;

    /// Returns the available parameters of this pipewire object.
    ///
    ///
    /// The return value is a GVariant of type a{ss}, where the key of each map entry is a spa param type id (the same ids that you can pass in `wp.PipewireObject.enumParams`) and the value is a string that can contain the following letters, each of them representing a flag:
    ///  - r: the param is readable (SPA_PARAM_INFO_READ)
    ///  - w: the param is writable (SPA_PARAM_INFO_WRITE)
    ///
    /// For params that are readable, you can query them with `wp.PipewireObject.enumParams`
    /// Params that are writable can be set with `wp.PipewireObject.setParam`
    /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
    extern fn wp_pipewire_object_get_param_info(p_self: *PipewireObject) ?*glib.Variant;
    pub const getParamInfo = wp_pipewire_object_get_param_info;

    /// Retrieves the PipeWire properties of this object.
    ///
    ///
    /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
    extern fn wp_pipewire_object_get_properties(p_self: *PipewireObject) *wp.Properties;
    pub const getProperties = wp_pipewire_object_get_properties;

    /// Returns the value of a single pipewire property.
    ///
    ///
    /// This is the same as getting the whole properties structure with `wp.PipewireObject.getProperties` and accessing a single property with `wp.Properties.get`, but saves one call and having to clean up the WpProperties reference count afterwards.
    /// The value is owned by the proxy, but it is guaranteed to stay alive until execution returns back to the event loop.
    /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
    extern fn wp_pipewire_object_get_property(p_self: *PipewireObject, p_key: [*:0]const u8) ?[*:0]const u8;
    pub const getProperty = wp_pipewire_object_get_property;

    /// Iterates over the object's PipeWire properties.
    ///
    ///
    /// Requires WP_PIPEWIRE_OBJECT_FEATURE_INFO
    extern fn wp_pipewire_object_new_properties_iterator(p_self: *PipewireObject) *wp.Iterator;
    pub const newPropertiesIterator = wp_pipewire_object_new_properties_iterator;

    /// Sets a parameter on the object.
    extern fn wp_pipewire_object_set_param(p_self: *PipewireObject, p_id: [*:0]const u8, p_flags: u32, p_param: *wp.SpaPod) c_int;
    pub const setParam = wp_pipewire_object_set_param;

    extern fn wp_pipewire_object_get_type() usize;
    pub const getGObjectType = wp_pipewire_object_get_type;

    extern fn g_object_ref(p_self: *wp.PipewireObject) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.PipewireObject) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *PipewireObject, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// This interface provides a way to request an item for linking before doing so. This allows item implementations to apply internal policy rules.
/// A WpSiAcquisition is associated directly with a WpSiLinkable via `wp.SiLinkable.getAcquisition`. In order to allow switching policies, it is recommended that port info implementations use a separate session item to implement this interface and allow replacing it.
pub const SiAcquisition = opaque {
    pub const Prerequisites = [_]type{wp.SessionItem};
    pub const Iface = wp.SiAcquisitionInterface;
    pub const virtual_methods = struct {
        /// Acquires the `item` for linking by `acquisitor`.
        ///
        ///
        /// When a link is not allowed by policy, this operation should return an error.
        /// When a link needs to be delayed for a short amount of time (ex. to apply a fade out effect on another item), this operation should finish with a delay. It is safe to assume that after this operation completes, the item will be linked immediately.
        pub const acquire = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_acquisitor: *wp.SiLink, p_item: *wp.SiLinkable, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) void {
                return gobject.ext.as(SiAcquisition.Iface, p_class).f_acquire.?(gobject.ext.as(SiAcquisition, p_self), p_acquisitor, p_item, p_callback, p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_acquisitor: *wp.SiLink, p_item: *wp.SiLinkable, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(SiAcquisition.Iface, p_class).f_acquire = @ptrCast(p_implementation);
            }
        };

        /// Finishes the operation started by `wp.SiAcquisition.acquire`. This is meant to be called in the callback that was passed to that method.
        pub const acquire_finish = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int {
                return gobject.ext.as(SiAcquisition.Iface, p_class).f_acquire_finish.?(gobject.ext.as(SiAcquisition, p_self), p_res, p_error);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) c_int) void {
                gobject.ext.as(SiAcquisition.Iface, p_class).f_acquire_finish = @ptrCast(p_implementation);
            }
        };

        /// Releases the `item`, which means that it is being unlinked.
        pub const release = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_acquisitor: *wp.SiLink, p_item: *wp.SiLinkable) void {
                return gobject.ext.as(SiAcquisition.Iface, p_class).f_release.?(gobject.ext.as(SiAcquisition, p_self), p_acquisitor, p_item);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_acquisitor: *wp.SiLink, p_item: *wp.SiLinkable) callconv(.c) void) void {
                gobject.ext.as(SiAcquisition.Iface, p_class).f_release = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {};

    /// Acquires the `item` for linking by `acquisitor`.
    ///
    ///
    /// When a link is not allowed by policy, this operation should return an error.
    /// When a link needs to be delayed for a short amount of time (ex. to apply a fade out effect on another item), this operation should finish with a delay. It is safe to assume that after this operation completes, the item will be linked immediately.
    extern fn wp_si_acquisition_acquire(p_self: *SiAcquisition, p_acquisitor: *wp.SiLink, p_item: *wp.SiLinkable, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) void;
    pub const acquire = wp_si_acquisition_acquire;

    /// Finishes the operation started by `wp.SiAcquisition.acquire`. This is meant to be called in the callback that was passed to that method.
    extern fn wp_si_acquisition_acquire_finish(p_self: *SiAcquisition, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int;
    pub const acquireFinish = wp_si_acquisition_acquire_finish;

    /// Releases the `item`, which means that it is being unlinked.
    extern fn wp_si_acquisition_release(p_self: *SiAcquisition, p_acquisitor: *wp.SiLink, p_item: *wp.SiLinkable) void;
    pub const release = wp_si_acquisition_release;

    extern fn wp_si_acquisition_get_type() usize;
    pub const getGObjectType = wp_si_acquisition_get_type;

    extern fn g_object_ref(p_self: *wp.SiAcquisition) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.SiAcquisition) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *SiAcquisition, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An interface for port adapters
pub const SiAdapter = opaque {
    pub const Prerequisites = [_]type{wp.SessionItem};
    pub const Iface = wp.SiAdapterInterface;
    pub const virtual_methods = struct {
        /// Gets the format used to configure the adapter session item's ports.
        pub const get_ports_format = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_mode: ?*[*:0]const u8) *wp.SpaPod {
                return gobject.ext.as(SiAdapter.Iface, p_class).f_get_ports_format.?(gobject.ext.as(SiAdapter, p_self), p_mode);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_mode: ?*[*:0]const u8) callconv(.c) *wp.SpaPod) void {
                gobject.ext.as(SiAdapter.Iface, p_class).f_get_ports_format = @ptrCast(p_implementation);
            }
        };

        /// Gets the ports state.
        pub const get_ports_state = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) wp.SiAdapterPortsState {
                return gobject.ext.as(SiAdapter.Iface, p_class).f_get_ports_state.?(gobject.ext.as(SiAdapter, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) wp.SiAdapterPortsState) void {
                gobject.ext.as(SiAdapter.Iface, p_class).f_get_ports_state = @ptrCast(p_implementation);
            }
        };

        /// Sets the format and configures the adapter session item ports using the given format.
        ///
        ///
        /// The result of the operation can be checked using the `wp.SiAdapter.setPortsFormatFinish` API. If format is NULL, the adapter will be configured with the default format. If mode is NULL, the adapter will use "dsp" mode.
        pub const set_ports_format = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_format: ?*wp.SpaPod, p_mode: ?[*:0]const u8, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) void {
                return gobject.ext.as(SiAdapter.Iface, p_class).f_set_ports_format.?(gobject.ext.as(SiAdapter, p_self), p_format, p_mode, p_callback, p_data);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_format: ?*wp.SpaPod, p_mode: ?[*:0]const u8, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) callconv(.c) void) void {
                gobject.ext.as(SiAdapter.Iface, p_class).f_set_ports_format = @ptrCast(p_implementation);
            }
        };

        /// Finishes the operation started by `wp_si_adapter_set_format`. This is meant to be called in the callback that was passed to that method.
        pub const set_ports_format_finish = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int {
                return gobject.ext.as(SiAdapter.Iface, p_class).f_set_ports_format_finish.?(gobject.ext.as(SiAdapter, p_self), p_res, p_error);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) c_int) void {
                gobject.ext.as(SiAdapter.Iface, p_class).f_set_ports_format_finish = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {
        pub const adapter_ports_state_changed = struct {
            pub const name = "adapter-ports-state-changed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), p_object: wp.SiAdapterPortsState, p_p0: wp.SiAdapterPortsState, P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(SiAdapter, p_instance))),
                    gobject.signalLookup("adapter-ports-state-changed", SiAdapter.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Gets the format used to configure the adapter session item's ports.
    extern fn wp_si_adapter_get_ports_format(p_self: *SiAdapter, p_mode: ?*[*:0]const u8) *wp.SpaPod;
    pub const getPortsFormat = wp_si_adapter_get_ports_format;

    /// Gets the ports state.
    extern fn wp_si_adapter_get_ports_state(p_self: *SiAdapter) wp.SiAdapterPortsState;
    pub const getPortsState = wp_si_adapter_get_ports_state;

    /// Sets the format and configures the adapter session item ports using the given format.
    ///
    ///
    /// The result of the operation can be checked using the `wp.SiAdapter.setPortsFormatFinish` API. If format is NULL, the adapter will be configured with the default format. If mode is NULL, the adapter will use "dsp" mode.
    extern fn wp_si_adapter_set_ports_format(p_self: *SiAdapter, p_format: ?*wp.SpaPod, p_mode: ?[*:0]const u8, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) void;
    pub const setPortsFormat = wp_si_adapter_set_ports_format;

    /// Finishes the operation started by `wp_si_adapter_set_format`. This is meant to be called in the callback that was passed to that method.
    extern fn wp_si_adapter_set_ports_format_finish(p_self: *SiAdapter, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) c_int;
    pub const setPortsFormatFinish = wp_si_adapter_set_ports_format_finish;

    extern fn wp_si_adapter_get_type() usize;
    pub const getGObjectType = wp_si_adapter_get_type;

    extern fn g_object_ref(p_self: *wp.SiAdapter) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.SiAdapter) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *SiAdapter, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An interface for session items that provide a PipeWire link.
pub const SiLink = opaque {
    pub const Prerequisites = [_]type{wp.SessionItem};
    pub const Iface = wp.SiLinkInterface;
    pub const virtual_methods = struct {
        /// Gets the input item linked by the link.
        pub const get_in_item = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) *wp.SiLinkable {
                return gobject.ext.as(SiLink.Iface, p_class).f_get_in_item.?(gobject.ext.as(SiLink, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) *wp.SiLinkable) void {
                gobject.ext.as(SiLink.Iface, p_class).f_get_in_item = @ptrCast(p_implementation);
            }
        };

        /// Gets the output item linked by the link.
        pub const get_out_item = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) *wp.SiLinkable {
                return gobject.ext.as(SiLink.Iface, p_class).f_get_out_item.?(gobject.ext.as(SiLink, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) *wp.SiLinkable) void {
                gobject.ext.as(SiLink.Iface, p_class).f_get_out_item = @ptrCast(p_implementation);
            }
        };

        /// Gets the properties of the link.
        pub const get_properties = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) ?*wp.Properties {
                return gobject.ext.as(SiLink.Iface, p_class).f_get_properties.?(gobject.ext.as(SiLink, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) ?*wp.Properties) void {
                gobject.ext.as(SiLink.Iface, p_class).f_get_properties = @ptrCast(p_implementation);
            }
        };

        /// This should return information that is used for registering the link, as a GVariant of type a{ss} that contains additional properties to be added to the list of global properties.
        pub const get_registration_info = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) *glib.Variant {
                return gobject.ext.as(SiLink.Iface, p_class).f_get_registration_info.?(gobject.ext.as(SiLink, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) *glib.Variant) void {
                gobject.ext.as(SiLink.Iface, p_class).f_get_registration_info = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {
        pub const link_properties_changed = struct {
            pub const name = "link-properties-changed";

            pub fn connect(p_instance: anytype, comptime P_Data: type, p_callback: *const fn (@TypeOf(p_instance), P_Data) callconv(.c) void, p_data: P_Data, p_options: gobject.ext.ConnectSignalOptions(P_Data)) c_ulong {
                return gobject.signalConnectClosureById(
                    @ptrCast(@alignCast(gobject.ext.as(SiLink, p_instance))),
                    gobject.signalLookup("link-properties-changed", SiLink.getGObjectType()),
                    glib.quarkFromString(p_options.detail orelse null),
                    gobject.CClosure.new(@ptrCast(p_callback), p_data, @ptrCast(p_options.destroyData)),
                    @intFromBool(p_options.after),
                );
            }
        };
    };

    /// Gets the input item linked by the link.
    extern fn wp_si_link_get_in_item(p_self: *SiLink) *wp.SiLinkable;
    pub const getInItem = wp_si_link_get_in_item;

    /// Gets the output item linked by the link.
    extern fn wp_si_link_get_out_item(p_self: *SiLink) *wp.SiLinkable;
    pub const getOutItem = wp_si_link_get_out_item;

    /// Gets the properties of the link.
    extern fn wp_si_link_get_properties(p_self: *SiLink) ?*wp.Properties;
    pub const getProperties = wp_si_link_get_properties;

    /// This should return information that is used for registering the link, as a GVariant of type a{ss} that contains additional properties to be added to the list of global properties.
    extern fn wp_si_link_get_registration_info(p_self: *SiLink) *glib.Variant;
    pub const getRegistrationInfo = wp_si_link_get_registration_info;

    extern fn wp_si_link_get_type() usize;
    pub const getGObjectType = wp_si_link_get_type;

    extern fn g_object_ref(p_self: *wp.SiLink) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.SiLink) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *SiLink, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An interface for retrieving PipeWire port information from a session item. This information is used to create links in the nodes graph.
pub const SiLinkable = opaque {
    pub const Prerequisites = [_]type{wp.SessionItem};
    pub const Iface = wp.SiLinkableInterface;
    pub const virtual_methods = struct {
        /// Gets the acquisition interface associated with the item.
        pub const get_acquisition = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) ?*wp.SiAcquisition {
                return gobject.ext.as(SiLinkable.Iface, p_class).f_get_acquisition.?(gobject.ext.as(SiLinkable, p_self));
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance) callconv(.c) ?*wp.SiAcquisition) void {
                gobject.ext.as(SiLinkable.Iface, p_class).f_get_acquisition = @ptrCast(p_implementation);
            }
        };

        /// This method returns a variant of type "a(uuu)", where each tuple in the array contains the following information:
        ///
        ///
        ///
        ///  - u: (guint32) node id
        ///  - u: (guint32) port id (the port must belong on the node specified above)
        ///  - u: (guint32) the audio channel (enum spa_audio_channel) that this port makes available, or 0 for non-audio content
        ///
        /// The order in which ports appear in this array is important when no channel information is available. The link implementation should link the ports in the order they appear. This is normally a good enough substitute for channel matching.
        /// The `context` argument can be used to get different sets of ports from the item. The following well-known contexts are defined:
        ///  - NULL: get the standard ports to be linked
        ///  - "monitor": get the monitor ports
        ///  - "control": get the control port
        ///  - "reverse": get the reverse direction ports, if this item controls a filter node, which would have ports on both directions
        ///
        /// Contexts other than NULL may only be used internally to ease the implementation of more complex item relationships. For example, a WpSessionItem that is in control of an input (sink) adapter node may implement WpSiLinkable where the NULL context will return the standard input ports and the "monitor" context will return the adapter's monitor ports. When linking this item to another item, the NULL context will always be used, but the item may internally spawn a secondary WpSessionItem that implements the "monitor" item. That secondary item may implement WpSiLinkable, chaining calls to the WpSiLinkable of the original item using the "monitor" context. This way, the monitor WpSessionItem does not need to share control of the underlying node; it only proxies calls to satisfy the API.
        pub const get_ports = struct {
            pub fn call(p_class: anytype, p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_context: ?[*:0]const u8) *glib.Variant {
                return gobject.ext.as(SiLinkable.Iface, p_class).f_get_ports.?(gobject.ext.as(SiLinkable, p_self), p_context);
            }

            pub fn implement(p_class: anytype, p_implementation: *const fn (p_self: *@typeInfo(@TypeOf(p_class)).pointer.child.Instance, p_context: ?[*:0]const u8) callconv(.c) *glib.Variant) void {
                gobject.ext.as(SiLinkable.Iface, p_class).f_get_ports = @ptrCast(p_implementation);
            }
        };
    };

    pub const properties = struct {};

    pub const signals = struct {};

    /// Gets the acquisition interface associated with the item.
    extern fn wp_si_linkable_get_acquisition(p_self: *SiLinkable) ?*wp.SiAcquisition;
    pub const getAcquisition = wp_si_linkable_get_acquisition;

    /// This method returns a variant of type "a(uuu)", where each tuple in the array contains the following information:
    ///
    ///
    ///
    ///  - u: (guint32) node id
    ///  - u: (guint32) port id (the port must belong on the node specified above)
    ///  - u: (guint32) the audio channel (enum spa_audio_channel) that this port makes available, or 0 for non-audio content
    ///
    /// The order in which ports appear in this array is important when no channel information is available. The link implementation should link the ports in the order they appear. This is normally a good enough substitute for channel matching.
    /// The `context` argument can be used to get different sets of ports from the item. The following well-known contexts are defined:
    ///  - NULL: get the standard ports to be linked
    ///  - "monitor": get the monitor ports
    ///  - "control": get the control port
    ///  - "reverse": get the reverse direction ports, if this item controls a filter node, which would have ports on both directions
    ///
    /// Contexts other than NULL may only be used internally to ease the implementation of more complex item relationships. For example, a WpSessionItem that is in control of an input (sink) adapter node may implement WpSiLinkable where the NULL context will return the standard input ports and the "monitor" context will return the adapter's monitor ports. When linking this item to another item, the NULL context will always be used, but the item may internally spawn a secondary WpSessionItem that implements the "monitor" item. That secondary item may implement WpSiLinkable, chaining calls to the WpSiLinkable of the original item using the "monitor" context. This way, the monitor WpSessionItem does not need to share control of the underlying node; it only proxies calls to satisfy the API.
    extern fn wp_si_linkable_get_ports(p_self: *SiLinkable, p_context: ?[*:0]const u8) *glib.Variant;
    pub const getPorts = wp_si_linkable_get_ports;

    extern fn wp_si_linkable_get_type() usize;
    pub const getGObjectType = wp_si_linkable_get_type;

    extern fn g_object_ref(p_self: *wp.SiLinkable) void;
    pub const ref = g_object_ref;

    extern fn g_object_unref(p_self: *wp.SiLinkable) void;
    pub const unref = g_object_unref;

    pub fn as(p_instance: *SiLinkable, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const AsyncEventHookClass = extern struct {
    pub const Instance = wp.AsyncEventHook;

    f_parent_class: wp.InterestEventHookClass,

    pub fn as(p_instance: *AsyncEventHookClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ClientClass = extern struct {
    pub const Instance = wp.Client;

    f_parent_class: wp.GlobalProxyClass,

    pub fn as(p_instance: *ClientClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ComponentLoaderInterface = extern struct {
    pub const Instance = wp.ComponentLoader;

    f_interface: gobject.TypeInterface,
    f_supports_type: ?*const fn (p_self: *wp.ComponentLoader, p_type: [*:0]const u8) callconv(.c) c_int,
    f_load: ?*const fn (p_self: *wp.ComponentLoader, p_core: *wp.Core, p_component: [*:0]const u8, p_type: [*:0]const u8, p_args: *wp.SpaJson, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) callconv(.c) void,
    f_load_finish: ?*const fn (p_self: *wp.ComponentLoader, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) ?*gobject.Object,
    f__wp_padding: [5]*anyopaque,

    pub fn as(p_instance: *ComponentLoaderInterface, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ConfClass = extern struct {
    pub const Instance = wp.Conf;

    f_parent_class: gobject.ObjectClass,

    pub fn as(p_instance: *ConfClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const CoreClass = extern struct {
    pub const Instance = wp.Core;

    f_parent_class: wp.ObjectClass,

    pub fn as(p_instance: *CoreClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const DeviceClass = extern struct {
    pub const Instance = wp.Device;

    f_parent_class: wp.GlobalProxyClass,

    pub fn as(p_instance: *DeviceClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// WpEvent describes an event, an event is an entity which can be pushed on to event stack and the event dispatcher is going to pick and dispatch it.
pub const Event = opaque {
    /// Creates a new event.
    extern fn wp_event_new(p_type: [*:0]const u8, p_priority: c_int, p_properties: ?*wp.Properties, p_source: *gobject.Object, p_subject: ?*gobject.Object) *wp.Event;
    pub const new = wp_event_new;

    /// Collects all the hooks registered in the `dispatcher` that run for this `event`.
    extern fn wp_event_collect_hooks(p_event: *Event, p_dispatcher: *wp.EventDispatcher) c_int;
    pub const collectHooks = wp_event_collect_hooks;

    /// Returns the internal GCancellable that is used to track whether this event has been stopped by `wp.Event.stopProcessing`.
    extern fn wp_event_get_cancellable(p_self: *Event) *gio.Cancellable;
    pub const getCancellable = wp_event_get_cancellable;

    /// Gets the data that was previously associated with `key` by `wp.Event.setData`.
    extern fn wp_event_get_data(p_self: *Event, p_key: [*:0]const u8) ?*const gobject.Value;
    pub const getData = wp_event_get_data;

    /// Gets the name of the event.
    extern fn wp_event_get_name(p_self: *Event) [*:0]const u8;
    pub const getName = wp_event_get_name;

    /// Gets the priority of the event.
    extern fn wp_event_get_priority(p_self: *Event) c_int;
    pub const getPriority = wp_event_get_priority;

    /// Gets the properties of the Event.
    extern fn wp_event_get_properties(p_self: *Event) *wp.Properties;
    pub const getProperties = wp_event_get_properties;

    /// Gets the Source Object of the Event.
    extern fn wp_event_get_source(p_self: *Event) *gobject.Object;
    pub const getSource = wp_event_get_source;

    /// Gets the Subject Object of the Event.
    extern fn wp_event_get_subject(p_self: *Event) *gobject.Object;
    pub const getSubject = wp_event_get_subject;

    /// Returns an iterator that iterates over all the hooks that were collected by `wp.Event.collectHooks`.
    extern fn wp_event_new_hooks_iterator(p_event: *Event) *wp.Iterator;
    pub const newHooksIterator = wp_event_new_hooks_iterator;

    extern fn wp_event_ref(p_self: *Event) *wp.Event;
    pub const ref = wp_event_ref;

    /// Stores `data` on the event, associated with the specified `key`.
    ///
    ///
    /// This can be used to exchange arbitrary data between hooks that run for this event.
    extern fn wp_event_set_data(p_self: *Event, p_key: [*:0]const u8, p_data: ?*const gobject.Value) void;
    pub const setData = wp_event_set_data;

    /// Stops processing of this event; any further hooks will not be executed from this moment onwards and the event will be discarded from the stack.
    extern fn wp_event_stop_processing(p_self: *Event) void;
    pub const stopProcessing = wp_event_stop_processing;

    extern fn wp_event_unref(p_self: *Event) void;
    pub const unref = wp_event_unref;

    extern fn wp_event_get_type() usize;
    pub const getGObjectType = wp_event_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const EventDispatcherClass = extern struct {
    pub const Instance = wp.EventDispatcher;

    f_parent_class: gobject.ObjectClass,

    pub fn as(p_instance: *EventDispatcherClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const EventHookClass = extern struct {
    pub const Instance = wp.EventHook;

    f_parent_class: gobject.ObjectClass,
    f_runs_for_event: ?*const fn (p_self: *wp.EventHook, p_event: *wp.Event) callconv(.c) c_int,
    f_run: ?*const fn (p_self: *wp.EventHook, p_event: *wp.Event, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_callback_data: ?*anyopaque) callconv(.c) void,
    f_finish: ?*const fn (p_self: *wp.EventHook, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) c_int,
    f_get_matching_event_types: ?*const fn (p_self: *wp.EventHook) callconv(.c) ?*glib.PtrArray,
    f__wp_padding: [4]*anyopaque,

    pub fn as(p_instance: *EventHookClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const FactoryClass = extern struct {
    pub const Instance = wp.Factory;

    f_parent_class: wp.GlobalProxyClass,

    pub fn as(p_instance: *FactoryClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const FeatureActivationTransitionClass = extern struct {
    pub const Instance = wp.FeatureActivationTransition;

    f_parent_class: wp.TransitionClass,

    pub fn as(p_instance: *FeatureActivationTransitionClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Global = opaque {
    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const GlobalProxyClass = extern struct {
    pub const Instance = wp.GlobalProxy;

    f_parent_class: wp.ProxyClass,
    f__wp_padding: [4]*anyopaque,

    pub fn as(p_instance: *GlobalProxyClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ImplMetadataClass = extern struct {
    pub const Instance = wp.ImplMetadata;

    f_parent_class: wp.MetadataClass,

    pub fn as(p_instance: *ImplMetadataClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ImplModuleClass = extern struct {
    pub const Instance = wp.ImplModule;

    f_parent_class: gobject.ObjectClass,

    pub fn as(p_instance: *ImplModuleClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ImplNodeClass = extern struct {
    pub const Instance = wp.ImplNode;

    f_parent_class: wp.ProxyClass,

    pub fn as(p_instance: *ImplNodeClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const InterestEventHookClass = extern struct {
    pub const Instance = wp.InterestEventHook;

    f_parent_class: wp.EventHookClass,
    f__wp_padding: [4]*anyopaque,

    pub fn as(p_instance: *InterestEventHookClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A generic iterator API
pub const Iterator = opaque {
    /// Constructs an iterator that uses the provided `methods` to implement its API.
    ///
    ///
    /// The WpIterator structure is internally allocated with `user_size` additional space at the end. A pointer to this space can be retrieved with `wp.Iterator.getUserData` and is available for implementation-specific storage.
    extern fn wp_iterator_new(p_methods: *const wp.IteratorMethods, p_user_size: usize) *wp.Iterator;
    pub const new = wp_iterator_new;

    /// Creates an iterator from a pointer array.
    extern fn wp_iterator_new_ptr_array(p_items: *glib.PtrArray, p_item_type: usize) *wp.Iterator;
    pub const newPtrArray = wp_iterator_new_ptr_array;

    /// Fold a function over the items of the iterator.
    extern fn wp_iterator_fold(p_self: *Iterator, p_func: wp.IteratorFoldFunc, p_ret: *gobject.Value, p_data: ?*anyopaque) c_int;
    pub const fold = wp_iterator_fold;

    /// Iterates over all items of the iterator calling a function.
    extern fn wp_iterator_foreach(p_self: *Iterator, p_func: wp.IteratorForeachFunc, p_data: ?*anyopaque) c_int;
    pub const foreach = wp_iterator_foreach;

    /// Gets the implementation-specific storage of an iterator.
    ///
    ///
    /// this only for use by implementations of WpIterator
    extern fn wp_iterator_get_user_data(p_self: *Iterator) ?*anyopaque;
    pub const getUserData = wp_iterator_get_user_data;

    /// Gets the next item of the iterator.
    extern fn wp_iterator_next(p_self: *Iterator, p_item: *gobject.Value) c_int;
    pub const next = wp_iterator_next;

    /// Increases the reference count of an iterator.
    extern fn wp_iterator_ref(p_self: *Iterator) *wp.Iterator;
    pub const ref = wp_iterator_ref;

    /// Resets the iterator so we can iterate again from the beginning.
    extern fn wp_iterator_reset(p_self: *Iterator) void;
    pub const reset = wp_iterator_reset;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_iterator_unref(p_self: *Iterator) void;
    pub const unref = wp_iterator_unref;

    extern fn wp_iterator_get_type() usize;
    pub const getGObjectType = wp_iterator_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const IteratorMethods = extern struct {
    f_version: u32,
    f_reset: ?*const fn (p_self: *wp.Iterator) callconv(.c) void,
    f_next: ?*const fn (p_self: *wp.Iterator, p_item: *gobject.Value) callconv(.c) c_int,
    f_fold: ?*const fn (p_self: *wp.Iterator, p_func: wp.IteratorFoldFunc, p_ret: *gobject.Value, p_data: ?*anyopaque) callconv(.c) c_int,
    f_foreach: ?*const fn (p_self: *wp.Iterator, p_func: wp.IteratorForeachFunc, p_data: ?*anyopaque) callconv(.c) c_int,
    f_finalize: ?*const fn (p_self: *wp.Iterator) callconv(.c) void,

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const LinkClass = extern struct {
    pub const Instance = wp.Link;

    f_parent_class: wp.GlobalProxyClass,

    pub fn as(p_instance: *LinkClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// A structure representing a log topic.
pub const LogTopic = extern struct {
    f_topic_name: ?[*:0]const u8,
    f_flags: wp.LogTopicFlags,
    f__wp_padding: [3]*anyopaque,

    /// Initializes a log topic. Internal function, don't use it directly.
    extern fn wp_log_topic_init(p_topic: *LogTopic) void;
    pub const init = wp_log_topic_init;

    /// Registers a log topic.
    ///
    ///
    /// The log topic must be unregistered using wp_log_topic_unregister before its lifetime ends.
    /// This function is threadsafe.
    extern fn wp_log_topic_register(p_topic: *LogTopic) void;
    pub const register = wp_log_topic_register;

    /// Unregisters a log topic.
    ///
    ///
    /// This function is threadsafe.
    extern fn wp_log_topic_unregister(p_topic: *LogTopic) void;
    pub const unregister = wp_log_topic_unregister;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const MetadataClass = extern struct {
    pub const Instance = wp.Metadata;

    f_parent_class: wp.GlobalProxyClass,
    f__wp_padding: [4]*anyopaque,

    pub fn as(p_instance: *MetadataClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// WpMetadataItem holds the subject, key, type and value of a metadata entry.
pub const MetadataItem = opaque {
    /// Gets the key from a metadata item.
    extern fn wp_metadata_item_get_key(p_self: *MetadataItem) [*:0]const u8;
    pub const getKey = wp_metadata_item_get_key;

    /// Gets the subject from a metadata item.
    extern fn wp_metadata_item_get_subject(p_self: *MetadataItem) u32;
    pub const getSubject = wp_metadata_item_get_subject;

    /// Gets the value from a metadata item.
    extern fn wp_metadata_item_get_value(p_self: *MetadataItem) [*:0]const u8;
    pub const getValue = wp_metadata_item_get_value;

    /// Gets the value type from a metadata item.
    extern fn wp_metadata_item_get_value_type(p_self: *MetadataItem) [*:0]const u8;
    pub const getValueType = wp_metadata_item_get_value_type;

    /// Increases the reference count of a metadata item object.
    extern fn wp_metadata_item_ref(p_self: *MetadataItem) *wp.MetadataItem;
    pub const ref = wp_metadata_item_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_metadata_item_unref(p_self: *MetadataItem) void;
    pub const unref = wp_metadata_item_unref;

    extern fn wp_metadata_item_get_type() usize;
    pub const getGObjectType = wp_metadata_item_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const NodeClass = extern struct {
    pub const Instance = wp.Node;

    f_parent_class: wp.GlobalProxyClass,

    pub fn as(p_instance: *NodeClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ObjectClass = extern struct {
    pub const Instance = wp.Object;

    f_parent_class: gobject.ObjectClass,
    f_get_supported_features: ?*const fn (p_self: *wp.Object) callconv(.c) wp.ObjectFeatures,
    f_activate_get_next_step: ?*const fn (p_self: *wp.Object, p_transition: *wp.FeatureActivationTransition, p_step: c_uint, p_missing: wp.ObjectFeatures) callconv(.c) c_uint,
    f_activate_execute_step: ?*const fn (p_self: *wp.Object, p_transition: *wp.FeatureActivationTransition, p_step: c_uint, p_missing: wp.ObjectFeatures) callconv(.c) void,
    f_deactivate: ?*const fn (p_self: *wp.Object, p_features: wp.ObjectFeatures) callconv(.c) void,
    f__wp_padding: [8]*anyopaque,

    pub fn as(p_instance: *ObjectClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// An object interest is a helper that is used in WpObjectManager to declare interest in certain kinds of objects.
/// An interest is defined by a GType and a set of constraints on the object's properties. An object "matches" the interest if it is of the specified GType (either the same type or a descendant of it) and all the constraints are satisfied.
pub const ObjectInterest = opaque {
    /// Creates a new interest that declares interest in objects of the specified `gtype`, with the constraints specified in the variable arguments.
    ///
    ///
    /// The variable arguments should be a list of constraints terminated with NULL, where each constraint consists of the following arguments:
    ///  - a WpConstraintType: the constraint type
    ///  - a const gchar *: the subject name
    ///  - a const gchar *: the format string
    ///  - 0 or more arguments according to the format string
    ///
    /// The format string is interpreted as follows:
    ///  - the first character is the constraint verb:
    ///  - =: WP_CONSTRAINT_VERB_EQUALS
    ///  - !: WP_CONSTRAINT_VERB_NOT_EQUALS
    ///  - c: WP_CONSTRAINT_VERB_IN_LIST
    ///  - ~: WP_CONSTRAINT_VERB_IN_RANGE
    ///  - #: WP_CONSTRAINT_VERB_MATCHES
    ///  - +: WP_CONSTRAINT_VERB_IS_PRESENT
    ///  - -: WP_CONSTRAINT_VERB_IS_ABSENT
    ///
    ///  - the rest of the characters are interpreted as a GVariant format string, as it would be used in `glib.Variant.new`
    ///
    /// The rest of this function's arguments up to the start of the next constraint depend on the GVariant format part of the format string and are used to construct a GVariant for the constraint's value argument.
    /// For further reading on the constraint's arguments, see `wp.ObjectInterest.addConstraint`
    /// For example, this interest matches objects that are descendants of WpProxy with a "bound-id" between 0 and 100 (inclusive), with a pipewire property called "format.dsp" that contains the string "audio" somewhere in the value and with a pipewire property "port.name" being present (with any value):
    /// ```
    ///   interest = wp_object_interest_new (WP_TYPE_PROXY,
    ///       WP_CONSTRAINT_TYPE_G_PROPERTY, "bound-id", "~(uu)", 0, 100,
    ///       WP_CONSTRAINT_TYPE_PW_PROPERTY, "format.dsp", "`s`", "*audio*",
    ///       WP_CONSTRAINT_TYPE_PW_PROPERTY, "port.name", "+",
    ///       NULL);
    /// ```
    extern fn wp_object_interest_new(p_gtype: usize, ...) *wp.ObjectInterest;
    pub const new = wp_object_interest_new;

    /// Creates a new interest that declares interest in objects of the specified `gtype`, without any property constraints.
    ///
    ///
    /// To add property constraints, you can call `wp.ObjectInterest.addConstraint` afterwards.
    extern fn wp_object_interest_new_type(p_gtype: usize) *wp.ObjectInterest;
    pub const newType = wp_object_interest_new_type;

    /// va_list version of `wp.ObjectInterest.new`
    extern fn wp_object_interest_new_valist(p_gtype: usize, p_args: *std.builtin.VaList) *wp.ObjectInterest;
    pub const newValist = wp_object_interest_new_valist;

    /// Adds a constraint to this interest. Constraints consist of a `type`, a `subject`, a `verb` and, depending on the `verb`, a `value`.
    ///
    ///
    /// Constraints are almost like a spoken language sentence that declare a condition that must be true in order to consider that an object can match this interest. For instance, a constraint can be "pipewire property
    /// 'object.id' equals 10". This would be translated to:
    /// ```
    ///   wp_object_interest_add_constraint (i,
    ///      WP_CONSTRAINT_TYPE_PW_PROPERTY, "object.id",
    ///      WP_CONSTRAINT_VERB_EQUALS, g_variant_new_int (10));
    /// ```
    /// Some verbs require a `value` and some others do not. For those that do, the `value` must be of a specific type:
    ///  - WP_CONSTRAINT_VERB_EQUALS: `value` can be a string, a (u)int32, a (u)int64, a double or a boolean. The `subject` value must equal this value for the constraint to be satisfied
    ///  - WP_CONSTRAINT_VERB_IN_LIST: `value` must be a tuple that contains any number of items of the same type; the items can be string, (u)int32, (u)int64 or double. These items make a list that the `subject`'s value will be checked against. If any of the items equals the `subject` value, the constraint is satisfied
    ///  - WP_CONSTRAINT_VERB_IN_RANGE: `value` must be a tuple that contains exactly 2 numbers of the same type ((u)int32, (u)int64 or double), meaning the minimum and maximum (inclusive) of the range. If the `subject` value is a number within this range, the constraint is satisfied
    ///  - WP_CONSTRAINT_VERB_MATCHES: `value` must be a string that defines a pattern usable with GPatternSpec If the `subject` value matches this pattern, the constraint is satisfied
    ///
    /// In case the type of the `subject` value is not the same type as the one requested by the type of the `value`, the `subject` value is converted. For GObject properties, this conversion is done using `gobject.Value.transform`, so limitations of this function apply. In the case of PipeWire properties, which are `always` strings, conversion is done as follows:
    ///  - to boolean: "true" or "1" means TRUE, "false" or "0" means FALSE
    ///  - to int / uint / int64 / uint64: One of the `strtol` family of functions is used to convert, using base 10
    ///  - to double: `strtod` is used
    ///
    /// This method does not fail if invalid arguments are given. However, `wp.ObjectInterest.validate` should be called after adding all the constraints on an interest in order to catch errors.
    extern fn wp_object_interest_add_constraint(p_self: *ObjectInterest, p_type: wp.ConstraintType, p_subject: [*:0]const u8, p_verb: wp.ConstraintVerb, p_value: ?*glib.Variant) void;
    pub const addConstraint = wp_object_interest_add_constraint;

    /// Finds all the defined constraint values for a subject in `self`.
    ///
    ///
    /// A defined constraint value is the value of a constraint with the 'equal' or 'in-list' verb, because the full value must be defined with those verbs. This can be useful for cases where we want to enumerate interests that are interested in specific subjects.
    extern fn wp_object_interest_find_defined_constraint_values(p_self: *ObjectInterest, p_type: wp.ConstraintType, p_subject: [*:0]const u8) ?*glib.PtrArray;
    pub const findDefinedConstraintValues = wp_object_interest_find_defined_constraint_values;

    /// Checks if the specified `object` matches the type and all the constraints that are described in `self`.
    ///
    ///
    /// If `self` is configured to match GObject subclasses, this is equivalent to wp_object_interest_matches_full (self, G_OBJECT_TYPE (object), object, NULL, NULL) and if it is configured to match WpProperties, this is equivalent to wp_object_interest_matches_full (self, self->gtype, NULL, (WpProperties *) object, NULL);
    extern fn wp_object_interest_matches(p_self: *ObjectInterest, p_object: ?*anyopaque) c_int;
    pub const matches = wp_object_interest_matches;

    /// A low-level version of `wp.ObjectInterest.matches`.
    ///
    ///
    /// In this version, the object's type is directly given in `object_type` and is not inferred from the `object`. `object` is only used to check for constraints against GObject properties.
    /// `pw_props` and `pw_global_props` are used to check constraints against PipeWire object properties and global properties, respectively.
    /// `object`, `pw_props` and `pw_global_props` may be NULL, but in case there are any constraints that require them, the match will fail. As a special case, if `object` is not NULL and is a subclass of WpProxy, then `pw_props` and `pw_global_props`, if required, will be internally retrieved from `object` by calling `wp.PipewireObject.getProperties` and `wp.GlobalProxy.getGlobalProperties` respectively.
    /// When `flags` contains WP_INTEREST_MATCH_FLAGS_CHECK_ALL, all the constraints are checked and the returned value contains accurate information about which types of constraints have failed to match, if any. When this flag is not present, this function returns after the first failure has been encountered. This means that the returned flags set will contain all but one flag, which will indicate the kind of constraint that failed (more could have failed, but they are not checked...)
    extern fn wp_object_interest_matches_full(p_self: *ObjectInterest, p_flags: wp.InterestMatchFlags, p_object_type: usize, p_object: ?*gobject.Object, p_pw_props: ?*wp.Properties, p_pw_global_props: ?*wp.Properties) wp.InterestMatch;
    pub const matchesFull = wp_object_interest_matches_full;

    /// Increases the reference count of an object interest.
    extern fn wp_object_interest_ref(p_self: *ObjectInterest) *wp.ObjectInterest;
    pub const ref = wp_object_interest_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_object_interest_unref(p_self: *ObjectInterest) void;
    pub const unref = wp_object_interest_unref;

    /// Validates the interest, ensuring that the interest GType is a valid object and that all the constraints have been expressed properly.
    ///
    ///
    /// This is called internally when `self` is first used to find a match, so it is not necessary to call it explicitly
    extern fn wp_object_interest_validate(p_self: *ObjectInterest, p_error: ?*?*glib.Error) c_int;
    pub const validate = wp_object_interest_validate;

    extern fn wp_object_interest_get_type() usize;
    pub const getGObjectType = wp_object_interest_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ObjectManagerClass = extern struct {
    pub const Instance = wp.ObjectManager;

    f_parent_class: gobject.ObjectClass,

    pub fn as(p_instance: *ObjectManagerClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const PipewireObjectInterface = extern struct {
    pub const Instance = wp.PipewireObject;

    f_parent_iface: gobject.TypeInterface,
    f_get_native_info: ?*const fn (p_self: *wp.PipewireObject) callconv(.c) ?*const anyopaque,
    f_get_properties: ?*const fn (p_self: *wp.PipewireObject) callconv(.c) *wp.Properties,
    f_get_param_info: ?*const fn (p_self: *wp.PipewireObject) callconv(.c) ?*glib.Variant,
    f_enum_params: ?*const fn (p_self: *wp.PipewireObject, p_id: ?[*:0]const u8, p_filter: ?*wp.SpaPod, p_cancellable: ?*gio.Cancellable, p_callback: ?gio.AsyncReadyCallback, p_user_data: ?*anyopaque) callconv(.c) void,
    f_enum_params_finish: ?*const fn (p_self: *wp.PipewireObject, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) ?*wp.Iterator,
    f_enum_params_sync: ?*const fn (p_self: *wp.PipewireObject, p_id: [*:0]const u8, p_filter: ?*wp.SpaPod) callconv(.c) ?*wp.Iterator,
    f_set_param: ?*const fn (p_self: *wp.PipewireObject, p_id: [*:0]const u8, p_flags: u32, p_param: *wp.SpaPod) callconv(.c) c_int,
    f__wp_padding: [5]*anyopaque,

    pub fn as(p_instance: *PipewireObjectInterface, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const PluginClass = extern struct {
    pub const Instance = wp.Plugin;

    f_parent_class: wp.ObjectClass,
    f_enable: ?*const fn (p_self: *wp.Plugin, p_transition: *wp.Transition) callconv(.c) void,
    f_disable: ?*const fn (p_self: *wp.Plugin) callconv(.c) void,
    f__wp_padding: [6]*anyopaque,

    pub fn as(p_instance: *PluginClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const PortClass = extern struct {
    pub const Instance = wp.Port;

    f_parent_class: wp.GlobalProxyClass,

    pub fn as(p_instance: *PortClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// WpProcInfo holds information of a process.
pub const ProcInfo = opaque {
    /// Gets the indexed arg of a process information object.
    extern fn wp_proc_info_get_arg(p_self: *ProcInfo, p_index: c_uint) [*:0]const u8;
    pub const getArg = wp_proc_info_get_arg;

    /// Gets the systemd cgroup of a process information object.
    extern fn wp_proc_info_get_cgroup(p_self: *ProcInfo) [*:0]const u8;
    pub const getCgroup = wp_proc_info_get_cgroup;

    /// Gets the number of args of a process information object.
    extern fn wp_proc_info_get_n_args(p_self: *ProcInfo) c_uint;
    pub const getNArgs = wp_proc_info_get_n_args;

    /// Gets the parent PID of a process information object.
    extern fn wp_proc_info_get_parent_pid(p_self: *ProcInfo) std.posix.pid_t;
    pub const getParentPid = wp_proc_info_get_parent_pid;

    /// Gets the PID of a process information object.
    extern fn wp_proc_info_get_pid(p_self: *ProcInfo) std.posix.pid_t;
    pub const getPid = wp_proc_info_get_pid;

    /// Increases the reference count of a process information object.
    extern fn wp_proc_info_ref(p_self: *ProcInfo) *wp.ProcInfo;
    pub const ref = wp_proc_info_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_proc_info_unref(p_self: *ProcInfo) void;
    pub const unref = wp_proc_info_unref;

    extern fn wp_proc_info_get_type() usize;
    pub const getGObjectType = wp_proc_info_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// WpProperties is a data structure that contains string key-value pairs, which are used to send/receive/attach arbitrary properties to PipeWire objects.
/// This could be thought of as a hash table with strings as both keys and values. However, the reason that this class exists instead of using GHashTable directly is that in reality it wraps the PipeWire native struct spa_dict and struct pw_properties and therefore it can be easily passed to PipeWire function calls that require a struct spa_dict * or a struct pw_properties * as arguments. Or alternatively, it can easily wrap a struct spa_dict * or a struct pw_properties * that was given from the PipeWire API without necessarily doing an expensive copy operation.
/// WpProperties normally wraps a struct pw_properties, unless it was created with `wp.Properties.newWrapDict`, in which case it wraps a struct spa_dict and it is immutable (you cannot add/remove/modify any key-value pair).
/// In most cases, it actually owns the struct pw_properties internally and manages its lifetime. The exception to that rule is when WpProperties is constructed with `wp.Properties.newWrap`, in which case the ownership of the struct pw_properties remains outside. This must be used with care, as the struct pw_properties may be free'ed externally.
/// WpProperties is reference-counted with `wp.Properties.ref` and `wp.Properties.unref`.
pub const Properties = opaque {
    /// Constructs a new properties set that contains the given properties.
    extern fn wp_properties_new(p_key: [*:0]const u8, ...) *wp.Properties;
    pub const new = wp_properties_new;

    /// Constructs a new WpProperties that contains a copy of all the properties contained in the given `props` structure.
    extern fn wp_properties_new_copy(p_props: ?*anyopaque) *wp.Properties;
    pub const newCopy = wp_properties_new_copy;

    /// Constructs a new WpProperties that contains a copy of all the properties contained in the given `dict` structure.
    extern fn wp_properties_new_copy_dict(p_dict: ?*anyopaque) *wp.Properties;
    pub const newCopyDict = wp_properties_new_copy_dict;

    /// Creates a new empty properties set.
    extern fn wp_properties_new_empty() *wp.Properties;
    pub const newEmpty = wp_properties_new_empty;

    /// Constructs a new properties set that contains the properties that can be parsed from the given JSON object.
    extern fn wp_properties_new_json(p_json: *const wp.SpaJson) *wp.Properties;
    pub const newJson = wp_properties_new_json;

    /// Constructs a new properties set that contains the properties that can be parsed from the given string.
    extern fn wp_properties_new_string(p_str: [*:0]const u8) *wp.Properties;
    pub const newString = wp_properties_new_string;

    /// Constructs a new WpProperties that wraps the given `props` structure, allowing reading & writing properties on that `props` structure through the WpProperties API.
    ///
    ///
    /// In contrast with `wp.Properties.newWrap`, this function assumes ownership of the `props` structure, so it will try to free `props` when it is destroyed.
    extern fn wp_properties_new_take(p_props: ?*anyopaque) *wp.Properties;
    pub const newTake = wp_properties_new_take;

    /// This is the va_list version of `wp.Properties.new`.
    extern fn wp_properties_new_valist(p_key: [*:0]const u8, p_args: std.builtin.VaList) *wp.Properties;
    pub const newValist = wp_properties_new_valist;

    /// Constructs a new WpProperties that wraps the given `props` structure, allowing reading properties on that `props` structure through the WpProperties API.
    ///
    ///
    /// Care must be taken when using this function, since the returned WpProperties object does not own the `props` structure. Therefore, if the owner decides to free `props`, the returned WpProperties will crash when used. In addition, the returned WpProperties object will not try to free `props` when destroyed.
    /// Furthermore, note that the returned WpProperties object is immutable. That means that you cannot add or modify any properties on it, unless you make a copy first.
    extern fn wp_properties_new_wrap(p_props: ?*anyopaque) *wp.Properties;
    pub const newWrap = wp_properties_new_wrap;

    /// Constructs a new WpProperties that wraps the given `dict` structure, allowing reading properties from that `dict` through the WpProperties API.
    ///
    ///
    /// Note that the returned object does not own the `dict`, so care must be taken not to free it externally while this WpProperties object is alive.
    /// In addition, note that the returned WpProperties object is immutable. That means that you cannot add or modify any properties on it, since there is no defined method for modifying a struct spa_dict. If you need to change this properties set later, you should make a copy with `wp.Properties.copy`.
    extern fn wp_properties_new_wrap_dict(p_dict: ?*anyopaque) *wp.Properties;
    pub const newWrapDict = wp_properties_new_wrap_dict;

    /// Adds new properties in `self`, using the given `props` as a source.
    ///
    ///
    /// Properties (keys) from `props` that are already contained in `self` are not modified, unlike what happens with `wp.Properties.update`. Properties in `self` that are not contained in `props` are left untouched.
    extern fn wp_properties_add(p_self: *Properties, p_props: *wp.Properties) c_int;
    pub const add = wp_properties_add;

    /// Adds new properties in `self`, using the given `dict` as a source.
    ///
    ///
    /// Properties (keys) from `dict` that are already contained in `self` are not modified, unlike what happens with `wp.Properties.updateFromDict`. Properties in `self` that are not contained in `dict` are left untouched.
    extern fn wp_properties_add_from_dict(p_self: *Properties, p_dict: ?*anyopaque) c_int;
    pub const addFromDict = wp_properties_add_from_dict;

    /// Adds new properties in `self`, using the given `props` as a source.
    ///
    ///
    /// Unlike `wp.Properties.add`, this function only adds properties that have one of the specified keys; the rest is left untouched.
    extern fn wp_properties_add_keys(p_self: *Properties, p_props: *wp.Properties, p_key1: [*:0]const u8, ...) c_int;
    pub const addKeys = wp_properties_add_keys;

    /// The same as `wp.Properties.addKeys`, using a NULL-terminated array for specifying the keys to add.
    extern fn wp_properties_add_keys_array(p_self: *Properties, p_props: *wp.Properties, p_keys: [*][*:0]const u8) c_int;
    pub const addKeysArray = wp_properties_add_keys_array;

    /// Adds new properties in `self`, using the given `dict` as a source.
    ///
    ///
    /// Unlike `wp.Properties.addFromDict`, this function only adds properties that have one of the specified keys; the rest is left untouched.
    extern fn wp_properties_add_keys_from_dict(p_self: *Properties, p_dict: ?*anyopaque, p_key1: [*:0]const u8, ...) c_int;
    pub const addKeysFromDict = wp_properties_add_keys_from_dict;

    /// Constructs and returns a new WpProperties object that contains a copy of all the properties contained in `other`.
    extern fn wp_properties_copy(p_other: *Properties) *wp.Properties;
    pub const copy = wp_properties_copy;

    /// Ensures that the given properties set is uniquely owned.
    ///
    ///
    /// "Uniquely owned" means that:
    ///  - its reference count is 1
    ///  - it is not wrapping a native spa_dict or pw_properties object
    ///
    /// If `self` is not uniquely owned already, then it is unrefed and a copy of it is returned instead. You should always consider `self` as unsafe to use after this call and you should use the returned object instead.
    extern fn wp_properties_ensure_unique_owner(p_self: *Properties) *wp.Properties;
    pub const ensureUniqueOwner = wp_properties_ensure_unique_owner;

    /// Looks up a given property value from a key.
    extern fn wp_properties_get(p_self: *Properties, p_key: [*:0]const u8) ?[*:0]const u8;
    pub const get = wp_properties_get;

    /// Gets the number of properties contained in this object.
    extern fn wp_properties_get_count(p_self: *Properties) c_uint;
    pub const getCount = wp_properties_get_count;

    /// Checks if all property values contained in `other` are matching with the values in `self`.
    ///
    ///
    /// If a property is contained in `other` and not in `self`, the result is not matched. If a property is contained in both sets, then the value of the property in `other` is interpreted as a glob-style pattern (using `glib.patternMatchSimple`) and the value in `self` is checked to see if it matches with this pattern.
    extern fn wp_properties_matches(p_self: *Properties, p_other: *wp.Properties) c_int;
    pub const matches = wp_properties_matches;

    /// Iterates through all the properties in the properties object.
    extern fn wp_properties_new_iterator(p_self: *Properties) *wp.Iterator;
    pub const newIterator = wp_properties_new_iterator;

    /// Gets the dictionary wrapped by a properties object.
    extern fn wp_properties_peek_dict(p_self: *Properties) ?*anyopaque;
    pub const peekDict = wp_properties_peek_dict;

    extern fn wp_properties_ref(p_self: *Properties) *wp.Properties;
    pub const ref = wp_properties_ref;

    /// Sets the given property `key` - `value` pair on `self`.
    ///
    ///
    /// If the property already existed, the value is overwritten with the new one.
    /// If the `value` is NULL, then the specified property is removed from `self`
    extern fn wp_properties_set(p_self: *Properties, p_key: [*:0]const u8, p_value: ?[*:0]const u8) c_int;
    pub const set = wp_properties_set;

    /// Formats the given `format` string with the specified arguments and sets the result as a value of the property specified with `key`.
    extern fn wp_properties_setf(p_self: *Properties, p_key: [*:0]const u8, p_format: [*:0]const u8, ...) c_int;
    pub const setf = wp_properties_setf;

    /// This is the va_list version of `wp.Properties.setf`.
    extern fn wp_properties_setf_valist(p_self: *Properties, p_key: [*:0]const u8, p_format: [*:0]const u8, p_args: std.builtin.VaList) c_int;
    pub const setfValist = wp_properties_setf_valist;

    /// Sorts the keys in alphabetical order.
    extern fn wp_properties_sort(p_self: *Properties) void;
    pub const sort = wp_properties_sort;

    /// Gets a copy of the properties object as a struct pw_properties.
    extern fn wp_properties_to_pw_properties(p_self: *Properties) ?*anyopaque;
    pub const toPwProperties = wp_properties_to_pw_properties;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_properties_unref(p_self: *Properties) void;
    pub const unref = wp_properties_unref;

    /// Similar to `wp.Properties.toPwProperties`, but this method avoids making a copy of the properties by returning the struct pw_properties that is stored internally and then freeing the WpProperties wrapper.
    ///
    ///
    /// If `self` is not uniquely owned (see `wp.Properties.ensureUniqueOwner`), then this method does make a copy and is the same as `wp.Properties.toPwProperties`, performance-wise.
    extern fn wp_properties_unref_and_take_pw_properties(p_self: *Properties) ?*anyopaque;
    pub const unrefAndTakePwProperties = wp_properties_unref_and_take_pw_properties;

    /// Updates (adds new or modifies existing) properties in `self`, using the given `props` as a source.
    ///
    ///
    /// Any properties that are not contained in `props` are left untouched.
    extern fn wp_properties_update(p_self: *Properties, p_props: *wp.Properties) c_int;
    pub const update = wp_properties_update;

    /// Updates (adds new or modifies existing) properties in `self`, using the given `dict` as a source.
    ///
    ///
    /// Any properties that are not contained in `dict` are left untouched.
    extern fn wp_properties_update_from_dict(p_self: *Properties, p_dict: ?*anyopaque) c_int;
    pub const updateFromDict = wp_properties_update_from_dict;

    /// Updates (adds new or modifies existing) properties in `self`, using the given `json` as a source.
    ///
    ///
    /// Any properties that are not contained in `json` are left untouched.
    extern fn wp_properties_update_from_json(p_self: *Properties, p_json: *const wp.SpaJson) c_int;
    pub const updateFromJson = wp_properties_update_from_json;

    /// Updates (adds new or modifies existing) properties in `self`, using the given `props` as a source.
    ///
    ///
    /// Unlike `wp.Properties.update`, this function only updates properties that have one of the specified keys; the rest is left untouched.
    extern fn wp_properties_update_keys(p_self: *Properties, p_props: *wp.Properties, p_key1: [*:0]const u8, ...) c_int;
    pub const updateKeys = wp_properties_update_keys;

    /// The same as `wp.Properties.updateKeys`, using a NULL-terminated array for specifying the keys to update.
    extern fn wp_properties_update_keys_array(p_self: *Properties, p_props: *wp.Properties, p_keys: [*][*:0]const u8) c_int;
    pub const updateKeysArray = wp_properties_update_keys_array;

    /// Updates (adds new or modifies existing) properties in `self`, using the given `dict` as a source.
    ///
    ///
    /// Unlike `wp.Properties.updateFromDict`, this function only updates properties that have one of the specified keys; the rest is left untouched.
    extern fn wp_properties_update_keys_from_dict(p_self: *Properties, p_dict: ?*anyopaque, p_key1: [*:0]const u8, ...) c_int;
    pub const updateKeysFromDict = wp_properties_update_keys_from_dict;

    extern fn wp_properties_get_type() usize;
    pub const getGObjectType = wp_properties_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const PropertiesItem = opaque {
    /// Gets the key from a properties item.
    extern fn wp_properties_item_get_key(p_self: *PropertiesItem) [*:0]const u8;
    pub const getKey = wp_properties_item_get_key;

    /// Gets the value from a properties item.
    extern fn wp_properties_item_get_value(p_self: *PropertiesItem) [*:0]const u8;
    pub const getValue = wp_properties_item_get_value;

    /// Increases the reference count of a properties item object.
    extern fn wp_properties_item_ref(p_self: *PropertiesItem) *wp.PropertiesItem;
    pub const ref = wp_properties_item_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_properties_item_unref(p_self: *PropertiesItem) void;
    pub const unref = wp_properties_item_unref;

    extern fn wp_properties_item_get_type() usize;
    pub const getGObjectType = wp_properties_item_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ProxyClass = extern struct {
    pub const Instance = wp.Proxy;

    f_parent_class: wp.ObjectClass,
    f_pw_iface_type: ?[*:0]const u8,
    f_pw_iface_version: u32,
    f_pw_proxy_created: ?*const fn (p_self: *wp.Proxy, p_proxy: ?*anyopaque) callconv(.c) void,
    f_pw_proxy_destroyed: ?*const fn (p_self: *wp.Proxy) callconv(.c) void,
    f_bound: ?*const fn (p_self: *wp.Proxy, p_id: u32) callconv(.c) void,
    f_error: ?*const fn (p_self: *wp.Proxy, p_seq: c_int, p_res: c_int, p_message: [*:0]const u8) callconv(.c) void,
    f__wp_padding: [6]*anyopaque,

    pub fn as(p_instance: *ProxyClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SessionItemClass = extern struct {
    pub const Instance = wp.SessionItem;

    f_parent_class: wp.ObjectClass,
    f_reset: ?*const fn (p_self: *wp.SessionItem) callconv(.c) void,
    f_configure: ?*const fn (p_self: *wp.SessionItem, p_props: *wp.Properties) callconv(.c) c_int,
    f_get_associated_proxy: ?*const fn (p_self: *wp.SessionItem, p_proxy_type: usize) callconv(.c) ?*anyopaque,
    f_disable_active: ?*const fn (p_self: *wp.SessionItem) callconv(.c) void,
    f_disable_exported: ?*const fn (p_self: *wp.SessionItem) callconv(.c) void,
    f_enable_active: ?*const fn (p_self: *wp.SessionItem, p_transition: *wp.Transition) callconv(.c) void,
    f_enable_exported: ?*const fn (p_self: *wp.SessionItem, p_transition: *wp.Transition) callconv(.c) void,
    f__wp_padding: [5]*anyopaque,

    pub fn as(p_instance: *SessionItemClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SettingsClass = extern struct {
    pub const Instance = wp.Settings;

    f_parent_class: wp.ObjectClass,

    pub fn as(p_instance: *SettingsClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// WpSettingsItem holds the key and value of a setting
pub const SettingsItem = opaque {
    /// Gets the key from a settings item.
    extern fn wp_settings_item_get_key(p_self: *SettingsItem) [*:0]const u8;
    pub const getKey = wp_settings_item_get_key;

    /// Gets the value from a settings item.
    extern fn wp_settings_item_get_value(p_self: *SettingsItem) *wp.SpaJson;
    pub const getValue = wp_settings_item_get_value;

    /// Increases the reference count of a settings item object.
    extern fn wp_settings_item_ref(p_self: *SettingsItem) *wp.SettingsItem;
    pub const ref = wp_settings_item_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_settings_item_unref(p_self: *SettingsItem) void;
    pub const unref = wp_settings_item_unref;

    extern fn wp_settings_item_get_type() usize;
    pub const getGObjectType = wp_settings_item_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// WpSettingSpec holds the specification of a setting.
pub const SettingsSpec = opaque {
    /// Checks whether a value is compatible with the spec or not.
    extern fn wp_settings_spec_check_value(p_self: *SettingsSpec, p_value: *wp.SpaJson) c_int;
    pub const checkValue = wp_settings_spec_check_value;

    /// Gets the default value of a settings spec.
    extern fn wp_settings_spec_get_default_value(p_self: *SettingsSpec) *wp.SpaJson;
    pub const getDefaultValue = wp_settings_spec_get_default_value;

    /// Gets the description of a settings spec.
    extern fn wp_settings_spec_get_description(p_self: *SettingsSpec) [*:0]const u8;
    pub const getDescription = wp_settings_spec_get_description;

    /// Gets the maximum value of a settings spec.
    extern fn wp_settings_spec_get_max_value(p_self: *SettingsSpec) ?*wp.SpaJson;
    pub const getMaxValue = wp_settings_spec_get_max_value;

    /// Gets the minimum value of a settings spec.
    extern fn wp_settings_spec_get_min_value(p_self: *SettingsSpec) ?*wp.SpaJson;
    pub const getMinValue = wp_settings_spec_get_min_value;

    /// Gets the human-readable name of a settings spec.
    extern fn wp_settings_spec_get_name(p_self: *SettingsSpec) ?[*:0]const u8;
    pub const getName = wp_settings_spec_get_name;

    /// Gets the type of a settings spec.
    extern fn wp_settings_spec_get_value_type(p_self: *SettingsSpec) wp.SettingsSpecType;
    pub const getValueType = wp_settings_spec_get_value_type;

    /// Increases the reference count of a settings spec object.
    extern fn wp_settings_spec_ref(p_self: *SettingsSpec) *wp.SettingsSpec;
    pub const ref = wp_settings_spec_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_settings_spec_unref(p_self: *SettingsSpec) void;
    pub const unref = wp_settings_spec_unref;

    extern fn wp_settings_spec_get_type() usize;
    pub const getGObjectType = wp_settings_spec_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SiAcquisitionInterface = extern struct {
    pub const Instance = wp.SiAcquisition;

    f_interface: gobject.TypeInterface,
    f_acquire: ?*const fn (p_self: *wp.SiAcquisition, p_acquisitor: *wp.SiLink, p_item: *wp.SiLinkable, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) callconv(.c) void,
    f_acquire_finish: ?*const fn (p_self: *wp.SiAcquisition, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) c_int,
    f_release: ?*const fn (p_self: *wp.SiAcquisition, p_acquisitor: *wp.SiLink, p_item: *wp.SiLinkable) callconv(.c) void,
    f__wp_padding: [5]*anyopaque,

    pub fn as(p_instance: *SiAcquisitionInterface, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SiAdapterInterface = extern struct {
    pub const Instance = wp.SiAdapter;

    f_interface: gobject.TypeInterface,
    f_get_ports_format: ?*const fn (p_self: *wp.SiAdapter, p_mode: ?*[*:0]const u8) callconv(.c) *wp.SpaPod,
    f_set_ports_format: ?*const fn (p_self: *wp.SiAdapter, p_format: ?*wp.SpaPod, p_mode: ?[*:0]const u8, p_callback: ?gio.AsyncReadyCallback, p_data: ?*anyopaque) callconv(.c) void,
    f_set_ports_format_finish: ?*const fn (p_self: *wp.SiAdapter, p_res: *gio.AsyncResult, p_error: ?*?*glib.Error) callconv(.c) c_int,
    f_get_ports_state: ?*const fn (p_self: *wp.SiAdapter) callconv(.c) wp.SiAdapterPortsState,
    f__wp_padding: [4]*anyopaque,

    pub fn as(p_instance: *SiAdapterInterface, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SiFactoryClass = extern struct {
    pub const Instance = wp.SiFactory;

    f_parent_class: gobject.ObjectClass,
    f_construct: ?*const fn (p_self: *wp.SiFactory, p_core: *wp.Core) callconv(.c) *wp.SessionItem,
    f__wp_padding: [7]*anyopaque,

    pub fn as(p_instance: *SiFactoryClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SiLinkInterface = extern struct {
    pub const Instance = wp.SiLink;

    f_interface: gobject.TypeInterface,
    f_get_registration_info: ?*const fn (p_self: *wp.SiLink) callconv(.c) *glib.Variant,
    f_get_properties: ?*const fn (p_self: *wp.SiLink) callconv(.c) ?*wp.Properties,
    f_get_out_item: ?*const fn (p_self: *wp.SiLink) callconv(.c) *wp.SiLinkable,
    f_get_in_item: ?*const fn (p_self: *wp.SiLink) callconv(.c) *wp.SiLinkable,
    f__wp_padding: [4]*anyopaque,

    pub fn as(p_instance: *SiLinkInterface, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SiLinkableInterface = extern struct {
    pub const Instance = wp.SiLinkable;

    f_interface: gobject.TypeInterface,
    f_get_ports: ?*const fn (p_self: *wp.SiLinkable, p_context: ?[*:0]const u8) callconv(.c) *glib.Variant,
    f_get_acquisition: ?*const fn (p_self: *wp.SiLinkable) callconv(.c) ?*wp.SiAcquisition,
    f__wp_padding: [6]*anyopaque,

    pub fn as(p_instance: *SiLinkableInterface, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SimpleEventHookClass = extern struct {
    pub const Instance = wp.SimpleEventHook;

    f_parent_class: wp.InterestEventHookClass,

    pub fn as(p_instance: *SimpleEventHookClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SpaDeviceClass = extern struct {
    pub const Instance = wp.SpaDevice;

    f_parent_class: wp.ProxyClass,

    pub fn as(p_instance: *SpaDeviceClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SpaJson = opaque {
    /// Creates a spa json of type array.
    extern fn wp_spa_json_new_array(p_format: ?[*:0]const u8, ...) *wp.SpaJson;
    pub const newArray = wp_spa_json_new_array;

    /// This is the va_list version of `wp.SpaJson.newArray`.
    extern fn wp_spa_json_new_array_valist(p_format: ?[*:0]const u8, p_args: std.builtin.VaList) *wp.SpaJson;
    pub const newArrayValist = wp_spa_json_new_array_valist;

    /// Creates a spa json of type boolean.
    extern fn wp_spa_json_new_boolean(p_value: c_int) *wp.SpaJson;
    pub const newBoolean = wp_spa_json_new_boolean;

    /// Creates a spa json of type float.
    extern fn wp_spa_json_new_float(p_value: f32) *wp.SpaJson;
    pub const newFloat = wp_spa_json_new_float;

    /// Constructs a new WpSpaJson from a JSON string.
    extern fn wp_spa_json_new_from_string(p_json_str: [*:0]const u8) *wp.SpaJson;
    pub const newFromString = wp_spa_json_new_from_string;

    /// Constructs a new WpSpaJson from a JSON string with specific length.
    extern fn wp_spa_json_new_from_stringn(p_json_str: [*:0]const u8, p_len: usize) *wp.SpaJson;
    pub const newFromStringn = wp_spa_json_new_from_stringn;

    /// Creates a spa json of type int.
    extern fn wp_spa_json_new_int(p_value: c_int) *wp.SpaJson;
    pub const newInt = wp_spa_json_new_int;

    /// Creates a spa json of type NULL.
    extern fn wp_spa_json_new_null() *wp.SpaJson;
    pub const newNull = wp_spa_json_new_null;

    /// Creates a spa json of type object.
    extern fn wp_spa_json_new_object(p_key: ?[*:0]const u8, p_format: ?[*:0]const u8, ...) *wp.SpaJson;
    pub const newObject = wp_spa_json_new_object;

    /// This is the va_list version of `wp.SpaJson.newObject`.
    extern fn wp_spa_json_new_object_valist(p_key: ?[*:0]const u8, p_format: ?[*:0]const u8, p_args: std.builtin.VaList) *wp.SpaJson;
    pub const newObjectValist = wp_spa_json_new_object_valist;

    /// Creates a spa json of type string.
    extern fn wp_spa_json_new_string(p_value: [*:0]const u8) *wp.SpaJson;
    pub const newString = wp_spa_json_new_string;

    /// Constructs a new WpSpaJson that wraps the given spa_json.
    extern fn wp_spa_json_new_wrap(p_json: ?*anyopaque) *wp.SpaJson;
    pub const newWrap = wp_spa_json_new_wrap;

    /// Constructs a new WpSpaJson that wraps a JSON string.
    extern fn wp_spa_json_new_wrap_string(p_json_str: [*:0]const u8) *wp.SpaJson;
    pub const newWrapString = wp_spa_json_new_wrap_string;

    /// Constructs a new WpSpaJson that wraps a JSON string with specific length.
    extern fn wp_spa_json_new_wrap_stringn(p_json_str: [*:0]const u8, p_len: usize) *wp.SpaJson;
    pub const newWrapStringn = wp_spa_json_new_wrap_stringn;

    /// Copies a spa json object.
    extern fn wp_spa_json_copy(p_other: *SpaJson) *wp.SpaJson;
    pub const copy = wp_spa_json_copy;

    /// If `self` is not uniquely owned already, then it is unrefed and a copy of it is returned instead. You should always consider `self` as unsafe to use after this call and you should use the returned object instead.
    extern fn wp_spa_json_ensure_unique_owner(p_self: *SpaJson) *wp.SpaJson;
    pub const ensureUniqueOwner = wp_spa_json_ensure_unique_owner;

    /// Returns the json data.
    extern fn wp_spa_json_get_data(p_self: *const SpaJson) [*:0]const u8;
    pub const getData = wp_spa_json_get_data;

    /// Returns the json data size.
    extern fn wp_spa_json_get_size(p_self: *const SpaJson) usize;
    pub const getSize = wp_spa_json_get_size;

    /// Converts a WpSpaJson pointer to a struct spa_json one, for use with native pipewire & spa functions. The returned pointer is owned by WpSpaJson and may not be modified or freed.
    extern fn wp_spa_json_get_spa_json(p_self: *const SpaJson) ?*anyopaque;
    pub const getSpaJson = wp_spa_json_get_spa_json;

    /// Checks whether the spa json is of type array or not.
    extern fn wp_spa_json_is_array(p_self: *SpaJson) c_int;
    pub const isArray = wp_spa_json_is_array;

    /// Checks whether the spa json is of type boolean or not.
    extern fn wp_spa_json_is_boolean(p_self: *SpaJson) c_int;
    pub const isBoolean = wp_spa_json_is_boolean;

    /// Checks whether the spa json is of type container or not.
    extern fn wp_spa_json_is_container(p_self: *SpaJson) c_int;
    pub const isContainer = wp_spa_json_is_container;

    /// Checks whether the spa json is of type float or not.
    extern fn wp_spa_json_is_float(p_self: *SpaJson) c_int;
    pub const isFloat = wp_spa_json_is_float;

    /// Checks whether the spa json is of type int or not.
    extern fn wp_spa_json_is_int(p_self: *SpaJson) c_int;
    pub const isInt = wp_spa_json_is_int;

    /// Checks whether the spa json is of type null or not.
    extern fn wp_spa_json_is_null(p_self: *SpaJson) c_int;
    pub const isNull = wp_spa_json_is_null;

    /// Checks whether the spa json is of type object or not.
    extern fn wp_spa_json_is_object(p_self: *SpaJson) c_int;
    pub const isObject = wp_spa_json_is_object;

    /// Checks whether the spa json is of type string or not.
    extern fn wp_spa_json_is_string(p_self: *SpaJson) c_int;
    pub const isString = wp_spa_json_is_string;

    /// Checks if the json is the unique owner of its data or not.
    extern fn wp_spa_json_is_unique_owner(p_self: *SpaJson) c_int;
    pub const isUniqueOwner = wp_spa_json_is_unique_owner;

    /// Creates a new iterator for a spa json object.
    extern fn wp_spa_json_new_iterator(p_self: *SpaJson) *wp.Iterator;
    pub const newIterator = wp_spa_json_new_iterator;

    /// Parses the object property values of a spa json object.
    extern fn wp_spa_json_object_get(p_self: *SpaJson, ...) c_int;
    pub const objectGet = wp_spa_json_object_get;

    /// This is the va_list version of `wp.SpaJson.objectGet`.
    extern fn wp_spa_json_object_get_valist(p_self: *SpaJson, p_args: std.builtin.VaList) c_int;
    pub const objectGetValist = wp_spa_json_object_get_valist;

    /// Parses the array types and values of a spa json object.
    extern fn wp_spa_json_parse_array(p_self: *SpaJson, ...) c_int;
    pub const parseArray = wp_spa_json_parse_array;

    /// This is the va_list version of `wp.SpaJson.parseArray`.
    extern fn wp_spa_json_parse_array_valist(p_self: *SpaJson, p_args: std.builtin.VaList) c_int;
    pub const parseArrayValist = wp_spa_json_parse_array_valist;

    /// Parses the boolean value of a spa json object.
    extern fn wp_spa_json_parse_boolean(p_self: *SpaJson, p_value: *c_int) c_int;
    pub const parseBoolean = wp_spa_json_parse_boolean;

    /// Parses the float value of a spa json object.
    extern fn wp_spa_json_parse_float(p_self: *SpaJson, p_value: *f32) c_int;
    pub const parseFloat = wp_spa_json_parse_float;

    /// Parses the int value of a spa json object.
    extern fn wp_spa_json_parse_int(p_self: *SpaJson, p_value: *c_int) c_int;
    pub const parseInt = wp_spa_json_parse_int;

    /// Parses the object properties and values of a spa json object.
    extern fn wp_spa_json_parse_object(p_self: *SpaJson, ...) c_int;
    pub const parseObject = wp_spa_json_parse_object;

    /// This is the va_list version of `wp.SpaJson.parseObject`.
    extern fn wp_spa_json_parse_object_valist(p_self: *SpaJson, p_args: std.builtin.VaList) c_int;
    pub const parseObjectValist = wp_spa_json_parse_object_valist;

    /// Parses the string value of a spa json object.
    extern fn wp_spa_json_parse_string(p_self: *SpaJson) [*:0]u8;
    pub const parseString = wp_spa_json_parse_string;

    /// Increases the reference count of a spa json object.
    extern fn wp_spa_json_ref(p_self: *SpaJson) *wp.SpaJson;
    pub const ref = wp_spa_json_ref;

    /// Returns a newly allocated json string with length matching the size.
    extern fn wp_spa_json_to_string(p_self: *const SpaJson) [*:0]u8;
    pub const toString = wp_spa_json_to_string;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_spa_json_unref(p_self: *SpaJson) void;
    pub const unref = wp_spa_json_unref;

    extern fn wp_spa_json_get_type() usize;
    pub const getGObjectType = wp_spa_json_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SpaJsonBuilder = opaque {
    /// Creates a spa json builder of type array.
    extern fn wp_spa_json_builder_new_array() *wp.SpaJsonBuilder;
    pub const newArray = wp_spa_json_builder_new_array;

    /// Creates a spa json builder of type object.
    extern fn wp_spa_json_builder_new_object() *wp.SpaJsonBuilder;
    pub const newObject = wp_spa_json_builder_new_object;

    /// Adds values into the builder.
    extern fn wp_spa_json_builder_add(p_self: *SpaJsonBuilder, ...) void;
    pub const add = wp_spa_json_builder_add;

    /// Adds a boolean value into the builder.
    extern fn wp_spa_json_builder_add_boolean(p_self: *SpaJsonBuilder, p_value: c_int) void;
    pub const addBoolean = wp_spa_json_builder_add_boolean;

    /// Adds a float value into the builder.
    extern fn wp_spa_json_builder_add_float(p_self: *SpaJsonBuilder, p_value: f32) void;
    pub const addFloat = wp_spa_json_builder_add_float;

    /// Adds a json string into the builder.
    extern fn wp_spa_json_builder_add_from_string(p_self: *SpaJsonBuilder, p_json_str: [*:0]const u8) void;
    pub const addFromString = wp_spa_json_builder_add_from_string;

    /// Adds a json string with specific length into the builder.
    extern fn wp_spa_json_builder_add_from_stringn(p_self: *SpaJsonBuilder, p_json_str: [*:0]const u8, p_len: usize) void;
    pub const addFromStringn = wp_spa_json_builder_add_from_stringn;

    /// Adds a int value into the builder.
    extern fn wp_spa_json_builder_add_int(p_self: *SpaJsonBuilder, p_value: c_int) void;
    pub const addInt = wp_spa_json_builder_add_int;

    /// Adds a json value into the builder.
    extern fn wp_spa_json_builder_add_json(p_self: *SpaJsonBuilder, p_json: *wp.SpaJson) void;
    pub const addJson = wp_spa_json_builder_add_json;

    /// Adds a null value into the builder.
    extern fn wp_spa_json_builder_add_null(p_self: *SpaJsonBuilder) void;
    pub const addNull = wp_spa_json_builder_add_null;

    /// Adds a property into the builder.
    extern fn wp_spa_json_builder_add_property(p_self: *SpaJsonBuilder, p_key: [*:0]const u8) void;
    pub const addProperty = wp_spa_json_builder_add_property;

    /// Adds a string value into the builder.
    extern fn wp_spa_json_builder_add_string(p_self: *SpaJsonBuilder, p_value: [*:0]const u8) void;
    pub const addString = wp_spa_json_builder_add_string;

    /// This is the va_list version of `wp.SpaJsonBuilder.add`.
    extern fn wp_spa_json_builder_add_valist(p_self: *SpaJsonBuilder, p_args: std.builtin.VaList) void;
    pub const addValist = wp_spa_json_builder_add_valist;

    /// Ends the builder process and returns the constructed spa json object.
    extern fn wp_spa_json_builder_end(p_self: *SpaJsonBuilder) *wp.SpaJson;
    pub const end = wp_spa_json_builder_end;

    /// Increases the reference count of a spa json builder.
    extern fn wp_spa_json_builder_ref(p_self: *SpaJsonBuilder) *wp.SpaJsonBuilder;
    pub const ref = wp_spa_json_builder_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_spa_json_builder_unref(p_self: *SpaJsonBuilder) void;
    pub const unref = wp_spa_json_builder_unref;

    extern fn wp_spa_json_builder_get_type() usize;
    pub const getGObjectType = wp_spa_json_builder_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SpaJsonParser = opaque {
    /// Creates a spa json array parser. The `json` object must be valid for the entire life-cycle of the returned parser.
    extern fn wp_spa_json_parser_new_array(p_json: *wp.SpaJson) *wp.SpaJsonParser;
    pub const newArray = wp_spa_json_parser_new_array;

    /// Creates a spa json object parser. The `json` object must be valid for the entire life-cycle of the returned parser.
    extern fn wp_spa_json_parser_new_object(p_json: *wp.SpaJson) *wp.SpaJsonParser;
    pub const newObject = wp_spa_json_parser_new_object;

    /// Creates a new spa json parser for undefined type of data. The `json` object must be valid for the entire life-cycle of the returned parser.
    ///
    ///
    /// This function allows creating a parser object for any type of spa json and is mostly useful to parse non-standard JSON data that should be treated as if it were an object or array, but does not start with a '{' or '[' character. Such data can be for instance a comma-separated list of single values (array) or key-value pairs (object). Such data is also the main configuration file, which is an object but doesn't start with a '{' character.
    /// If the data is an array or object, the parser will not enter it and the only token it will be able to parse is the same `json` object that is passed in as an argument. Use `wp.SpaJsonParser.newArray` or `wp.SpaJsonParser.newObject` to parse arrays or objects.
    extern fn wp_spa_json_parser_new_undefined(p_json: *wp.SpaJson) *wp.SpaJsonParser;
    pub const newUndefined = wp_spa_json_parser_new_undefined;

    extern fn wp_spa_json_parser_end(p_self: *SpaJsonParser) void;
    pub const end = wp_spa_json_parser_end;

    /// Gets the values from a spa json parser object.
    extern fn wp_spa_json_parser_get(p_self: *SpaJsonParser, ...) c_int;
    pub const get = wp_spa_json_parser_get;

    /// Gets the boolean value from a spa json parser.
    extern fn wp_spa_json_parser_get_boolean(p_self: *SpaJsonParser, p_value: *c_int) c_int;
    pub const getBoolean = wp_spa_json_parser_get_boolean;

    /// Gets the float value from a spa json parser object.
    extern fn wp_spa_json_parser_get_float(p_self: *SpaJsonParser, p_value: *f32) c_int;
    pub const getFloat = wp_spa_json_parser_get_float;

    /// Gets the int value from a spa json parser object.
    extern fn wp_spa_json_parser_get_int(p_self: *SpaJsonParser, p_value: *c_int) c_int;
    pub const getInt = wp_spa_json_parser_get_int;

    /// Gets the spa json value from a spa json parser object.
    ///
    ///
    /// the returned spa json object references the original data instead of copying it, therefore the original data must be valid for the entire life-cycle of the returned object
    extern fn wp_spa_json_parser_get_json(p_self: *SpaJsonParser) *wp.SpaJson;
    pub const getJson = wp_spa_json_parser_get_json;

    /// Gets the null value from a spa json parser.
    extern fn wp_spa_json_parser_get_null(p_self: *SpaJsonParser) c_int;
    pub const getNull = wp_spa_json_parser_get_null;

    /// Gets the string value from a spa json parser object.
    extern fn wp_spa_json_parser_get_string(p_self: *SpaJsonParser) [*:0]u8;
    pub const getString = wp_spa_json_parser_get_string;

    /// This is the va_list version of `wp.SpaJsonParser.get`.
    extern fn wp_spa_json_parser_get_valist(p_self: *SpaJsonParser, p_args: std.builtin.VaList) c_int;
    pub const getValist = wp_spa_json_parser_get_valist;

    /// Increases the reference count of a spa json parser.
    extern fn wp_spa_json_parser_ref(p_self: *SpaJsonParser) *wp.SpaJsonParser;
    pub const ref = wp_spa_json_parser_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_spa_json_parser_unref(p_self: *SpaJsonParser) void;
    pub const unref = wp_spa_json_parser_unref;

    extern fn wp_spa_json_parser_get_type() usize;
    pub const getGObjectType = wp_spa_json_parser_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SpaPod = opaque {
    /// Creates a spa pod of type boolean.
    extern fn wp_spa_pod_new_boolean(p_value: c_int) *wp.SpaPod;
    pub const newBoolean = wp_spa_pod_new_boolean;

    /// Creates a spa pod of type bytes.
    extern fn wp_spa_pod_new_bytes(p_value: ?*const anyopaque, p_len: u32) *wp.SpaPod;
    pub const newBytes = wp_spa_pod_new_bytes;

    /// Creates a spa pod of type choice.
    extern fn wp_spa_pod_new_choice(p_choice_type: [*:0]const u8, ...) *wp.SpaPod;
    pub const newChoice = wp_spa_pod_new_choice;

    /// This is the va_list version of `wp.SpaPod.newChoice`.
    extern fn wp_spa_pod_new_choice_valist(p_choice_type: [*:0]const u8, p_args: std.builtin.VaList) *wp.SpaPod;
    pub const newChoiceValist = wp_spa_pod_new_choice_valist;

    /// Creates a spa pod of type double.
    extern fn wp_spa_pod_new_double(p_value: f64) *wp.SpaPod;
    pub const newDouble = wp_spa_pod_new_double;

    /// Creates a spa pod of type Fd.
    extern fn wp_spa_pod_new_fd(p_value: i64) *wp.SpaPod;
    pub const newFd = wp_spa_pod_new_fd;

    /// Creates a spa pod of type float.
    extern fn wp_spa_pod_new_float(p_value: f32) *wp.SpaPod;
    pub const newFloat = wp_spa_pod_new_float;

    /// Creates a spa pod of type fraction.
    extern fn wp_spa_pod_new_fraction(p_num: u32, p_denom: u32) *wp.SpaPod;
    pub const newFraction = wp_spa_pod_new_fraction;

    /// Creates a spa pod of type Id.
    extern fn wp_spa_pod_new_id(p_value: u32) *wp.SpaPod;
    pub const newId = wp_spa_pod_new_id;

    /// Creates a spa pod of type int.
    extern fn wp_spa_pod_new_int(p_value: i32) *wp.SpaPod;
    pub const newInt = wp_spa_pod_new_int;

    /// Creates a spa pod of type long.
    extern fn wp_spa_pod_new_long(p_value: i64) *wp.SpaPod;
    pub const newLong = wp_spa_pod_new_long;

    /// Creates a spa pod of type None.
    extern fn wp_spa_pod_new_none() *wp.SpaPod;
    pub const newNone = wp_spa_pod_new_none;

    /// Creates a spa pod of type object.
    extern fn wp_spa_pod_new_object(p_type_name: [*:0]const u8, p_id_name: [*:0]const u8, ...) *wp.SpaPod;
    pub const newObject = wp_spa_pod_new_object;

    /// This is the va_list version of `wp.SpaPod.newObject`.
    extern fn wp_spa_pod_new_object_valist(p_type_name: [*:0]const u8, p_id_name: [*:0]const u8, p_args: std.builtin.VaList) *wp.SpaPod;
    pub const newObjectValist = wp_spa_pod_new_object_valist;

    /// Creates a spa pod of type pointer.
    extern fn wp_spa_pod_new_pointer(p_type_name: [*:0]const u8, p_value: ?*const anyopaque) *wp.SpaPod;
    pub const newPointer = wp_spa_pod_new_pointer;

    /// Creates a spa pod of type rectangle.
    extern fn wp_spa_pod_new_rectangle(p_width: u32, p_height: u32) *wp.SpaPod;
    pub const newRectangle = wp_spa_pod_new_rectangle;

    /// Creates a spa pod of type sequence.
    extern fn wp_spa_pod_new_sequence(p_unit: c_uint, ...) *wp.SpaPod;
    pub const newSequence = wp_spa_pod_new_sequence;

    /// This is the va_list version of `wp.SpaPod.newSequence`.
    extern fn wp_spa_pod_new_sequence_valist(p_unit: c_uint, p_args: std.builtin.VaList) *wp.SpaPod;
    pub const newSequenceValist = wp_spa_pod_new_sequence_valist;

    /// Creates a spa pod of type string.
    extern fn wp_spa_pod_new_string(p_value: [*:0]const u8) *wp.SpaPod;
    pub const newString = wp_spa_pod_new_string;

    /// Constructs a new WpSpaPod that wraps the given spa_pod.
    extern fn wp_spa_pod_new_wrap(p_pod: ?*anyopaque) *wp.SpaPod;
    pub const newWrap = wp_spa_pod_new_wrap;

    /// Constructs a new immutable WpSpaPod that wraps the given spa_pod.
    extern fn wp_spa_pod_new_wrap_const(p_pod: ?*anyopaque) *wp.SpaPod;
    pub const newWrapConst = wp_spa_pod_new_wrap_const;

    /// Copies a spa pod object.
    extern fn wp_spa_pod_copy(p_other: *SpaPod) *wp.SpaPod;
    pub const copy = wp_spa_pod_copy;

    /// If `self` is not uniquely owned already, then it is unrefed and a copy of it is returned instead. You should always consider `self` as unsafe to use after this call and you should use the returned object instead.
    extern fn wp_spa_pod_ensure_unique_owner(p_self: *SpaPod) *wp.SpaPod;
    pub const ensureUniqueOwner = wp_spa_pod_ensure_unique_owner;

    /// Checks whether two spa pod objects have the same value or not.
    extern fn wp_spa_pod_equal(p_self: *SpaPod, p_pod: *wp.SpaPod) c_int;
    pub const equal = wp_spa_pod_equal;

    extern fn wp_spa_pod_filter(p_self: *SpaPod, p_filter: *wp.SpaPod) *wp.SpaPod;
    pub const filter = wp_spa_pod_filter;

    /// Fixates choices in an object pod so that they only have one value.
    extern fn wp_spa_pod_fixate(p_self: *SpaPod) c_int;
    pub const fixate = wp_spa_pod_fixate;

    /// Gets the child of a spa pod array object.
    extern fn wp_spa_pod_get_array_child(p_self: *SpaPod) *wp.SpaPod;
    pub const getArrayChild = wp_spa_pod_get_array_child;

    /// Gets the boolean value of a spa pod object.
    extern fn wp_spa_pod_get_boolean(p_self: *SpaPod, p_value: *c_int) c_int;
    pub const getBoolean = wp_spa_pod_get_boolean;

    /// Gets the bytes value and its len of a spa pod object.
    extern fn wp_spa_pod_get_bytes(p_self: *SpaPod, p_value: ?*anyopaque, p_len: *u32) c_int;
    pub const getBytes = wp_spa_pod_get_bytes;

    /// Gets the child of a spa pod choice object.
    extern fn wp_spa_pod_get_choice_child(p_self: *SpaPod) *wp.SpaPod;
    pub const getChoiceChild = wp_spa_pod_get_choice_child;

    /// If the pod is a Choice, this gets the choice type (Range, Step, Enum, ...).
    extern fn wp_spa_pod_get_choice_type(p_self: *SpaPod) wp.SpaIdValue;
    pub const getChoiceType = wp_spa_pod_get_choice_type;

    /// Gets the offset, type name and spa pod value of a spa pod control.
    extern fn wp_spa_pod_get_control(p_self: *SpaPod, p_offset: ?*u32, p_ctl_type: ?*[*:0]const u8, p_value: ?**wp.SpaPod) c_int;
    pub const getControl = wp_spa_pod_get_control;

    /// Gets the double value of a spa pod object.
    extern fn wp_spa_pod_get_double(p_self: *SpaPod, p_value: *f64) c_int;
    pub const getDouble = wp_spa_pod_get_double;

    /// Gets the Fd value of a spa pod object.
    extern fn wp_spa_pod_get_fd(p_self: *SpaPod, p_value: *i64) c_int;
    pub const getFd = wp_spa_pod_get_fd;

    /// Gets the float value of a spa pod object.
    extern fn wp_spa_pod_get_float(p_self: *SpaPod, p_value: *f32) c_int;
    pub const getFloat = wp_spa_pod_get_float;

    /// Gets the fractions's numerator and denominator value of a spa pod object.
    extern fn wp_spa_pod_get_fraction(p_self: *SpaPod, p_num: *u32, p_denom: *u32) c_int;
    pub const getFraction = wp_spa_pod_get_fraction;

    /// Gets the Id value of a spa pod object.
    extern fn wp_spa_pod_get_id(p_self: *SpaPod, p_value: *u32) c_int;
    pub const getId = wp_spa_pod_get_id;

    /// Gets the int value of a spa pod object.
    extern fn wp_spa_pod_get_int(p_self: *SpaPod, p_value: *i32) c_int;
    pub const getInt = wp_spa_pod_get_int;

    /// Gets the long value of a spa pod object.
    extern fn wp_spa_pod_get_long(p_self: *SpaPod, p_value: *i64) c_int;
    pub const getLong = wp_spa_pod_get_long;

    /// Gets the object properties values of a spa pod object.
    extern fn wp_spa_pod_get_object(p_self: *SpaPod, p_id_name: *[*:0]const u8, ...) c_int;
    pub const getObject = wp_spa_pod_get_object;

    /// This is the va_list version of `wp.SpaPod.getObject`.
    extern fn wp_spa_pod_get_object_valist(p_self: *SpaPod, p_id_name: *[*:0]const u8, p_args: std.builtin.VaList) c_int;
    pub const getObjectValist = wp_spa_pod_get_object_valist;

    /// Gets the pointer value and its type name of a spa pod object.
    extern fn wp_spa_pod_get_pointer(p_self: *SpaPod, p_value: ?*anyopaque) c_int;
    pub const getPointer = wp_spa_pod_get_pointer;

    /// Gets the name, flags and spa pod value of a spa pod property.
    extern fn wp_spa_pod_get_property(p_self: *SpaPod, p_key: ?*[*:0]const u8, p_value: ?**wp.SpaPod) c_int;
    pub const getProperty = wp_spa_pod_get_property;

    /// Gets the rectangle's width and height value of a spa pod object.
    extern fn wp_spa_pod_get_rectangle(p_self: *SpaPod, p_width: *u32, p_height: *u32) c_int;
    pub const getRectangle = wp_spa_pod_get_rectangle;

    /// Converts a WpSpaPod pointer to a struct spa_pod one, for use with native pipewire & spa functions. The returned pointer is owned by WpSpaPod and may not be modified or freed.
    extern fn wp_spa_pod_get_spa_pod(p_self: *const SpaPod) ?*anyopaque;
    pub const getSpaPod = wp_spa_pod_get_spa_pod;

    /// Gets the SPA type of the spa pod.
    ///
    ///
    /// If the pod is an object or pointer, this will return the derived object/pointer type directly. If the pod is an object property or a control, this will return the type of the contained value.
    extern fn wp_spa_pod_get_spa_type(p_self: *SpaPod) wp.SpaType;
    pub const getSpaType = wp_spa_pod_get_spa_type;

    /// Gets the string value of a spa pod object.
    extern fn wp_spa_pod_get_string(p_self: *SpaPod, p_value: *[*:0]const u8) c_int;
    pub const getString = wp_spa_pod_get_string;

    /// Gets the struct's values of a spa pod object.
    extern fn wp_spa_pod_get_struct(p_self: *SpaPod, ...) c_int;
    pub const getStruct = wp_spa_pod_get_struct;

    /// This is the va_list version of `wp.SpaPod.getStruct`.
    extern fn wp_spa_pod_get_struct_valist(p_self: *SpaPod, p_args: std.builtin.VaList) c_int;
    pub const getStructValist = wp_spa_pod_get_struct_valist;

    /// Checks whether the spa pod is of type array or not.
    extern fn wp_spa_pod_is_array(p_self: *SpaPod) c_int;
    pub const isArray = wp_spa_pod_is_array;

    /// Checks whether the spa pod is of type boolean or not.
    extern fn wp_spa_pod_is_boolean(p_self: *SpaPod) c_int;
    pub const isBoolean = wp_spa_pod_is_boolean;

    /// Checks whether the spa pod is of type bytes or not.
    extern fn wp_spa_pod_is_bytes(p_self: *SpaPod) c_int;
    pub const isBytes = wp_spa_pod_is_bytes;

    /// Checks whether the spa pod is of type choice or not.
    extern fn wp_spa_pod_is_choice(p_self: *SpaPod) c_int;
    pub const isChoice = wp_spa_pod_is_choice;

    /// Checks whether the spa pod is of type control or not.
    extern fn wp_spa_pod_is_control(p_self: *SpaPod) c_int;
    pub const isControl = wp_spa_pod_is_control;

    /// Checks whether the spa pod is of type double or not.
    extern fn wp_spa_pod_is_double(p_self: *SpaPod) c_int;
    pub const isDouble = wp_spa_pod_is_double;

    /// Checks whether the spa pod is of type Fd or not.
    extern fn wp_spa_pod_is_fd(p_self: *SpaPod) c_int;
    pub const isFd = wp_spa_pod_is_fd;

    /// Checks whether the spa pod is of type float or not.
    extern fn wp_spa_pod_is_float(p_self: *SpaPod) c_int;
    pub const isFloat = wp_spa_pod_is_float;

    /// Checks whether the spa pod is of type fraction or not.
    extern fn wp_spa_pod_is_fraction(p_self: *SpaPod) c_int;
    pub const isFraction = wp_spa_pod_is_fraction;

    /// Checks whether the spa pod is of type Id or not.
    extern fn wp_spa_pod_is_id(p_self: *SpaPod) c_int;
    pub const isId = wp_spa_pod_is_id;

    /// Checks whether the spa pod is of type int or not.
    extern fn wp_spa_pod_is_int(p_self: *SpaPod) c_int;
    pub const isInt = wp_spa_pod_is_int;

    /// Checks whether the spa pod is of type long or not.
    extern fn wp_spa_pod_is_long(p_self: *SpaPod) c_int;
    pub const isLong = wp_spa_pod_is_long;

    /// Checks whether the spa pod is of type none or not.
    extern fn wp_spa_pod_is_none(p_self: *SpaPod) c_int;
    pub const isNone = wp_spa_pod_is_none;

    /// Checks whether the spa pod is of type object or not.
    extern fn wp_spa_pod_is_object(p_self: *SpaPod) c_int;
    pub const isObject = wp_spa_pod_is_object;

    /// Checks whether the spa pod is of type pointer or not.
    extern fn wp_spa_pod_is_pointer(p_self: *SpaPod) c_int;
    pub const isPointer = wp_spa_pod_is_pointer;

    /// Checks whether the spa pod is of type property or not.
    extern fn wp_spa_pod_is_property(p_self: *SpaPod) c_int;
    pub const isProperty = wp_spa_pod_is_property;

    /// Checks whether the spa pod is of type rectangle or not.
    extern fn wp_spa_pod_is_rectangle(p_self: *SpaPod) c_int;
    pub const isRectangle = wp_spa_pod_is_rectangle;

    /// Checks whether the spa pod is of type sequence or not.
    extern fn wp_spa_pod_is_sequence(p_self: *SpaPod) c_int;
    pub const isSequence = wp_spa_pod_is_sequence;

    /// Checks whether the spa pod is of type string or not.
    extern fn wp_spa_pod_is_string(p_self: *SpaPod) c_int;
    pub const isString = wp_spa_pod_is_string;

    /// Checks whether the spa pod is of type struct or not.
    extern fn wp_spa_pod_is_struct(p_self: *SpaPod) c_int;
    pub const isStruct = wp_spa_pod_is_struct;

    /// Checks if the pod is the unique owner of its data or not.
    extern fn wp_spa_pod_is_unique_owner(p_self: *SpaPod) c_int;
    pub const isUniqueOwner = wp_spa_pod_is_unique_owner;

    /// Creates a new iterator for a spa pod object.
    extern fn wp_spa_pod_new_iterator(p_pod: *SpaPod) *wp.Iterator;
    pub const newIterator = wp_spa_pod_new_iterator;

    /// Increases the reference count of a spa pod object.
    extern fn wp_spa_pod_ref(p_self: *SpaPod) *wp.SpaPod;
    pub const ref = wp_spa_pod_ref;

    /// Sets a boolean value in the spa pod object.
    extern fn wp_spa_pod_set_boolean(p_self: *SpaPod, p_value: c_int) c_int;
    pub const setBoolean = wp_spa_pod_set_boolean;

    /// Sets a double value in the spa pod object.
    extern fn wp_spa_pod_set_double(p_self: *SpaPod, p_value: f64) c_int;
    pub const setDouble = wp_spa_pod_set_double;

    /// Sets a Fd value in the spa pod object.
    extern fn wp_spa_pod_set_fd(p_self: *SpaPod, p_value: i64) c_int;
    pub const setFd = wp_spa_pod_set_fd;

    /// Sets a float value in the spa pod object.
    extern fn wp_spa_pod_set_float(p_self: *SpaPod, p_value: f32) c_int;
    pub const setFloat = wp_spa_pod_set_float;

    /// Sets the numerator and denominator values of a fraction in the spa pod object.
    extern fn wp_spa_pod_set_fraction(p_self: *SpaPod, p_num: u32, p_denom: u32) c_int;
    pub const setFraction = wp_spa_pod_set_fraction;

    /// Sets an Id value in the spa pod object.
    extern fn wp_spa_pod_set_id(p_self: *SpaPod, p_value: u32) c_int;
    pub const setId = wp_spa_pod_set_id;

    /// Sets an int value in the spa pod object.
    extern fn wp_spa_pod_set_int(p_self: *SpaPod, p_value: i32) c_int;
    pub const setInt = wp_spa_pod_set_int;

    /// Sets a long value in the spa pod object.
    extern fn wp_spa_pod_set_long(p_self: *SpaPod, p_value: i64) c_int;
    pub const setLong = wp_spa_pod_set_long;

    /// Sets the value of a spa pod object in the current spa pod object. The spa pod objects must be of the same value.
    extern fn wp_spa_pod_set_pod(p_self: *SpaPod, p_pod: *wp.SpaPod) c_int;
    pub const setPod = wp_spa_pod_set_pod;

    /// Sets a pointer value with its type name in the spa pod object.
    extern fn wp_spa_pod_set_pointer(p_self: *SpaPod, p_type_name: [*:0]const u8, p_value: ?*const anyopaque) c_int;
    pub const setPointer = wp_spa_pod_set_pointer;

    /// Sets the width and height values of a rectangle in the spa pod object.
    extern fn wp_spa_pod_set_rectangle(p_self: *SpaPod, p_width: u32, p_height: u32) c_int;
    pub const setRectangle = wp_spa_pod_set_rectangle;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_spa_pod_unref(p_self: *SpaPod) void;
    pub const unref = wp_spa_pod_unref;

    extern fn wp_spa_pod_get_type() usize;
    pub const getGObjectType = wp_spa_pod_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SpaPodBuilder = opaque {
    /// Creates a spa pod builder of type array.
    extern fn wp_spa_pod_builder_new_array() *wp.SpaPodBuilder;
    pub const newArray = wp_spa_pod_builder_new_array;

    /// Creates a spa pod builder of type choice.
    extern fn wp_spa_pod_builder_new_choice(p_choice_type: [*:0]const u8) *wp.SpaPodBuilder;
    pub const newChoice = wp_spa_pod_builder_new_choice;

    /// Creates a spa pod builder of type object.
    extern fn wp_spa_pod_builder_new_object(p_type_name: [*:0]const u8, p_id_name: [*:0]const u8) *wp.SpaPodBuilder;
    pub const newObject = wp_spa_pod_builder_new_object;

    /// Creates a spa pod builder of type sequence.
    extern fn wp_spa_pod_builder_new_sequence(p_unit: c_uint) *wp.SpaPodBuilder;
    pub const newSequence = wp_spa_pod_builder_new_sequence;

    /// Creates a spa pod builder of type struct.
    extern fn wp_spa_pod_builder_new_struct() *wp.SpaPodBuilder;
    pub const newStruct = wp_spa_pod_builder_new_struct;

    /// Adds a list of values into the builder.
    extern fn wp_spa_pod_builder_add(p_self: *SpaPodBuilder, ...) void;
    pub const add = wp_spa_pod_builder_add;

    /// Adds a boolean value into the builder.
    extern fn wp_spa_pod_builder_add_boolean(p_self: *SpaPodBuilder, p_value: c_int) void;
    pub const addBoolean = wp_spa_pod_builder_add_boolean;

    /// Adds a bytes value with its length into the builder.
    extern fn wp_spa_pod_builder_add_bytes(p_self: *SpaPodBuilder, p_value: ?*const anyopaque, p_len: u32) void;
    pub const addBytes = wp_spa_pod_builder_add_bytes;

    /// Adds a control into the builder.
    extern fn wp_spa_pod_builder_add_control(p_self: *SpaPodBuilder, p_offset: u32, p_ctl_type: [*:0]const u8) void;
    pub const addControl = wp_spa_pod_builder_add_control;

    /// Adds a double value into the builder.
    extern fn wp_spa_pod_builder_add_double(p_self: *SpaPodBuilder, p_value: f64) void;
    pub const addDouble = wp_spa_pod_builder_add_double;

    /// Adds a Fd value into the builder.
    extern fn wp_spa_pod_builder_add_fd(p_self: *SpaPodBuilder, p_value: i64) void;
    pub const addFd = wp_spa_pod_builder_add_fd;

    /// Adds a float value into the builder.
    extern fn wp_spa_pod_builder_add_float(p_self: *SpaPodBuilder, p_value: f32) void;
    pub const addFloat = wp_spa_pod_builder_add_float;

    /// Adds the numerator and denominator values of a fraction into the builder.
    extern fn wp_spa_pod_builder_add_fraction(p_self: *SpaPodBuilder, p_num: u32, p_denom: u32) void;
    pub const addFraction = wp_spa_pod_builder_add_fraction;

    /// Adds a Id value into the builder.
    extern fn wp_spa_pod_builder_add_id(p_self: *SpaPodBuilder, p_value: u32) void;
    pub const addId = wp_spa_pod_builder_add_id;

    /// Adds a int value into the builder.
    extern fn wp_spa_pod_builder_add_int(p_self: *SpaPodBuilder, p_value: i32) void;
    pub const addInt = wp_spa_pod_builder_add_int;

    /// Adds a long value into the builder.
    extern fn wp_spa_pod_builder_add_long(p_self: *SpaPodBuilder, p_value: i64) void;
    pub const addLong = wp_spa_pod_builder_add_long;

    /// Adds a none value into the builder.
    extern fn wp_spa_pod_builder_add_none(p_self: *SpaPodBuilder) void;
    pub const addNone = wp_spa_pod_builder_add_none;

    /// Adds a pod value into the builder.
    extern fn wp_spa_pod_builder_add_pod(p_self: *SpaPodBuilder, p_pod: *wp.SpaPod) void;
    pub const addPod = wp_spa_pod_builder_add_pod;

    /// Adds a pointer value with its type name into the builder.
    extern fn wp_spa_pod_builder_add_pointer(p_self: *SpaPodBuilder, p_type_name: [*:0]const u8, p_value: ?*const anyopaque) void;
    pub const addPointer = wp_spa_pod_builder_add_pointer;

    /// Adds a property into the builder.
    extern fn wp_spa_pod_builder_add_property(p_self: *SpaPodBuilder, p_key: [*:0]const u8) void;
    pub const addProperty = wp_spa_pod_builder_add_property;

    /// Adds a property into the builder.
    extern fn wp_spa_pod_builder_add_property_id(p_self: *SpaPodBuilder, p_id: u32) void;
    pub const addPropertyId = wp_spa_pod_builder_add_property_id;

    /// Adds the width and height values of a rectangle into the builder.
    extern fn wp_spa_pod_builder_add_rectangle(p_self: *SpaPodBuilder, p_width: u32, p_height: u32) void;
    pub const addRectangle = wp_spa_pod_builder_add_rectangle;

    /// Adds a string value into the builder.
    extern fn wp_spa_pod_builder_add_string(p_self: *SpaPodBuilder, p_value: [*:0]const u8) void;
    pub const addString = wp_spa_pod_builder_add_string;

    /// Adds a list of values into the builder.
    extern fn wp_spa_pod_builder_add_valist(p_self: *SpaPodBuilder, p_args: std.builtin.VaList) void;
    pub const addValist = wp_spa_pod_builder_add_valist;

    /// Ends the builder process and returns the constructed spa pod object.
    extern fn wp_spa_pod_builder_end(p_self: *SpaPodBuilder) *wp.SpaPod;
    pub const end = wp_spa_pod_builder_end;

    /// Increases the reference count of a spa pod builder.
    extern fn wp_spa_pod_builder_ref(p_self: *SpaPodBuilder) *wp.SpaPodBuilder;
    pub const ref = wp_spa_pod_builder_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_spa_pod_builder_unref(p_self: *SpaPodBuilder) void;
    pub const unref = wp_spa_pod_builder_unref;

    extern fn wp_spa_pod_builder_get_type() usize;
    pub const getGObjectType = wp_spa_pod_builder_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SpaPodParser = opaque {
    /// Creates an object spa pod parser. The `pod` object must be valid for the entire life-cycle of the returned parser.
    extern fn wp_spa_pod_parser_new_object(p_pod: *wp.SpaPod, p_id_name: *[*:0]const u8) *wp.SpaPodParser;
    pub const newObject = wp_spa_pod_parser_new_object;

    /// Creates an struct spa pod parser. The `pod` object must be valid for the entire life-cycle of the returned parser.
    extern fn wp_spa_pod_parser_new_struct(p_pod: *wp.SpaPod) *wp.SpaPodParser;
    pub const newStruct = wp_spa_pod_parser_new_struct;

    /// Ends the parser process.
    extern fn wp_spa_pod_parser_end(p_self: *SpaPodParser) void;
    pub const end = wp_spa_pod_parser_end;

    /// Gets a list of values from a spa pod parser object.
    extern fn wp_spa_pod_parser_get(p_self: *SpaPodParser, ...) c_int;
    pub const get = wp_spa_pod_parser_get;

    /// Gets the boolean value from a spa pod parser.
    extern fn wp_spa_pod_parser_get_boolean(p_self: *SpaPodParser, p_value: *c_int) c_int;
    pub const getBoolean = wp_spa_pod_parser_get_boolean;

    /// Gets the bytes value and its length from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_bytes(p_self: *SpaPodParser, p_value: ?*anyopaque, p_len: *u32) c_int;
    pub const getBytes = wp_spa_pod_parser_get_bytes;

    /// Gets the double value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_double(p_self: *SpaPodParser, p_value: *f64) c_int;
    pub const getDouble = wp_spa_pod_parser_get_double;

    /// Gets the Fd value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_fd(p_self: *SpaPodParser, p_value: *i64) c_int;
    pub const getFd = wp_spa_pod_parser_get_fd;

    /// Gets the float value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_float(p_self: *SpaPodParser, p_value: *f32) c_int;
    pub const getFloat = wp_spa_pod_parser_get_float;

    /// Gets the fractions's numerator and denominator value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_fraction(p_self: *SpaPodParser, p_num: *u32, p_denom: *u32) c_int;
    pub const getFraction = wp_spa_pod_parser_get_fraction;

    /// Gets the Id value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_id(p_self: *SpaPodParser, p_value: *u32) c_int;
    pub const getId = wp_spa_pod_parser_get_id;

    /// Gets the int value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_int(p_self: *SpaPodParser, p_value: *i32) c_int;
    pub const getInt = wp_spa_pod_parser_get_int;

    /// Gets the long value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_long(p_self: *SpaPodParser, p_value: *i64) c_int;
    pub const getLong = wp_spa_pod_parser_get_long;

    /// Gets the spa pod value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_pod(p_self: *SpaPodParser) *wp.SpaPod;
    pub const getPod = wp_spa_pod_parser_get_pod;

    /// Gets the pointer value and its type name from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_pointer(p_self: *SpaPodParser, p_value: ?*anyopaque) c_int;
    pub const getPointer = wp_spa_pod_parser_get_pointer;

    /// Gets the rectangle's width and height value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_rectangle(p_self: *SpaPodParser, p_width: *u32, p_height: *u32) c_int;
    pub const getRectangle = wp_spa_pod_parser_get_rectangle;

    /// Gets the string value from a spa pod parser object.
    extern fn wp_spa_pod_parser_get_string(p_self: *SpaPodParser, p_value: *[*:0]const u8) c_int;
    pub const getString = wp_spa_pod_parser_get_string;

    /// This is the va_list version of `wp.SpaPodParser.get`.
    extern fn wp_spa_pod_parser_get_valist(p_self: *SpaPodParser, p_args: std.builtin.VaList) c_int;
    pub const getValist = wp_spa_pod_parser_get_valist;

    /// Increases the reference count of a spa pod parser.
    extern fn wp_spa_pod_parser_ref(p_self: *SpaPodParser) *wp.SpaPodParser;
    pub const ref = wp_spa_pod_parser_ref;

    /// Decreases the reference count on `self` and frees it when the ref count reaches zero.
    extern fn wp_spa_pod_parser_unref(p_self: *SpaPodParser) void;
    pub const unref = wp_spa_pod_parser_unref;

    extern fn wp_spa_pod_parser_get_type() usize;
    pub const getGObjectType = wp_spa_pod_parser_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const StateClass = extern struct {
    pub const Instance = wp.State;

    f_parent_class: gobject.ObjectClass,

    pub fn as(p_instance: *StateClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const TransitionClass = extern struct {
    pub const Instance = wp.Transition;

    f_parent_class: gobject.ObjectClass,
    f_get_next_step: ?*const fn (p_transition: *wp.Transition, p_step: c_uint) callconv(.c) c_uint,
    f_execute_step: ?*const fn (p_transition: *wp.Transition, p_step: c_uint) callconv(.c) void,
    f__wp_padding: [6]*anyopaque,

    pub fn as(p_instance: *TransitionClass, comptime P_T: type) *P_T {
        return gobject.ext.as(P_T, p_instance);
    }

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ConstraintType = enum(c_int) {
    none = 0,
    pw_global_property = 1,
    pw_property = 2,
    g_property = 3,
    _,

    extern fn wp_constraint_type_get_type() usize;
    pub const getGObjectType = wp_constraint_type_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ConstraintVerb = enum(c_int) {
    equals = 61,
    not_equals = 33,
    in_list = 99,
    in_range = 126,
    matches = 35,
    is_present = 43,
    is_absent = 45,
    _,

    extern fn wp_constraint_verb_get_type() usize;
    pub const getGObjectType = wp_constraint_verb_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const Direction = enum(c_int) {
    input = 0,
    output = 1,
    _,

    extern fn wp_direction_get_type() usize;
    pub const getGObjectType = wp_direction_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const LibraryErrorEnum = enum(c_int) {
    invariant = 0,
    invalid_argument = 1,
    operation_failed = 2,
    service_unavailable = 3,
    _,

    extern fn wp_library_error_enum_get_type() usize;
    pub const getGObjectType = wp_library_error_enum_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const LinkState = enum(c_int) {
    @"error" = -2,
    unlinked = -1,
    init = 0,
    negotiating = 1,
    allocating = 2,
    paused = 3,
    active = 4,
    _,

    extern fn wp_link_state_get_type() usize;
    pub const getGObjectType = wp_link_state_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const NodeState = enum(c_int) {
    @"error" = -1,
    creating = 0,
    suspended = 1,
    idle = 2,
    running = 3,
    _,

    extern fn wp_node_state_get_type() usize;
    pub const getGObjectType = wp_node_state_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SettingsSpecType = enum(c_int) {
    unknown = 0,
    bool = 1,
    int = 2,
    float = 3,
    string = 4,
    array = 5,
    object = 6,
    _,

    extern fn wp_settings_spec_type_get_type() usize;
    pub const getGObjectType = wp_settings_spec_type_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SiAdapterPortsState = enum(c_int) {
    none = 0,
    configuring = 1,
    configured = 2,
    _,

    extern fn wp_si_adapter_ports_state_get_type() usize;
    pub const getGObjectType = wp_si_adapter_ports_state_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const TransitionStep = enum(c_int) {
    none = 0,
    @"error" = 1,
    custom_start = 16,
    _,

    extern fn wp_transition_step_get_type() usize;
    pub const getGObjectType = wp_transition_step_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const BaseDirsFlags = packed struct(c_uint) {
    env_config: bool = false,
    env_data: bool = false,
    env_module: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    xdg_config_home: bool = false,
    xdg_data_home: bool = false,
    xdg_config_dirs: bool = false,
    build_sysconfdir: bool = false,
    xdg_data_dirs: bool = false,
    build_datadir: bool = false,
    build_libdir: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    flag_module: bool = false,
    flag_subdir_wireplumber: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_env_config: BaseDirsFlags = @bitCast(@as(c_uint, 1));
    pub const flags_env_data: BaseDirsFlags = @bitCast(@as(c_uint, 2));
    pub const flags_env_module: BaseDirsFlags = @bitCast(@as(c_uint, 4));
    pub const flags_xdg_config_home: BaseDirsFlags = @bitCast(@as(c_uint, 256));
    pub const flags_xdg_data_home: BaseDirsFlags = @bitCast(@as(c_uint, 512));
    pub const flags_xdg_config_dirs: BaseDirsFlags = @bitCast(@as(c_uint, 1024));
    pub const flags_build_sysconfdir: BaseDirsFlags = @bitCast(@as(c_uint, 2048));
    pub const flags_xdg_data_dirs: BaseDirsFlags = @bitCast(@as(c_uint, 4096));
    pub const flags_build_datadir: BaseDirsFlags = @bitCast(@as(c_uint, 8192));
    pub const flags_build_libdir: BaseDirsFlags = @bitCast(@as(c_uint, 16384));
    pub const flags_flag_module: BaseDirsFlags = @bitCast(@as(c_uint, 16777216));
    pub const flags_flag_subdir_wireplumber: BaseDirsFlags = @bitCast(@as(c_uint, 33554432));
    pub const flags_configuration: BaseDirsFlags = @bitCast(@as(c_uint, 33570049));
    pub const flags_data: BaseDirsFlags = @bitCast(@as(c_uint, 33567234));
    pub const flags_module: BaseDirsFlags = @bitCast(@as(c_uint, 50348036));
    extern fn wp_base_dirs_flags_get_type() usize;
    pub const getGObjectType = wp_base_dirs_flags_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const CoreFeatures = packed struct(c_uint) {
    connected: bool = false,
    components: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_connected: CoreFeatures = @bitCast(@as(c_uint, 1));
    pub const flags_components: CoreFeatures = @bitCast(@as(c_uint, 2));
    extern fn wp_core_features_get_type() usize;
    pub const getGObjectType = wp_core_features_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const InitFlags = packed struct(c_uint) {
    pipewire: bool = false,
    spa_types: bool = false,
    set_pw_log: bool = false,
    set_glib_log: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_pipewire: InitFlags = @bitCast(@as(c_uint, 1));
    pub const flags_spa_types: InitFlags = @bitCast(@as(c_uint, 2));
    pub const flags_set_pw_log: InitFlags = @bitCast(@as(c_uint, 4));
    pub const flags_set_glib_log: InitFlags = @bitCast(@as(c_uint, 8));
    pub const flags_all: InitFlags = @bitCast(@as(c_uint, 15));
    extern fn wp_init_flags_get_type() usize;
    pub const getGObjectType = wp_init_flags_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const InterestMatch = packed struct(c_uint) {
    gtype: bool = false,
    pw_global_properties: bool = false,
    pw_properties: bool = false,
    g_properties: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_none: InterestMatch = @bitCast(@as(c_uint, 0));
    pub const flags_gtype: InterestMatch = @bitCast(@as(c_uint, 1));
    pub const flags_pw_global_properties: InterestMatch = @bitCast(@as(c_uint, 2));
    pub const flags_pw_properties: InterestMatch = @bitCast(@as(c_uint, 4));
    pub const flags_g_properties: InterestMatch = @bitCast(@as(c_uint, 8));
    pub const flags_all: InterestMatch = @bitCast(@as(c_uint, 15));
    extern fn wp_interest_match_get_type() usize;
    pub const getGObjectType = wp_interest_match_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const InterestMatchFlags = packed struct(c_uint) {
    check_all: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_none: InterestMatchFlags = @bitCast(@as(c_uint, 0));
    pub const flags_check_all: InterestMatchFlags = @bitCast(@as(c_uint, 1));
    extern fn wp_interest_match_flags_get_type() usize;
    pub const getGObjectType = wp_interest_match_flags_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const LogTopicFlags = packed struct(c_uint) {
    _padding0: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    flag_static: bool = false,
    flag_initialized: bool = false,

    pub const flags_level_mask: LogTopicFlags = @bitCast(@as(c_uint, 65535));
    pub const flags_flag_static: LogTopicFlags = @bitCast(@as(c_uint, 1073741824));
    pub const flags_flag_initialized: LogTopicFlags = @bitCast(@as(c_uint, 2147483648));
    extern fn wp_log_topic_flags_get_type() usize;
    pub const getGObjectType = wp_log_topic_flags_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const MetadataFeatures = packed struct(c_uint) {
    _padding0: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    data: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_data: MetadataFeatures = @bitCast(@as(c_uint, 65536));
    extern fn wp_metadata_features_get_type() usize;
    pub const getGObjectType = wp_metadata_features_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const NodeFeatures = packed struct(c_uint) {
    _padding0: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    ports: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_ports: NodeFeatures = @bitCast(@as(c_uint, 65536));
    extern fn wp_node_features_get_type() usize;
    pub const getGObjectType = wp_node_features_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const PluginFeatures = packed struct(c_uint) {
    enabled: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_enabled: PluginFeatures = @bitCast(@as(c_uint, 1));
    extern fn wp_plugin_features_get_type() usize;
    pub const getGObjectType = wp_plugin_features_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const ProxyFeatures = packed struct(c_uint) {
    proxy_feature_bound: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    pipewire_object_feature_info: bool = false,
    pipewire_object_feature_param_props: bool = false,
    pipewire_object_feature_param_format: bool = false,
    pipewire_object_feature_param_profile: bool = false,
    pipewire_object_feature_param_port_config: bool = false,
    pipewire_object_feature_param_route: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_proxy_feature_bound: ProxyFeatures = @bitCast(@as(c_uint, 1));
    pub const flags_pipewire_object_feature_info: ProxyFeatures = @bitCast(@as(c_uint, 16));
    pub const flags_pipewire_object_feature_param_props: ProxyFeatures = @bitCast(@as(c_uint, 32));
    pub const flags_pipewire_object_feature_param_format: ProxyFeatures = @bitCast(@as(c_uint, 64));
    pub const flags_pipewire_object_feature_param_profile: ProxyFeatures = @bitCast(@as(c_uint, 128));
    pub const flags_pipewire_object_feature_param_port_config: ProxyFeatures = @bitCast(@as(c_uint, 256));
    pub const flags_pipewire_object_feature_param_route: ProxyFeatures = @bitCast(@as(c_uint, 512));
    pub const flags_pipewire_object_features_minimal: ProxyFeatures = @bitCast(@as(c_uint, 17));
    pub const flags_pipewire_object_features_all: ProxyFeatures = @bitCast(@as(c_uint, 1009));
    extern fn wp_proxy_features_get_type() usize;
    pub const getGObjectType = wp_proxy_features_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SessionItemFeatures = packed struct(c_uint) {
    active: bool = false,
    exported: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_active: SessionItemFeatures = @bitCast(@as(c_uint, 1));
    pub const flags_exported: SessionItemFeatures = @bitCast(@as(c_uint, 2));
    extern fn wp_session_item_features_get_type() usize;
    pub const getGObjectType = wp_session_item_features_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SettingsFeatures = packed struct(c_uint) {
    loaded: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    _padding16: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_loaded: SettingsFeatures = @bitCast(@as(c_uint, 1));
    extern fn wp_settings_features_get_type() usize;
    pub const getGObjectType = wp_settings_features_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

pub const SpaDeviceFeatures = packed struct(c_uint) {
    _padding0: bool = false,
    _padding1: bool = false,
    _padding2: bool = false,
    _padding3: bool = false,
    _padding4: bool = false,
    _padding5: bool = false,
    _padding6: bool = false,
    _padding7: bool = false,
    _padding8: bool = false,
    _padding9: bool = false,
    _padding10: bool = false,
    _padding11: bool = false,
    _padding12: bool = false,
    _padding13: bool = false,
    _padding14: bool = false,
    _padding15: bool = false,
    enabled: bool = false,
    _padding17: bool = false,
    _padding18: bool = false,
    _padding19: bool = false,
    _padding20: bool = false,
    _padding21: bool = false,
    _padding22: bool = false,
    _padding23: bool = false,
    _padding24: bool = false,
    _padding25: bool = false,
    _padding26: bool = false,
    _padding27: bool = false,
    _padding28: bool = false,
    _padding29: bool = false,
    _padding30: bool = false,
    _padding31: bool = false,

    pub const flags_enabled: SpaDeviceFeatures = @bitCast(@as(c_uint, 65536));
    extern fn wp_spa_device_features_get_type() usize;
    pub const getGObjectType = wp_spa_device_features_get_type;

    test {
        @setEvalBranchQuota(100_000);
        std.testing.refAllDecls(@This());
    }
};

/// Searches for `filename` in the hierarchy of directories specified by the `flags` parameter.
///
///
/// Returns the highest priority file found in the hierarchy of directories specified by the `flags` parameter. The `subdir` parameter is the name of the subdirectory to search in, inside the specified directories. If `subdir` is NULL, the base path of each directory is used.
/// The `filename` parameter is the name of the file to search for. If the file is found, its full path is returned. If the file is not found, NULL is returned. The file is considered found if it is a regular file.
/// If the `filename` is an absolute path, it is tested for existence and returned as is, ignoring the lookup directories in `flags` as well as the `subdir` parameter.
extern fn wp_base_dirs_find_file(p_flags: wp.BaseDirsFlags, p_subdir: ?[*:0]const u8, p_filename: [*:0]const u8) ?[*:0]u8;
pub const baseDirsFindFile = wp_base_dirs_find_file;

/// Creates an iterator to iterate over all files that match `suffix` within the `subdir` of the directories specified in `flags`.
///
///
/// The `subdir` parameter is the name of the subdirectory to search in, inside the directories specified by `flags`. If `subdir` is NULL, the base path of each directory is used. If `subdir` is an absolute path, files are only looked up in that directory and the directories in `flags` are ignored.
/// The `suffix` parameter is the filename suffix to match. If `suffix` is NULL, all files are matched.
/// The iterator will iterate over the absolute paths of all the files files found, in the order of priority of the directories, starting from the lowest priority directory (e.g. /usr/share/wireplumber) and ending with the highest priority directory (e.g. $XDG_CONFIG_HOME/wireplumber). Files within each directory are also sorted by filename.
extern fn wp_base_dirs_new_files_iterator(p_flags: wp.BaseDirsFlags, p_subdir: ?[*:0]const u8, p_suffix: ?[*:0]const u8) *wp.Iterator;
pub const baseDirsNewFilesIterator = wp_base_dirs_new_files_iterator;

extern fn wp_domain_library_quark() glib.Quark;
pub const domainLibraryQuark = wp_domain_library_quark;

/// Gets the WirePlumber library API version.
extern fn wp_get_library_api_version() [*:0]const u8;
pub const getLibraryApiVersion = wp_get_library_api_version;

/// Gets the WirePlumber library version.
extern fn wp_get_library_version() [*:0]const u8;
pub const getLibraryVersion = wp_get_library_version;

/// Initializes WirePlumber and PipeWire underneath.
///
///
/// `flags` can modify which parts are initialized, in cases where you want to handle part of this initialization externally.
extern fn wp_init(p_flags: wp.InitFlags) void;
pub const init = wp_init;

/// Matches the given properties against a set of rules described in JSON and calls the given callback to perform actions on a successful match.
///
///
/// The given JSON should be an array of objects, where each object has a "matches" and an "actions" property. The "matches" value should also be an array of objects, where each object is a set of properties to match. Inside such an object, all properties must match to consider a successful match. However, if multiple objects are provided, only one object needs to match.
/// The "actions" value should be an object where the key is the action name and the value can be any valid JSON. Both the action name and the value are passed as-is on the `callback`.
extern fn wp_json_utils_match_rules(p_json: *wp.SpaJson, p_match_props: *wp.Properties, p_callback: wp.RuleMatchCallback, p_data: ?*anyopaque, p_error: ?*?*glib.Error) c_int;
pub const jsonUtilsMatchRules = wp_json_utils_match_rules;

/// Matches the given properties against a set of rules described in JSON and updates the properties if the rule actions include the "update-props" action.
extern fn wp_json_utils_match_rules_update_properties(p_json: *wp.SpaJson, p_props: *wp.Properties) c_int;
pub const jsonUtilsMatchRulesUpdateProperties = wp_json_utils_match_rules_update_properties;

/// Merges two JSON containers (objects or arrays) into one.
///
///
/// If both `a` and `b` are objects, the result will be a new object containing all properties from both `a` and `b`. If a property exists in both `a` and `b`, the values are recursively merged. If a property exists in both `a` and `b` and the property name starts with the "override." prefix in either of those, the value from the key with the prefix is used.
/// If both `a` and `b` are arrays, the result will be a new array containing all elements from both `a` and `b`.
/// If `a` and `b` are not of the same type, NULL is returned.
extern fn wp_json_utils_merge_containers(p_a: *wp.SpaJson, p_b: *wp.SpaJson) *wp.SpaJson;
pub const jsonUtilsMergeContainers = wp_json_utils_merge_containers;

/// Used internally by the debug logging macros. Avoid using it directly.
extern fn wp_log_checked(p_log_topic: [*:0]const u8, p_log_level: glib.LogLevelFlags, p_file: [*:0]const u8, p_line: [*:0]const u8, p_func: [*:0]const u8, p_object_type: usize, p_object: ?*const anyopaque, p_message_format: [*:0]const u8, ...) void;
pub const logChecked = wp_log_checked;

/// private, called from `wp.init`
extern fn wp_log_init(p_flags: c_int) void;
pub const logInit = wp_log_init;

extern fn wp_log_set_level(p_log_level: [*:0]const u8) c_int;
pub const logSetLevel = wp_log_set_level;

/// WirePlumber's GLogWriterFunc.
///
///
/// This is installed automatically when you call `wp.init` with WP_INIT_SET_GLIB_LOG set in the flags
extern fn wp_log_writer_default(p_log_level: glib.LogLevelFlags, p_fields: *const glib.LogField, p_n_fields: usize, p_user_data: ?*anyopaque) glib.LogWriterOutput;
pub const logWriterDefault = wp_log_writer_default;

/// Used internally by the debug logging macros. Avoid using it directly.
///
///
/// This assumes that the arguments are correct and that the log_topic is enabled for the given log_level. No additional checks are performed.
extern fn wp_logt_checked(p_topic: *const wp.LogTopic, p_log_level: glib.LogLevelFlags, p_file: [*:0]const u8, p_line: [*:0]const u8, p_func: [*:0]const u8, p_object_type: usize, p_object: ?*const anyopaque, p_message_format: [*:0]const u8, ...) void;
pub const logtChecked = wp_logt_checked;

/// Gets the process information of a given PID.
extern fn wp_proc_utils_get_proc_info(p_pid: std.posix.pid_t) *wp.ProcInfo;
pub const procUtilsGetProcInfo = wp_proc_utils_get_proc_info;

/// Registers an additional WpSpaIdTable in the spa type system.
///
///
/// This is useful to add custom enumeration types.
/// Note that both `name` and `values` must be statically allocated, or otherwise guaranteed to be kept in memory until `wp.spaDynamicTypeDeinit` is called. No memory copy is done by this function.
extern fn wp_spa_dynamic_id_table_register(p_name: [*:0]const u8, p_values: ?*anyopaque) wp.SpaIdTable;
pub const spaDynamicIdTableRegister = wp_spa_dynamic_id_table_register;

/// Deinitializes the spa type registry.
///
///
/// You do not need to ever call this, unless you want to free memory at the end of the execution of a test, so that it doesn't show as leaked in the memory profiler.
extern fn wp_spa_dynamic_type_deinit() void;
pub const spaDynamicTypeDeinit = wp_spa_dynamic_type_deinit;

/// Initializes the spa dynamic type registry.
///
///
/// This allows registering new spa types at runtime. The spa type system still works if this function is not called.
/// Normally called by `wp.init` when WP_INIT_SPA_TYPES is passed in its flags.
extern fn wp_spa_dynamic_type_init() void;
pub const spaDynamicTypeInit = wp_spa_dynamic_type_init;

/// Registers an additional type in the spa type system.
///
///
/// This is useful to add a custom pod object type.
/// Note that both `name` and `values` must be statically allocated, or otherwise guaranteed to be kept in memory until `wp.spaDynamicTypeDeinit` is called. No memory copy is done by this function.
extern fn wp_spa_dynamic_type_register(p_name: [*:0]const u8, p_parent: wp.SpaType, p_values: ?*anyopaque) wp.SpaType;
pub const spaDynamicTypeRegister = wp_spa_dynamic_type_register;

/// Finds a value in an SPA Id table.
extern fn wp_spa_id_table_find_value(p_table: wp.SpaIdTable, p_value: c_uint) wp.SpaIdValue;
pub const spaIdTableFindValue = wp_spa_id_table_find_value;

/// Finds a named value in an SPA Id table.
extern fn wp_spa_id_table_find_value_from_name(p_table: wp.SpaIdTable, p_name: [*:0]const u8) wp.SpaIdValue;
pub const spaIdTableFindValueFromName = wp_spa_id_table_find_value_from_name;

/// Finds a short named value in an SPA Id table.
extern fn wp_spa_id_table_find_value_from_short_name(p_table: wp.SpaIdTable, p_short_name: [*:0]const u8) wp.SpaIdValue;
pub const spaIdTableFindValueFromShortName = wp_spa_id_table_find_value_from_short_name;

/// Finds a WpSpaIdTable given its name.
///
///
/// This name can either be the full type name of an object type, or the name of an enum (which is (!!) a type). For example, "Spa:Pod:Object:Param:Format" and "Spa:Enum:ParamId" are both valid table names.
extern fn wp_spa_id_table_from_name(p_name: [*:0]const u8) wp.SpaIdTable;
pub const spaIdTableFromName = wp_spa_id_table_from_name;

extern fn wp_spa_id_table_get_type() usize;
pub const spaIdTableGetType = wp_spa_id_table_get_type;

/// This function returns an iterator that allows you to iterate through the values associated with this table.
///
///
/// The items in the iterator are of type WpSpaIdValue.
extern fn wp_spa_id_table_new_iterator(p_table: wp.SpaIdTable) *wp.Iterator;
pub const spaIdTableNewIterator = wp_spa_id_table_new_iterator;

/// If the value type of `id` is SPA_TYPE_Array, this function returns the type that is allowed to be contained inside the array.
///
///
/// When the returned type is (or is derived from) SPA_TYPE_Id or SPA_TYPE_Object, `table` is set to point to the WpSpaIdTable that contains the possible Id values / object fields.
extern fn wp_spa_id_value_array_get_item_type(p_id: wp.SpaIdValue, p_table: ?*wp.SpaIdTable) wp.SpaType;
pub const spaIdValueArrayGetItemType = wp_spa_id_value_array_get_item_type;

/// Looks up an id value (enum, flag or object field) directly from its full name.
///
///
/// For instance, "Spa:Enum:Direction:Input" will resolve to the id value that represents "Input" in the "Spa:Enum:Direction" enum.
extern fn wp_spa_id_value_from_name(p_name: [*:0]const u8) wp.SpaIdValue;
pub const spaIdValueFromName = wp_spa_id_value_from_name;

/// Looks up an id value given its container `table_name` and its numeric representation, `id`.
extern fn wp_spa_id_value_from_number(p_table_name: [*:0]const u8, p_id: c_uint) wp.SpaIdValue;
pub const spaIdValueFromNumber = wp_spa_id_value_from_number;

/// Looks up an id value given its container `table_name` and its `short_name`.
extern fn wp_spa_id_value_from_short_name(p_table_name: [*:0]const u8, p_short_name: [*:0]const u8) wp.SpaIdValue;
pub const spaIdValueFromShortName = wp_spa_id_value_from_short_name;

extern fn wp_spa_id_value_get_type() usize;
pub const spaIdValueGetType = wp_spa_id_value_get_type;

/// Returns the value type associated with this WpSpaIdValue.
///
///
/// This information is useful when `id` represents an object field, which can take a value of an arbitrary type.
/// When the returned type is (or is derived from) SPA_TYPE_Id or SPA_TYPE_Object, `table` is set to point to the WpSpaIdTable that contains the possible Id values / object fields.
extern fn wp_spa_id_value_get_value_type(p_id: wp.SpaIdValue, p_table: ?*wp.SpaIdTable) wp.SpaType;
pub const spaIdValueGetValueType = wp_spa_id_value_get_value_type;

/// Gets the name of an id value.
extern fn wp_spa_id_value_name(p_id: wp.SpaIdValue) [*:0]const u8;
pub const spaIdValueName = wp_spa_id_value_name;

/// Gets the numeric value of an id value.
extern fn wp_spa_id_value_number(p_id: wp.SpaIdValue) c_uint;
pub const spaIdValueNumber = wp_spa_id_value_number;

/// Gets the short name of an id value.
extern fn wp_spa_id_value_short_name(p_id: wp.SpaIdValue) [*:0]const u8;
pub const spaIdValueShortName = wp_spa_id_value_short_name;

/// Gets WirePlumber's instance of spa_log.
extern fn wp_spa_log_get_instance() ?*anyopaque;
pub const spaLogGetInstance = wp_spa_log_get_instance;

pub const IteratorFoldFunc = *const fn (p_item: *const gobject.Value, p_ret: *gobject.Value, p_data: ?*anyopaque) callconv(.c) c_int;

pub const IteratorForeachFunc = *const fn (p_item: *const gobject.Value, p_data: ?*anyopaque) callconv(.c) void;

pub const RuleMatchCallback = *const fn (p_data: ?*anyopaque, p_action: [*:0]const u8, p_value: *wp.SpaJson, p_error: ?*?*glib.Error) callconv(.c) c_int;

pub const SettingsChangedCallback = *const fn (p_obj: *wp.Settings, p_setting: [*:0]const u8, p_value: *wp.SpaJson, p_user_data: ?*anyopaque) callconv(.c) void;

pub const ITERATOR_METHODS_VERSION = 0;
/// A custom GLib log level for trace messages (extension of GLogLevelFlags).
pub const LOG_LEVEL_TRACE = 256;
/// Special value that can be used to activate all the supported features in any given object.
pub const OBJECT_FEATURES_ALL = 4294967295;
pub const OBJECT_FORMAT = "<%s:%p>";
pub const SETTINGS_PERSISTENT_METADATA_NAME_PREFIX = "persistent-";
pub const SETTINGS_SCHEMA_METADATA_NAME_PREFIX = "schema-";
pub const SPA_TYPE_INVALID = 4294967295;

test {
    @setEvalBranchQuota(100_000);
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(ext);
}
