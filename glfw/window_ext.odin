package glfw

/* Set the window position to the center of the owner monitor. */
center_window :: proc(window: Window) {
	owner := get_monitor_owner(window)

	if owner.monitor == nil {
		return
	}

	set_window_pos(
		window,
		Window_Pos {
			u32(owner.x) + (u32(owner.width) / 2) - (owner.w_size.width / 2),
			u32(owner.y) + (u32(owner.height) / 2) - (owner.w_size.height / 2),
		},
	)
}
