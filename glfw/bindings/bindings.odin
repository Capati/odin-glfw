package glfw_bindings

// Core
import "core:c"

// Vendor
import vk "vendor:vulkan"

when ODIN_OS == .Windows {
	@(extra_linker_flags = "/NODEFAULTLIB:libcmt")
	foreign import glfw {
		"./lib/glfw3.lib",
		"system:user32.lib",
		"system:gdi32.lib",
		"system:shell32.lib",
	}
} else when ODIN_OS == .Linux {
	when #config(GLFW_USE_SYSTEM_LIBRARIES, false) {
		foreign import glfw "system:glfw"
	} else {
		foreign import glfw {
			"lib/libglfw3.a",
		}
	}
} else when ODIN_OS == .Darwin {
	when #config(GLFW_USE_SYSTEM_LIBRARIES, false) {
		foreign import glfw "system:glfw"
	} else {
		foreign import glfw {
			"lib/darwin/libglfw3.a",
			 "system:Cocoa.framework",
			 "system:IOKit.framework",
			 "system:OpenGL.framework",
		}
	}
} else {
	foreign import glfw "system:glfw"
}

#assert(size_of(c.int) == size_of(b32))

/*** Functions ***/
@(default_calling_convention = "c", link_prefix = "glfw")
foreign glfw {
	Init :: proc() -> b32 ---
	Terminate :: proc() ---

	InitHint :: proc(hint, value: c.int) ---

	InitAllocator :: proc(allocator: ^Allocator) ---

	InitVulkanLoader :: proc(loader: vk.ProcGetInstanceProcAddr) ---

	GetVersion :: proc(major, minor, rev: ^c.int) ---
	GetVersionString :: proc() -> cstring ---

	GetError :: proc(description: ^cstring) -> c.int ---
	SetErrorCallback :: proc(cb_proc: Error_Proc) -> Error_Proc ---

	GetPlatform :: proc() -> c.int ---
    PlatformSupported :: proc(platform: c.int) -> c.int ---

	GetMonitors :: proc(count: ^c.int) -> [^]Monitor ---
	GetPrimaryMonitor :: proc() -> Monitor ---
	GetMonitorPos :: proc(monitor: Monitor, xpos, ypos: ^c.int) ---
	GetMonitorWorkarea :: proc(monitor: Monitor, xpos, ypos, width, height: ^c.int) ---
	GetMonitorPhysicalSize :: proc(monitor: Monitor, widthMM, heightMM: ^c.int) ---
	GetMonitorContentScale :: proc(monitor: Monitor, xscale, yscale: ^f32) ---
	GetMonitorName :: proc(monitor: Monitor) -> cstring ---
	SetMonitorUserPointer :: proc(monitor: Monitor, pointer: rawptr) ---
	GetMonitorUserPointer :: proc(monitor: Monitor) -> rawptr ---
	SetMonitorCallback :: proc(monitor: Monitor, cbfun: Monitor_Proc) -> Monitor_Proc ---

	GetVideoModes :: proc(monitor: Monitor, count: ^c.int) -> [^]Video_Mode ---
	GetVideoMode :: proc(monitor: Monitor) -> ^Video_Mode ---
	SetGamma :: proc(monitor: Monitor, gamma: f32) ---
	GetGammaRamp :: proc(monitor: Monitor) -> ^Gamma_Ramp ---
	SetGammaRamp :: proc(monitor: Monitor, ramp: ^Gamma_Ramp) ---

	DefaultWindowHints :: proc() ---
	WindowHint :: proc(hint, value: c.int) ---
	WindowHintString :: proc(hint: c.int, value: cstring) ---

	CreateWindow :: proc(width, height: c.int, title: cstring, monitor: Monitor, share: Window) -> Window ---
	DestroyWindow :: proc(window: Window) ---

	WindowShouldClose :: proc(window: Window) -> b32 ---

	SwapInterval :: proc(interval: c.int) ---
	SwapBuffers :: proc(window: Window) ---

	SetWindowTitle :: proc(window: Window, title: cstring) ---
	SetWindowIcon :: proc(window: Window, count: c.int, images: [^]Image) ---
	SetWindowPos :: proc(window: Window, xpos, ypos: c.int) ---
	SetWindowSizeLimits :: proc(window: Window, minwidth, minheight, maxwidth, maxheight: c.int) ---
	SetWindowAspectRatio :: proc(window: Window, numer, denom: c.int) ---
	SetWindowSize :: proc(window: Window, width, height: c.int) ---
	GetWindowPos :: proc(window: Window, xpos, ypos: ^c.int) ---
	GetWindowSize :: proc(window: Window, width, height: ^c.int) ---
	GetFramebufferSize :: proc(window: Window, width, height: ^c.int) ---
	GetWindowFrameSize :: proc(window: Window, left, top, right, bottom: ^c.int) ---

	GetWindowContentScale :: proc(window: Window, xscale, yscale: ^f32) ---
	GetWindowOpacity :: proc(window: Window) -> f32 ---
	SetWindowOpacity :: proc(window: Window, opacity: f32) ---

	GetClipboardString :: proc(window: Window) -> cstring ---
	GetKey :: proc(window: Window, key: c.int) -> c.int ---
	GetKeyName :: proc(key, scancode: c.int) -> cstring ---
	SetWindowShouldClose :: proc(window: Window, value: b32) ---
	JoystickPresent :: proc(joy: c.int) -> b32 ---
	GetJoystickName :: proc(joy: c.int) -> cstring ---
	GetKeyScancode :: proc(key: c.int) -> c.int ---

	IconifyWindow :: proc(window: Window) ---
	RestoreWindow :: proc(window: Window) ---
	MaximizeWindow :: proc(window: Window) ---
	ShowWindow :: proc(window: Window) ---
	HideWindow :: proc(window: Window) ---
	FocusWindow :: proc(window: Window) ---

	RequestWindowAttention :: proc(window: Window) ---

	GetWindowMonitor :: proc(window: Window) -> Monitor ---
	SetWindowMonitor :: proc(window: Window, monitor: Monitor, xpos, ypos, width, height, refresh_rate: c.int) ---
	GetWindowAttrib :: proc(window: Window, attrib: c.int) -> c.int ---
	SetWindowUserPointer :: proc(window: Window, pointer: rawptr) ---
	GetWindowUserPointer :: proc(window: Window) -> rawptr ---

	SetWindowAttrib :: proc(window: Window, attrib: c.int, value: b32) ---

	PollEvents :: proc() ---
	WaitEvents :: proc() ---
	WaitEventsTimeout :: proc(timeout: f64) ---
	PostEmptyEvent :: proc() ---

	RawMouseMotionSupported :: proc() -> b32 ---
	GetInputMode :: proc(window: Window, mode: c.int) -> c.int ---
	SetInputMode :: proc(window: Window, mode, value: c.int) ---

	GetMouseButton :: proc(window: Window, button: c.int) -> c.int ---
	GetCursorPos :: proc(window: Window, xpos, ypos: ^c.double) ---
	SetCursorPos :: proc(window: Window, xpos, ypos: f64) ---

	CreateCursor :: proc(image: ^Image, xhot, yhot: c.int) -> Cursor ---
	DestroyCursor :: proc(cursor: Cursor) ---
	SetCursor :: proc(window: Window, cursor: Cursor) ---
	CreateStandardCursor :: proc(shape: c.int) -> Cursor ---

	GetJoystickAxes :: proc(joy: c.int, count: ^c.int) -> [^]f32 ---
	GetJoystickButtons :: proc(joy: c.int, count: ^c.int) -> [^]u8 ---
	GetJoystickHats :: proc(jid: c.int, count: ^c.int) -> [^]u8 ---
	GetJoystickGUID :: proc(jid: c.int) -> cstring ---
	SetJoystickUserPointer :: proc(jid: c.int, pointer: rawptr) ---
	GetJoystickUserPointer :: proc(jid: c.int) -> rawptr ---
	JoystickIsGamepad :: proc(jid: c.int) -> b32 ---
	UpdateGamepadMappings :: proc(str: cstring) -> c.int ---
	GetGamepadName :: proc(jid: c.int) -> cstring ---
	GetGamepadState :: proc(jid: c.int, state: ^Gamepad_State) -> b32 ---

	SetClipboardString :: proc(window: Window, str: cstring) ---

	SetTime :: proc(time: f64) ---
	GetTime :: proc() -> f64 ---
	GetTimerValue :: proc() -> u64 ---
	GetTimerFrequency :: proc() -> u64 ---

	MakeContextCurrent :: proc(window: Window) ---
	GetCurrentContext :: proc() -> Window ---
	GetProcAddress :: proc(name: cstring) -> rawptr ---
	ExtensionSupported :: proc(extension: cstring) -> b32 ---

	VulkanSupported :: proc() -> b32 ---
	GetRequiredInstanceExtensions :: proc(count: ^c.uint32_t) -> [^]cstring ---
	GetInstanceProcAddress :: proc(instance: vk.Instance, procname: cstring) -> rawptr ---
	GetPhysicalDevicePresentationSupport :: proc(instance: vk.Instance, device: vk.PhysicalDevice, queuefamily: c.uint32_t) -> b32 ---
	CreateWindowSurface :: proc(instance: vk.Instance, window: Window, allocator: ^vk.AllocationCallbacks, surface: ^vk.SurfaceKHR) -> vk.Result ---

	SetWindowIconifyCallback :: proc(window: Window, cbfun: Window_Iconify_Proc) -> Window_Iconify_Proc ---
	SetWindowRefreshCallback :: proc(window: Window, cbfun: Window_Refresh_Proc) -> Window_Refresh_Proc ---
	SetWindowFocusCallback :: proc(window: Window, cbfun: Window_Focus_Proc) -> Window_Focus_Proc ---
	SetWindowCloseCallback :: proc(window: Window, cbfun: Window_Close_Proc) -> Window_Close_Proc ---
	SetWindowSizeCallback :: proc(window: Window, cbfun: Window_Size_Proc) -> Window_Size_Proc ---
	SetWindowPosCallback :: proc(window: Window, cbfun: Window_Pos_Proc) -> Window_Pos_Proc ---
	SetFramebufferSizeCallback :: proc(window: Window, cbfun: Framebuffer_Size_Proc) -> Framebuffer_Size_Proc ---
	SetDropCallback :: proc(window: Window, cbfun: Drop_Proc) -> Drop_Proc ---
	SetWindowMaximizeCallback :: proc(window: Window, cbfun: Window_Maximize_Proc) -> Window_Maximize_Proc ---
	SetWindowContentScaleCallback :: proc(window: Window, cbfun: Window_Content_Scale_Proc) -> Window_Content_Scale_Proc ---

	SetKeyCallback :: proc(window: Window, cbfun: Key_Proc) -> Key_Proc ---
	SetMouseButtonCallback :: proc(window: Window, cbfun: Mouse_Button_Proc) -> Mouse_Button_Proc ---
	SetCursorPosCallback :: proc(window: Window, cbfun: Cursor_Pos_Proc) -> Cursor_Pos_Proc ---
	SetScrollCallback :: proc(window: Window, cbfun: Scroll_Proc) -> Scroll_Proc ---
	SetCharCallback :: proc(window: Window, cbfun: Char_Proc) -> Char_Proc ---
	SetCharModsCallback :: proc(window: Window, cbfun: Char_Mods_Proc) -> Char_Mods_Proc ---
	SetCursorEnterCallback :: proc(window: Window, cbfun: Cursor_Enter_Proc) -> Cursor_Enter_Proc ---
	SetJoystickCallback :: proc(cbfun: Joystick_Proc) -> Joystick_Proc ---

}
