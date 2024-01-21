package glfw

// Core
import "core:c"
import "core:fmt"

_ :: fmt

// Bindings
import glfw "bindings"

/* Errors that GLFW can produce. */
Error_Code :: enum {
	No_Error,
	Not_Initialized,
	No_Current_Context,
	Invalid_Enum,
	Invalid_Value,
	Out_Of_Memory,
	Api_Unavailable,
	Version_Unavailable,
	Platform_Error,
	Format_Unavailable,
	No_Window_Context,
	Cursor_Unavailable,
	Feature_Unavailable,
	Feature_Unimplemented,
	Platform_Unavailable,
}

/* Convert a GLFW error integer to idiomatic `Error_Code` enum. */
convert_error :: proc "contextless" (e: c.int) -> Error_Code {
	switch e {
	case NO_ERROR:
		return Error_Code.No_Error
	case NOT_INITIALIZED:
		return Error_Code.Not_Initialized
	case NO_CURRENT_CONTEXT:
		return Error_Code.No_Current_Context
	case INVALID_ENUM:
		return Error_Code.Invalid_Enum
	case INVALID_VALUE:
		return Error_Code.Invalid_Value
	case OUT_OF_MEMORY:
		return Error_Code.Out_Of_Memory
	case API_UNAVAILABLE:
		return Error_Code.Api_Unavailable
	case VERSION_UNAVAILABLE:
		return Error_Code.Version_Unavailable
	case PLATFORM_ERROR:
		return Error_Code.Platform_Error
	case FORMAT_UNAVAILABLE:
		return Error_Code.Format_Unavailable
	case NO_WINDOW_CONTEXT:
		return Error_Code.No_Window_Context
	case CURSOR_UNAVAILABLE:
		return Error_Code.Cursor_Unavailable
	case FEATURE_UNAVAILABLE:
		return Error_Code.Feature_Unavailable
	case FEATURE_UNIMPLEMENTED:
		return Error_Code.Feature_Unimplemented
	case PLATFORM_UNAVAILABLE:
		return Error_Code.Platform_Unavailable
	}
	return .No_Error
}

/* An error produced by GLFW and the description associated with it. */
Error :: struct {
	code:        Error_Code,
	description: string,
}

// Get last error information.
get_error :: proc "contextless" () -> Error {
	desc: cstring
	code := convert_error(glfw.GetError(&desc))
	return {code, string(desc)}
}

/* Clears the last error and the error description pointer for the calling thread. */
clear_error :: glfw.GetError

/* The procedure type for errors callback. */
Error_Proc :: #type proc(code: Error_Code, description: string)

@(private)
_user_error_callback: Error_Proc

@(private)
_glfw_error_callback :: proc "c" (code: c.int, description: cstring) {
	if _user_error_callback == nil do return
	_user_error_callback(convert_error(code), string(description))
}

/* Sets the error callback. */
@(disabled = !ODIN_DEBUG)
set_error_callback :: proc "contextless" (cb_proc: Error_Proc) {
	_user_error_callback = cb_proc
	glfw.SetErrorCallback(_glfw_error_callback)
}
