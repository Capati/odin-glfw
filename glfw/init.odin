package glfw

// core
import "core:c"
import "core:runtime"

// bindings
import glfw "bindings"

/* Initializes the GLFW library. */
init :: proc (allocator := context.allocator) -> (ok: bool) {
	if init_events(allocator) != nil do return false
	_window_handles.allocator = allocator
	return bool(glfw.Init())
}

/* Terminates the GLFW library. */
terminate :: proc() {
	delete(_events.data)
	delete(_window_handles)
	glfw.Terminate()
}

/* Platform type (rendering backend) to request when using OpenGL ES and EGL via **ANGLE**. */
Angle_Platform :: enum c.int {
	None     = ANGLE_PLATFORM_TYPE_NONE,
	OpenGL   = ANGLE_PLATFORM_TYPE_OPENGL,
	OpenGLES = ANGLE_PLATFORM_TYPE_OPENGLES,
	D3D9     = ANGLE_PLATFORM_TYPE_D3D9,
	D3D11    = ANGLE_PLATFORM_TYPE_D3D11,
	Vulkan   = ANGLE_PLATFORM_TYPE_VULKAN,
	Metal    = ANGLE_PLATFORM_TYPE_METAL,
}

/* Platform type to use for windowing and input. */
Platform :: enum c.int {
	Any     = ANY_PLATFORM,
	Win32   = PLATFORM_WIN32,
	Cocoa   = PLATFORM_COCOA,
	Wayland = PLATFORM_WAYLAND,
	X11     = PLATFORM_X11,
	Null    = PLATFORM_NULL,
}

/* Whether to use libdecor for window decorations where available. */
Wayland_Libdecor :: enum c.int {
	Prefer_Libdecor  = WAYLAND_PREFER_LIBDECOR,
	Disable_Libdecor = WAYLAND_DISABLE_LIBDECOR,
}

/* Initialization hints. */
Init_Hint :: enum c.int {
	Platform               = PLATFORM,
	Joystick_Hat_Buttons   = JOYSTICK_HAT_BUTTONS,
	Angle_Platform         = ANGLE_PLATFORM_TYPE,
	Cocoa_Chdir_Resources  = COCOA_CHDIR_RESOURCES,
	Cocoa_Menubar          = COCOA_MENUBAR,
	X11_Xcb_Vulkan_Surface = X11_XCB_VULKAN_SURFACE,
	Wayland_Libdecor       = WAYLAND_LIBDECOR,
}

@(private)
init_hint_bool :: proc "contextless" (hint: Init_Hint, value: bool, loc := #caller_location) {
	#partial switch hint {
	case .Joystick_Hat_Buttons, .Cocoa_Chdir_Resources, .Cocoa_Menubar, .X11_Xcb_Vulkan_Surface:
		glfw.InitHint(transmute(c.int)hint, c.int(value))
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'bool' value does not support the given init hint", loc)
		}
	}
}

@(private)
init_hint_platform_type :: proc "contextless" (
	hint: Init_Hint,
	value: Platform,
	loc := #caller_location,
) {
	#partial switch hint {
	case .Platform:
		glfw.InitHint(transmute(c.int)hint, transmute(c.int)value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'Platform' value does not support the given init hint", loc)
		}
	}
}

@(private)
init_hint_angle_platform_type :: proc "contextless" (
	hint: Init_Hint,
	value: Angle_Platform,
	loc := #caller_location,
) {
	#partial switch hint {
	case .Angle_Platform:
		glfw.InitHint(transmute(c.int)hint, transmute(c.int)value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'Angle_Platform' value does not support the given init hint", loc)
		}
	}
}

@(private)
init_hint_wayland_libdecor :: proc "contextless" (
	hint: Init_Hint,
	value: Wayland_Libdecor,
	loc := #caller_location,
) {
	#partial switch hint {
	case .Wayland_Libdecor:
		glfw.InitHint(transmute(c.int)hint, transmute(c.int)value)
	case:
		when ODIN_DEBUG {
			context = runtime.default_context()
			panic("The 'Wayland_Libdecor' value does not support the given init hint", loc)
		}
	}
}

/* Sets the specified init hint to the desired value. */
init_hint :: proc {
	init_hint_bool,
	init_hint_platform_type,
	init_hint_angle_platform_type,
	init_hint_wayland_libdecor,
}

/* Sets the init allocator to the desired value. */
init_allocator :: glfw.InitAllocator

/* Sets the desired Vulkan vkGetInstanceProcAddr function. */
init_vulkan_loader :: glfw.InitVulkanLoader

/* Major, minor and revision */
Version :: struct {
	major: u32,
	minor: u32,
	rev:   u32,
}

/* Retrieves the version of the GLFW library. */
get_version :: proc "contextless" () -> Version {
	major: c.int = 0
	minor: c.int = 0
	rev: c.int = 0

	glfw.GetVersion(&major, &minor, &rev)
	return Version{u32(major), u32(minor), u32(rev)}
}

/* Returns a string describing the compile-time configuration. */
get_version_string :: proc "contextless" () -> string {
	return string(glfw.GetVersionString())
}

/* Returns the currently selected platform. */
get_platform :: proc "contextless" () -> Platform {
	return transmute(Platform)glfw.GetPlatform()
}

/* Returns whether the library includes support for the specified platform. */
platform_supported :: proc "contextless" (platform: Platform) -> bool {
	return bool(glfw.PlatformSupported(transmute(c.int)platform))
}
