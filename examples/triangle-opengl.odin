package main

// Core
import "core:bytes"
import "core:fmt"
import "core:image"
import "core:image/png"
import glm "core:math/linalg/glsl"
_ :: png

// Vendor
import gl "vendor:OpenGL"

// Libs
import "../glfw"

OPEN_GL_VERSION_MAJOR :: 3
OPEN_GL_VERSION_MINOR :: 3

WINDOW_WIDTH :: 640
WINDOW_HEIGHT :: 480

Vertex :: struct {
	pos: glm.vec2,
	col: glm.vec3,
}

vertices := [3]Vertex {
	{{-0.6, -0.4}, {1.0, 0.0, 0.0}},
	{{0.6, -0.4}, {0.0, 1.0, 0.0}},
	{{0.0, 0.6}, {0.0, 0.0, 1.0}},
}

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
	monitor := glfw.get_primary_monitor()
	video_mode := glfw.get_video_mode(monitor)

	glfw.window_hint(.Position_X, video_mode.width / 2 - WINDOW_WIDTH / 2)
	glfw.window_hint(.Position_Y, video_mode.height / 2 - WINDOW_HEIGHT / 2)

	// Enabled custom events types
	enabled_events := glfw.Enabled_Events_Flags{.Key, .Framebuffer_Size}

	window := glfw.create_window(
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
		"OpenGL Triangle in Odin Language",
		nil,
		nil,
		enabled_events,
	)
	assert(window != nil, "Unable to create the GLFW window")
	defer glfw.destroy_window(window)

	image1, _ := image.load_from_bytes(#load("./icon-16.png"))
	image2, _ := image.load_from_bytes(#load("./icon-32.png"))

	glfw.set_window_icon(
		window,
		& {
			{16, 16, bytes.buffer_to_bytes(&image1.pixels)},
			{32, 32, bytes.buffer_to_bytes(&image2.pixels)},
		},
	)
	image.destroy(image1);image.destroy(image2)

	// Create the OpenGL context for the current window
	glfw.make_context_current(window)
	gl.load_up_to(OPEN_GL_VERSION_MAJOR, OPEN_GL_VERSION_MINOR, glfw.gl_set_proc_address)

	framebuffer_size := glfw.get_framebuffer_size(window)
	gl.Viewport(0, 0, i32(framebuffer_size.width), i32(framebuffer_size.height))

	glfw.swap_interval(1)

	// NOTE: OpenGL error checks have been omitted for brevity

	vertex_buffer: u32
	gl.GenBuffers(1, &vertex_buffer)
	gl.BindBuffer(gl.ARRAY_BUFFER, vertex_buffer)
	gl.BufferData(gl.ARRAY_BUFFER, size_of(vertices), raw_data(vertices[:]), gl.STATIC_DRAW)

	vertex_shader_text := #load("./vertex.vert", cstring)
	vertex_shader := gl.CreateShader(gl.VERTEX_SHADER)
	gl.ShaderSource(vertex_shader, 1, &vertex_shader_text, nil)
	gl.CompileShader(vertex_shader)

	fragment_shader_text := #load("./fragment.frag", cstring)
	fragment_shader := gl.CreateShader(gl.FRAGMENT_SHADER)
	gl.ShaderSource(fragment_shader, 1, &fragment_shader_text, nil)
	gl.CompileShader(fragment_shader)

	program := gl.CreateProgram()
	gl.AttachShader(program, vertex_shader)
	gl.AttachShader(program, fragment_shader)
	gl.LinkProgram(program)

	mvp_location := gl.GetUniformLocation(program, "MVP")
	vpos_location := gl.GetAttribLocation(program, "vPos")
	vcol_location := gl.GetAttribLocation(program, "vCol")

	vertex_array: u32
	gl.GenVertexArrays(1, &vertex_array)
	gl.BindVertexArray(vertex_array)
	gl.EnableVertexAttribArray(u32(vpos_location))
	gl.VertexAttribPointer(
		u32(vpos_location),
		2,
		gl.FLOAT,
		false,
		size_of(Vertex),
		offset_of(Vertex, pos),
	)
	gl.EnableVertexAttribArray(u32(vcol_location))
	gl.VertexAttribPointer(
		u32(vcol_location),
		3,
		gl.FLOAT,
		false,
		size_of(Vertex),
		offset_of(Vertex, col),
	)

	initial_size := glfw.get_framebuffer_size(window)
	ratio := f32(initial_size.width) / f32(initial_size.height)

	for !glfw.window_should_close(window) {
		// Process events to trigger event callbacks and fill the custom event loop
		glfw.poll_events()

		// Process the custom event loop (similar to SDL)
		for glfw.has_next_event() {
			#partial switch event in glfw.next_event() {
			case glfw.Key_Press_Event:
				if event.key == .Escape {
					glfw.set_window_should_close(window, true)
				}
			case glfw.Framebuffer_Resize_Event:
				ratio = f32(event.size.width) / f32(event.size.height)
				gl.Viewport(0, 0, i32(event.size.width), i32(event.size.height))
			}
		}

		gl.Clear(gl.COLOR_BUFFER_BIT)

		m := glm.mat4Rotate({0.0, 0.0, 1.0}, f32(glfw.get_time()))
		p := glm.mat4Ortho3d(-ratio, ratio, -1.0, 1.0, 1.0, -1.0)
		mvp := p * m

		gl.UseProgram(program)
		gl.UniformMatrix4fv(mvp_location, 1, false, &mvp[0, 0])
		gl.BindVertexArray(vertex_array)
		gl.DrawArrays(gl.TRIANGLES, 0, 3)

		glfw.swap_buffers(window)
	}
}

error_callback :: proc(code: glfw.Error_Code, description: string) {
	fmt.eprintf("GLFW Error [%v]: %s\n", code, description)
}
