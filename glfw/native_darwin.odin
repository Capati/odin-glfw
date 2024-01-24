//+build darwin
package glfw

// Core
import NS "vendor:darwin/foundation"

when GLFW_USE_SYSTEM_LIBRARIES {
	foreign import glfw "system:glfw"
} else {
	when ODIN_ARCH == .amd64 {
		when GLFW_SHARED {
			foreign import glfw {
				"lib/darwin/x86_x64/libglfw.3.dylib",
				 "system:Cocoa.framework",
				 "system:IOKit.framework",
				 "system:OpenGL.framework",
			}
		} else {
			foreign import glfw {
				"lib/darwin/x86_x64/libglfw3.a",
				 "system:Cocoa.framework",
				 "system:IOKit.framework",
				 "system:OpenGL.framework",
			}
		}
	} else when ODIN_ARCH == .arm64 {
		when GLFW_SHARED {
			foreign import glfw {
				"lib/darwin/arm64/libglfw.3.dylib",
				 "system:Cocoa.framework",
				 "system:IOKit.framework",
				 "system:OpenGL.framework",
			}
		} else {
			foreign import glfw {
				"lib/darwin/arm64/libglfw3.a",
				 "system:Cocoa.framework",
				 "system:IOKit.framework",
				 "system:OpenGL.framework",
			}
		}
	} else {
		#panic("Unsupported Darwin architecture")
	}
}

@(default_calling_convention="c", link_prefix="glfw")
foreign glfw {
    GetCocoaWindow :: proc(window: Window) -> ^NS.Window ---
}

// TODO:
// CGDirectDisplayID glfwGetCocoaMonitor(GLFWmonitor* monitor);
// id glfwGetNSGLContext(GLFWwindow* window);
