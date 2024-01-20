//+build windows
package glfw

// Core
import win32 "core:sys/windows"

@(extra_linker_flags = "/NODEFAULTLIB:libcmt")
foreign import glfw {
	"./bindings/lib/glfw3.lib",
	"system:user32.lib",
	"system:gdi32.lib",
	"system:shell32.lib",
}

@(default_calling_convention = "c")
foreign glfw {
	/* Returns the adapter device name of the specified monitor. */
	@(link_name = "glfwGetWin32Adapter")
	get_win32_adapter :: proc(monitor: Monitor) -> cstring ---

	/* Returns the display device name of the specified monitor. */
	@(link_name = "glfwGetWin32Monitor")
	get_win32_monitor :: proc(monitor: Monitor) -> cstring ---

	/* Returns the HWND of the specified window. */
	@(link_name = "glfwGetWin32Window")
	get_win32_window :: proc(window: Window) -> win32.HWND ---

	/* Returns the HGLRC of the specified window. */
	@(link_name = "glfwGetWGLContext")
	get_wgl_context :: proc(window: Window) -> rawptr ---
}
