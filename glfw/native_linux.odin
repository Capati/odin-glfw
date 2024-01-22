//+build linux
package glfw

// Core
import "core:c"

when #config(GLFW_USE_SYSTEM_LIBRARIES, false) {
	foreign import glfw "system:glfw"
} else {
	foreign import glfw {
		"bindings/lib/libglfw3.a",
	}
}

@(default_calling_convention = "c")
foreign glfw {
	@(link_name = "glfwGetX11Display")
	get_x11_display :: proc() -> rawptr ---
	@(link_name = "glfwGetX11Adapter")
	get_x11_adapter :: proc(monitor: Monitor) -> c.uint32_t ---
	@(link_name = "glfwGetX11Monitor")
	get_x11_monitor :: proc(monitor: Monitor) -> c.uint32_t ---
	@(link_name = "glfwGetX11Window")
	get_x11_window :: proc(window: Window) -> c.uint32_t ---
	@(link_name = "glfwSetX11SelectionString")
	set_x11_selection_string :: proc(string: cstring) ---
	@(link_name = "glfwGetX11SelectionString")
	get_x11_selection_string :: proc() -> cstring ---

	@(link_name = "glfwGetWaylandDisplay")
	get_wayland_display :: proc() -> rawptr ---
	@(link_name = "glfwGetWaylandMonitor")
	get_wayland_monitor :: proc(monitor: Monitor) -> rawptr ---
	@(link_name = "glfwGetWaylandWindow")
	get_wayland_window :: proc(window: Window) -> rawptr ---
}
