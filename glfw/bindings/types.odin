package glfw_bindings

// Core
import "core:c"

@(private)
Handle :: rawptr

Monitor :: distinct Handle
Window :: distinct Handle
Cursor :: distinct Handle

Allocate_Proc :: #type proc "c" (size: c.size_t, user: rawptr)
Reallocate_Proc :: #type proc "c" (block: rawptr, size: c.size_t, user: rawptr)
Deallocate_Proc :: #type proc "c" (block: rawptr, user: rawptr)
Error_Proc :: #type proc "c" (code: c.int, description: cstring)
Window_Pos_Proc :: #type proc "c" (window: Window, xpos, ypos: c.int)
Window_Size_Proc :: #type proc "c" (window: Window, width, height: c.int)
Window_Close_Proc :: #type proc "c" (window: Window)
Window_Refresh_Proc :: #type proc "c" (window: Window)
Window_Focus_Proc :: #type proc "c" (window: Window, focused: c.int)
Window_Iconify_Proc :: #type proc "c" (window: Window, iconified: b32)
Window_Maximize_Proc :: #type proc "c" (window: Window, maximized: b32)
Framebuffer_Size_Proc :: #type proc "c" (window: Window, width, height: c.int)
Window_Content_Scale_Proc :: #type proc "c" (window: Window, xscale, yscale: f32)
Mouse_Button_Proc :: #type proc "c" (window: Window, button, action, mods: c.int)
Cursor_Pos_Proc :: #type proc "c" (window: Window, xpos, ypos: f64)
Cursor_Enter_Proc :: #type proc "c" (window: Window, entered: b32)
Scroll_Proc :: #type proc "c" (window: Window, xoffset, yoffset: f64)
Key_Proc :: #type proc "c" (window: Window, key, scancode, action, mods: c.int)
Char_Proc :: #type proc "c" (window: Window, codepoint: rune)
Char_Mods_Proc :: #type proc "c" (window: Window, codepoint: rune, mods: c.int)
Drop_Proc :: #type proc "c" (window: Window, count: c.int, paths: [^]cstring)
Monitor_Proc :: #type proc "c" (monitor: Monitor, event: c.int)
Joystick_Proc :: #type proc "c" (joy, event: c.int)

Video_Mode :: struct {
	width:        c.int,
	height:       c.int,
	red_bits:     c.int,
	green_bits:   c.int,
	blue_bits:    c.int,
	refresh_rate: c.int,
}

Gamma_Ramp :: struct {
	red, green, blue: [^]c.ushort,
	size:             c.uint,
}

Image :: struct {
	width, height: c.int,
	pixels:        [^]u8,
}

Gamepad_State :: struct {
	buttons: [15]u8,
	axes:    [6]f32,
}

Allocator :: struct {
	allocate:   Allocate_Proc,
	reallocate: Reallocate_Proc,
	deallocate: Deallocate_Proc,
	user:       rawptr,
}
