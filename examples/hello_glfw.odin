package main

// Core
import "core:fmt"

// Vendor
import gl "vendor:OpenGL"

// Libs
import "../glfw"

OPEN_GL_VERSION_MAJOR :: 4
OPEN_GL_VERSION_MINOR :: 6
WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600

main :: proc() {
	// Setup error callback before any GLFW call
	glfw.set_error_callback(error_callback)

	// Get current GLFW version values in major, minor and revision
	glfw_version := glfw.get_version()
	fmt.printf("GLFW: %d.%d.%d\n", expand_values(glfw_version))

	// Get the version and names of all APIs for all the platforms that the library binary supports
	glfw_version_string := glfw.get_version_string()
	fmt.println(glfw_version_string)

	if !glfw.init() do panic("Unable to initialize the GLFW library")
	defer glfw.terminate()

	// Get the selected platform
	platform := glfw.get_platform()
	fmt.printf("Platform: %v\n", platform)

	// Setup OpenGL context
	glfw.window_hint(.Context_Version_Major, OPEN_GL_VERSION_MAJOR)
	glfw.window_hint(.Context_Version_Minor, OPEN_GL_VERSION_MINOR)
	glfw.window_hint(.OpenGL_Profile, glfw.OpenGL_Profile.Core)

	when ODIN_OS == .Darwin {
		glfw.window_hint(.OpenGL_Profile, glfw.OpenGL_Profile.Compat)
	}

	// Center the window using Position_X and Position_Y window hints.
	// This removes the need to create a hidden window, move it and then show it
	{
		monitor := glfw.get_primary_monitor()
		video_mode := glfw.get_video_mode(monitor)

		glfw.window_hint(.Position_X, video_mode.width / 2 - WINDOW_WIDTH / 2)
		glfw.window_hint(.Position_Y, video_mode.height / 2 - WINDOW_HEIGHT / 2)
	}

	window := glfw.create_window(WINDOW_WIDTH, WINDOW_HEIGHT, "Window")
	assert(window != nil, "Unable to create the GLFW window")
	defer glfw.destroy_window(window)

	// Enable Caps Lock and Num Lock modifiers
	glfw.enable_lock_key_mods(window, true)
	// The same as above:
	// glfw.set_input_mode(window, .Lock_Key_Mods, true)

	glfw.set_framebuffer_size_callback(window, framebuffer_size_callback)

	// Create the OpenGL context for the current window
	glfw.make_context_current(window)
	gl.load_up_to(OPEN_GL_VERSION_MAJOR, OPEN_GL_VERSION_MINOR, glfw.gl_set_proc_address)

	for !glfw.window_should_close(window) {
		glfw.poll_events()

		// Process the custom event loop (similar to SDL)
		for glfw.has_next_event() {
			#partial switch event in glfw.next_event() {
			case glfw.Close_Event:
				fmt.println("Closing...")
			case glfw.Key_Press_Event:
				if event.key == .Escape {
					glfw.set_window_should_close(window, true)
				}
			case glfw.Framebuffer_Resize_Event:
			case glfw.Window_Resize_Event:
			case glfw.Key_Release_Event:
			case glfw.Key_Repeat_Event:
			case glfw.Focus_Event:
			case glfw.Char_Event:
			case glfw.Mouse_Motion_Event:
			case glfw.Mouse_Button_Press_Event:
			case glfw.Mouse_Button_Release_Event:
			case glfw.Mouse_Scroll_Event:
			case glfw.Cursor_Enter_Event:
			case glfw.Joystick_Connected_Event:
			case glfw.Joystick_Disconnected_Event:
			case glfw.Iconified_Event:
			case glfw.Maximized_Event:
			case glfw.Window_Pos_Event:
			case glfw.Window_Refresh_Event:
			case glfw.Paths_Drop_Event:
			}
		}

		gl.ClearColor(0.2, 0.3, 0.3, 1.0)
		gl.Clear(gl.COLOR_BUFFER_BIT)

		// My OpenGL commands...

		glfw.swap_buffers(window)
	}
}

error_callback :: proc(code: glfw.Error_Code, description: string) {
	fmt.eprintf("GLFW Error [%v]: %s\n", code, description)
}

framebuffer_size_callback :: proc(window: glfw.Window, size: glfw.Framebuffer_Size) {
	gl.Viewport(0, 0, i32(size.width), i32(size.height))
}
