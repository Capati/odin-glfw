# GLFW 3.4 for Odin

A [GLFW](https://www.glfw.org/) binding for [Odin Language](https://odin-lang.org/) with idiomatic features, utility functions and custom event loop.

## Linking

All platforms binds to a static GLFW.

## Installation

Just copy the `glfw` folder into the shared collection or inside your project.

## Usage

Read the [GLFW documentation](https://www.glfw.org/docs/3.4/index.html) for detailed instructions on how to use the library. The Odin interface is idiomatic but almost identical to the underlying C interface, with a few notable differences:

- Most types are wrapped, except the opaque ones (`Window`, `Monitor`, `Cursor`) and `Allocator`.

- The `Allocator` is a new feature of 3.4 but there is no custom allocator for it yet.

- Hints for initialization and window creation are typed and can panic if you provide an invalid value for a given hint.

For example:

```odin
glfw.window_hint(.OpenGL_Profile, "Core")
```

The string "Core" is not a valid value for the hint `OpenGL_Profile`, you need to use the enum type `glfw.OpenGL_Profile`.

- The `GLFWgamepadstate` in the C interface uses a fixed array of size and positions for buttons and axes. In this binding, a struct is utilized to provide a mapping for both buttons and axes:

From C:

```cpp
GLFWgamepadstate state;

if (glfwGetGamepadState(GLFW_JOYSTICK_1, &state))
{
    if (state.buttons[GLFW_GAMEPAD_BUTTON_A])
    {
        input_jump();
    }
}
```

To Odin version:

```odin
state := glfw.get_gamepad_state(.One)

if state.buttons.A {
  input_jump()
}
```

- Input modes are typed too, so you can avoid invalid values that are not supported for a given mode.

For example, use the typed procedure to enable Caps Lock and Num Lock modifiers:

```odin
glfw.enable_lock_key_mods(window, true)
```

The following version is the same as above, but can panic if you use an invalid value:

```odin
glfw.set_input_mode(window, .Lock_Key_Mods, true)
```

- Functions in the C interface that mutate values, the same values are wrapped in some struct.

For example, the `glfwGetFramebufferSize` is implemented as follow:

```odin
/* Retrieves the size of the framebuffer of the specified window. */
get_framebuffer_size :: proc "contextless" (window: Window) -> Framebuffer_Size {
  width, height: c.int
  glfw.GetFramebufferSize(window, &width, &height)
  return {u32(width), u32(height)}
}
```

## Custom callbacks

All callbacks are wrapped in a typed version, the "c" calling convention is done in the wrapper.

For example, instead to set an `error_callback` with the follow signature:

```odin
Error_Proc :: #type proc "c" (code: c.int, description: cstring)
```

Now you can set for a typed version:

```odin
Error_Proc :: #type proc(code: Error_Code, description: string)
```

**Note**: Given that all callbacks are wrapped and many of them are tied with a specific window, an internal map is created to hold each window created using `glfw.create_window`. When a callback is fired, the window handle is retrieved from the internal map, and the corresponding custom callback is executed.

### Disable custom callbacks

If you wish to disable the custom callbacks and directly set them using the "c" calling convention, you can achieve this by set the config `GLFW_DISABLE_CUSTOM_CALLBACKS` with the value `true`:

`-define:GLFW_DISABLE_CUSTOM_CALLBACKS=true`

**Note**: Disabling the custom callbacks also disables the custom event loop. Further details are provided in the following section.

## Custom Event Loop

Before proceeding, it's essential to note that this is an experimental feature designed with the intention of achieving something similar to what SDL does when polling events.

The events are tied with a specific window and must be explicitly enabled during window creation. This is accomplished by passing specific flags as the last argument to `glfw.create_window`. This approach ensures that only the events relevant to your application are processed, preventing unnecessary overhead for events that will not be utilized:

```odin
// Enabled custom events types
enabled_events := glfw.Enabled_Events_Flags{.Key, .Framebuffer_Size}

window := glfw.create_window(
  800, 600, "My Window", nil, nil,
  enabled_events, // <- here
)
```

Now you can process the events in your application loop:

```odin
for !glfw.window_should_close(window) {
  // Process events to trigger event callbacks and fill the custom event loop
  glfw.poll_events()

  // Process the custom event loop (similar to SDL)
  for glfw.has_next_event() {
    #partial switch event in glfw.next_event() {
    case glfw.Key_Press_Event:
      if event.key == .Escape {
        glfw.set_window_should_close(window, true)
      }
    }
  }
}
```

The events are stored in a First-In-First-Out (FIFO) queue using the `core:container/queue` package. The queue is initialized when you invoke `glfw.init` and the default  capacity is enough to hold multiple events without requiring further allocations within the loop.

First, `has_next_event` is called to check the presence of an event in the queue, followed by a call to `next_event` to retrieve the subsequent event. Because events are unions, the recommended approach for filtering by event type is using the pattern `switch X in union`. The `#partial` is used to avoid unhandled event cases.

**Note**: Failure to call the `next_event` procedure will result in an infinite loop, as `has_next_event` in a for loop only checks for the queue length.

List of all events:

- Char_Event
- Char_Mods_Event
- Close_Event
- Cursor_Enter_Event
- Focus_Event
- Framebuffer_Resize_Event
- Iconified_Event
- Key_Press_Event
- Key_Release_Event
- Key_Repeat_Event
- Maximized_Event
- Mouse_Button_Press_Event
- Mouse_Button_Release_Event
- Mouse_Motion_Event
- Mouse_Scroll_Event
- Paths_Drop_Event
- Window_Content_Scale_Event
- Window_Pos_Event
- Window_Refresh_Event
- Window_Resize_Event

### Disable custom event loop

You can set the configuration `GLFW_DISABLE_CUSTOM_EVENTS` and set its value to `true` to fully disable the custom events:

`-define:GLFW_DISABLE_CUSTOM_EVENTS=true`

**Note**: Custom callbacks are used to fill the events; consequently, disabling the custom callbacks will also deactivate the custom events.

## Example

See [triangle-opengl](./examples/triangle-opengl.odin) for a complete example.
