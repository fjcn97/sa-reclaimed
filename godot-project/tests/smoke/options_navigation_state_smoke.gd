extends SceneTree

const OPTIONS_NAVIGATION_STATE := preload("res://scripts/core/OptionsNavigationState.gd")

func _init() -> void:
	var state = OPTIONS_NAVIGATION_STATE.new()
	state.mode = 4
	state.menu_index = 5
	state.player_data_menu_index = 2
	state.reset(1)
	_check(state.mode == 1, "reset restores main options mode")
	_check(state.menu_index == 0 and state.player_data_menu_index == 0, "reset clears cursors")
	print("OPTIONS_NAVIGATION_STATE_CHECKS=2")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error("OPTIONS_NAVIGATION_STATE_FAILED " + message)
		quit(1)
