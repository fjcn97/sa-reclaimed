class_name PauseMenuState
extends RefCounted

## Owns pause cursor selection and the source-accurate A-release lock.
var menu_index: int = 0
var a_hold_lock: bool = false
var a_previous_held: bool = false

func reset() -> void:
	menu_index = 0
	a_hold_lock = false
	a_previous_held = false

func open(a_held: bool) -> void:
	menu_index = 0
	a_hold_lock = a_held
	a_previous_held = a_held

func select(direction: int) -> void:
	if direction < 0:
		menu_index = 0
	elif direction > 0:
		menu_index = 1

## Returns true when a post-lock A release confirms the selected action.
func consume_a_release(a_held: bool) -> bool:
	if a_previous_held and not a_held:
		if a_hold_lock:
			a_hold_lock = false
		else:
			a_previous_held = false
			return true
	a_previous_held = a_held
	if a_hold_lock and not a_held:
		a_hold_lock = false
	return false
