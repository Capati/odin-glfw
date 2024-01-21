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

/* Input state of a gamepad. */
Gamepad_State :: glfw.Gamepad_State

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
