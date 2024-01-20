package glfw

// Core
import "core:c"
import "core:runtime"

// Bindings
import glfw "bindings"

/* Makes the context of the specified window current for the calling thread. */
make_context_current :: proc "contextless" (window: Window) {
	glfw.MakeContextCurrent(window)
}

/* Returns the window whose context is current on the calling thread. */
get_current_context :: proc "contextless" () -> Window {
	return glfw.GetCurrentContext()
}

/* Sets the swap interval for the current context. */
swap_interval :: proc "contextless" (interval: i32) {
	glfw.SwapInterval(cast(c.int)interval)
}

/* 	Returns whether the specified extension is available. */
extension_supported :: proc "contextless" (extension: cstring) -> (supported: bool) {
	when ODIN_DEBUG {
		context = runtime.default_context()
		assert(extension == "", "Extension name is invalid")
	}

	return bool(glfw.ExtensionSupported(extension))
}

/* 	Returns the address of the specified function for the current context. */
get_proc_address :: glfw.GetProcAddress

/* Used by `vendor:OpenGL`. */
gl_set_proc_address :: proc(p: rawptr, name: cstring) {
	(^rawptr)(p)^ = get_proc_address(name)
}

/* 	Client API function pointer type. */
// GL_Proc :: #type proc "c" ()
