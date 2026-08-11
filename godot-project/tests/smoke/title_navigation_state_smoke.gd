extends SceneTree

const TITLE_NAVIGATION_STATE := preload("res://scripts/core/TitleNavigationState.gd")

func _init() -> void:
	var state = TITLE_NAVIGATION_STATE.new()
	state.phase = 4
	state.menu_index = 3
	state.notice_text = "READY"
	state.reset(1)
	_check(state.phase == 1, "reset assigns press-start phase")
	_check(state.menu_index == 0 and state.notice_text.is_empty(), "reset clears transient navigation")
	print("TITLE_NAVIGATION_STATE_CHECKS=2")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error("TITLE_NAVIGATION_STATE_FAILED " + message)
		quit(1)
