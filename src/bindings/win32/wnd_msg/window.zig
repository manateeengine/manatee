const std = @import("std");

const Brush = @import("brush.zig").Brush;
const Cursor = @import("cursor.zig").Cursor;
const Icon = @import("icon.zig").Icon;
const Instance = @import("instance.zig").Instance;
const Menu = @import("menu.zig").Menu;

/// An opaque handle to a window object.
/// Original: `HWND`
/// See: https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
pub const Window = opaque {
    const Self = @This();

    /// TODO: Figure out how I want to document manatee-specific init functions
    pub fn init(extended_style: WindowStyleEx, class_name: ?[*:0]const u16, window_name: ?[*:0]const u16, style: WindowStyle, x: i32, y: i32, width: i32, height: i32, parent_window: ?*Window, menu: ?*Menu, instance: ?*Instance, param: ?*const anyopaque) *Self {
        return createWindowExW(extended_style, class_name, window_name, style, x, y, width, height, parent_window, menu, instance, param);
    }

    /// TODO: Figure out how I want to document manatee-specific deinit functions
    pub fn deinit(self: *Self) void {
        _ = destroyWindow(self);
    }

    /// Creates an overlapped, pop-up, or child window with an extended window style.
    /// Original: `CreateWindowExW`
    /// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-createwindowexw
    pub fn createWindowExW(extended_style: WindowStyleEx, class_name: ?[*:0]const u16, window_name: ?[*:0]const u16, style: WindowStyle, x: i32, y: i32, width: i32, height: i32, parent_window: ?*Window, menu: ?*Menu, instance: ?*Instance, param: ?*const anyopaque) *Self {
        return CreateWindowExW(extended_style, class_name, window_name, style, x, y, width, height, parent_window, menu, instance, param);
    }

    /// Calls the default window procedure to provide default processing for any window messages that
    /// an application does not process.
    /// Original: DefWindowProcW
    /// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-defwindowprocw
    pub fn defaultWindowProcedureW(self: *Self, message: u32, w_param: usize, l_param: isize) isize {
        return DefWindowProcW(self, message, w_param, l_param);
    }

    /// Destroys the specified window.
    /// Original: `DestroyWindow`
    /// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-destroywindow
    pub fn destroyWindow(self: *Self) bool {
        return DestroyWindow(self);
    }

    /// Indicates to the system that a thread has made a request to terminate (quit).
    /// Original: `PostQuitMessage'
    /// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-postquitmessage
    pub fn postQuitMessage(self: *Self, exit_code: i32) void {
        _ = self;
        return PostQuitMessage(exit_code);
    }

    /// Sets the specified window's show state.
    /// Original: `ShowWindow`
    /// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
    pub fn showWindow(self: *Self, show_command: ShowWindowCmd) void {
        _ = ShowWindow(self, @intFromEnum(show_command));
    }
};

/// A callback function, which you define in your application, that processes messages sent to a
/// window.
/// Original: `WndProc`
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nc-winuser-wndproc
pub const WindowProcedureFn = *const fn (hwnd: *Window, msg: u32, wparam: usize, lparam: isize) callconv(std.builtin.CallingConvention.winapi) isize;

pub const cw_use_default = @as(i32, -2147483648);

/// Controls how the window is to be shown.
/// Original: `int nCmdShow`
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

/// Contains window class information. It is used with the registerClassExW and getClassInfoExW
/// functions.
/// See: https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-wndclassexw
pub const WindowClassExW = extern struct {
    const Self = @This();
    /// The size, in bytes, of this structure.
    cb_size: u32 = @sizeOf(Self),
    /// The class style(s). This member can be any combination of the `WindowClassStyles` enum.
    style: WindowClassStyles,
    /// A pointer to the window procedure.
    wnd_proc: WindowProcedureFn,
    /// The number of extra bytes to allocate following the window-class structure.
    cb_cls_extra: i32 = 0,
    /// The number of extra bytes to allocate following the window instance.
    cb_wnd_extra: i32 = 0,
    /// The handle to the instance that contains the window procedure for the class.
    hinstance: *Instance,
    /// A handle to the class icon.
    hicon: ?*Icon = null,
    /// A handle to the class cursor.
    hcursor: ?*Cursor = null,
    /// A handle to the class background brush.
    hbrush_background: ?*Brush = null,
    /// Pointer to a null-terminated character string that specifies the resource name of the class
    /// menu, as the name appears in the resource file.
    menu_name: ?[*:0]const u16 = null,
    /// A pointer to a null-terminated string or is an atom.
    class_name: ?[*:0]const u16 = null,
    /// A handle to a small icon that is associated with the window class.
    hicon_sm: ?*Icon = null,

    pub fn registerClass(self: *const Self) void {
        _ = RegisterClassExW(self);
    }
};

/// Window Class Styles
/// See: https://learn.microsoft.com/en-us/windows/win32/winmsg/window-class-styles
pub const WindowClassStyles = packed struct(u32) {
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

    /// Aligns the window's client area on a byte boundary (in the x direction).
    pub const byte_align_client = Self{ .byte_align_client_enabled = true };
    /// Aligns the window on a byte boundary (in the x direction).
    pub const byte_align_window = Self{ .byte_align_window_enabled = true };
    /// Allocates one device context to be shared by all windows in the class.
    pub const class_dc = Self{ .class_dc_enabled = true };
    /// Sends a double-click message to the window procedure when the user double-clicks the mouse
    /// while the cursor is within a window belonging to the class.
    pub const dbl_clicks = Self{ .dbl_clicks_enabled = true };
    /// Enables the drop shadow effect on a window.
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
    /// child can draw on the parent.
    pub const parent_dc = Self{ .parent_dc_enabled = true };
    /// Saves, as a bitmap, the portion of the screen image obscured by a window of this class.
    pub const save_bits = Self{ .save_bits_enabled = true };
    /// Redraws the entire window if a movement or size adjustment changes the height of the client
    /// area.
    pub const v_redraw = Self{ .v_redraw_enabled = true };
};

/// Window Styles
/// Original: `DWORD dwStyle`
/// See: https://learn.microsoft.com/en-us/windows/win32/winmsg/window-styles
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
    /// The window is a child window.
    pub const child = Self{ .child_child_window_enabled = true };
    /// Same as the `WindowStyle.child_window` style.
    pub const child_window = Self{ .child_child_window_enabled = true };
    /// Excludes the area occupied by child windows when drawing occurs within the parent window.
    pub const clip_children = Self{ .clip_children_enabled = true };
    /// Clips child windows relative to each other.
    pub const clip_siblings = Self{ .clip_siblings_enabled = true };
    /// The window is initially disabled.
    pub const disabled = Self{ .disabled_enabled = true };
    /// The window has a border of a style typically used with dialog boxes.
    pub const dlg_frame = Self{ .dlg_frame_enabled = true };
    /// The window is the first control of a group of controls.
    pub const group = Self{ .group_minimize_box_enabled = true };
    /// The window has a horizontal scroll bar.
    pub const h_scroll = Self{ .h_scroll_enabled = true };
    /// The window is initially minimized.
    pub const iconic = Self{ .minimize_iconic_enabled = true };
    /// The window has a maximize button.
    pub const maximize = Self{ .maximize_enabled = true };
    /// The window is initially minimized.
    pub const minimize = Self{ .minimize_iconic_enabled = true };
    /// The window has a minimize button.
    pub const minimize_box = Self{ .group_minimize_box_enabled = true };
    /// The window is an overlapped window.
    pub const overlapped = Self{};
    /// The window is an overlapped window.
    pub const overlapped_window = Self{ .tab_stop_maximize_box_enabled = true, .group_minimize_box_enabled = true, .thick_frame_size_box_enabled = true, .sys_menu_enabled = true, .dlg_frame_enabled = true, .border_enabled = true };
    /// The window is a pop-up window.
    pub const popup = Self{ .popup_enabled = true };
    /// The window is a pop-up window.
    pub const popup_window = Self{ .popup_enabled = true, .border_enabled = true, .sys_menu_enabled = true };
    /// The window has a sizing border.
    pub const size_box = Self{ .thick_frame_size_box_enabled = true };
    /// The window has a window menu on its title bar.
    pub const sys_menu = Self{ .sys_menu_enabled = true };
    /// The window is a control that can receive the keyboard focus when the user presses the TAB
    /// key.
    pub const tap_stop = Self{ .tab_stop_maximize_box_enabled = true };
    /// The window has a sizing border.
    pub const thick_frame = Self{ .thick_frame_size_box_enabled = true };
    /// The window is an overlapped window.
    pub const tiled = Self{};
    /// The window is an overlapped window.
    pub const tiled_window = Self{ .tab_stop_maximize_box_enabled = true, .group_minimize_box_enabled = true, .thick_frame_size_box_enabled = true, .sys_menu_enabled = true, .dlg_frame_enabled = true, .border_enabled = true };
    /// The window is initially visible.
    pub const visible = Self{ .visible_enabled = true };
    /// The window has a vertical scroll bar.
    pub const v_scroll = Self{ .v_scroll_enabled = true };
};

/// Extended Window Styles
/// Original: `DWORD dwExStyle`
/// See: https://learn.microsoft.com/en-us/windows/win32/winmsg/extended-window-styles
pub const WindowStyleEx = packed struct(u32) {
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
    pub const composited = Self{ .composited_enabled = true };
    /// The title bar of the window includes a question mark.
    pub const context_help = Self{ .context_help_enabled = true };
    /// The window itself contains child windows that should take part in dialog box navigation.
    pub const control_parent = Self{ .control_parent_enabled = true };
    /// The window has a double border.
    pub const dlg_modal_frame = Self{ .dlg_modal_frame_enabled = true };
    /// The window is a layered window.
    pub const layered = Self{ .layered_enabled = true };
    /// If the shell language is Hebrew, Arabic, or another language that supports reading order
    /// alignment, the horizontal origin of the window is on the right edge.
    pub const layout_rtl = Self{ .layout_rtl_enabled = true };
    /// The window has generic left-aligned properties.
    pub const left = Self{};
    /// If the shell language is Hebrew, Arabic, or another language that supports reading order
    /// alignment, the vertical scroll bar (if present) is to the left of the client area.
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
    /// The window does not render to a redirection surface.
    pub const no_redirection_bitmap = Self{ .no_redirection_bitmap_enabled = true };
    /// The window is an overlapped window.
    pub const overlapped_window = Self{ .client_edge_enabled = true, .window_edge_enabled = true };
    /// The window is palette window, which is a modeless dialog box that presents an array of
    /// commands.
    pub const palette_window = Self{ .window_edge_enabled = true, .tool_window_enabled = true, .topmost_enabled = true };
    /// The window has generic "right-aligned" properties.
    pub const right = Self{ .right_enabled = true };
    /// The vertical scroll bar (if present) is to the right of the client area.
    pub const right_scrollbar = Self{};
    /// If the shell language is Hebrew, Arabic, or another language that supports reading-order
    /// alignment, the window text is displayed using right-to-left reading-order properties.
    pub const rtl_reading = Self{ .rtl_reading_enabled = true };
    /// The window has a three-dimensional border style intended to be used for items that do not
    /// accept user input.
    pub const static_edge = Self{ .static_edge_enabled = true };
    /// The window is intended to be used as a floating toolbar.
    pub const tool_window = Self{ .tool_window_enabled = true };
    /// The window should be placed above all non-topmost windows and should stay above them, even
    /// when the window is deactivated.
    pub const topmost = Self{ .topmost_enabled = true };
    /// The window should not be painted until siblings beneath the window (that were created by
    /// the same thread) have been painted.
    pub const transparent = Self{ .transparent_enabled = true };
    /// The window has a border with a raised edge.
    pub const window_edge = Self{ .window_edge_enabled = true };
};

extern "user32" fn CreateWindowExW(dwExStyle: WindowStyleEx, lpClassName: ?[*:0]const u16, lpWindowName: ?[*:0]const u16, dwStyle: WindowStyle, X: i32, Y: i32, nWidth: i32, nHeight: i32, hWndParent: ?*Window, hMenu: ?*Menu, hInstance: ?*Instance, lpParam: ?*const anyopaque) callconv(std.builtin.CallingConvention.winapi) *Window;
extern "user32" fn DefWindowProcW(hwnd: *Window, Msg: u32, wParam: usize, lParam: isize) isize;
extern "user32" fn DestroyWindow(hwnd: *Window) callconv(std.builtin.CallingConvention.winapi) bool;
extern "user32" fn PostQuitMessage(nExitCode: i32) callconv(std.builtin.CallingConvention.winapi) void;
extern "user32" fn RegisterClassExW(unnamedParam1: *const WindowClassExW) callconv(std.builtin.CallingConvention.winapi) u16;
extern "user32" fn ShowWindow(hwnd: *Window, nCmdShow: i32) callconv(std.builtin.CallingConvention.winapi) bool;
