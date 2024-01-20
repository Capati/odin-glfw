package glfw

/* This describes a single video mode. */
Video_Mode :: struct {
	width, height:                   i32,
	red_bits, green_bits, blue_bits: i32,
	refresh_rate:                    i32,
}
