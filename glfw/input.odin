package glfw

// Core
import "core:c"
import "core:runtime"

// Bindings
import glfw "bindings"

Input_Mode :: enum c.int {
	Cursor               = CURSOR,
	Sticky_Keys          = STICKY_KEYS,
	Sticky_Mouse_Buttons = STICKY_MOUSE_BUTTONS,
	Lock_Key_Mods        = LOCK_KEY_MODS,
	Raw_Mouse_Motion     = RAW_MOUSE_MOTION,
}

Input_Mode_Cursor :: enum c.int {
	Normal   = CURSOR_NORMAL,
	Hidden   = CURSOR_HIDDEN,
	Disabled = CURSOR_DISABLED,
	Captured = CURSOR_CAPTURED,
}

/* Sets the input mode of the cursor, whether it should behave normally, be hidden, or captured. */
set_input_mode_cursor :: proc "contextless" (window: Window, value: Input_Mode_Cursor) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Cursor, transmute(c.int)value)

	if value == .Disabled {
		glfw.SetInputMode(window, transmute(c.int)Input_Mode.Raw_Mouse_Motion, 1)
		return
	}

	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Raw_Mouse_Motion, 0)
}

/* Gets the current input mode of the cursor. */
get_input_mode_cursor :: proc "contextless" (window: Window) -> Input_Mode_Cursor {
	return transmute(Input_Mode_Cursor)glfw.GetInputMode(window, transmute(c.int)Input_Mode.Cursor)
}

/* Sets the input mode of sticky keys. */
set_input_mode_sticky_keys :: proc "contextless" (window: Window, enabled: bool) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Sticky_Keys, c.int(enabled))
}

/* Tells if the sticky keys input mode is enabled. */
get_input_mode_sticky_keys :: proc "contextless" (window: Window) -> bool {
	return glfw.GetInputMode(window, transmute(c.int)Input_Mode.Sticky_Keys) == 1
}

/* Sets the input mode of sticky mouse buttons. */
set_input_mode_sticky_mouse_buttons :: proc "contextless" (window: Window, enabled: bool) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Sticky_Mouse_Buttons, c.int(enabled))
}

/* Tells if the sticky mouse buttons input mode is enabled. */
get_input_mode_sticky_mouse_buttons :: proc "contextless" (window: Window) -> bool {
	return glfw.GetInputMode(window, transmute(c.int)Input_Mode.Sticky_Mouse_Buttons) == 1
}

/* Sets the input mode of locking key modifiers. */
set_input_mode_lock_key_mods :: proc "contextless" (window: Window, enabled: bool) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Lock_Key_Mods, c.int(enabled))
}

/* Tells if the locking key modifiers input mode is enabled. */
get_input_mode_lock_keys :: proc "contextless" (window: Window) -> bool {
	return glfw.GetInputMode(window, transmute(c.int)Input_Mode.Lock_Key_Mods) == 1
}

/* Sets the input mode of raw mouse motion. */
set_input_mode_raw_mouse_motion :: proc "contextless" (window: Window, enabled: bool) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Raw_Mouse_Motion, c.int(enabled))
}

/* Tells if the raw mouse motion input mode is enabled. */
get_input_mode_raw_mouse_motion :: proc "contextless" (window: Window) -> bool {
	return glfw.GetInputMode(window, transmute(c.int)Input_Mode.Raw_Mouse_Motion) == 1
}

/* Returns the value of an input option for the specified window. */
get_input_mode :: proc "contextless" (window: Window, mode: Input_Mode) -> i32 {
	return i32(glfw.GetInputMode(window, transmute(c.int)mode))
}

Input_Mode_Value :: union {
	Input_Mode_Cursor,
	bool,
}

/* Sets an input option for the specified window. */
set_input_mode :: proc "contextless" (
	window: Window,
	mode: Input_Mode,
	value: Input_Mode_Value,
	loc := #caller_location,
) {
	when ODIN_DEBUG {
		context = runtime.default_context()
	}

	int_value: c.int

	switch v in value {
	case Input_Mode_Cursor:
		#partial switch mode {
		case .Cursor:
			int_value = transmute(c.int)v
		case:
			when ODIN_DEBUG {
				panic("The 'Input_Mode_Cursor' value does not support the given input mode", loc)
			}
		}
	case bool:
		when ODIN_DEBUG {
			assert(mode != .Cursor, "The 'bool' value does not support the given input mode", loc)
		}
		int_value = c.int(v)
	}

	glfw.SetInputMode(window, transmute(c.int)mode, int_value)
}

/* Returns whether raw mouse motion is supported. */
raw_mouse_motion_supported :: proc "contextless" () -> bool {
	return bool(glfw.RawMouseMotionSupported())
}

/* Mouse button types. */
Mouse_Button :: enum c.int {
	One    = MOUSE_BUTTON_1,
	Two    = MOUSE_BUTTON_2,
	Three  = MOUSE_BUTTON_3,
	Four   = MOUSE_BUTTON_4,
	Five   = MOUSE_BUTTON_5,
	Six    = MOUSE_BUTTON_6,
	Seven  = MOUSE_BUTTON_7,
	Eight  = MOUSE_BUTTON_8,
	Last   = MOUSE_BUTTON_8,
	Left   = MOUSE_BUTTON_1,
	Right  = MOUSE_BUTTON_2,
	Middle = MOUSE_BUTTON_3,
}

/* Returns the last reported state of a mouse button for the specified window. */
get_mouse_button :: proc "contextless" (window: Window, button: Mouse_Button) -> Action {
	return transmute(Action)glfw.GetMouseButton(window, transmute(c.int)button)
}

/* Sets the Unicode character callback. */
set_char_callback :: proc "contextless" (window: Window, callback: Char_Proc = nil) -> Char_Proc {
	return glfw.SetCharCallback(window, callback)
}

/* Sets the Unicode character with modifiers callback. */
set_char_mods_callback :: proc "contextless" (
	window: Window,
	callback: Char_Mods_Proc = nil,
) -> Char_Mods_Proc {
	return glfw.SetCharModsCallback(window, callback)
}

/* Sets the mouse button callback. */
set_mouse_button_callback :: proc "contextless" (
	window: Window,
	callback: Mouse_Button_Proc = nil,
) -> Mouse_Button_Proc {
	return glfw.SetMouseButtonCallback(window, callback)
}

/* Sets the scroll callback. */
set_scroll_callback :: proc "contextless" (
	window: Window,
	callback: Scroll_Proc = nil,
) -> Scroll_Proc {
	return glfw.SetScrollCallback(window, callback)
}

/* Sets the path drop callback. */
set_drop_callback :: proc "contextless" (window: Window, callback: Drop_Proc = nil) -> Drop_Proc {
	return glfw.SetDropCallback(window, callback)
}
