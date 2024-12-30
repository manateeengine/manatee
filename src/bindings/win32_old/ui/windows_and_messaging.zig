const c = @import("../c.zig");

pub const createWindowExW = c.ui.windows_and_messaging.CreateWindowExW;
pub const defWindowProcW = c.ui.windows_and_messaging.DefWindowProcW;
pub const destroyWindow = c.ui.windows_and_messaging.DestroyWindow;
pub const dispatchMessageW = c.ui.windows_and_messaging.DispatchMessageW;
pub const getMessageW = c.ui.windows_and_messaging.GetMessageW;
pub const getWindowLongW = c.ui.windows_and_messaging.GetWindowLongW;
pub const postQuitMessage = c.ui.windows_and_messaging.PostQuitMessage;
pub const registerClassExW = c.ui.windows_and_messaging.RegisterClassExW;
pub const showWindow = c.ui.windows_and_messaging.ShowWindow;
pub const translateMessage = c.ui.windows_and_messaging.TranslateMessage;

pub const Msg = c.ui.windows_and_messaging.MSG;
pub const WndClassExW = c.ui.windows_and_messaging.WNDCLASSEXW;
pub const WndClassStyles = c.ui.windows_and_messaging.WNDCLASS_STYLES;
pub const WindowLongPtrIndex = c.ui.windows_and_messaging.WINDOW_LONG_PTR_INDEX;

pub const CwUseDefault = c.ui.windows_and_messaging.CW_USEDEFAULT;
pub const pmRemove = c.ui.windows_and_messaging.PM_REMOVE;
pub const SwShow = c.ui.windows_and_messaging.SW_SHOW;
pub const WmDestroy = c.ui.windows_and_messaging.WM_DESTROY;
pub const WsExOverlappedWindow = c.ui.windows_and_messaging.WS_EX_OVERLAPPEDWINDOW;
pub const WsOverlappedWindow = c.ui.windows_and_messaging.WS_OVERLAPPEDWINDOW;
