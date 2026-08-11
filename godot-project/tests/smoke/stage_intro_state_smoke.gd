extends SceneTree

const STAGE_INTRO_STATE := preload("res://scripts/core/StageIntroState.gd")

func _init() -> void:
	var state = STAGE_INTRO_STATE.new()
	state.begin(3.5)
	_check(state.intro_timer == 3.5, "begin sets countdown")
	state.start_boost_timer = 1.0
	state.final_intro_pending = true
	state.reset()
	_check(state.intro_timer == 0.0 and state.start_boost_timer == 0.0, "reset clears timers")
	_check(not state.final_intro_pending and not state.intro_primed, "reset clears flags")
	print("STAGE_INTRO_STATE_CHECKS=3")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error("STAGE_INTRO_STATE_FAILED " + message)
		quit(1)
