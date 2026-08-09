extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	var original_unlocked: int = bridge._unlocked_level_index
	var original_selected: int = bridge._selected_level_index
	bridge._unlocked_level_index = 8
	bridge._selected_level_index = 8
	bridge.open_course_select_screen(bridge.TITLE_PHASE_SINGLE_PLAYER, "NEW COURSE UNLOCKED", true)
	_check(bridge.is_course_select_unlocking(), "unlock cutscene starts busy")
	_check(bridge.get_course_select_unlock_phase() == bridge.COURSE_UNLOCK_PHASE_PATH, "starts with path animation")
	bridge.adjust_title_selection(1)
	_check(bridge.get_selected_level_index() == 8, "input is blocked during path animation")

	bridge.advance_ui_timers(0.31)
	_check(bridge.get_course_select_unlock_phase() == bridge.COURSE_UNLOCK_PHASE_SCROLL_BACK, "path animation hands off to camera return")
	bridge.advance_ui_timers(0.36)
	_check(bridge.get_course_select_unlock_phase() == bridge.COURSE_UNLOCK_PHASE_SCROLL_NEXT, "camera return hands off to next course travel")
	bridge.advance_ui_timers(0.56)
	_check(bridge.get_course_select_unlock_phase() == bridge.COURSE_UNLOCK_PHASE_PAUSE, "next course travel hands off to final pause")
	_check(bridge.is_course_select_unlocking(), "final pause remains busy")
	bridge.advance_ui_timers(1.02)
	_check(not bridge.is_course_select_unlocking(), "cutscene releases input after final pause")
	_check(not bridge.is_course_select_busy(), "cutscene leaves course select idle")
	bridge.adjust_title_selection(-1)
	_check(bridge.get_selected_level_index() == 7, "navigation resumes after unlock")

	bridge._unlocked_level_index = original_unlocked
	bridge._selected_level_index = original_selected
	bridge.open_title_screen_and_skip_intro()
	print("COURSE_UNLOCK_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("COURSE_UNLOCK_FAIL: " + label)
