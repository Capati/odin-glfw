package glfw

// Core
import "core:c"
import "core:runtime"

// Bindings
import glfw "bindings"

/* All GLFW keys */
Key :: enum c.int {
	// The unknown key
	Unknown       = KEY_UNKNOWN,

	// Printable keys
	Space         = KEY_SPACE,
	Apostrophe    = KEY_APOSTROPHE,
	Comma         = KEY_COMMA,
	Minus         = KEY_MINUS,
	Period        = KEY_PERIOD,
	Slash         = KEY_SLASH,
	Zero          = KEY_0,
	One           = KEY_1,
	Two           = KEY_2,
	Three         = KEY_3,
	Four          = KEY_4,
	Five          = KEY_5,
	Six           = KEY_6,
	Seven         = KEY_7,
	Eight         = KEY_8,
	Nine          = KEY_9,
	Semicolon     = KEY_SEMICOLON,
	Equal         = KEY_EQUAL,
	A             = KEY_A,
	B             = KEY_B,
	C             = KEY_C,
	D             = KEY_D,
	E             = KEY_E,
	F             = KEY_F,
	G             = KEY_G,
	H             = KEY_H,
	I             = KEY_I,
	J             = KEY_J,
	K             = KEY_K,
	L             = KEY_L,
	M             = KEY_M,
	N             = KEY_N,
	O             = KEY_O,
	P             = KEY_P,
	Q             = KEY_Q,
	R             = KEY_R,
	S             = KEY_S,
	T             = KEY_T,
	U             = KEY_U,
	V             = KEY_V,
	W             = KEY_W,
	X             = KEY_X,
	Y             = KEY_Y,
	Z             = KEY_Z,
	Left_Bracket  = KEY_LEFT_BRACKET,
	Backslash     = KEY_BACKSLASH,
	Right_Bracket = KEY_RIGHT_BRACKET,
	Grave_Accent  = KEY_GRAVE_ACCENT,
	World_1       = KEY_WORLD_1, // non-US #1
	World_2       = KEY_WORLD_2, // non-US #2

	// Function keys
	Escape        = KEY_ESCAPE,
	Enter         = KEY_ENTER,
	Tab           = KEY_TAB,
	Backspace     = KEY_BACKSPACE,
	Insert        = KEY_INSERT,
	Delete        = KEY_DELETE,
	Right         = KEY_RIGHT,
	Left          = KEY_LEFT,
	Down          = KEY_DOWN,
	Up            = KEY_UP,
	Page_Up       = KEY_PAGE_UP,
	Page_Down     = KEY_PAGE_DOWN,
	Home          = KEY_HOME,
	End           = KEY_END,
	Caps_Lock     = KEY_CAPS_LOCK,
	Scroll_Lock   = KEY_SCROLL_LOCK,
	Num_Lock      = KEY_NUM_LOCK,
	Print_Screen  = KEY_PRINT_SCREEN,
	Pause         = KEY_PAUSE,
	F1            = KEY_F1,
	F2            = KEY_F2,
	F3            = KEY_F3,
	F4            = KEY_F4,
	F5            = KEY_F5,
	F6            = KEY_F6,
	F7            = KEY_F7,
	F8            = KEY_F8,
	F9            = KEY_F9,
	F10           = KEY_F10,
	F11           = KEY_F11,
	F12           = KEY_F12,
	F13           = KEY_F13,
	F14           = KEY_F14,
	F15           = KEY_F15,
	F16           = KEY_F16,
	F17           = KEY_F17,
	F18           = KEY_F18,
	F19           = KEY_F19,
	F20           = KEY_F20,
	F21           = KEY_F21,
	F22           = KEY_F22,
	F23           = KEY_F23,
	F24           = KEY_F24,
	F25           = KEY_F25,
	Kp_0          = KEY_KP_0,
	Kp_1          = KEY_KP_1,
	Kp_2          = KEY_KP_2,
	Kp_3          = KEY_KP_3,
	Kp_4          = KEY_KP_4,
	Kp_5          = KEY_KP_5,
	Kp_6          = KEY_KP_6,
	Kp_7          = KEY_KP_7,
	Kp_8          = KEY_KP_8,
	Kp_9          = KEY_KP_9,
	Kp_Decimal    = KEY_KP_DECIMAL,
	Kp_Divide     = KEY_KP_DIVIDE,
	Kp_Multiply   = KEY_KP_MULTIPLY,
	Kp_Subtract   = KEY_KP_SUBTRACT,
	Kp_Add        = KEY_KP_ADD,
	Kp_Enter      = KEY_KP_ENTER,
	Kp_Equal      = KEY_KP_EQUAL,
	Left_Shift    = KEY_LEFT_SHIFT,
	Left_Control  = KEY_LEFT_CONTROL,
	Left_Alt      = KEY_LEFT_ALT,
	Left_Super    = KEY_LEFT_SUPER,
	Right_Shift   = KEY_RIGHT_SHIFT,
	Right_Control = KEY_RIGHT_CONTROL,
	Right_Alt     = KEY_RIGHT_ALT,
	Right_Super   = KEY_RIGHT_SUPER,
	Menu          = KEY_MENU,
}

/* Convert a GLFW raw key integer to idiomatic `Key` enum */
convert_key :: proc "contextless" (key: c.int) -> Key {
	return transmute(Key)key
}

/* Returns the layout-specific name of the specified printable key. */
get_key_name :: proc "contextless" (key: Key, scancode: i32) -> string {
	return string(glfw.GetKeyName(transmute(c.int)key, scancode))
}

/* Returns the platform-specific scancode of the specified key. */
get_key_scancode :: proc "contextless" (key: Key) -> i32 {
	return i32(glfw.GetKeyScancode(transmute(c.int)key))
}

/* Key and button actions. */
Action :: enum c.int {
	Release = RELEASE,
	Press   = PRESS,
	Repeat  = REPEAT,
}

/* Returns the last reported state of a keyboard key for the specified window. */
get_key :: proc "contextless" (window: Window, key: Key, loc := #caller_location) -> Action {
	when ODIN_DEBUG {
		context = runtime.default_context()
		assert(key != .Unknown, "'Unknown' is not a valid key", loc)
	}

	return transmute(Action)glfw.GetKey(window, transmute(c.int)key)
}
