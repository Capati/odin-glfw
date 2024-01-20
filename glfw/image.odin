package glfw

/* Describes a single 2D image. */
Image :: struct {
	width, height: u32,
	pixels: []byte,
}
