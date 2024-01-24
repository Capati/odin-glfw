package glfw

// Core
import "core:math"
import "core:runtime"

// Bindings
import glfw "bindings"

// ((26^4 - 1) / 10^9)
MAX_SECONDS: f64 = math.floor_f64(
    (math.pow_f64(2, 64) - 1) / math.pow_f64(10, 9),
)

get_time :: proc "contextless" () -> f64 {
	return glfw.GetTime()
}

/* Sets the GLFW time. */
set_time :: proc "contextless" (time: f64, loc := #caller_location) {
	when ODIN_DEBUG {
		context = runtime.default_context()
		assert(!math.is_nan(time), "Time value is not a number", loc)
		assert(time > 0, "Time value is not positive", loc)
		assert(time <= MAX_SECONDS, "Time value is too big", loc)
	}

	glfw.SetTime(time)
}

/* Returns the current value of the raw timer. */
get_timer_value :: proc "contextless" () -> u64 {
	return glfw.GetTimerValue()
}

/* Returns the frequency, in Hz, of the raw timer. */
get_timer_frequency :: proc "contextless" () -> u64 {
	return glfw.GetTimerFrequency()
}
