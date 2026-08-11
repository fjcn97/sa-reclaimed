extends SceneTree

const RUN_MODE_STATE := preload("res://scripts/core/RunModeState.gd")

func _init() -> void:
	var state = RUN_MODE_STATE.new()
	state.begin(true, false)
	_check(state.from_time_attack and not state.from_multiplayer, "time-attack mode is retained")
	state.begin(false, true)
	_check(not state.from_time_attack and state.from_multiplayer, "multiplayer mode replaces prior mode")
	state.reset()
	_check(not state.from_time_attack and not state.from_multiplayer, "reset clears run modes")
	print("RUN_MODE_STATE_CHECKS=3")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error("RUN_MODE_STATE_FAILED " + message)
		quit(1)
