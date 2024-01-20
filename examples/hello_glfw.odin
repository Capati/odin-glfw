package main

// Core
import "core:fmt"
import "core:runtime"

// Vendor
import gl "vendor:OpenGL"

// Libs
import "../glfw"

OPEN_GL_VERSION_MAJOR :: 4
OPEN_GL_VERSION_MINOR :: 6

error_callback :: proc "c" (code: i32, description: cstring) {
	context = runtime.default_context()
	fmt.eprintf("GLFW Error [%v]: %s\n", glfw.convert_error(code), description)
}

main :: proc() {
	glfw.set_error_callback(error_callback)

	glfw_version := glfw.get_version()
	fmt.printf("GLFW: %d.%d.%d\n", expand_values(glfw_version))

	if !glfw.init() do panic("Unable to initialize the GLFW library")
	defer glfw.terminate()

	platform := glfw.get_platform()
	fmt.printf("Platform: %v\n", platform)

	glfw.window_hint(.Context_Version_Major, OPEN_GL_VERSION_MAJOR)
	glfw.window_hint(.Context_Version_Minor, OPEN_GL_VERSION_MINOR)
	glfw.window_hint(.OpenGL_Profile, glfw.OpenGL_Profile.Core)
	when ODIN_OS == .Darwin {
		glfw.window_hint(.OpenGL_Profile, glfw.OpenGL_Profile.Compat)
	}
	// Start hidden, so we can center the window "behind the scene" to avoid window jump
	glfw.window_hint(.Visible, false)

	window := glfw.create_window(800, 600, "Window")
	assert(window != nil, "Unable to create the GLFW window")
	defer glfw.destroy_window(window)

	// Show a centered window
	glfw.center_window(window)
	glfw.show_window(window)

	glfw.make_context_current(window)
	gl.load_up_to(OPEN_GL_VERSION_MAJOR, OPEN_GL_VERSION_MINOR, glfw.gl_set_proc_address)

	for !glfw.window_should_close(window) {
		glfw.poll_events()

		gl.ClearColor(0.2, 0.3, 0.3, 1.0)
		gl.Clear(gl.COLOR_BUFFER_BIT)

		glfw.swap_buffers(window)
	}
}
