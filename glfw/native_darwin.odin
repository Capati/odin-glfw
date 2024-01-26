//+build darwin
package glfw

// Core
import NS "vendor:darwin/foundation"

// odinfmt: disable
when GLFW_USE_SYSTEM_LIBRARIES {
	foreign import glfw "system:glfw"
} else {
	when GLFW_SHARED {
		foreign import glfw {
			"lib/darwin/libglfw.3.4.dylib",
			"system:Cocoa.framework",
			"system:IOKit.framework",
			"system:OpenGL.framework",
		}
	} else {
		foreign import glfw {
			"lib/darwin/libglfw3.a",
			"system:Cocoa.framework",
			"system:IOKit.framework",
			"system:OpenGL.framework",
		}
	}
}
// odinfmt: enable

@(default_calling_convention = "c", link_prefix = "glfw")
foreign glfw {
	GetCocoaWindow :: proc(window: Window) -> ^NS.Window ---
}

// TODO:
// CGDirectDisplayID glfwGetCocoaMonitor(GLFWmonitor* monitor);
// id glfwGetNSGLContext(GLFWwindow* window);
