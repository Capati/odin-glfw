package glfw

// Core
import "core:c"

// Bindings
import glfw "bindings"

/* Opaque window object. */
Window :: glfw.Window

/* Opaque monitor object. */
Monitor :: glfw.Monitor

/* Opaque cursor object. */
Cursor :: glfw.Cursor

/* Custom allocator object. */
Allocator :: glfw.Allocator

Gamepad_Buttons_State :: struct {
	a:             bool,
	b:             bool,
	x:             bool,
	y:             bool,
	left_bumper:   bool,
	right_bumper:  bool,
	back:          bool,
	start:         bool,
	guide:         bool,
	left_thumb:    bool,
	right_thumb:   bool,
	dpad_up:       bool,
	dpad_right:    bool,
	dpad_down:     bool,
	dpad_left:     bool,
	left_trigger:  bool,
	right_trigger: bool,
}

Gamepad_Axes_State :: struct {
	left_x:        f32,
	left_y:        f32,
	right_x:       f32,
	right_y:       f32,
	left_trigger:  f32,
	right_trigger: f32,
}

/* Input state of a gamepad. */
Gamepad_State :: struct {
	buttons: Gamepad_Buttons_State,
	axes:    Gamepad_Axes_State,
}

/* Describes a single 2D image. */
Image :: struct {
	width, height: u32,
	pixels:        []byte,
}

/* Describes the gamma ramp for a monitor. */
Gamma_Ramp :: struct {
	red, green, blue: []u16,
}

/* This describes a single video mode. */
Video_Mode :: struct {
	width, height:                   i32,
	red_bits, green_bits, blue_bits: i32,
	refresh_rate:                    i32,
}

/* Event status for the configuration */
Event_Status :: enum c.int {
	Connected    = CONNECTED,
	Disconnected = DISCONNECTED,
}
