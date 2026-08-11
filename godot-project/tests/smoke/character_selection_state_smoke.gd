extends SceneTree

const CHARACTER_SELECTION_STATE := preload("res://scripts/core/CharacterSelectionState.gd")

func _init() -> void:
	var state = CHARACTER_SELECTION_STATE.new()
	state.open(3, 2, 5)
	_check(state.selected_index == 3 and state.context == 2, "open retains selection and context")
	state.open(8, 4, 5)
	_check(state.selected_index == 4 and state.context == 4, "open clamps selection to catalog bounds")
	state.move(1, [0, 2, 4])
	_check(state.selected_index == 0, "move wraps through available roster entries")
	_check(state.is_context(4), "context query remains owned by the selection state")
	state.reset()
	_check(state.selected_index == 0 and state.context == 0, "reset restores selection defaults")
	print("CHARACTER_SELECTION_STATE_CHECKS=5")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error("CHARACTER_SELECTION_STATE_FAILED " + message)
		quit(1)
