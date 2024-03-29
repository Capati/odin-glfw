package glfw

// Core
import "core:c"

// Bindings
import glfw "bindings"

/* Joystick IDs. */
Joystick_ID :: enum c.int {
	One      = JOYSTICK_1,
	Two      = JOYSTICK_2,
	Three    = JOYSTICK_3,
	Four     = JOYSTICK_4,
	Five     = JOYSTICK_5,
	Six      = JOYSTICK_6,
	Seven    = JOYSTICK_7,
	Eight    = JOYSTICK_8,
	Nine     = JOYSTICK_9,
	Ten      = JOYSTICK_10,
	Eleven   = JOYSTICK_11,
	Twelve   = JOYSTICK_12,
	Thirteen = JOYSTICK_13,
	Fourteen = JOYSTICK_14,
	Fifteen  = JOYSTICK_15,
	Sixteen  = JOYSTICK_16,
	Last     = JOYSTICK_16,
}

/* Convert a GLFW raw joystick id integer to idiomatic `Joystick_ID` enum */
convert_joystick_id :: proc "contextless" (id: c.int) -> Joystick_ID {
	return transmute(Joystick_ID)id
}

/* Returns whether the specified joystick is present. */
joystick_present :: proc "contextless" (id: Joystick_ID) -> bool {
	return bool(glfw.JoystickPresent(transmute(c.int)id))
}

/* Returns the values of all axes of the specified joystick. */
get_joystick_axes :: proc "contextless" (id: Joystick_ID) -> []f32 {
	count: c.int
	axis := glfw.GetJoystickAxes(transmute(c.int)id, &count)

	if count > 0 && axis != nil {
		return axis[:count]
	}

	return {}
}

/* Returns the state of all buttons of the specified joystick. */
get_joystick_buttons :: proc "contextless" (id: Joystick_ID) -> []u8 {
	count: c.int
	buttons := glfw.GetJoystickButtons(transmute(c.int)id, &count)

	if count > 0 && buttons != nil {
		return buttons[:count]
	}

	return {}
}

/* Holds all GLFW hat values in their raw form. */
Joystick_Hat :: struct {
	centered:   bool,
	up:         bool,
	right:      bool,
	down:       bool,
	left:       bool,
	right_up:   bool,
	right_down: bool,
	left_up:    bool,
	left_down:  bool,
}

/* Returns the state of all hats of the specified joystick. */
get_joystick_hats :: proc(id: Joystick_ID) -> []u8 {
	count: c.int
	hats := glfw.GetJoystickHats(transmute(c.int)id, &count)

	if count > 0 && hats != nil {
		return hats[:count]
	}

	return {}
}

/* Returns the state of the given raw hat. */
get_hat_state_from_raw_hat :: proc "contextless" (hat: u8) -> (ret: Joystick_Hat) {
	ret.centered = (hat & HAT_CENTERED) != 0
	ret.up = (hat & HAT_UP) != 0
	ret.right = (hat & HAT_RIGHT) != 0
	ret.down = (hat & HAT_DOWN) != 0
	ret.left = (hat & HAT_LEFT) != 0
	ret.right_up = (hat & HAT_RIGHT_UP) != 0
	ret.right_down = (hat & HAT_RIGHT_DOWN) != 0
	ret.left_up = (hat & HAT_LEFT_UP) != 0
	ret.left_down = (hat & HAT_LEFT_DOWN) != 0
	return
}

/* Returns the state of the specified joystick for the given hat state. */
get_hat_state_from_state :: proc "contextless" (
	id: Joystick_ID,
	state: u32,
) -> (
	red: Joystick_Hat,
) {
	count: c.int
	hats := glfw.GetJoystickHats(transmute(c.int)id, &count)

	if count > 0 && state <= u32(count) && hats != nil {
		slice := hats[:count]
		return get_hat_state_from_raw_hat(slice[state])
	}

	return {}
}

/* Returns the state of a hat. */
get_hst_state :: proc {
	get_hat_state_from_raw_hat,
	get_hat_state_from_state,
}

/* Returns the name of the specified joystick. */
get_joystick_name :: proc "contextless" (id: Joystick_ID) -> string {
	return string(glfw.GetJoystickName(transmute(c.int)id))
}

/* Returns the SDL compatible GUID of the specified joystick. */
get_joystick_guid :: proc "contextless" (id: Joystick_ID) -> string {
	return string(glfw.GetJoystickGUID(transmute(c.int)id))
}

/* Sets the user pointer of the specified joystick. */
set_joystick_user_pointer :: proc "contextless" (id: Joystick_ID, pointer: rawptr) {
	glfw.SetJoystickUserPointer(transmute(c.int)id, pointer)
}

/* Sets the user pointer of the specified joystick. */
get_joystick_user_pointer :: proc "contextless" (id: Joystick_ID, $T: typeid) -> ^T {
	pointer := glfw.GetJoystickUserPointer(transmute(c.int)id)

	if pointer != nil {
		return cast(^T)pointer
	}

	return nil
}

/* Returns whether the specified joystick has a gamepad mapping. */
joystick_is_gamepad :: proc "contextless" (id: Joystick_ID) -> bool {
	return bool(glfw.JoystickIsGamepad(transmute(c.int)id))
}

/* Adds the specified SDL_GameControllerDB gamepad mappings. */
update_gamepad_mappings :: proc "contextless" (char: cstring) -> bool {
	return bool(glfw.UpdateGamepadMappings(char))
}

/* Returns the human-readable gamepad name for the specified joystick. */
get_gamepad_name :: proc "contextless" (id: Joystick_ID) -> string {
	return string(glfw.GetGamepadName(transmute(c.int)id))
}

/* Retrieves the state of the specified joystick remapped as a gamepad. */
get_gamepad_state :: proc "contextless" (
	id: Joystick_ID,
) -> (
	state: Gamepad_State,
	success: bool,
) #optional_ok {
	raw: glfw.Gamepad_State
	success = bool(glfw.GetGamepadState(transmute(c.int)id, &raw))
	if !success do return

	state.buttons = Gamepad_Buttons_State {
		a             = raw.buttons[GAMEPAD_BUTTON_A] != 0,
		b             = raw.buttons[GAMEPAD_BUTTON_B] != 0,
		x             = raw.buttons[GAMEPAD_BUTTON_X] != 0,
		y             = raw.buttons[GAMEPAD_BUTTON_Y] != 0,
		left_bumper   = raw.buttons[GAMEPAD_BUTTON_LEFT_BUMPER] != 0,
		right_bumper  = raw.buttons[GAMEPAD_BUTTON_RIGHT_BUMPER] != 0,
		back          = raw.buttons[GAMEPAD_BUTTON_BACK] != 0,
		start         = raw.buttons[GAMEPAD_BUTTON_START] != 0,
		guide         = raw.buttons[GAMEPAD_BUTTON_GUIDE] != 0,
		left_thumb    = raw.buttons[GAMEPAD_BUTTON_LEFT_THUMB] != 0,
		right_thumb   = raw.buttons[GAMEPAD_BUTTON_RIGHT_THUMB] != 0,
		dpad_up       = raw.buttons[GAMEPAD_BUTTON_DPAD_UP] != 0,
		dpad_right    = raw.buttons[GAMEPAD_BUTTON_DPAD_RIGHT] != 0,
		dpad_down     = raw.buttons[GAMEPAD_BUTTON_DPAD_DOWN] != 0,
		dpad_left     = raw.buttons[GAMEPAD_BUTTON_DPAD_LEFT] != 0,
		left_trigger  = raw.axes[GAMEPAD_AXIS_LEFT_TRIGGER] > 0.0,
		right_trigger = raw.axes[GAMEPAD_AXIS_RIGHT_TRIGGER] > 0.0,
	}

	state.axes = Gamepad_Axes_State {
		left_x        = raw.axes[GAMEPAD_AXIS_LEFT_X],
		left_y        = raw.axes[GAMEPAD_AXIS_LEFT_Y],
		right_x       = raw.axes[GAMEPAD_AXIS_RIGHT_X],
		right_y       = raw.axes[GAMEPAD_AXIS_RIGHT_Y],
		left_trigger  = raw.axes[GAMEPAD_AXIS_LEFT_TRIGGER],
		right_trigger = raw.axes[GAMEPAD_AXIS_RIGHT_TRIGGER],
	}

	return
}
