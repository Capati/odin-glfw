package glfw

// Core
import "core:c"
import "core:container/queue"
import "core:runtime"

// Bindings
import glfw "bindings"

@(private)
Window_Handle :: struct {
	enabled:                   Enabled_Events_Flags,
	framebuffer_size_proc:     Framebuffer_Size_Proc,
	window_size_proc:          Window_Size_Proc,
	key_proc:                  Key_Proc,
	char_proc:                 Char_Proc,
	cursor_pos_proc:           Cursor_Pos_Proc,
	mouse_button_proc:         Mouse_Button_Proc,
	scroll_proc:               Scroll_Proc,
	window_close_proc:         Window_Close_Proc,
	window_focus_proc:         Window_Focus_Proc,
	cursor_enter_proc:         Cursor_Enter_Proc,
	window_minimized_proc:     Window_Minimized_Proc,
	window_maximize_proc:      Window_Maximize_Proc,
	window_pos_proc:           Window_Pos_Proc,
	window_refresh_proc:       Window_Refresh_Proc,
	window_content_scale_proc: Window_Content_Scale_Proc,
	char_mods_proc:            Char_Mods_Proc,
	drop_proc:                 Drop_Proc,
}

@(private)
_window_handles: map[Window]Window_Handle

/* The procedure type for joystick configuration callback. */
Joystick_Proc :: #type proc(joy: Joystick_ID, event: Event_Status)

@(private)
_user_joystick_callback: Joystick_Proc

@(private)
_joystick_callback :: proc "c" (joy, event: c.int) {
	if _user_joystick_callback != nil {
		_user_joystick_callback(transmute(Joystick_ID)joy, transmute(Event_Status)event)
	}
}

/* Sets the joystick configuration callback. */
set_joystick_callback :: proc "contextless" (cb_proc: Joystick_Proc) {
	_user_joystick_callback = cb_proc
	glfw.SetJoystickCallback(_joystick_callback if cb_proc != nil else nil)
}

/* The procedure type for monitor configuration callback. */
Monitor_Proc :: #type proc(monitor: Monitor, status: Event_Status)

@(private)
_user_monitor_callback: Monitor_Proc

@(private)
_monitor_callback :: proc "c" (monitor: Monitor, event: c.int) {
	if _user_monitor_callback != nil {
		_user_monitor_callback(monitor, transmute(Event_Status)event)
	}
}

/* Sets the monitor configuration callback. */
set_monitor_callback :: proc "contextless" (monitor: Monitor, cb_proc: Monitor_Proc) {
	_user_monitor_callback = cb_proc
	glfw.SetMonitorCallback(monitor, _monitor_callback if cb_proc != nil else nil)
}

/* The procedure type for framebuffer size callback. */
Framebuffer_Size_Proc :: #type proc(window: Window, size: Framebuffer_Size)

@(private)
_framebuffer_size_callback :: proc "c" (window: Window, width, height: c.int) {
	context = runtime.default_context()

	size := Framebuffer_Size{u32(width), u32(height)}

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.framebuffer_size_proc != nil {
		handle.framebuffer_size_proc(window, size)
	}

	if .Framebuffer_Size in handle.enabled {
		resize_event := Framebuffer_Resize_Event{window, size}

		// Avoid accumulate the same type in the event loop
		if _events.len > 0 {
			last_event := queue.peek_back(&_events)
			if _, ok := last_event.(Framebuffer_Resize_Event); ok {
				queue.set(&_events, _events.len - 1, resize_event)
				return
			}
		}

		push_event(resize_event)
	}
}

/* Sets the framebuffer resize callback for the specified window. */
set_framebuffer_size_callback :: proc "contextless" (
	window: Window,
	cb_proc: Framebuffer_Size_Proc,
) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.framebuffer_size_proc = cb_proc
	}

	glfw.SetFramebufferSizeCallback(window, _framebuffer_size_callback if cb_proc != nil else nil)
}

/* The procedure type for window size callback. */
Window_Size_Proc :: #type proc(window: Window, size: Window_Size)

@(private)
_window_size_callback :: proc "c" (window: Window, width, height: c.int) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	size := Window_Size{u32(width), u32(height)}

	if handle.window_size_proc != nil {
		handle.window_size_proc(window, size)
	}

	if .Window_Size in handle.enabled {
		resize_event := Window_Resize_Event{window, size}

		// Avoid accumulate the same type in the event loop
		if _events.len > 0 {
			last_event := queue.peek_back(&_events)
			if _, ok := last_event.(Window_Resize_Event); ok {
				queue.set(&_events, _events.len - 1, resize_event)
				return
			}
		}

		push_event(resize_event)
	}
}

/* Sets the framebuffer resize callback for the specified window. */
set_window_size_callback :: proc "contextless" (window: Window, cb_proc: Window_Size_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_size_proc = cb_proc
	}

	glfw.SetWindowSizeCallback(window, _window_size_callback if cb_proc != nil else nil)
}

/* The procedure type for window position callback. */
Window_Pos_Proc :: #type proc(window: Window, pos: Window_Pos)

@(private)
_window_pos_callback :: proc "c" (window: Window, xpos, ypos: c.int) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	pos := Window_Pos{u32(xpos), u32(ypos)}

	if handle.window_pos_proc != nil {
		handle.window_pos_proc(window, pos)
	}

	if .Window_Pos in handle.enabled {
		resize_event := Window_Pos_Event{window, pos}

		// Avoid accumulate the same type in the event loop
		if _events.len > 0 {
			last_event := queue.peek_back(&_events)
			if _, ok := last_event.(Window_Pos_Event); ok {
				queue.set(&_events, _events.len - 1, resize_event)
				return
			}
		}

		push_event(resize_event)
	}
}

/* Sets the position callback for the specified window. */
set_window_pos_callback :: proc "contextless" (window: Window, cb_proc: Window_Pos_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_pos_proc = cb_proc
	}

	glfw.SetWindowPosCallback(window, _window_pos_callback if cb_proc != nil else nil)
}

/* The procedure type for window content refresh callbacks. */
Window_Refresh_Proc :: #type proc(window: Window)

@(private)
_window_refresh_callback :: proc "c" (window: Window) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.window_refresh_proc != nil {
		handle.window_refresh_proc(window)
	}

	if .Window_Refresh in handle.enabled {
		push_event(Window_Refresh_Event{window})
	}
}

/* Sets the refresh callback for the specified window. */
set_window_refresh_callback :: proc "contextless" (window: Window, cb_proc: Window_Refresh_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_refresh_proc = cb_proc
	}

	glfw.SetWindowRefreshCallback(window, _window_refresh_callback if cb_proc != nil else nil)
}

/* The procedure type for window content scale callbacks. */
Window_Content_Scale_Proc :: #type proc(window: Window, scale: Window_Content_Scale)

@(private)
_window_content_scale_callback :: proc "c" (window: Window, xscale, yscale: f32) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	scale := Window_Content_Scale{xscale, yscale}

	if handle.window_content_scale_proc != nil {
		handle.window_content_scale_proc(window, scale)
	}

	if .Window_Content_Scale in handle.enabled {
		scale_event := Window_Content_Scale_Event{window, scale}

		// Avoid accumulate the same type in the event loop
		if _events.len > 0 {
			last_event := queue.peek_back(&_events)
			if _, ok := last_event.(Window_Content_Scale_Event); ok {
				queue.set(&_events, _events.len - 1, scale_event)
				return
			}
		}

		push_event(scale_event)
	}
}

/* Sets the window content scale callback for the specified window. */
set_window_content_scale_callback :: proc "contextless" (
	window: Window,
	cb_proc: Window_Content_Scale_Proc,
) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_content_scale_proc = cb_proc
	}

	glfw.SetWindowContentScaleCallback(
		window,
		_window_content_scale_callback if cb_proc != nil else nil,
	)
}

/* The procedure type for Unicode character with modifiers callbacks. */
Char_Mods_Proc :: #type proc(window: Window, codepoint: rune, mods: Key_Mods)

@(private)
_char_mods_callback :: proc "c" (window: Window, codepoint: rune, mods: c.int) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	_mods := Key_Mods {
		shift     = (mods & MOD_SHIFT) != 0,
		control   = (mods & MOD_CONTROL) != 0,
		alt       = (mods & MOD_ALT) != 0,
		super     = (mods & MOD_SUPER) != 0,
		caps_lock = (mods & MOD_CAPS_LOCK) != 0,
		num_lock  = (mods & MOD_NUM_LOCK) != 0,
	}

	if handle.char_mods_proc != nil {
		handle.char_mods_proc(window, codepoint, _mods)
	}

	if .Char_Mods in handle.enabled {
		push_event(Char_Mods_Event{window, codepoint, _mods})
	}
}

/* Sets the Unicode character with modifiers callback. */
set_char_mods_callback :: proc "contextless" (window: Window, cb_proc: Char_Mods_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.char_mods_proc = cb_proc
	}

	glfw.SetCharModsCallback(window, _char_mods_callback if cb_proc != nil else nil)
}

/* The procedure type for path drop callback. */
Drop_Proc :: #type proc(window: Window, paths: []cstring)

@(private)
_drop_callback :: proc "c" (window: Window, count: c.int, paths: [^]cstring) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.drop_proc != nil {
		handle.drop_proc(window, paths[:count])
	}

	if .Drop in handle.enabled {
		push_event(Paths_Drop_Event{window, paths[:count]})
	}
}

/* Sets the path drop callback. */
set_drop_callback :: proc "contextless" (window: Window, cb_proc: Drop_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.drop_proc = cb_proc
	}

	glfw.SetDropCallback(window, _drop_callback if cb_proc != nil else nil)
}

/* The procedure type for key press/release/repeat callbacks. */
Key_Proc :: #type proc(window: Window, key: Key, scancode: i32, action: Action, mods: Key_Mods)

@(private)
_key_callback :: proc "c" (window: Window, key, scancode, action, mods: c.int) {
	context = runtime.default_context()

	_mods := Key_Mods {
		shift     = (mods & MOD_SHIFT) != 0,
		control   = (mods & MOD_CONTROL) != 0,
		alt       = (mods & MOD_ALT) != 0,
		super     = (mods & MOD_SUPER) != 0,
		caps_lock = (mods & MOD_CAPS_LOCK) != 0,
		num_lock  = (mods & MOD_NUM_LOCK) != 0,
	}

	_key := transmute(Key)key

	key_event := Key_Event {
		window = window,
		key    = _key,
		mods   = _mods,
	}

	_action := transmute(Action)action

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.key_proc != nil {
		handle.key_proc(window, _key, i32(scancode), _action, _mods)
	}

	if .Key in handle.enabled {
		switch _action {
		case .Press:
			push_event(Key_Press_Event(key_event))
		case .Release:
			push_event(Key_Release_Event(key_event))
		case .Repeat:
			push_event(Key_Repeat_Event(key_event))
		}
	}
}

/* Sets the key callback. */
set_key_callback :: proc "contextless" (window: Window, cb_proc: Key_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.key_proc = cb_proc
	}

	glfw.SetKeyCallback(window, _key_callback if cb_proc != nil else nil)
}

/* The procedure type for Unicode character callback. */
Char_Proc :: #type proc(window: Window, codepoint: rune)

@(private)
_char_callback :: proc "c" (window: Window, codepoint: rune) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.char_proc != nil {
		handle.char_proc(window, codepoint)
	}

	if .Char in handle.enabled {
		push_event(Char_Event{window, codepoint})
	}
}

/* Sets the Unicode character callback. */
set_char_callback :: proc "contextless" (window: Window, cb_proc: Char_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.char_proc = cb_proc
	}

	glfw.SetCharCallback(window, _char_callback if cb_proc != nil else nil)
}

/* The procedure type for cursor position callback. */
Cursor_Pos_Proc :: #type proc(window: Window, pos: Cursor_Position)

@(private)
_cursor_pos_callback :: proc "c" (window: Window, xpos, ypos: f64) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.cursor_pos_proc != nil {
		handle.cursor_pos_proc(window, {xpos, ypos})
	}

	if .Cursor_Pos in handle.enabled {
		push_event(Mouse_Motion_Event{window, {xpos, ypos}})
	}
}

/* Sets the cursor position callback. */
set_cursor_pos_callback :: proc "contextless" (window: Window, cb_proc: Cursor_Pos_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.cursor_pos_proc = cb_proc
	}

	glfw.SetCursorPosCallback(window, _cursor_pos_callback if cb_proc != nil else nil)
}

/* The procedure type for mouse button callback. */
Mouse_Button_Proc :: #type proc(
	window: Window,
	button: Mouse_Button,
	action: Action,
	mods: Key_Mods,
)

@(private)
_mouse_button_callback :: proc "c" (window: Window, button, action, mods: c.int) {
	context = runtime.default_context()

	_mods := Key_Mods {
		shift     = (mods & MOD_SHIFT) != 0,
		control   = (mods & MOD_CONTROL) != 0,
		alt       = (mods & MOD_ALT) != 0,
		super     = (mods & MOD_SUPER) != 0,
		caps_lock = (mods & MOD_CAPS_LOCK) != 0,
		num_lock  = (mods & MOD_NUM_LOCK) != 0,
	}

	_button := convert_mouse_button(button)
	pos := get_cursor_pos(window)

	mouse_button_event := Mouse_Button_Event {
		window = window,
		button = _button,
		pos    = pos,
		mods   = _mods,
	}

	_action := transmute(Action)action

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.mouse_button_proc != nil {
		handle.mouse_button_proc(window, _button, _action, _mods)
	}

	if .Mouse_Button in handle.enabled {
		#partial switch _action {
		case .Press:
			push_event(Mouse_Button_Press_Event(mouse_button_event))
		case .Release:
			push_event(Mouse_Button_Release_Event(mouse_button_event))
		}
	}
}

/* Sets the mouse button callback. */
set_mouse_button_callback :: proc "contextless" (window: Window, cb_proc: Mouse_Button_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.mouse_button_proc = cb_proc
	}

	glfw.SetMouseButtonCallback(window, _mouse_button_callback if cb_proc != nil else nil)
}

/* The procedure type for mouse scroll callback. */
Scroll_Proc :: #type proc(window: Window, offset: Scroll_Offset)

@(private)
_scroll_callback :: proc "c" (window: Window, xoffset, yoffset: f64) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.scroll_proc != nil {
		handle.scroll_proc(window, {xoffset, yoffset})
	}

	if .Scroll in handle.enabled {
		push_event(Mouse_Scroll_Event{window, {xoffset, yoffset}})
	}
}

/* Sets the scroll callback. */
set_scroll_callback :: proc "contextless" (window: Window, cb_proc: Scroll_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.scroll_proc = cb_proc
	}

	glfw.SetScrollCallback(window, _scroll_callback if cb_proc != nil else nil)
}

/* The procedure type for window close callback. */
Window_Close_Proc :: #type proc(window: Window)

@(private)
_close_callback :: proc "c" (window: Window) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.window_close_proc != nil {
		handle.window_close_proc(window)
	}

	if .Window_Close in handle.enabled {
		push_event(Close_Event{window, true})
	}
}

/* Sets the close callback for the specified window. */
set_window_close_callback :: proc "contextless" (window: Window, cb_proc: Window_Close_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_close_proc = cb_proc
	}

	glfw.SetWindowCloseCallback(window, _close_callback if cb_proc != nil else nil)
}

/* The procedure type for window focus callback. */
Window_Focus_Proc :: #type proc(window: Window, focused: bool)

@(private)
_window_focus_callback :: proc "c" (window: Window, focused: c.int) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.window_focus_proc != nil {
		handle.window_focus_proc(window, bool(focused))
	}

	if .Window_Focus in handle.enabled {
		push_event(Focus_Event{window, bool(focused)})
	}
}

/* Sets the focus callback for the specified window. */
set_window_focus_callback :: proc(window: Window, cb_proc: Window_Focus_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_focus_proc = cb_proc
	}

	glfw.SetWindowFocusCallback(window, _window_focus_callback if cb_proc != nil else nil)
}

/* The procedure type for cursor enter/leave callbacks. */
Cursor_Enter_Proc :: #type proc(window: Window, entered: bool)

@(private)
_cursor_enter_callback :: proc "c" (window: Window, entered: b32) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.cursor_enter_proc != nil {
		handle.cursor_enter_proc(window, bool(entered))
	}

	if .Cursor_Enter in handle.enabled {
		push_event(Cursor_Enter_Event{window, bool(entered)})
	}
}

/* Sets the cursor enter/leave callback. */
set_cursor_enter_callback :: proc "contextless" (window: Window, cb_proc: Cursor_Enter_Proc) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.cursor_enter_proc = cb_proc
	}

	glfw.SetCursorEnterCallback(window, _cursor_enter_callback if cb_proc != nil else nil)
}

/* The procedure type for window minimization (iconify) callback. */
Window_Minimized_Proc :: #type proc(window: Window, iconified: bool)

@(private)
_window_iconify_callback :: proc "c" (window: Window, iconified: b32) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.window_minimized_proc != nil {
		handle.window_minimized_proc(window, bool(iconified))
	}

	if .Window_Iconify in handle.enabled {
		push_event(Iconified_Event{window, bool(iconified)})
	}
}

/* Sets the minimized (iconify) callback for the specified window. */
set_window_iconify_callback :: proc "contextless" (
	window: Window,
	cb_proc: Window_Minimized_Proc,
) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_minimized_proc = cb_proc
	}

	glfw.SetWindowIconifyCallback(window, _window_iconify_callback if cb_proc != nil else nil)
}

/* The procedure type for window maximized callback. */
Window_Maximize_Proc :: #type proc(window: Window, maximized: bool)

@(private)
_window_maximize_proc :: proc "c" (window: Window, maximized: b32) {
	context = runtime.default_context()

	handle, handle_ok := &_window_handles[window]
	if !handle_ok do return

	if handle.window_maximize_proc != nil {
		handle.window_maximize_proc(window, bool(maximized))
	}

	if .Window_Maximize in handle.enabled {
		push_event(Maximized_Event{window, bool(maximized)})
	}
}

/* Sets the maximize callback for the specified window. */
set_window_maximize_callback :: proc "contextless" (
	window: Window,
	cb_proc: Window_Maximize_Proc,
) {
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_maximize_proc = cb_proc
	}

	glfw.SetWindowMaximizeCallback(window, _window_maximize_proc if cb_proc != nil else nil)
}
