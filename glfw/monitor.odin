package glfw

// Core
import "core:c"
import "core:mem"
import "core:runtime"

// Bindings
import glfw "bindings"

/* Returns the currently connected monitors. */
get_monitors :: proc "contextless" () -> []Monitor {
	count: c.int
	monitors := glfw.GetMonitors(&count)

	if count > 0 && monitors != nil {
		return monitors[:count]
	}

	return {}
}

/* Returns the primary monitor. */
get_primary_monitor :: glfw.GetPrimaryMonitor

Monitor_Pos :: struct {
	x, y: u32,
}

/* Returns the position of the monitor's viewport on the virtual screen. */
get_monitor_pos :: proc "contextless" (monitor: Monitor) -> Monitor_Pos {
	x_pos, y_pos: c.int
	glfw.GetMonitorPos(monitor, &x_pos, &y_pos)
	return {u32(x_pos), u32(y_pos)}
}

Monitor_Work_Area :: struct {
	x, y, width, height: u32,
}

/* Retrieves the work area of the monitor. */
get_monitor_work_area :: proc "contextless" (monitor: Monitor) -> Monitor_Work_Area {
	x_pos, y_pos, width, height: c.int
	glfw.GetMonitorWorkarea(monitor, &x_pos, &y_pos, &width, &height)
	return {u32(x_pos), u32(y_pos), u32(width), u32(height)}
}

Monitor_Physical_Size :: struct {
	width, height: u32,
}

/* Returns the physical size of the monitor. */
get_monitor_physical_size :: proc "contextless" (monitor: Monitor) -> Monitor_Physical_Size {
	width, height: c.int
	glfw.GetMonitorPhysicalSize(monitor, &width, &height)
	return {u32(width), u32(height)}
}

Monitor_Content_Scale :: struct {
	x_scale, y_scale: f32,
}

/* Retrieves the content scale for the specified monitor. */
get_monitor_content_scale :: proc "contextless" (monitor: Monitor) -> Monitor_Content_Scale {
	x_scale, y_scale: c.float
	glfw.GetMonitorContentScale(monitor, &x_scale, &y_scale)
	return {f32(x_scale), f32(y_scale)}
}

/* Returns the name of the specified monitor. */
get_monitor_name :: proc "contextless" (monitor: Monitor) -> string {
	return string(glfw.GetMonitorName(monitor))
}

/* Sets the user pointer of the specified monitor. */
set_monitor_user_pointer :: proc "contextless" (monitor: Monitor, pointer: ^$T) {
	glfw.SetMonitorUserPointer(monitor, pointer)
}

/* Returns the user pointer of the specified monitor. */
get_monitor_user_pointer :: proc "contextless" (monitor: Monitor, $T: typeid) -> ^T {
	pointer := glfw.GetMonitorUserPointer(monitor)

	if pointer != nil {
		return cast(^T)pointer
	}

	return nil
}

/* Returns the available video modes for the specified monitor. */
get_video_modes_raw :: proc "contextless" (monitor: Monitor) -> []glfw.Video_Mode {
	count: c.int
	modes := glfw.GetVideoModes(monitor, &count)

	if count > 0 && modes != nil {
		return modes[:count]
	}

	return {}
}

get_video_modes_allocate :: proc(
	monitor: Monitor,
	allocator := context.allocator,
	loc := #caller_location,
) -> (
	modes: []Video_Mode,
	err: mem.Allocator_Error,
) {
	count: c.int
	_modes := glfw.GetVideoModes(monitor, &count)

	if count > 0 {
		modes = make([]Video_Mode, count, allocator, loc) or_return

		for i in 0 ..< count {
			modes[i] = Video_Mode {
				width        = _modes[i].width,
				height       = _modes[i].height,
				red_bits     = _modes[i].red_bits,
				green_bits   = _modes[i].green_bits,
				blue_bits    = _modes[i].blue_bits,
				refresh_rate = _modes[i].refresh_rate,
			}
		}
	}

	return
}

get_video_modes :: proc {
	get_video_modes_raw,
	get_video_modes_allocate,
}

/* Returns the current mode of the specified monitor. */
get_video_mode :: proc "contextless" (monitor: Monitor) -> (mode: Video_Mode) {
	_mode := glfw.GetVideoMode(monitor)

	mode = Video_Mode {
		width        = _mode.width,
		height       = _mode.height,
		red_bits     = _mode.red_bits,
		green_bits   = _mode.green_bits,
		blue_bits    = _mode.blue_bits,
		refresh_rate = _mode.refresh_rate,
	}

	return
}

/* Generates a gamma ramp and sets it for the specified monitor. */
set_gamma :: proc "contextless" (monitor: Monitor, gamma: f32, loc := #caller_location) {
	when ODIN_DEBUG {
		context = runtime.default_context()
		assert(gamma > 0, "Gama value is not positive", loc)
		assert(gamma < max(f32), "Game value is too big", loc)
	}

	glfw.SetGamma(monitor, gamma)
}

/* Returns the current gamma ramp for the specified monitor. */
get_gamma_ramp :: proc "contextless" (monitor: Monitor) -> Gamma_Ramp {
	ramp := glfw.GetGammaRamp(monitor)
	return(
		 {
			red = ramp.red[:ramp.size],
			green = ramp.green[:ramp.size],
			blue = ramp.blue[:ramp.size],
		} \
	)
}

/* Sets the current gamma ramp for the specified monitor. */
set_gamma_ramp :: proc "contextless" (monitor: Monitor, ramp: Gamma_Ramp) {
	ramp := glfw.Gamma_Ramp {
		red   = &ramp.red[0],
		green = &ramp.green[0],
		blue  = &ramp.blue[0],
		size  = c.uint(len(ramp.red)),
	}

	glfw.SetGammaRamp(monitor, &ramp)
}
