package glfw

// Core
import "core:c"
import "core:container/queue"
import "core:runtime"

@(private)
Window_Handle :: struct {
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
	context = runtime.default_context()

	joystick := transmute(Joystick_ID)joy
	event_status := transmute(Event_Status)event

	if _user_joystick_callback != nil {
		_user_joystick_callback(joystick, event_status)
	}

	switch event_status {
	case .Connected:
		push_event(Joystick_Connected_Event{joystick})
	case .Disconnected:
		push_event(Joystick_Disconnected_Event{joystick})
	}
}

/* Sets the joystick configuration callback. */
set_joystick_callback :: proc(callback: Joystick_Proc = nil) {
	// The main callback was set on GLFW initialization (default for custom event loop)
	// Here we only set for the user callback
	_user_joystick_callback = callback
}

/* The procedure type for monitor configuration callback. */
Monitor_Proc :: #type proc(monitor: Monitor, status: Event_Status)

@(private)
_user_monitor_callback: Monitor_Proc

@(private)
_monitor_callback :: proc "c" (monitor: Monitor, event: c.int) {
	context = runtime.default_context()

	event_status := transmute(Event_Status)event

	if _user_monitor_callback != nil {
		_user_monitor_callback(monitor, event_status)
	}

	switch event_status {
	case .Connected:
		push_event(Monitor_Connected_Event{monitor})
	case .Disconnected:
		push_event(Monitor_Disconnected_Event{monitor})
	}
}

/* Sets the monitor configuration callback. */
set_monitor_callback :: proc "contextless" (cb_proc: Monitor_Proc) {
	// The main callback was set on GLFW initialization (default for custom event loop)
	// Here we only set for the user callback
	_user_monitor_callback = cb_proc
}

/* The procedure type for framebuffer size callback. */
Framebuffer_Size_Proc :: #type proc(window: Window, size: Framebuffer_Size)

@(private)
_framebuffer_size_callback :: proc "c" (window: Window, width, height: c.int) {
	context = runtime.default_context()

	size := Framebuffer_Size{u32(width), u32(height)}

	if handle, ok := &_window_handles[window]; ok {
		if handle.framebuffer_size_proc != nil {
			handle.framebuffer_size_proc(window, size)
		}
	}

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

/* Sets the framebuffer resize callback for the specified window. */
set_framebuffer_size_callback :: proc "contextless" (
	window: Window,
	cb_proc: Framebuffer_Size_Proc,
) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.framebuffer_size_proc = cb_proc
	}
}

/* The procedure type for window size callback. */
Window_Size_Proc :: #type proc(window: Window, size: Window_Size)

@(private)
_window_size_callback :: proc "c" (window: Window, width, height: c.int) {
	context = runtime.default_context()

	size := Window_Size{u32(width), u32(height)}

	if handle, ok := &_window_handles[window]; ok {
		if handle.window_size_proc != nil {
			handle.window_size_proc(window, size)
		}
	}

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

/* Sets the framebuffer resize callback for the specified window. */
set_window_size_callback :: proc "contextless" (window: Window, cb_proc: Window_Size_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_size_proc = cb_proc
	}
}

/* The procedure type for window position callback. */
Window_Pos_Proc :: #type proc(window: Window, pos: Window_Pos)

@(private)
_window_pos_callback :: proc "c" (window: Window, xpos, ypos: c.int) {
	context = runtime.default_context()

	pos := Window_Pos{u32(xpos), u32(ypos)}

	if handle, ok := &_window_handles[window]; ok {
		if handle.window_pos_proc != nil {
			handle.window_pos_proc(window, pos)
		}
	}

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

/* Sets the position callback for the specified window. */
set_window_pos_callback :: proc "contextless" (window: Window, cb_proc: Window_Pos_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_pos_proc = cb_proc
	}
}

/* The procedure type for window content refresh callbacks. */
Window_Refresh_Proc :: #type proc(window: Window)

@(private)
_window_refresh_callback :: proc "c" (window: Window) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.window_refresh_proc != nil {
			handle.window_refresh_proc(window)
		}
	}

	push_event(Window_Refresh_Event{window})
}

/* Sets the refresh callback for the specified window. */
set_window_refresh_callback :: proc "contextless" (window: Window, cb_proc: Window_Refresh_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_refresh_proc = cb_proc
	}
}

/* The procedure type for window content scale callbacks. */
Window_Content_Scale_Proc :: #type proc(window: Window, scale: Window_Content_Scale)

@(private)
_window_content_scale_callback :: proc "c" (window: Window, xscale, yscale: f32) {
	context = runtime.default_context()

	scale := Window_Content_Scale{xscale, yscale}

	if handle, ok := &_window_handles[window]; ok {
		if handle.window_content_scale_proc != nil {
			handle.window_content_scale_proc(window, scale)
		}
	}

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

/* Sets the window content scale callback for the specified window. */
set_window_content_scale_callback :: proc "contextless" (
	window: Window,
	cb_proc: Window_Content_Scale_Proc,
) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_content_scale_proc = cb_proc
	}
}

/* The procedure type for Unicode character with modifiers callbacks. */
Char_Mods_Proc :: #type proc(window: Window, codepoint: rune, mods: Key_Mods)

@(private)
_char_mods_callback :: proc "c" (window: Window, codepoint: rune, mods: c.int) {
	context = runtime.default_context()

	_mods := Key_Mods {
		shift     = (mods & MOD_SHIFT) != 0,
		control   = (mods & MOD_CONTROL) != 0,
		alt       = (mods & MOD_ALT) != 0,
		super     = (mods & MOD_SUPER) != 0,
		caps_lock = (mods & MOD_CAPS_LOCK) != 0,
		num_lock  = (mods & MOD_NUM_LOCK) != 0,
	}

	if handle, ok := &_window_handles[window]; ok {
		if handle.char_mods_proc != nil {
			handle.char_mods_proc(window, codepoint, _mods)
		}
	}

	push_event(Char_Mods_Event{window, codepoint, _mods})
}

/* Sets the Unicode character with modifiers callback. */
set_char_mods_callback :: proc "contextless" (window: Window, cb_proc: Char_Mods_Proc = nil) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.char_mods_proc = cb_proc
	}
}

/* The procedure type for path drop callback. */
Drop_Proc :: #type proc(window: Window, paths: []cstring)

@(private)
_drop_callback :: proc "c" (window: Window, count: c.int, paths: [^]cstring) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.drop_proc != nil {
			handle.drop_proc(window, paths[:count])
		}
	}

	push_event(Paths_Drop_Event{window, paths[:count]})
}

/* Sets the path drop callback. */
set_drop_callback :: proc "contextless" (window: Window, cb_proc: Drop_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.drop_proc = cb_proc
	}
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

	if handle, ok := &_window_handles[window]; ok {
		if handle.key_proc != nil {
			handle.key_proc(window, _key, i32(scancode), _action, _mods)
		}
	}

	switch _action {
	case .Press:
		push_event(Key_Press_Event(key_event))
	case .Release:
		push_event(Key_Release_Event(key_event))
	case .Repeat:
		push_event(Key_Repeat_Event(key_event))
	}
}

/* Sets the key callback. */
set_key_callback :: proc "contextless" (window: Window, cb_proc: Key_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.key_proc = cb_proc
	}
}

/* The procedure type for Unicode character callback. */
Char_Proc :: #type proc(window: Window, codepoint: rune)

@(private)
_char_callback :: proc "c" (window: Window, codepoint: rune) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.char_proc != nil {
			handle.char_proc(window, codepoint)
		}
	}

	push_event(Char_Event{window, codepoint})
}

/* Sets the Unicode character callback. */
set_char_callback :: proc "contextless" (window: Window, cb_proc: Char_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.char_proc = cb_proc
	}
}

/* The procedure type for cursor position callback. */
Cursor_Pos_Proc :: #type proc(window: Window, pos: Cursor_Position)

@(private)
_cursor_pos_callback :: proc "c" (window: Window, xpos, ypos: f64) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.cursor_pos_proc != nil {
			handle.cursor_pos_proc(window, {xpos, ypos})
		}
	}

	push_event(Mouse_Motion_Event{window, {xpos, ypos}})
}

/* Sets the cursor position callback. */
set_cursor_pos_callback :: proc "contextless" (window: Window, cb_proc: Cursor_Pos_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.cursor_pos_proc = cb_proc
	}
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

	if handle, ok := &_window_handles[window]; ok {
		if handle.mouse_button_proc != nil {
			handle.mouse_button_proc(window, _button, _action, _mods)
		}
	}

	#partial switch _action {
	case .Press:
		push_event(Mouse_Button_Press_Event(mouse_button_event))
	case .Release:
		push_event(Mouse_Button_Release_Event(mouse_button_event))
	}
}

/* Sets the mouse button callback. */
set_mouse_button_callback :: proc "contextless" (window: Window, cb_proc: Mouse_Button_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.mouse_button_proc = cb_proc
	}
}

/* The procedure type for mouse scroll callback. */
Scroll_Proc :: #type proc(window: Window, offset: Scroll_Offset)

@(private)
_scroll_callback :: proc "c" (window: Window, xoffset, yoffset: f64) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.scroll_proc != nil {
			handle.scroll_proc(window, {xoffset, yoffset})
		}
	}

	push_event(Mouse_Scroll_Event{window, {xoffset, yoffset}})
}

/* Sets the scroll callback. */
set_scroll_callback :: proc "contextless" (window: Window, cb_proc: Scroll_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.scroll_proc = cb_proc
	}
}

/* The procedure type for window close callback. */
Window_Close_Proc :: #type proc(window: Window)

@(private)
_close_callback :: proc "c" (window: Window) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.window_close_proc != nil {
			handle.window_close_proc(window)
		}
	}

	push_event(Close_Event{window, true})
}

/* Sets the close callback for the specified window. */
set_window_close_callback :: proc "contextless" (window: Window, cb_proc: Window_Close_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_close_proc = cb_proc
	}
}

/* The procedure type for window focus callback. */
Window_Focus_Proc :: #type proc(window: Window, focused: bool)

@(private)
_window_focus_callback :: proc "c" (window: Window, focused: c.int) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.window_focus_proc != nil {
			handle.window_focus_proc(window, bool(focused))
		}
	}

	push_event(Focus_Event{window, bool(focused)})
}

/* Sets the focus callback for the specified window. */
set_window_focus_callback :: proc(window: Window, cb_proc: Window_Focus_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_focus_proc = cb_proc
	}
}

/* The procedure type for cursor enter/leave callbacks. */
Cursor_Enter_Proc :: #type proc(window: Window, entered: bool)

@(private)
_cursor_enter_callback :: proc "c" (window: Window, entered: b32) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.cursor_enter_proc != nil {
			handle.cursor_enter_proc(window, bool(entered))
		}
	}

	push_event(Cursor_Enter_Event{window, bool(entered)})
}

/* Sets the cursor enter/leave callback. */
set_cursor_enter_callback :: proc "contextless" (window: Window, cb_proc: Cursor_Enter_Proc) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.cursor_enter_proc = cb_proc
	}
}

/* The procedure type for window minimization (iconify) callback. */
Window_Minimized_Proc :: #type proc(window: Window, iconified: bool)

@(private)
_window_iconify_callback :: proc "c" (window: Window, iconified: b32) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.window_minimized_proc != nil {
			handle.window_minimized_proc(window, bool(iconified))
		}
	}

	push_event(Iconified_Event{window, bool(iconified)})
}

/* Sets the minimized (iconify) callback for the specified window. */
set_window_iconify_callback :: proc "contextless" (
	window: Window,
	cb_proc: Window_Minimized_Proc,
) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_minimized_proc = cb_proc
	}
}

/* The procedure type for window maximized callback. */
Window_Maximize_Proc :: #type proc(window: Window, maximized: bool)

@(private)
_window_maximize_proc :: proc "c" (window: Window, maximized: b32) {
	context = runtime.default_context()

	if handle, ok := &_window_handles[window]; ok {
		if handle.window_maximize_proc != nil {
			handle.window_maximize_proc(window, bool(maximized))
		}
	}

	push_event(Maximized_Event{window, bool(maximized)})
}

/* Sets the maximize callback for the specified window. */
set_window_maximize_callback :: proc "contextless" (
	window: Window,
	cb_proc: Window_Maximize_Proc,
) {
	// The main callback was set on window creation (default for custom event loop)
	// Here we only set for the user callback
	if handle, ok := &_window_handles[window]; ok {
		handle^.window_maximize_proc = cb_proc
	}
}
