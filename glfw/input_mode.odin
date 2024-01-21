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
enable_cursor_mode :: proc "contextless" (window: Window, value: Input_Mode_Cursor) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Cursor, transmute(c.int)value)

	if value == .Disabled {
		glfw.SetInputMode(window, transmute(c.int)Input_Mode.Raw_Mouse_Motion, 1)
		return
	}

	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Raw_Mouse_Motion, 0)
}

/* Gets the current input mode of the cursor. */
get_cursor_mode :: proc "contextless" (window: Window) -> Input_Mode_Cursor {
	return transmute(Input_Mode_Cursor)glfw.GetInputMode(window, transmute(c.int)Input_Mode.Cursor)
}

/* Sets the input mode of sticky keys. */
enable_sticky_keys :: proc "contextless" (window: Window, enabled: bool) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Sticky_Keys, c.int(enabled))
}

/* Tells if the sticky keys input mode is enabled. */
get_sticky_keys :: proc "contextless" (window: Window) -> bool {
	return glfw.GetInputMode(window, transmute(c.int)Input_Mode.Sticky_Keys) == 1
}

/* Sets the input mode of sticky mouse buttons. */
enable_sticky_mouse_buttons :: proc "contextless" (window: Window, enabled: bool) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Sticky_Mouse_Buttons, c.int(enabled))
}

/* Tells if the sticky mouse buttons input mode is enabled. */
get_sticky_mouse_buttons :: proc "contextless" (window: Window) -> bool {
	return glfw.GetInputMode(window, transmute(c.int)Input_Mode.Sticky_Mouse_Buttons) == 1
}

/* Sets the input mode of locking key modifiers. */
enable_lock_key_mods :: proc "contextless" (window: Window, enabled: bool) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Lock_Key_Mods, c.int(enabled))
}

/* Tells if the locking key modifiers input mode is enabled. */
get_lock_keys :: proc "contextless" (window: Window) -> bool {
	return glfw.GetInputMode(window, transmute(c.int)Input_Mode.Lock_Key_Mods) == 1
}

/* Sets the input mode of raw mouse motion. */
enable_raw_mouse_motion :: proc "contextless" (window: Window, enabled: bool) {
	glfw.SetInputMode(window, transmute(c.int)Input_Mode.Raw_Mouse_Motion, c.int(enabled))
}

/* Tells if the raw mouse motion input mode is enabled. */
get_raw_mouse_motion :: proc "contextless" (window: Window) -> bool {
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
	Left   = MOUSE_BUTTON_1,
	Right  = MOUSE_BUTTON_2,
	Middle = MOUSE_BUTTON_3,
	Four   = MOUSE_BUTTON_4,
	Five   = MOUSE_BUTTON_5,
	Six    = MOUSE_BUTTON_6,
	Seven  = MOUSE_BUTTON_7,
	Eight  = MOUSE_BUTTON_8,
	Last   = MOUSE_BUTTON_8,
}

/* Convert a GLFW raw mouse button integer to idiomatic `Mouse_Button` enum */
convert_mouse_button :: proc "contextless" (button: c.int) -> Mouse_Button {
	return transmute(Mouse_Button)button
}

/* Returns the last reported state of a mouse button for the specified window. */
get_mouse_button :: proc "contextless" (window: Window, button: Mouse_Button) -> Action {
	return transmute(Action)glfw.GetMouseButton(window, transmute(c.int)button)
}
