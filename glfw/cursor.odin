package glfw

// Core
import "core:c"

// Bindings
import glfw "bindings"

Cursor_Position :: struct {
	x, y: f64,
}

/* Retrieves the position of the cursor relative to the content area of the window. */
get_cursor_pos :: proc "contextless" (window: Window) -> Cursor_Position {
	x_pos, y_pos: c.double
	glfw.GetCursorPos(window, &x_pos, &y_pos)
	return {f64(x_pos), f64(y_pos)}
}

/* Sets the position of the cursor, relative to the content area of the window. */
set_cursor_pos :: proc "contextless" (window: Window, pos: Cursor_Position) {
	glfw.SetCursorPos(window, c.double(pos.x), c.double(pos.y))
}

/* Creates a custom cursor. */
create_cursor :: proc "contextless" (image: ^Image, x_hot, y_hot: i32) -> Cursor {
	raw_image := glfw.Image {
		width  = c.int(image.width),
		height = c.int(image.height),
		pixels = raw_data(image.pixels[:]),
	}

	return glfw.CreateCursor(&raw_image, x_hot, y_hot)
}

/* Standard system cursor shapes. */
Cursor_Shape :: enum c.int {
	Arrow         = ARROW_CURSOR,
	Ibeam         = IBEAM_CURSOR,
	Crosshair     = CROSSHAIR_CURSOR,
	Pointing_Hand = POINTING_HAND_CURSOR,
	Resize_Ew     = RESIZE_EW_CURSOR,
	Resize_Ns     = RESIZE_NS_CURSOR,
	Resize_Nwse   = RESIZE_NWSE_CURSOR,
	Resize_Nesw   = RESIZE_NESW_CURSOR,
	Resize_All    = RESIZE_ALL_CURSOR,
	Not_Allowed   = NOT_ALLOWED_CURSOR,
}

/* Convert a GLFW raw cursor shape integer to idiomatic `Cursor_Shape` enum */
convert_cursor_shape :: proc "contextless" (shape: c.int) -> Cursor_Shape {
	return transmute(Cursor_Shape)shape
}

/* Creates a cursor with a standard shape. */
create_standard_cursor :: proc "contextless" (shape: Cursor_Shape) -> Cursor {
	return glfw.CreateStandardCursor(transmute(c.int)shape)
}

/* Destroys a cursor. */
destroy_cursor :: proc "contextless" (cursor: Cursor) {
	glfw.DestroyCursor(cursor)
}

/* Sets the cursor for the window. */
set_cursor :: proc "contextless" (window: Window, cursor: Cursor) {
	glfw.SetCursor(window, cursor)
}
