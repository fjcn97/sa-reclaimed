extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node_or_null("CoreBridge")
	if bridge == null:
		bridge = preload("res://scripts/CoreBridge.gd").new()
		bridge.name = "CoreBridge"
		get_root().add_child(bridge)
	bridge.open_press_start_screen()
	_check(bridge.is_press_start_screen(), "press start")
	bridge.open_title_screen_at_play_mode_menu()
	_check(bridge.is_play_mode_screen(), "play mode")
	var play_original_language: int = bridge._language_index
	bridge._language_index = 2
	var play_mode_rows: Array = bridge.get_play_mode_rows()
	_check(play_mode_rows[0]["description"] == "GESCHICHTE, LEVELS UND SOLO-FORTSCHRITT", "play mode description follows localization")
	_check(bool(play_mode_rows[0].get("available", false)), "single player exposes availability state")
	_check(bool(play_mode_rows[1].get("available", false)) == bridge.has_profile_name(), "multiplayer availability follows profile state")
	bridge._language_index = play_original_language
	bridge.open_title_screen_at_single_player_menu()
	_check(bridge.is_single_player_menu_screen(), "single player")
	bridge.open_title_screen_at_multiplayer_menu()
	_check(bridge.is_multiplayer_mode_screen(), "multiplayer mode")
	bridge.open_multiplayer_lobby_screen()
	_check(bridge.is_multiplayer_lobby_screen(), "multiplayer lobby")
	bridge.open_multiplayer_comm_screen(1)
	_check(bridge.is_multiplayer_comm_screen(), "multiplayer communication")
	bridge.open_singlepak_sync_screen()
	_check(bridge.is_multiplayer_comm_screen(), "single pak sync")
	bridge.open_singlepak_results_screen()
	_check(bridge.is_singlepak_results_screen(), "single pak results")
	bridge.open_multiplayer_outcome_screen(0, 3)
	_check(bridge.is_multiplayer_outcome_screen(), "multiplayer outcome")
	bridge.open_title_screen_at_time_attack_menu()
	_check(bridge.is_time_attack_mode_screen(), "time attack mode")
	var original_language: int = bridge._language_index
	bridge._language_index = 2
	var time_attack_rows: Array = bridge.get_time_attack_mode_rows()
	_check(bridge.get_time_attack_mode_prompt_text() == "ANGRIFFSMODUS WAEHLEN", "time attack mode prompt follows localization")
	_check(time_attack_rows[1]["status"] == "GESPERRT" and bool(time_attack_rows[1].get("locked", false)), "time attack lock state is localized and semantic")
	bridge._language_index = original_language
	bridge.open_time_attack_level_select_screen()
	_check(bridge.is_time_attack_level_select_screen(), "time attack level select")
	bridge.open_course_select_screen(2)
	_check(bridge.is_course_select_screen(), "course select")
	bridge.open_character_select()
	_check(bridge.is_character_select(), "character select")
	bridge.open_options_screen()
	_check(bridge.is_options_main_screen(), "options main")
	_exercise_options(bridge)
	_exercise_special_stage(bridge)
	bridge.open_title_screen_and_skip_intro()
	_check(bridge.is_title_screen(), "return to title")
	print("MENU_FLOW_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _exercise_special_stage(bridge: Node) -> void:
	bridge._open_special_stage()
	_check(bridge.is_special_stage_screen(), "special stage entry")
	bridge.advance_ui_timers(3.0)
	_check(bridge.is_special_stage_running_screen(), "special stage run")
	bridge.advance_ui_timers(0.25, bridge.DPAD_UP, bridge.A_BUTTON)
	_check(bridge.get_special_stage_speed() > 1.0, "special stage acceleration")
	_check(bridge.is_special_stage_jumping(), "special stage jump")
	bridge.advance_ui_timers(0.8)
	_check(not bridge.is_special_stage_jumping(), "special stage jump recovery")
	bridge.advance_ui_timers(0.5, bridge.DPAD_RIGHT, bridge.DPAD_RIGHT)
	_check(bridge.get_special_stage_progress() > 0.0, "special stage progress")
	_check(bridge.get_special_stage_guard_state().has("progress"), "special stage guard")
	bridge._advance_special_stage()
	_check(bridge.is_special_stage_results_screen(), "special stage results")
	bridge._advance_special_stage()

func _exercise_options(bridge: Node) -> void:
	var items: Array = bridge.get_options_menu_items()
	for index in range(maxi(0, items.size() - 1)):
		bridge.open_options_screen()
		for _step in range(index):
			bridge.move_save_selection(1)
		bridge.accept_save_selection()
		var label := str(items[index])
		match label:
			"PLAYER DATA":
				_check(bridge.is_player_data_screen(), "options player data")
				bridge.accept_save_selection()
				_check(bridge.is_name_entry_screen(), "options name entry")
				bridge.cancel_save_selection()
				bridge.move_save_selection(1)
				bridge.accept_save_selection()
				_check(bridge.is_time_records_screen(), "options time records")
				bridge.cancel_save_selection()
				bridge.move_save_selection(1)
				bridge.accept_save_selection()
				_check(bridge.is_multiplayer_records_screen(), "options multiplayer records")
				bridge.cancel_save_selection()
			"DIFFICULTY":
				_check(bridge.is_options_main_screen(), "difficulty stays on options")
			"TIME LIMIT":
				_check(bridge.is_options_main_screen(), "time limit stays on options")
			"LANGUAGE":
				_check(bridge.is_language_screen(), "options language")
			"BUTTON CONFIG":
				_check(bridge.is_button_config_screen(), "options button config")
			"SOUND TEST":
				_check(bridge.is_sound_test_screen(), "options sound test")
			"DELETE GAME DATA":
				_check(bridge.is_delete_confirm_screen(), "options delete confirm")
		bridge.cancel_save_selection()

func _check(condition: bool, label: String) -> void:
	if not condition:
		push_error("MENU_FLOW_FAILED %s" % label)
		failed = true
		return
	checks += 1
