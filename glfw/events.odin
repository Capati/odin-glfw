package glfw

// Core
import "core:container/queue"
import "core:mem"

Char_Event :: struct {
	window: Window,
	char:   rune,
}

Key_Mods :: struct {
	shift:     bool,
	control:   bool,
	alt:       bool,
	super:     bool,
	caps_lock: bool,
	num_lock:  bool,
}

Char_Mods_Event :: struct {
	window:    Window,
	codepoint: rune,
	mods:      Key_Mods,
}

Close_Event :: struct {
	window: Window,
	value:  bool,
}

Cursor_Enter_Event :: struct {
	window: Window,
	value:  bool,
}

Focus_Event :: struct {
	window: Window,
	value:  bool,
}

Framebuffer_Resize_Event :: struct {
	window: Window,
	size:   Framebuffer_Size,
}

Iconified_Event :: struct {
	window:    Window,
	iconified: bool,
}

Joystick_Connected_Event :: struct {
	joystick: Joystick_ID,
}

Joystick_Disconnected_Event :: struct {
	joystick: Joystick_ID,
}

Key_Event :: struct {
	window: Window,
	key:    Key,
	mods:   Key_Mods,
}

Key_Press_Event :: distinct Key_Event

Key_Release_Event :: distinct Key_Event

Key_Repeat_Event :: distinct Key_Event

Maximized_Event :: struct {
	window:    Window,
	maximized: bool,
}

Monitor_Connected_Event :: struct {
	monitor: Monitor,
}

Monitor_Disconnected_Event :: struct {
	monitor: Monitor,
}

Mouse_Button_Event :: struct {
	window: Window,
	button: Mouse_Button,
	pos:    Cursor_Position,
	mods:   Key_Mods,
}

Mouse_Button_Press_Event :: distinct Mouse_Button_Event

Mouse_Button_Release_Event :: distinct Mouse_Button_Event

Position :: struct {
	x, y: f64,
}

Mouse_Motion_Event :: struct {
	window: Window,
	pos:    Position,
}

Scroll_Offset :: struct {
	x, y: f64,
}

Mouse_Scroll_Event :: struct {
	window: Window,
	offset: Scroll_Offset,
}

Paths_Drop_Event :: struct {
	window: Window,
	paths:  []cstring,
}

Window_Content_Scale_Event :: struct {
	window: Window,
	scale:  Window_Content_Scale,
}

Window_Pos_Event :: struct {
	window: Window,
	pos:    Window_Pos,
}

Window_Refresh_Event :: struct {
	window: Window,
}

Window_Resize_Event :: struct {
	window: Window,
	size:   Window_Size,
}

Event :: union #no_nil {
	Char_Event,
	Char_Mods_Event,
	Close_Event,
	Cursor_Enter_Event,
	Focus_Event,
	Framebuffer_Resize_Event,
	Iconified_Event,
	Joystick_Connected_Event,
	Joystick_Disconnected_Event,
	Key_Press_Event,
	Key_Release_Event,
	Key_Repeat_Event,
	Maximized_Event,
	Monitor_Connected_Event,
	Monitor_Disconnected_Event,
	Mouse_Button_Press_Event,
	Mouse_Button_Release_Event,
	Mouse_Motion_Event,
	Mouse_Scroll_Event,
	Paths_Drop_Event,
	Window_Content_Scale_Event,
	Window_Pos_Event,
	Window_Refresh_Event,
	Window_Resize_Event,
}

// FIFO Queue
@(private)
Event_Queue :: distinct queue.Queue(Event)

@(private)
_events: Event_Queue

// Default events queue capacity
@(private)
GLFW_EVENTS_CAPACITY :: #config(GLFW_EVENTS_CAPACITY, 2048)

@(private)
init_events :: proc(
	allocator := context.allocator,
	capacity := GLFW_EVENTS_CAPACITY,
) -> mem.Allocator_Error {
	return queue.init(&_events, capacity, allocator)
}

@(private)
push_event :: proc(event: Event) {
	queue.push_back(&_events, event)
}

@(private)
clear_events :: proc "contextless" () {
	_events.len = 0
	_events.offset = 0
}

/* Get the next event in the event queue. */
next_event :: proc(event: ^Event) -> bool {
	if !has_next_event() do return false
	event^ = queue.pop_front(&_events)
	return true
}

/* Check if there is pending events to get. */
has_next_event :: proc "contextless" () -> bool {
	return _events.len > 0
}
