extends SceneTree

const CHECKS := 0
var checks := 0

func _check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		push_error("TIME_RECORDS_SMOKE_FAIL: %s" % message)
		quit(1)

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge = get_root().get_node("CoreBridge")
	bridge.open_options_screen()
	bridge._options_mode = bridge.OPTIONS_MODE_TIME_RECORDS
	bridge._time_records_context = bridge.TIME_RECORDS_CONTEXT_OPTIONS
	bridge._time_records_view = bridge.TIME_RECORDS_VIEW_COURSES
	bridge._time_records_boss_mode = false
	bridge._time_records_character_index = 0
	bridge._time_records_course_index = 0
	bridge._time_records_act_index = 0
	bridge._character_unlocked_level_indices[0] = 0

	_check(bridge.get_time_records_available_course_count() == 7, "options records browse all zones")
	bridge._language_index = 2
	_check(bridge.get_time_records_best_label_text(0) == "BESTE 1", "time records best label follows localization")
	bridge._language_index = 1
	bridge._advance_time_records_course(-1)
	_check(bridge._time_records_course_index == 6 and bridge._time_records_act_index == 1, "left wraps to zone 7 act 2")
	bridge._advance_time_records_course(1)
	_check(bridge._time_records_course_index == 0 and bridge._time_records_act_index == 0, "right wraps to zone 1 act 1")
	bridge._advance_time_records_course(1)
	_check(bridge._time_records_course_index == 0 and bridge._time_records_act_index == 1, "right toggles to act 2")
	bridge._advance_time_records_course(1)
	_check(bridge._time_records_course_index == 1 and bridge._time_records_act_index == 0, "right advances to next zone")
	bridge._time_records_course_index = 6
	bridge._time_records_act_index = 1
	var rows: Array = bridge.get_time_record_rows()
	_check(rows.size() == 3, "empty record table has three rows")
	_check(str(rows[0].get("time", "")) == "09'59\"99", "empty records use source sentinel")
	bridge._character_unlocked = [true, true, false, false, false]
	bridge._time_records_boss_mode = true
	bridge._time_records_character_index = 0
	bridge.move_save_selection(1)
	_check(bridge._time_records_character_index == 1, "boss records can change character with vertical input")
	bridge.move_save_selection(1)
	_check(bridge._time_records_character_index == 0, "character records wrap across unlocked runners")
	bridge._time_records_context = bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK
	bridge._time_records_boss_mode = false
	bridge._time_records_character_index = 1
	bridge._unlocked_level_index = 6
	bridge._character_unlocked_level_indices[1] = 2
	_check(bridge.get_time_records_available_course_count() == 2, "time attack uses the selected character course unlocks")
	_check(bridge._get_time_records_max_act_for_course(1) == 0, "time attack limits the selected character's final course")
	bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE, bridge._time_records_character_index)
	_check(bridge.get_character_menu_index() == 1, "character select receives the records character as initial selection")

	print("TIME_RECORDS_CHECKS=%d" % checks)
	quit(0)
