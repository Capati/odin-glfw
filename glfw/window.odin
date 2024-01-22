package glfw

// Core
import "core:c"
import "core:mem"
import "core:runtime"
import "core:strings"

// Bindings
import glfw "bindings"

/* Resets all window hints to their default values. */
default_window_hints :: glfw.DefaultWindowHints

Client_Api :: enum c.int {
	OpenGL    = OPENGL_API,
	OpenGl_ES = OPENGL_ES_API,
	No_Api    = NO_API,
}

Context_Creation_Api :: enum c.int {
	Native = NATIVE_CONTEXT_API,
	EGL    = EGL_CONTEXT_API,
	OSMesa = OSMESA_CONTEXT_API,
}

Context_Robustness :: enum c.int {
	No_Robustness         = NO_ROBUSTNESS,
	No_Reset_Notification = NO_RESET_NOTIFICATION,
	Lose_Context_On_Reset = LOSE_CONTEXT_ON_RESET,
}

Context_Release_Behavior :: enum c.int {
	Any   = ANY_RELEASE_BEHAVIOR,
	Flush = RELEASE_BEHAVIOR_FLUSH,
	None  = RELEASE_BEHAVIOR_NONE,
}

OpenGL_Profile :: enum c.int {
	Any    = OPENGL_ANY_PROFILE,
	Compat = OPENGL_COMPAT_PROFILE,
	Core   = OPENGL_CORE_PROFILE,
}

// Window hints
Window_Hint :: enum c.int {
	// Window related hints
	Resizable                = RESIZABLE,
	Visible                  = VISIBLE,
	Decorated                = DECORATED,
	Focused                  = FOCUSED,
	Auto_Iconify             = AUTO_ICONIFY,
	Floating                 = FLOATING,
	Maximized                = MAXIMIZED,
	Center_Cursor            = CENTER_CURSOR,
	Transparent_Framebuffer  = TRANSPARENT_FRAMEBUFFER,
	Focus_On_Show            = FOCUS_ON_SHOW,
	Scale_To_Monitor         = SCALE_TO_MONITOR,
	Mouse_Passthrough        = MOUSE_PASSTHROUGH,
	Position_X               = POSITION_X,
	Position_Y               = POSITION_Y,

	// Framebuffer hints
	Red_Bits                 = RED_BITS,
	Green_Bits               = GREEN_BITS,
	Blue_Bits                = BLUE_BITS,
	Alpha_Bits               = ALPHA_BITS,
	Depth_Bits               = DEPTH_BITS,
	Stencil_Bits             = STENCIL_BITS,
	Accum_Red_Bits           = ACCUM_RED_BITS,
	Accum_Green_Bits         = ACCUM_GREEN_BITS,
	Accum_Blue_Bits          = ACCUM_BLUE_BITS,
	Accum_Alpha_Bits         = ACCUM_ALPHA_BITS,
	Aux_Buffers              = AUX_BUFFERS,

	// OpenGL stereoscopic rendering
	Stereo                   = STEREO,

	// Framebuffer MSAA samples
	Samples                  = SAMPLES,

	// Framebuffer sRGB
	Srgb_Capable             = SRGB_CAPABLE,

	// Framebuffer double buffering
	Doublebuffer             = DOUBLEBUFFER,

	// Monitor refresh rate
	Refresh_Rate             = REFRESH_RATE,

	// Context related hints
	Client_Api               = CLIENT_API,
	Context_Creation_Api     = CONTEXT_CREATION_API,
	Context_Version_Major    = CONTEXT_VERSION_MAJOR,
	Context_Version_Minor    = CONTEXT_VERSION_MINOR,
	Opengl_Forward_Compat    = OPENGL_FORWARD_COMPAT,
	Context_Debug            = CONTEXT_DEBUG,
	OpenGL_Profile           = OPENGL_PROFILE,
	Context_Robustness       = CONTEXT_ROBUSTNESS,
	Context_Release_Behavior = CONTEXT_RELEASE_BEHAVIOR,
	Context_No_Error         = CONTEXT_NO_ERROR,

	//  Win32 specific
	Win32_Keyboard_Menu      = WIN32_KEYBOARD_MENU,

	// macOS specific
	Cocoa_Retina_Framebuffer = COCOA_RETINA_FRAMEBUFFER,
	Cocoa_Frame_Name         = COCOA_FRAME_NAME,
	Cocoa_Graphics_Switching = COCOA_GRAPHICS_SWITCHING,

	// X11 specific
	X11_Class_Name           = X11_CLASS_NAME,
	X11_Instance_Name        = X11_INSTANCE_NAME,

	// Wayland specific
	Wayland_App_ID           = WAYLAND_APP_ID,
}

@(private)
window_hint_bool :: proc "contextless" (hint: Window_Hint, value: bool, loc := #caller_location) {
	#partial switch hint {
	case .Resizable, .Visible, .Decorated, .Focused, .Auto_Iconify, .Floating, .Maximized,
	.Center_Cursor, .Transparent_Framebuffer, .Focus_On_Show, .Mouse_Passthrough,
	.Scale_To_Monitor, .Stereo, .Srgb_Capable, .Doublebuffer, .Context_No_Error,
	.Context_Debug, .Opengl_Forward_Compat, .Cocoa_Retina_Framebuffer,
	.Cocoa_Graphics_Switching, .Win32_Keyboard_Menu:
		glfw.WindowHint(transmute(c.int)hint, cast(c.int)value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'bool' value does not support the given window hint", loc)
		}
	}
}

@(private)
window_hint_int :: proc "contextless" (hint: Window_Hint, value: i32, loc := #caller_location) {
	#partial switch hint {
	case .Red_Bits, .Green_Bits, .Blue_Bits, .Alpha_Bits, .Depth_Bits, .Stencil_Bits,
	.Accum_Red_Bits, .Accum_Green_Bits, .Accum_Blue_Bits, .Accum_Alpha_Bits, .Aux_Buffers,
	.Samples, .Refresh_Rate, .Context_Version_Major, .Context_Version_Minor, .Position_X,
	.Position_Y:
		glfw.WindowHint(transmute(c.int)hint, value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'integer' value does not support the given window hint", loc)
		}
	}
}

@(private)
window_hint_cstring :: proc "contextless" (
	hint: Window_Hint,
	value: cstring,
	loc := #caller_location,
) {
	#partial switch hint {
	case .Cocoa_Frame_Name, .X11_Class_Name, .X11_Instance_Name:
		glfw.WindowHintString(transmute(c.int)hint, value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'cstring' value does not support the given window hint", loc)
		}
	}
}

@(private)
window_hint_client_api :: proc "contextless" (
	hint: Window_Hint,
	value: Client_Api,
	loc := #caller_location,
) {
	#partial switch hint {
	case .Client_Api:
		glfw.WindowHint(transmute(c.int)hint, transmute(c.int)value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'Client_Api' value does not support the given window hint", loc)
		}
	}
}

@(private)
window_hint_context_creation_api :: proc "contextless" (
	hint: Window_Hint,
	value: Context_Creation_Api,
	loc := #caller_location,
) {
	#partial switch hint {
	case .Context_Creation_Api:
		glfw.WindowHint(transmute(c.int)hint, transmute(c.int)value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'Context_Creation_Api' value does not support the given window hint", loc)
		}
	}
}

@(private)
window_hint_context_robustness :: proc "contextless" (
	hint: Window_Hint,
	value: Context_Robustness,
	loc := #caller_location,
) {
	#partial switch hint {
	case .Context_Robustness:
		glfw.WindowHint(transmute(c.int)hint, transmute(c.int)value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'Context_Robustness' value does not support the given window hint", loc)
		}
	}
}

@(private)
window_hint_context_release_behavior :: proc "contextless" (
	hint: Window_Hint,
	value: Context_Release_Behavior,
	loc := #caller_location,
) {
	#partial switch hint {
	case .Context_Release_Behavior:
		glfw.WindowHint(transmute(c.int)hint, transmute(c.int)value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic(
				"The 'Context_Release_Behavior' value does not support the given window hint",
				loc,
			)
		}
	}
}

@(private)
window_hint_open_gl_profile :: proc "contextless" (
	hint: Window_Hint,
	value: OpenGL_Profile,
	loc := #caller_location,
) {
	#partial switch hint {
	case .OpenGL_Profile:
		glfw.WindowHint(transmute(c.int)hint, transmute(c.int)value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'OpenGL_Profile' value does not support the given window hint", loc)
		}
	}
}

/* Sets the specified window hint to the desired value. */
window_hint :: proc {
	window_hint_bool,
	window_hint_int,
	window_hint_cstring,
	window_hint_client_api,
	window_hint_context_creation_api,
	window_hint_context_robustness,
	window_hint_context_release_behavior,
	window_hint_open_gl_profile,
}

/* Creates a window and its associated context. */
create_window :: proc (
	width, height: u32,
	title: string,
	monitor: Monitor = nil,
	share: Window = nil,
	loc := #caller_location,
) -> (
	window: Window,
) {
	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()
	c_title, c_title_err := strings.clone_to_cstring(title, context.temp_allocator, loc)

	if c_title_err != nil do return nil

	window = glfw.CreateWindow(i32(width), i32(height), c_title, monitor, share)

	// Setup custom callbacks
	if window != nil {
		_window_handles[window] = Window_Handle{}
		_setup_window_callbacks(window)
		return
	}

	return nil
}

@(private)
_setup_window_callbacks :: proc (window: Window) {
	if window == nil do return
	// Callbacks used for the custom event loop
	glfw.SetKeyCallback(window, _key_callback)
	glfw.SetCharCallback(window, _char_callback)
	glfw.SetCursorPosCallback(window, _cursor_pos_callback)
	glfw.SetMouseButtonCallback(window, _mouse_button_callback)
	glfw.SetScrollCallback(window, _scroll_callback)
	glfw.SetWindowCloseCallback(window, _close_callback)
	glfw.SetWindowFocusCallback(window, _window_focus_callback)
	glfw.SetCursorEnterCallback(window, _cursor_enter_callback)
	glfw.SetWindowIconifyCallback(window, _window_iconify_callback)
	glfw.SetWindowMaximizeCallback(window, _window_maximize_proc)
	glfw.SetFramebufferSizeCallback(window, _framebuffer_size_callback)
	glfw.SetWindowSizeCallback(window, _window_size_callback)
	glfw.SetWindowPosCallback(window, _window_pos_callback)
	glfw.SetWindowRefreshCallback(window, _window_refresh_callback)
	glfw.SetWindowContentScaleCallback(window, _window_content_scale_callback)
	glfw.SetCharModsCallback(window, _char_mods_callback)
	glfw.SetDropCallback(window, _drop_callback)
}

/* Destroys the specified window and its context. */
destroy_window :: proc(window: Window) {
	if window != nil do delete_key(&_window_handles, window)
	glfw.DestroyWindow(window)
}

/* Checks the close flag of the specified window. */
window_should_close :: proc "contextless" (window: Window) -> bool {
	return bool(glfw.WindowShouldClose(window))
}

/* Sets the close flag of the specified window. */
set_window_should_close :: proc "contextless" (window: Window, value: bool) {
	glfw.SetWindowShouldClose(window, b32(value))
}

/* Sets the title of the specified window. */
/* TODO(Capati): Accept string */
set_window_title :: proc "contextless" (window: Window, title: cstring) {
	glfw.SetWindowTitle(window, title)
}

/* Sets the icon for the specified window. */
set_window_icon :: proc(window: Window, images: ^[]Image) -> mem.Allocator_Error {
	if images != nil {
		runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()
		tmp := make([]glfw.Image, len(images), context.temp_allocator) or_return

		for img, i in images {
			tmp[i] = glfw.Image {
				width  = c.int(img.width),
				height = c.int(img.height),
				pixels = &img.pixels[0],
			}
		}

		glfw.SetWindowIcon(window, c.int(len(images)), raw_data(tmp[:]))
	} else {
		glfw.SetWindowIcon(window, 0, nil)
	}

	return nil
}

Window_Pos :: struct {
	x, y: u32,
}

/* Retrieves the position of the content area of the specified window. */
get_window_pos :: proc "contextless" (window: Window) -> Window_Pos {
	x, y: c.int
	glfw.GetWindowPos(window, &x, &y)
	return { x = u32(x), y = u32(y)}
}

/* 	Sets the position of the content area of the specified window. */
set_window_pos :: proc "contextless" (window: Window, pos: Window_Pos) {
	glfw.SetWindowPos(window, c.int(pos.x), c.int(pos.y))
}

Window_Size :: struct {
	width, height: u32,
}

/* Retrieves the size of the content area of the specified window. */
get_window_size :: proc "contextless" (window: Window) -> Window_Size {
	width, height: c.int
	glfw.GetWindowSize(window, &width, &height)
	return { width = u32(width), height = u32(height) }
}

/* Sets the size limits of the specified window. */
set_window_size_limits :: proc "contextless" (
	window: Window,
	min: Window_Size,
	max: Window_Size,
	loc := #caller_location,
) {
	when ODIN_DEBUG {
		context = runtime.default_context()
		assert(min.width >= max.width, "Min size limits is invalid", loc = loc)
		assert(min.height >= max.height, "Max size limits is invalid", loc = loc)
	}

	glfw.SetWindowSizeLimits(
		window,
		c.int(min.width),
		c.int(min.height),
		c.int(max.width),
		c.int(max.height),
	)
}

/* Sets the aspect ratio of the specified window. */
set_window_aspect_ratio :: proc "contextless" (window: Window, numerator, denominator: u32) {
	glfw.SetWindowAspectRatio(window, c.int(numerator), c.int(denominator))
}

/* Sets the size of the content area of the specified window. */
set_window_size :: proc "contextless" (window: Window, size: Window_Size) {
	glfw.SetWindowSize(window, c.int(size.width), c.int(size.height))
}

Framebuffer_Size :: struct {
	width, height: u32,
}

/* Retrieves the size of the framebuffer of the specified window. */
get_framebuffer_size :: proc "contextless" (window: Window) -> Framebuffer_Size {
	width, height: c.int
	glfw.GetFramebufferSize(window, &width, &height)
	return {u32(width), u32(height)}
}

Window_Frame_Size :: struct {
	left, top, right, bottom: u32,
}

/* Retrieves the size of the frame of the window. */
get_window_frame_size :: proc "contextless" (window: Window) -> Window_Frame_Size {
	left, top, right, bottom: c.int
	glfw.GetWindowFrameSize(window, &left, &top, &right, &bottom)
	return {u32(left), u32(top), u32(right), u32(bottom)}
}

Window_Content_Scale :: struct {
	x_scale, y_scale: f32,
}

/* Retrieves the content scale for the specified window. */
get_window_content_scale :: proc "contextless" (window: Window) -> Window_Content_Scale {
	x_scale, y_scale: f32
	glfw.GetWindowContentScale(window, &x_scale, &y_scale)
	return {x_scale, y_scale}
}

/* Returns the opacity of the whole window. */
get_window_opacity :: glfw.GetWindowOpacity

/* Sets the opacity of the whole window. */
set_window_opacity :: glfw.SetWindowOpacity

/* Iconifies the specified window. */
iconify_window :: glfw.IconifyWindow

/* Restores the specified window. */
restore_window :: glfw.RestoreWindow

/* Maximizes the specified window. */
maximize_window :: glfw.MaximizeWindow

/* Makes the specified window visible. */
show_window :: glfw.ShowWindow

/* Hides the specified window. */
hide_window :: glfw.HideWindow

/* Brings the specified window to front and sets input focus. */
focus_window :: glfw.FocusWindow

/* Requests user attention to the specified window. */
request_window_attention :: glfw.RequestWindowAttention

/* Returns the monitor that the window uses for full screen mode. */
get_window_monitor :: glfw.GetWindowMonitor

/* Sets the mode, monitor, video mode and placement of a window. */
set_window_monitor :: proc "contextless" (
	window: Window,
	monitor: Monitor,
	xpos, ypos, width, height, refresh_rate: i32,
) {
	glfw.SetWindowMonitor(
		window,
		monitor,
		c.int(xpos),
		c.int(ypos),
		c.int(width),
		c.int(height),
		c.int(refresh_rate),
	)
}

Window_Attributes :: enum c.int {
    Focused = FOCUSED,
	Iconified = ICONIFIED,
    Maximized = MAXIMIZED,
    Hovered = HOVERED,
    Visible = VISIBLE,
    Rresizable = RESIZABLE,
    Decorated = DECORATED,
    Auto_Iconify = AUTO_ICONIFY,
    Floating = FLOATING,
    Transparent_Framebuffer = TRANSPARENT_FRAMEBUFFER,
    Focus_On_Show = FOCUS_ON_SHOW,
    Mouse_Passthrough = MOUSE_PASSTHROUGH,

    Client_Api = CLIENT_API,
    Context_Creation_Api = CONTEXT_CREATION_API,
    Context_Version_Major = CONTEXT_VERSION_MAJOR,
    Context_Version_Minor = CONTEXT_VERSION_MINOR,
    Context_Revision = CONTEXT_REVISION,
    Opengl_Forward_Compat = OPENGL_FORWARD_COMPAT,
    Context_Debug = CONTEXT_DEBUG,
    Opengl_Profile = OPENGL_PROFILE,

    Context_Release_Behavior = CONTEXT_RELEASE_BEHAVIOR,
    Context_No_Error = CONTEXT_NO_ERROR,
    Context_Robustness = CONTEXT_ROBUSTNESS,

    Doublebuffer = DOUBLEBUFFER,
}

/* Returns an attribute of the specified window. */
get_window_attrib :: proc "contextless" (window: Window, attrib: Window_Attributes) -> i32 {
	return glfw.GetWindowAttrib(window, transmute(c.int)attrib)
}

/* Sets an attribute of the specified window */
set_window_attrib :: proc "contextless" (window: Window, attrib: Window_Attributes, value: bool) {
	glfw.SetWindowAttrib(window, transmute(c.int)attrib, b32(value))
}

/* Sets the user pointer of the specified window */
set_window_user_pointer :: glfw.SetWindowUserPointer

/* Returns the user pointer of the specified window */
get_window_user_pointer :: proc "contextless" (window: Window, $T: typeid) -> ^T {
	pointer := glfw.GetWindowUserPointer(window)

	if pointer != nil {
		return cast(^T)pointer
	}

	return nil
}

/* Processes all pending events. */
poll_events :: proc "contextless" () {
	clear_events()
	glfw.PollEvents()
}

/* Waits until events are queued and processes them. */
wait_events :: proc "contextless" () {
	clear_events()
	glfw.WaitEvents()
}

/* Waits with timeout until events are queued and processes them. */
wait_events_timeout :: proc "contextless" (timeout: f64) {
	clear_events()
	glfw.WaitEventsTimeout(timeout)
}

/* Posts an empty event to the event queue. */
post_empty_event :: glfw.PostEmptyEvent

/* Swaps the front and back buffers of the specified window. */
swap_buffers :: glfw.SwapBuffers
