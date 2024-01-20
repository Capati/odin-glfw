//+build darwin
package glfw

// Core
import NS "vendor:darwin/foundation"

when #config(GLFW_USE_SYSTEM_LIBRARIES, false) {
	foreign import glfw "system:glfw"
} else {
	foreign import glfw {
		"bindings/lib/darwin/libglfw3.a",
		 "system:Cocoa.framework",
		 "system:IOKit.framework",
		 "system:OpenGL.framework",
	}
}

@(default_calling_convention="c", link_prefix="glfw")
foreign glfw {
    GetCocoaWindow :: proc(window: Window) -> ^NS.Window ---
}

// TODO:
// CGDirectDisplayID glfwGetCocoaMonitor(GLFWmonitor* monitor);
// id glfwGetNSGLContext(GLFWwindow* window);
