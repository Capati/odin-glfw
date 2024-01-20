package glfw

// Bindings
import glfw "bindings"

/* Opaque window object. */
Window :: glfw.Window
/* Opaque monitor object. */
Monitor :: glfw.Monitor
/* Opaque cursor object. */
Cursor :: glfw.Cursor
/* Custom allocator object. */
Allocator :: glfw.Allocator

/* Input state of a gamepad. */
Gamepad_State :: glfw.Gamepad_State

Window_Iconify_Proc :: glfw.Window_Iconify_Proc
Window_Refresh_Proc :: glfw.Window_Refresh_Proc
Window_Focus_Proc :: glfw.Window_Focus_Proc
Window_Close_Proc :: glfw.Window_Close_Proc
Window_Size_Proc :: glfw.Window_Size_Proc
Window_Pos_Proc :: glfw.Window_Pos_Proc
Window_Maximize_Proc :: glfw.Window_Maximize_Proc
Window_Content_Scale_Proc :: glfw.Window_Content_Scale_Proc
Framebuffer_Size_Proc :: glfw.Framebuffer_Size_Proc
Drop_Proc :: glfw.Drop_Proc
Monitor_Proc :: glfw.Monitor_Proc

Key_Proc :: glfw.Key_Proc
Mouse_Button_Proc :: glfw.Mouse_Button_Proc
Cursor_Pos_Proc :: glfw.Cursor_Pos_Proc
Scroll_Proc :: glfw.Scroll_Proc
Char_Proc :: glfw.Char_Proc
Char_Mods_Proc :: glfw.Char_Mods_Proc
Cursor_Enter_Proc :: glfw.Cursor_Enter_Proc
Joystick_Proc :: glfw.Joystick_Proc

Error_Proc :: glfw.Error_Proc
