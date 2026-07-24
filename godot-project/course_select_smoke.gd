extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	var original_unlocked: int = bridge._unlocked_level_index
	var original_selected: int = bridge._selected_level_index
	var original_language: int = bridge._language_index
	bridge._unlocked_level_index = 8
	bridge._selected_level_index = 8
	bridge.open_course_select_screen(bridge.TITLE_PHASE_SINGLE_PLAYER)
	_check(bridge.get_course_select_zone_label() == "ZONE 5", "zone label uses zone index")
	bridge._language_index = 2
	_check(bridge.get_course_select_title() == "KURSAUSWAHL", "course select title follows saved language")
	_check(bridge.get_course_select_summary_text().contains("AKTUELLER KURS"), "course select summary follows saved language")
	bridge._language_index = original_language
	var rows: Array = bridge.get_course_select_rows()
	_check(rows.size() == 4, "course panel uses four-row window")
	_check(bool(rows[1].get("selected", false)), "selected course stays in row window")
	_check(bool(rows[1].get("unlocked", false)), "course row exposes language-independent unlock state")
	var original_cleared: Array = bridge._level_cleared_flags.duplicate()
	bridge._level_cleared_flags[8] = true
	rows = bridge.get_course_select_rows()
	_check(bool(rows[1].get("cleared", false)), "course row exposes language-independent clear state")
	bridge._level_cleared_flags = original_cleared
	bridge.move_title_selection(1)
	_check(bridge.get_selected_level_index() == 8, "course selection stops at unlock limit")
	var nodes: Array = bridge.get_course_select_map_nodes()
	_check(not bool(nodes[9].get("unlocked", true)), "locked map node remains locked")
	bridge.start_title_selection()
	_check(bridge.is_course_select_starting(), "course launch enters start transition")
	bridge.advance_ui_timers(0.30)
	_check(bridge.is_intro_screen(), "course launch enters stage intro")
	bridge._unlocked_level_index = original_unlocked
	bridge._selected_level_index = original_selected
	bridge._language_index = original_language
	bridge.open_title_screen_and_skip_intro()
	print("COURSE_SELECT_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("COURSE_SELECT_FAIL: " + label)
