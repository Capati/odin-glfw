package glfw

// Core
import "core:c"

// Vendor
import vk "vendor:vulkan"

// Bindings
import glfw "bindings"

/* Returns whether the Vulkan loader and an ICD have been found. */
vulkan_supported :: proc "contextless" () -> bool {
	return bool(glfw.VulkanSupported())
}

/* Returns the Vulkan instance extensions required by GLFW. */
get_required_instance_extensions :: proc "contextless" () -> []cstring {
	count: c.uint32_t
	extensions := glfw.GetRequiredInstanceExtensions(&count)

	if count > 0 && extensions != nil {
		return extensions[:count]
	}

	return {}
}

/* Returns the address of the specified Vulkan instance function. */
get_instance_proc_address :: proc "contextless" (
	instance: vk.Instance,
	proc_name: cstring,
) -> rawptr {
	return glfw.GetInstanceProcAddress(instance, proc_name)
}

/* Returns whether the specified queue family can present images. */
get_physical_device_presentation_support :: proc "contextless" (
	instance: vk.Instance,
	physical_device: vk.PhysicalDevice,
	queue_family: u32,
) -> bool {
	return bool(glfw.GetPhysicalDevicePresentationSupport(instance, physical_device, queue_family))
}

/* Creates a Vulkan surface for the specified window. */
create_window_surface :: proc "contextless" (
	instance: vk.Instance,
	window: Window,
	allocator: ^vk.AllocationCallbacks,
) -> (
	surface: vk.SurfaceKHR,
	result: vk.Result,
) {
	result = glfw.CreateWindowSurface(instance, window, allocator, &surface)
	return
}
