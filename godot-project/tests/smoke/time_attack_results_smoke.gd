extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._selected_character_index = 0
	bridge._selected_level_index = 0
	bridge._time_attack_boss_mode = false
	bridge.init_level(0, true, false)
	var record_key: String = bridge._get_current_time_attack_record_key()
	bridge._time_attack_record_tables = {record_key: [10.0, 20.0, 30.0]}
	bridge._time_attack_best_times = {record_key: 10.0}
	bridge._clear_result_state.time_snapshot = 15.0
	bridge._language_index = 2
	_check(bridge.get_time_attack_results_title_text() == "TIME ATTACK ERGEBNIS", "result title follows localization")
	_check(bridge.get_time_attack_results_time_text() == "0'15\"00", "result time uses public bridge API")
	bridge._language_index = 0
	bridge._store_clear_time_attack_result()
	var records: Array = bridge._time_attack_record_tables[record_key]
	_check(records == [10.0, 15.0, 20.0], "records insert in ascending order")
	_check(bridge._clear_time_attack_record_rank == 2, "record rank is second")
	bridge._complete_boss()
	_check(bridge.is_time_attack_clear_screen(), "time attack result opens")
	_check(not bridge.is_clear_input_ready(), "result input is locked initially")
	bridge.clear_replay()
	_check(bridge.is_time_attack_clear_screen(), "early confirm is ignored")
	bridge.advance_ui_timers(2.666)
	_check(bridge.is_clear_input_ready(), "result unlocks after source delay")
	bridge.clear_replay()
	_check(bridge.is_time_attack_clear_screen(), "confirm starts the source fade before lobby")
	bridge.advance_ui_timers(bridge.TIME_ATTACK_RESULTS_EXIT_FADE_SECONDS - 0.01)
	_check(bridge.is_time_attack_clear_screen(), "result fade holds for sixteen source frames")
	bridge.advance_ui_timers(0.02)
	_check(bridge.is_time_attack_lobby_screen(), "confirm returns to lobby")
	print("TIME_ATTACK_RESULTS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TIME_ATTACK_RESULTS_FAIL: " + label)
