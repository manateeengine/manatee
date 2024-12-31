//! The Win32 Windows and Messages API
//! See: https://learn.microsoft.com/en-us/windows/win32/api/_winmsg/

const std = @import("std");

const c = @import("c.zig");
const lib_loader = @import("lib_loader.zig");

// Types

/// A callback function, which you define in your application, that processes messages sent to a
/// window.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nc-winuser-wndproc
pub const WndProc = *const fn (hwnd: c.Hwnd, msg: u32, wparam: c.Wparam, lparam: c.Lparam) callconv(c.winapi_callconv) c.Lresult;

// Constants

pub const cw_use_default = @as(i32, -2147483648);

// Enums

/// Controls how the window is to be shown.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
pub const ShowWindowCmd = enum(i32) {
    hide = 0,
    show_normal = 1,
    show_minimized = 2,
    show_maximized = 3,
    show_no_activate = 4,
    show = 5,
    minimize = 6,
    show_min_no_active = 7,
    show_na = 8,
    restore = 9,
    show_default = 10,
    force_minimize = 11,
};

/// Extended Window Styles
/// See: https://learn.microsoft.com/en-us/windows/win32/winmsg/extended-window-styles
pub const WindowExStyle = packed struct(u32) {
    const Self = @This();

    dlg_modal_frame_enabled: bool = false,
    _reserved_bit_1: u1 = 0,
    no_parent_notify_enabled: bool = false,
    topmost_enabled: bool = false,
    accept_files_enabled: bool = false,
    transparent_enabled: bool = false,
    mdi_child_enabled: bool = false,
    tool_window_enabled: bool = false,
    window_edge_enabled: bool = false,
    client_edge_enabled: bool = false,
    context_help_enabled: bool = false,
    _reserved_bit_11: u1 = 0,
    right_enabled: bool = false,
    rtl_reading_enabled: bool = false,
    left_scrollbar_enabled: bool = false,
    _reserved_bit_15: u1 = 0,
    control_parent_enabled: bool = false,
    static_edge_enabled: bool = false,
    app_window_enabled: bool = false,
    layered_enabled: bool = false,
    no_inherit_layout_enabled: bool = false,
    no_redirection_bitmap_enabled: bool = false,
    layout_rtl_enabled: bool = false,
    _reserved_bit_23: u1 = 0,
    _reserved_bit_24: u1 = 0,
    composited_enabled: bool = false,
    _reserved_bit_26: u1 = 0,
    no_activate_enabled: bool = false,
    _reserved_bit_28: u1 = 0,
    _reserved_bit_29: u1 = 0,
    _reserved_bit_30: u1 = 0,
    _reserved_bit_31: u1 = 0,

    /// The window accepts drag-drop files.
    pub const accept_files = Self{ .accept_files_enabled = true };
    /// Forces a top-level window onto the taskbar when the window is visible.
    pub const app_window = Self{ .app_window_enabled = true };
    /// The window has a border with a sunken edge.
    pub const client_edge = Self{ .client_edge_enabled = true };
    /// Paints all descendants of a window in bottom-to-top painting order using double-buffering.
    /// Bottom-to-top painting order allows a descendent window to have translucency (alpha) and
    /// transparency (color-key) effects, but only if the descendent window also has the
    /// `WindowExStyle.transparent` bit set. Double-buffering allows the window and its
    /// descendents to be painted without flicker. This cannot be used if the window has a class
    /// style of either CS_OWNDC or CS_CLASSDC.
    /// Windows 2000: This style is not supported.
    pub const composited = Self{ .composited_enabled = true };
    /// The title bar of the window includes a question mark. When the user clicks the question
    /// mark, the cursor changes to a question mark with a pointer. If the user then clicks a child
    /// window, the child receives a WM_HELP message. The child window should pass the message to
    /// the parent window procedure, which should call the WinHelp function using the
    /// HELP_WM_HELP command. The Help application displays a pop-up window that typically contains
    /// help for the child window.
    /// `context_help` cannot be used with the WS_MAXIMIZEBOX or WS_MINIMIZEBOX styles.
    pub const context_help = Self{ .context_help_enabled = true };
    /// The window itself contains child windows that should take part in dialog box navigation. If
    /// this style is specified, the dialog manager recurses into children of this window when
    /// performing navigation operations such as handling the TAB key, an arrow key, or a keyboard
    /// mnemonic.
    pub const control_parent = Self{ .control_parent_enabled = true };
    /// The window has a double border; the window can, optionally, be created with a title bar by
    /// specifying the WS_CAPTION style in the dwStyle parameter.
    pub const dlg_modal_frame = Self{ .dlg_modal_frame_enabled = true };
    /// The window is a layered window.
    pub const layered = Self{ .layered_enabled = true };
    /// If the shell language is Hebrew, Arabic, or another language that supports reading order
    /// alignment, the horizontal origin of the window is on the right edge.
    pub const layout_rtl = Self{ .layout_rtl_enabled = true };
    /// The window has generic left-aligned properties. This is the default.
    pub const left = Self{};
    /// If the shell language is Hebrew, Arabic, or another language that supports reading order
    /// alignment, the vertical scroll bar (if present) is to the left of the client area. For
    /// other languages, the style is ignored.
    pub const left_scrollbar = Self{ .left_scrollbar_enabled = true };
    /// The window text is displayed using left-to-right reading-order properties.
    pub const ltr_reading = Self{};
    /// The window is a MDI child window.
    pub const mdi_child = Self{ .mdi_child_enabled = true };
    /// A top-level window created with this style does not become the foreground window when the
    /// user clicks it.
    pub const no_activate = Self{ .no_activate_enabled = true };
    /// The window does not pass its window layout to its child windows.
    pub const no_inherit_layout = Self{ .no_inherit_layout_enabled = true };
    /// The child window created with this style does not send the WM_PARENTNOTIFY message to its
    /// parent window when it is created or destroyed.
    pub const no_parent_notify = Self{ .no_parent_notify_enabled = true };
    /// The window does not render to a redirection surface. This is for windows that do not have
    /// visible content or that use mechanisms other than surfaces to provide their visual.
    pub const no_redirection_bitmap = Self{ .no_redirection_bitmap_enabled = true };
    /// The window is an overlapped window.
    pub const overlapped_window = Self{ .client_edge_enabled = true, .window_edge_enabled = true };
    /// The window is palette window, which is a modeless dialog box that presents an array of
    /// commands.
    pub const palette_window = Self{ .window_edge_enabled = true, .tool_window_enabled = true, .topmost_enabled = true };
    /// The window has generic "right-aligned" properties. This depends on the window class. This
    /// style has an effect only if the shell language is Hebrew, Arabic, or another language that
    /// supports reading-order alignment; otherwise, the style is ignored.
    /// Using the `WindowExStyle.right` style for static or edit controls has the same effect as
    /// using the SS_RIGHT or ES_RIGHT style, respectively. Using this style with button controls
    /// has the same effect as using BS_RIGHT and BS_RIGHTBUTTON styles.
    pub const right = Self{ .right_enabled = true };
    /// The vertical scroll bar (if present) is to the right of the client area. This is the
    /// default.
    pub const right_scrollbar = Self{};
    /// If the shell language is Hebrew, Arabic, or another language that supports reading-order
    /// alignment, the window text is displayed using right-to-left reading-order properties. For
    /// other languages, the style is ignored.
    pub const rtl_reading = Self{ .rtl_reading_enabled = true };
    /// The window has a three-dimensional border style intended to be used for items that do not
    /// accept user input.
    pub const static_edge = Self{ .static_edge_enabled = true };
    /// The window is intended to be used as a floating toolbar. A tool window has a title bar that
    /// is shorter than a normal title bar, and the window title is drawn using a smaller font. A
    /// tool window does not appear in the taskbar or in the dialog that appears when the user
    /// presses ALT+TAB. If a tool window has a system menu, its icon is not displayed on the title
    /// bar. However, you can display the system menu by right-clicking or by typing ALT+SPACE.
    pub const tool_window = Self{ .tool_window_enabled = true };
    /// The window should be placed above all non-topmost windows and should stay above them, even
    /// when the window is deactivated. To add or remove this style, use the SetWindowPos function.
    pub const topmost = Self{ .topmost_enabled = true };
    /// The window should not be painted until siblings beneath the window (that were created by
    /// the same thread) have been painted. The window appears transparent because the bits of
    /// underlying sibling windows have already been painted.
    /// To achieve transparency without these restrictions, use the SetWindowRgn function.
    pub const transparent = Self{ .transparent_enabled = true };
    /// The window has a border with a raised edge.
    pub const window_edge = Self{ .window_edge_enabled = true };
};

/// Window Notifications
/// See: https://learn.microsoft.com/en-us/windows/win32/winmsg/window-notifications
pub const WindowNotification = enum(u32) {
    /// Sent when an application requests that a window be created by calling the createWindowEx
    /// or createWindow function.
    create = 1,
    /// Sent when a window is being destroyed. It is sent to the window procedure of the window
    /// being destroyed after the window is removed from the screen.
    destroy = 2,
};

pub const WindowStyle = packed struct(u32) {
    const Self = @This();

    _reserved_bit_0: u1 = 0,
    _reserved_bit_1: u1 = 0,
    _reserved_bit_2: u1 = 0,
    _reserved_bit_3: u1 = 0,
    _reserved_bit_4: u1 = 0,
    _reserved_bit_5: u1 = 0,
    _reserved_bit_6: u1 = 0,
    _reserved_bit_7: u1 = 0,
    _reserved_bit_8: u1 = 0,
    _reserved_bit_9: u1 = 0,
    _reserved_bit_10: u1 = 0,
    _reserved_bit_11: u1 = 0,
    _reserved_bit_12: u1 = 0,
    _reserved_bit_13: u1 = 0,
    _reserved_bit_14: u1 = 0,
    _reserved_bit_15: u1 = 0,
    tab_stop_maximize_box_enabled: bool = false,
    group_minimize_box_enabled: bool = false,
    thick_frame_size_box_enabled: bool = false,
    sys_menu_enabled: bool = false,
    h_scroll_enabled: bool = false,
    v_scroll_enabled: bool = false,
    dlg_frame_enabled: bool = false,
    border_enabled: bool = false,
    maximize_enabled: bool = false,
    clip_children_enabled: bool = false,
    clip_siblings_enabled: bool = false,
    disabled_enabled: bool = false,
    visible_enabled: bool = false,
    minimize_iconic_enabled: bool = false,
    child_child_window_enabled: bool = false,
    popup_enabled: bool = false,

    /// The window has a thin-line border
    pub const border = Self{ .border_enabled = true };
    /// The window has a title bar (includes the `WindowStyle.border` style).
    pub const caption = Self{};
    /// The window is a child window. A window with this style cannot have a menu bar. This style
    /// cannot be used with the `WindowStyle.popup` style.
    pub const child = Self{ .child_child_window_enabled = true };
    /// Same as the `WindowStyle.child_window` style.
    pub const child_window = Self{ .child_child_window_enabled = true };
    /// Excludes the area occupied by child windows when drawing occurs within the parent window.
    /// This style is used when creating the parent window.
    pub const clip_children = Self{ .clip_children_enabled = true };
    /// Clips child windows relative to each other; that is, when a particular child window
    /// receives a WM_PAINT message, the WS_CLIPSIBLINGS style clips all other overlapping child
    /// windows out of the region of the child window to be updated. If WS_CLIPSIBLINGS is not
    /// specified and child windows overlap, it is possible, when drawing within the client area of
    /// a child window, to draw within the client area of a neighboring child window.
    pub const clip_siblings = Self{ .clip_siblings_enabled = true };
    /// The window is initially disabled. A disabled window cannot receive input from the user. To
    /// change this after a window has been created, use the EnableWindow function.
    pub const disabled = Self{ .disabled_enabled = true };
    /// The window has a border of a style typically used with dialog boxes. A window with this
    /// style cannot have a title bar.
    pub const dlg_frame = Self{ .dlg_frame_enabled = true };
    /// The window is the first control of a group of controls. The group consists of this first
    /// control and all controls defined after it, up to the next control with the
    /// `WindowStyle.Group` style. The first control in each group usually has the
    /// `WindowStyle.tab_stop` style so that the user can move from group to group. The user can
    /// subsequently change the keyboard focus from one control in the group to the next control
    /// in the group by using the direction keys.
    /// You can turn this style on and off to change dialog box navigation. To change this style
    /// after a window has been created, use the SetWindowLong function.
    pub const group = Self{ .group_minimize_box_enabled = true };
    /// The window has a horizontal scroll bar.
    pub const h_scroll = Self{ .h_scroll_enabled = true };
    /// The window is initially minimized. Same as the WS_MINIMIZE style.
    pub const iconic = Self{ .minimize_iconic_enabled = true };
    /// The window has a maximize button. Cannot be combined with the `WindowExStyle.context_help`
    /// style. The `WindowStyle.sys_menu` style must also be specified.
    pub const maximize = Self{ .maximize_enabled = true };
    /// The window is initially minimized. Same as the `WindowStyle.iconic` style.
    pub const minimize = Self{ .minimize_iconic_enabled = true };
    /// The window has a minimize button. Cannot be combined with the `WindowExStyle.context_help`
    /// style. The `WindowStyle.sys_menu` style must also be specified.
    pub const minimize_box = Self{ .group_minimize_box_enabled = true };
    /// The window is an overlapped window. An overlapped window has a title bar and a border. Same
    /// as the WS_TILED style.
    pub const overlapped = Self{};
    /// The window is an overlapped window. Same as the `WindowStyle.tiled_window` style.
    pub const overlapped_window = Self{ .tab_stop_maximize_box_enabled = true, .group_minimize_box_enabled = true, .thick_frame_size_box_enabled = true, .sys_menu_enabled = true, .dlg_frame_enabled = true, .border_enabled = true };
    /// The window is a pop-up window. This style cannot be used with the `WindowStyle.child` style.
    pub const popup = Self{ .popup_enabled = true };
    /// The window is a pop-up window. The `WindowStyle.caption` and `WindowStyle.popup_window`
    /// styles must be combined to make the window menu visible.
    pub const popup_window = Self{ .popup_enabled = true, .border_enabled = true, .sys_menu_enabled = true };
    /// The window has a sizing border. Same as the `WindowStyle.thick_frame` style.
    pub const size_box = Self{ .thick_frame_size_box_enabled = true };
    /// The window has a window menu on its title bar. The `WindowStyle.caption` style must also be
    /// specified.
    pub const sys_menu = Self{ .sys_menu_enabled = true };
    /// The window is a control that can receive the keyboard focus when the user presses the TAB
    /// key. Pressing the TAB key changes the keyboard focus to the next control with the
    /// `WindowStyle.tab_stop` style.
    /// You can turn this style on and off to change dialog box navigation. To change this style
    /// after a window has been created, use the SetWindowLong function. For user-created windows
    /// and modeless dialogs to work with tab stops, alter the message loop to call the
    /// IsDialogMessage function.
    pub const tap_stop = Self{ .tab_stop_maximize_box_enabled = true };
    /// The window has a sizing border. Same as the `WindowStyle.size_box` style.
    pub const thick_frame = Self{ .thick_frame_size_box_enabled = true };
    /// The window is an overlapped window. An overlapped window has a title bar and a border. Same
    /// as the `WindowStyle.overlapped` style.
    pub const tiled = Self{};
    /// The window is an overlapped window. Same as the `WindowStyle.overlapped_window` style.
    pub const tiled_window = Self{ .tab_stop_maximize_box_enabled = true, .group_minimize_box_enabled = true, .thick_frame_size_box_enabled = true, .sys_menu_enabled = true, .dlg_frame_enabled = true, .border_enabled = true };
    /// The window is initially visible.
    /// This style can be turned on and off by using the ShowWindow or SetWindowPos function.
    pub const visible = Self{ .visible_enabled = true };
    /// The window has a vertical scroll bar.
    pub const v_scroll = Self{ .v_scroll_enabled = true };
};

/// Window Class Styles
/// See: https://learn.microsoft.com/en-us/windows/win32/winmsg/window-class-styles
pub const WndClassStyles = packed struct(u32) {
    const Self = @This();

    v_redraw_enabled: bool = false,
    h_redraw_enabled: bool = false,
    _reserved_bit_2: u1 = 0,
    dbl_clicks_enabled: bool = false,
    _reserved_bit_4: u1 = 0,
    own_dc_enabled: bool = false,
    class_dc_enabled: u1 = 0,
    parent_dc_enabled: bool = false,
    _reserved_bit_8: u1 = 0,
    no_close_enabled: bool = false,
    _reserved_bit_10: u1 = 0,
    save_bits_enabled: bool = false,
    byte_align_client_enabled: bool = false,
    byte_align_window_enabled: bool = false,
    global_class_enabled: bool = false,
    _reserved_bit_15: u1 = 0,
    ime_enabled: bool = false,
    drop_shadow_enabled: bool = false,
    _reserved_bit_18: u1 = 0,
    _reserved_bit_19: u1 = 0,
    _reserved_bit_20: u1 = 0,
    _reserved_bit_21: u1 = 0,
    _reserved_bit_22: u1 = 0,
    _reserved_bit_23: u1 = 0,
    _reserved_bit_24: u1 = 0,
    _reserved_bit_25: u1 = 0,
    _reserved_bit_26: u1 = 0,
    _reserved_bit_27: u1 = 0,
    _reserved_bit_28: u1 = 0,
    _reserved_bit_29: u1 = 0,
    _reserved_bit_30: u1 = 0,
    _reserved_bit_31: u1 = 0,

    /// Aligns the window's client area on a byte boundary (in the x direction). This style affects
    /// the width of the window and its horizontal placement on the display.
    pub const byte_align_client = Self{ .byte_align_client_enabled = true };
    /// Aligns the window on a byte boundary (in the x direction). This style affects the width of
    /// the window and its horizontal placement on the display.
    pub const byte_align_window = Self{ .byte_align_window_enabled = true };
    /// Allocates one device context to be shared by all windows in the class. Because window
    /// classes are process specific, it is possible for multiple threads of an application to
    /// create a window of the same class. It is also possible for the threads to attempt to use
    /// the device context simultaneously. When this happens, the system allows only one thread to
    /// successfully finish its drawing operation.
    pub const class_dc = Self{ .class_dc_enabled = true };
    /// Sends a double-click message to the window procedure when the user double-clicks the mouse
    /// while the cursor is within a window belonging to the class.
    pub const dbl_clicks = Self{ .dbl_clicks_enabled = true };
    /// Enables the drop shadow effect on a window. The effect is turned on and off through
    /// SPI_SETDROPSHADOW. Typically, this is enabled for small, short-lived windows such as menus
    /// to emphasize their Z-order relationship to other windows. Windows created from a class with
    /// this style must be top-level windows; they may not be child windows.
    pub const drop_shadow = Self{ .drop_shadow_enabled = true };
    /// Indicates that the window class is an application global class.
    pub const global_class = Self{ .global_class_enabled = true };
    /// Redraws the entire window if a movement or size adjustment changes the width of the client
    /// area.
    pub const h_redraw = Self{ .h_redraw_enabled = true };
    /// Disables Close on the window menu.
    pub const no_close = Self{ .no_close_enabled = true };
    /// Allocates a unique device context for each window in the class.
    pub const own_dc = Self{ .own_dc_enabled = true };
    /// Sets the clipping rectangle of the child window to that of the parent window so that the
    /// child can draw on the parent. A window with the `WndClassStyles.parent_dc` style bit
    /// receives a regular device context from the system's cache of device contexts. It does not
    /// give the child the parent's device context or device context settings. Specifying
    /// `WndClassStyles.parent_dc` enhances an application's performance.
    pub const parent_dc = Self{ .parent_dc_enabled = true };
    /// Saves, as a bitmap, the portion of the screen image obscured by a window of this class.
    /// When the window is removed, the system uses the saved bitmap to restore the screen image,
    /// including other windows that were obscured. Therefore, the system does not send WM_PAINT
    /// messages to windows that were obscured if the memory used by the bitmap has not been
    /// discarded and if other screen actions have not invalidated the stored image.
    /// This style is useful for small windows (for example, menus or dialog boxes) that are
    /// displayed briefly and then removed before other screen activity takes place. This style
    /// increases the time required to display the window, because the system must first allocate
    /// memory to store the bitmap.
    pub const save_bits = Self{ .save_bits_enabled = true };
    /// Redraws the entire window if a movement or size adjustment changes the height of the client
    /// area.
    pub const v_redraw = Self{ .v_redraw_enabled = true };
};

// Structs

/// Contains message information from a thread's message queue.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-msg
pub const Msg = extern struct {
    hwnd: ?c.Hwnd,
    message: WindowNotification,
    wparam: c.Wparam,
    lparam: c.Lparam,
    time: u32,
    pt: c.Point,
};

/// An idiomatic Zig convenience struct for creating and managing instances
pub const Hinstance = struct {
    const Self = @This();

    /// A pointer to the internal Hinstance value
    _value: c.Hinstance,

    pub fn init(module_name: ?[*:0]const u16) !Self {
        const value = lib_loader.getModuleHandleW(module_name);
        return Self{
            ._value = value,
        };
    }
};

/// An idiomatic Zig convenience struct for creating and managing windows
pub const Hwnd = struct {
    const Self = @This();

    /// A pointer to the internal Hwnd value
    _value: c.Hwnd,
    allocator: ?std.mem.Allocator,

    pub fn create(allocator: std.mem.Allocator, hwnd_create_info: WindowExWCreateInfo) !*Self {
        const hwnd = try allocator.create(Hwnd);
        errdefer allocator.destroy(hwnd);
        hwnd.* = try Hwnd.init(allocator, hwnd_create_info);
        return hwnd;
    }

    pub fn destroy(self: *Self) void {
        self.deinit();
        self.allocator.?.destroy(self);
    }

    pub fn init(allocator: ?std.mem.Allocator, hwnd_create_info: WindowExWCreateInfo) !Hwnd {
        var hinstance: ?c.Hinstance = null;
        if (hwnd_create_info.hinstance != null) {
            hinstance = hwnd_create_info.hinstance.?._value;
        }

        const value = createWindowExW(
            hwnd_create_info.style,
            hwnd_create_info.class_name,
            hwnd_create_info.window_name,
            hwnd_create_info.window_style,
            hwnd_create_info.x,
            hwnd_create_info.y,
            hwnd_create_info.width,
            hwnd_create_info.height,
            hwnd_create_info.hwnd_parent,
            hwnd_create_info.hmenu,
            hinstance,
            hwnd_create_info.param,
        );

        return Hwnd{
            ._value = value,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Hwnd) void {
        _ = destroyWindow(self._value);
    }

    pub fn show(self: *Hwnd, show_cmd: ShowWindowCmd) void {
        _ = showWindow(self._value, show_cmd);
    }
};

/// Contains window class information. It is used with the registerClassExW and getClassInfoExW
/// functions.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-wndclassexw
pub const WndClassExW = extern struct {
    const Self = @This();
    /// The size, in bytes, of this structure. Set this member to `@sizeOf(WndClassExW)`. Be sure
    /// to set this member before calling the getClassInfoEx function.
    cb_size: u32 = @sizeOf(Self),
    /// The class style(s). This member can be any combination of the `WindowClassStyles` enum.
    style: WndClassStyles,
    /// An optional pointer to the window procedure. You must use the callWindowProc function to
    /// call the window procedure.
    wnd_proc: ?WndProc = null,
    /// The number of extra bytes to allocate following the window-class structure. The system
    /// initializes the bytes to zero.
    cb_cls_extra: i32 = 0,
    /// The number of extra bytes to allocate following the window instance. The system initializes
    /// the bytes to zero. If an application uses WndClassEx to register a dialog box created by
    /// using the CLASS directive in the resource file, it must set this member to
    /// `dlg_window_extra`.
    cb_wnd_extra: i32 = 0,
    /// An optional handle to the instance that contains the window procedure for the class.
    hinstance: ?c.Hinstance = null,
    /// A handle to the class icon. This member must be a handle to an icon resource. If this
    /// member is null, the system provides a default icon.
    hicon: ?c.Hicon = null,
    /// A handle to the class cursor. This member must be a handle to a cursor resource. If this
    /// member is null, an application must explicitly set the cursor shape whenever the mouse
    /// moves into the application's window.
    hcursor: ?c.Hcursor = null,
    /// A handle to the class background brush. This member can be a handle to the brush to be used
    /// for painting the background, or it can be a color value. A color value must be one of the
    /// following standard system colors (the value 1 must be added to the chosen color).
    hbrush_background: ?c.Hbrush = null,
    /// Pointer to a null-terminated character string that specifies the resource name of the class
    /// menu, as the name appears in the resource file. If you use an integer to identify the menu,
    /// use the makeIntResource fn. If this member is null, windows belonging to this class have
    /// no default menu.
    menu_name: ?[*:0]const u16 = null,
    /// A pointer to a null-terminated string or is an atom. If this parameter is an atom, it must
    /// be a class atom created by a previous call to the registerClass or registerClassEx
    /// function. The atom must be in the low-order word of lpszClassName; the high-order word must
    /// be zero.
    class_name: ?[*:0]const u16 = null,
    /// A handle to a small icon that is associated with the window class. If this member is NULL,
    /// the system searches the icon resource specified by the hIcon member for an icon of the
    /// appropriate size to use as the small icon.
    hicon_sm: ?c.Hicon = null,

    pub fn register(self: *const Self) bool {
        return registerClassExW(self);
    }
};

/// Structure specifying parameters of a newly created extended Hwnd
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-createwindowexw
pub const WindowExWCreateInfo = struct {
    /// The extended window style of the window being created.
    style: WindowExStyle,
    /// A null-terminated string or a class atom.
    class_name: ?[*:0]const u16 = null,
    /// The window name.
    window_name: ?[*:0]const u16 = null,
    /// The style of the window being created.
    window_style: WindowStyle,
    /// The initial horizontal position of the window.
    x: i32 = cw_use_default,
    /// The initial vertical position of the window.
    y: i32 = cw_use_default,
    /// The width, in device units, of the window.
    width: i32 = cw_use_default,
    /// The height, in device units, of the window.
    height: i32 = cw_use_default,
    /// A handle to the parent or owner window of the window being created.
    hwnd_parent: ?c.Hwnd = null,
    /// A handle to a menu, or specifies a child-window identifier, depending on the window style.
    hmenu: ?c.Hmenu = null,
    /// A handle to the instance of the module to be associated with the window.
    hinstance: ?Hinstance = null,
    /// Pointer to a value to be passed to the window through the createStruct fn  pointed to by
    /// the `param` param of the WM_CREATE message.
    param: ?*const anyopaque = null,
};

// Functions

/// Creates an overlapped, pop-up, or child window with an extended window style; otherwise, this
/// function is identical to the CreateWindow function.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-createwindowexw
pub fn createWindowExW(style: WindowExStyle, class_name: ?[*:0]const u16, window_name: ?[*:0]const u16, window_style: WindowStyle, x: i32, y: i32, width: i32, height: i32, hwnd_parent: ?c.Hwnd, hmenu: ?c.Hmenu, hinstance: ?c.Hinstance, param: ?*const anyopaque) c.Hwnd {
    return CreateWindowExW(style, class_name, window_name, window_style, x, y, width, height, hwnd_parent, hmenu, hinstance, param);
}
extern "user32" fn CreateWindowExW(dwExStyle: WindowExStyle, lpClassName: ?[*:0]const u16, lpWindowName: ?[*:0]const u16, dwStyle: WindowStyle, X: i32, Y: i32, nWidth: i32, nHeight: i32, hWndParent: ?c.Hwnd, hMenu: ?c.Hmenu, hInstance: ?c.Hinstance, lpParam: ?*const anyopaque) callconv(c.winapi_callconv) c.Hwnd;

/// Retrieves a message from the calling thread's message queue.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getmessagew
pub fn getMessageW(msg: ?*Msg, hwnd: ?c.Hwnd, msg_filter_min: u32, msg_filter_max: u32) bool {
    return GetMessageW(msg, hwnd, msg_filter_min, msg_filter_max);
}
extern "user32" fn GetMessageW(lpMsg: ?*Msg, hWnd: ?c.Hwnd, wMsgFilterMin: u32, wMsgFilterMax: u32) callconv(c.winapi_callconv) bool;

/// Calls the default window procedure to provide default processing for any window messages that
/// an application does not process.
/// https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-defwindowprocw
pub fn defWindowProcW(hwnd: c.Hwnd, msg: u32, wparam: c.Wparam, lparam: c.Lparam) c.Lresult {
    return DefWindowProcW(hwnd, msg, wparam, lparam);
}
extern "user32" fn DefWindowProcW(hwnd: c.Hwnd, Msg: u32, wParam: c.Wparam, lParam: c.Lparam) c.Lresult;

/// Destroys the specified window.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-destroywindow
pub fn destroyWindow(hwnd: c.Hwnd) bool {
    return DestroyWindow(hwnd);
}
extern "user32" fn DestroyWindow(hwnd: c.Hwnd) callconv(c.winapi_callconv) bool;

/// Dispatches a message to a window procedure.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-dispatchmessagew
pub fn dispatchMessageW(msg: ?*Msg) c.Lresult {
    return DispatchMessageW(msg);
}
extern "user32" fn DispatchMessageW(lpMsg: ?*Msg) callconv(c.winapi_callconv) c.Lresult;

/// Indicates to the system that a thread has made a request to terminate (quit).
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-postquitmessage
pub fn postQuitMessage(exit_code: i32) void {
    return PostQuitMessage(exit_code);
}
extern "user32" fn PostQuitMessage(nExitCode: i32) callconv(c.winapi_callconv) void;

/// Registers a window class for subsequent use in calls to the CreateWindow or CreateWindowEx
/// function.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registerclassexw
pub fn registerClassExW(wnd_class_ex_w: *const WndClassExW) bool {
    return RegisterClassExW(wnd_class_ex_w);
}
extern "user32" fn RegisterClassExW(unnamedParam1: *const WndClassExW) callconv(c.winapi_callconv) bool;

pub fn showWindow(hwnd: c.Hwnd, show_cmd: ShowWindowCmd) bool {
    return ShowWindow(hwnd, @intFromEnum(show_cmd));
}
extern "user32" fn ShowWindow(hwnd: c.Hwnd, nCmdShow: i32) callconv(c.winapi_callconv) bool;

/// Translates virtual-key messages into character messages.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-translatemessage
pub fn translateMessage(msg: ?*Msg) c.Lresult {
    return TranslateMessage(msg);
}
extern "user32" fn TranslateMessage(lpMsg: ?*Msg) callconv(c.winapi_callconv) c.Lresult;
