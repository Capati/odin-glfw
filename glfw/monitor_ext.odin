package glfw

Monitor_Owner :: struct {
	monitor: Monitor,
	w_pos:   Window_Pos,
	w_size:  Window_Size,
	x:       i32,
	y:       i32,
	width:   i32,
	height:  i32,
}

/* Get the main (owner) monitor of the window. */
get_monitor_owner :: proc(window: Window) -> (m_owner: Monitor_Owner) {
	// Get the window position
	w_pos := get_window_pos(window)

	// Get the window width and height
	w_size := get_window_size(window)

	// Get the list of available monitors
	monitors := get_monitors()

	// If no monitor is available, return early...
	if monitors == nil || len(monitors) == 0 {
		return {}
	}

	for m in monitors {
		// Get the monitor position
		m_pos := get_monitor_pos(m)

		// Get the monitor size from its video mode
		monitor_vidmode := get_video_mode(m)

		monitor_width: i32 = 0
		monitor_height: i32 = 0

		// Video mode is required for width and height, so skip this monitor
		if monitor_vidmode == {} {
			continue
		} else {
			monitor_width = monitor_vidmode.width
			monitor_height = monitor_vidmode.height
		}

		// Halve the window size and use it to adjust the window position to the
		// center of the window
		test_pos := Monitor_Pos {
			u32(w_pos.x) + (w_size.width / 2),
			u32(w_pos.y) + (w_size.height / 2),
		}

		// Set the owner to this monitor if the center of the window is within
		// its bounding box
		if (test_pos.x > m_pos.x && test_pos.x < (m_pos.x + u32(monitor_width))) &&
		   (test_pos.y > m_pos.y && test_pos.y < (m_pos.y + u32(monitor_height))) {
			m_owner.monitor = m

			m_owner.w_size = w_size
			m_owner.w_pos = w_pos

			m_owner.x = i32(m_pos.x)
			m_owner.y = i32(m_pos.y)

			m_owner.width = monitor_width
			m_owner.height = monitor_height

			return m_owner
		}
	}

	return
}
