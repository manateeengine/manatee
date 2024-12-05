//! A collection of idiomatic Zig utilities for writing native Win32 desktop applications.
//!
//! Note: Although Manatee has a rule of never using 3rd party packages, this file is an exception.
//! Normally, I'd import the system headers and build a more idiomatic abstraction from there. This
//! is the pattern that I used to build `macos.zig`. Unfortunately, Zig is unable to compile
//! windows.zig when imported, so we're stuck at a bit of an impasse here. Because of this issue,
//! this file brings in the package zig-win32 and exports the subset of that package that's
//! required for Manatee. I generally trust this package, as it's generated based off of
//! reference material created by Microsoft, however it's still massively bloated and I'd love to
//! eventually remove it so Manatee can maintain the same pattern across operating systems.

const std = @import("std");
const zigwin32 = @import("zigwin32");

const foundation = zigwin32.foundation;
const library_loader = zigwin32.system.library_loader;
const windows_and_messaging = zigwin32.ui.windows_and_messaging;
const win32_zig = zigwin32.zig;

pub const UInt = c_uint;
pub const WinApi = std.os.windows.WINAPI;

pub const HInstance = foundation.HINSTANCE;
pub const HWnd = foundation.HWND;
pub const LParam = foundation.LPARAM;
pub const LResult = foundation.LRESULT;
pub const WParam = foundation.WPARAM;

pub const getModuleHandleW = library_loader.GetModuleHandleW;

pub const createWindowExW = windows_and_messaging.CreateWindowExW;
pub const defWindowProcW = windows_and_messaging.DefWindowProcW;
pub const dispatchMessageW = windows_and_messaging.DispatchMessageW;
pub const getMessageW = windows_and_messaging.GetMessageW;
pub const postQuitMessage = windows_and_messaging.PostQuitMessage;
pub const registerClassExW = windows_and_messaging.RegisterClassExW;
pub const showWindow = windows_and_messaging.ShowWindow;
pub const translateMessage = windows_and_messaging.TranslateMessage;
pub const CwUseDefault = windows_and_messaging.CW_USEDEFAULT;
pub const Msg = windows_and_messaging.MSG;
pub const pmRemove = windows_and_messaging.PM_REMOVE;
pub const SwShow = windows_and_messaging.SW_SHOW;
pub const WmDestroy = windows_and_messaging.WM_DESTROY;
pub const WndClassExW = windows_and_messaging.WNDCLASSEXW;
pub const WndClassStyles = windows_and_messaging.WNDCLASS_STYLES;
pub const WsExOverlappedWindow = windows_and_messaging.WS_EX_OVERLAPPEDWINDOW;
pub const WsOverlappedWindow = windows_and_messaging.WS_OVERLAPPEDWINDOW;

pub const l = win32_zig.L;
