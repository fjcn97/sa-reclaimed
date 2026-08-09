# Device-specific input translation for PlayerController.
extends RefCounted
class_name InputDeviceSampler

const INPUT_BINDINGS := preload("res://scripts/core/InputBindings.gd")
const AXIS_DEADZONE := 0.35

static func key_event_bit(event: InputEventKey) -> int:
	var bit := INPUT_BINDINGS.keycode_to_bit(event.keycode)
	if bit == 0 and event.physical_keycode != event.keycode:
		bit = INPUT_BINDINGS.keycode_to_bit(event.physical_keycode)
	return bit

static func joypad_button_bit(button_index: int) -> int:
	return INPUT_BINDINGS.joypad_button_to_bit(button_index)

static func joypad_axis_bits(event: InputEventJoypadMotion, current_bits: int, left_bit: int, right_bit: int, up_bit: int, down_bit: int) -> int:
	var result := current_bits
	if event.axis == JOY_AXIS_LEFT_X:
		result &= ~(left_bit | right_bit)
		if event.axis_value <= -AXIS_DEADZONE:
			result |= left_bit
		elif event.axis_value >= AXIS_DEADZONE:
			result |= right_bit
	elif event.axis == JOY_AXIS_LEFT_Y:
		result &= ~(up_bit | down_bit)
		if event.axis_value <= -AXIS_DEADZONE:
			result |= up_bit
		elif event.axis_value >= AXIS_DEADZONE:
			result |= down_bit
	return result
