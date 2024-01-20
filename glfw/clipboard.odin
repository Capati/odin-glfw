package glfw

// Core
import "core:mem"
import "core:runtime"
import "core:strings"

// Bindings
import glfw "bindings"

/* Sets the clipboard to the specified string. */
set_clipboard_string :: proc(str: string, loc := #caller_location) -> mem.Allocator_Error {
	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()
	c_str := strings.clone_to_cstring(str, context.temp_allocator, loc) or_return
	glfw.SetClipboardString(nil, c_str)
	return nil
}

/* Returns the contents of the clipboard as a string.  */
get_clipboard_string :: proc "contextless" () -> string {
	return string(glfw.GetClipboardString(nil))
}
