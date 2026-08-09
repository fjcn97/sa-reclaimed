class_name SaveOptionsTransitionFlow
extends RefCounted

## Owns save-options confirm/back state transitions. CoreBridge supplies state
## and lower-level operations, while this flow keeps routing decisions together.

static func accept(bridge: Object) -> void:
	if bridge._game_state != bridge.GAME_STATE_SAVE_OPTIONS:
		return
	if bridge._save_reset_pending:
		bridge._reset_progress()
		bridge._save_reset_pending = false
		bridge._options_mode = bridge.OPTIONS_MODE_PLAYER_DATA
		bridge._player_data_menu_index = 0
		bridge._status_text = "PLAYER DATA"
		return
	match bridge._options_mode:
		bridge.OPTIONS_MODE_MAIN:
			_accept_main(bridge)
			if not bridge.is_save_options():
				return
		bridge.OPTIONS_MODE_PLAYER_DATA:
			_accept_player_data(bridge)
		bridge.OPTIONS_MODE_LANGUAGE:
			bridge.OPTIONS_SETTINGS_SYSTEM.commit_language_preview(bridge)
			if bridge._creating_new_profile:
				bridge._player_profile_name = [" ", " ", " ", " ", " ", " "]
				bridge._name_entry_snapshot = bridge._player_profile_name.duplicate()
				bridge._multiplayer_name_entry_snapshot = bridge._player_profile_name.duplicate()
				bridge._reset_name_entry_navigation()
				bridge._options_mode = bridge.OPTIONS_MODE_NAME_ENTRY
				bridge._status_text = "NAME ENTRY"
			else:
				bridge._options_mode = bridge.OPTIONS_MODE_MAIN
				bridge._options_menu_index = 3
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			if bridge._button_config_index == 0:
				bridge._finalize_button_config_a_stage()
			elif bridge._button_config_index == 1:
				bridge._finalize_button_config_b_stage()
			else:
				bridge._commit_button_config_bindings()
				bridge._options_mode = bridge.OPTIONS_MODE_MAIN
				bridge._options_menu_index = 4
		bridge.OPTIONS_MODE_SOUND_TEST:
			bridge._sound_test_state = bridge.SOUND_TEST_STATE_PLAYING
			bridge._status_text = bridge.get_sound_test_status_text()
			return
		bridge.OPTIONS_MODE_DIFFICULTY:
			bridge._options_mode = bridge.OPTIONS_MODE_MAIN
			bridge._options_menu_index = 1
		bridge.OPTIONS_MODE_TIME_LIMIT:
			bridge._options_mode = bridge.OPTIONS_MODE_MAIN
			bridge._options_menu_index = 2
		bridge.OPTIONS_MODE_DELETE_CONFIRM:
			if bridge._delete_confirm_index == 0:
				bridge._options_mode = bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL
				bridge._delete_confirm_index = 1
			else:
				_return_delete_to_main(bridge)
		bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			if bridge._delete_confirm_index == 0:
				bridge._reset_progress()
				bridge._options_mode = bridge.OPTIONS_MODE_MAIN
				bridge._options_menu_index = 0
				bridge._status_text = "SAVE DATA DELETED"
				return
			_return_delete_to_main(bridge)
		bridge.OPTIONS_MODE_TIME_RECORDS:
			if bridge._time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
				bridge._time_records_view = bridge.TIME_RECORDS_VIEW_COURSES
				bridge._time_records_menu_index = 0
			elif bridge._time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
				bridge._selected_character_index = bridge._time_records_character_index
				bridge._player_state.variant = bridge._selected_character_index
				bridge._time_attack_boss_mode = bridge._time_records_boss_mode
				bridge._selected_level_index = bridge._get_time_records_level_index()
				bridge._begin_level_run(bridge._selected_level_index, true)
				return
			else:
				bridge.update_save_menu_status()
				return
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			bridge._status_text = "VERSUS RECORDS"
			return
		bridge.OPTIONS_MODE_NAME_ENTRY:
			_accept_name_entry(bridge)
			if not bridge.is_save_options():
				return
	bridge.update_save_menu_status()

static func cancel(bridge: Object) -> void:
	if bridge._game_state != bridge.GAME_STATE_SAVE_OPTIONS:
		return
	if bridge._save_reset_pending:
		bridge._save_reset_pending = false
		bridge.update_save_menu_status()
		return
	match bridge._options_mode:
		bridge.OPTIONS_MODE_MAIN:
			bridge._persist_frontend_state()
			bridge.open_title_screen_at_single_player_menu(0)
		bridge.OPTIONS_MODE_PLAYER_DATA:
			bridge._options_mode = bridge.OPTIONS_MODE_MAIN
			bridge._options_menu_index = 0
		bridge.OPTIONS_MODE_LANGUAGE:
			bridge.OPTIONS_SETTINGS_SYSTEM.cancel_language_preview(bridge)
			if bridge._creating_new_profile:
				bridge._creating_new_profile = false
				if bridge._return_to_multiplayer_after_name_entry:
					bridge._return_to_multiplayer_after_name_entry = false
					bridge.open_title_screen_at_multiplayer_menu(clampi(bridge._return_to_multiplayer_menu_index, 0, 1), "PROFILE CREATION CANCELED")
				else:
					bridge._return_to_title_after_new_profile = false
					bridge.open_title_screen_at_single_player_menu(0, "PROFILE CREATION CANCELED")
				return
			bridge._options_mode = bridge.OPTIONS_MODE_MAIN
			bridge._options_menu_index = 3
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			if bridge._button_config_index == 0:
				bridge._button_bindings = bridge._button_bindings_before_edit.duplicate()
				bridge._options_mode = bridge.OPTIONS_MODE_MAIN
				bridge._options_menu_index = 4
			elif bridge._button_config_index == 1:
				bridge._button_config_index = 0
			else:
				bridge._button_config_index = 1
		bridge.OPTIONS_MODE_SOUND_TEST:
			if bridge._sound_test_state == bridge.SOUND_TEST_STATE_PLAYING:
				bridge._sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
			else:
				bridge._options_mode = bridge.OPTIONS_MODE_MAIN
				bridge._options_menu_index = 5
		bridge.OPTIONS_MODE_DIFFICULTY:
			bridge._difficulty_index = bridge._difficulty_before_edit
			bridge._options_mode = bridge.OPTIONS_MODE_MAIN
			bridge._options_menu_index = 1
		bridge.OPTIONS_MODE_TIME_LIMIT:
			bridge._time_limit_enabled = bridge._time_limit_before_edit
			bridge._options_mode = bridge.OPTIONS_MODE_MAIN
			bridge._options_menu_index = 2
		bridge.OPTIONS_MODE_DELETE_CONFIRM, bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			_return_delete_to_main(bridge)
		bridge.OPTIONS_MODE_TIME_RECORDS:
			if bridge._time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
				bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS if bridge._time_records_boss_mode else bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE, bridge._time_records_character_index)
			else:
				bridge._options_mode = bridge.OPTIONS_MODE_PLAYER_DATA
				bridge._player_data_menu_index = 1
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			bridge._options_mode = bridge.OPTIONS_MODE_PLAYER_DATA
			bridge._player_data_menu_index = 2
		bridge.OPTIONS_MODE_NAME_ENTRY:
			bridge._player_profile_name = bridge._name_entry_snapshot.duplicate()
			if bridge._return_to_multiplayer_after_name_entry:
				bridge._return_from_name_entry_to_multiplayer(false)
			elif bridge._return_to_title_after_new_profile:
				bridge._return_to_title_after_new_profile = false
				bridge._creating_new_profile = false
				bridge.open_title_screen_at_single_player_menu(0, "PROFILE CREATION CANCELED")
			else:
				bridge._options_mode = bridge.OPTIONS_MODE_PLAYER_DATA
				bridge._player_data_menu_index = 0
	bridge.update_save_menu_status()

static func _accept_main(bridge: Object) -> void:
	match bridge._options_menu_index:
		0: bridge._options_mode = bridge.OPTIONS_MODE_PLAYER_DATA; bridge._player_data_menu_index = 0
		1: bridge.OPTIONS_SETTINGS_SYSTEM.cycle_difficulty(bridge); bridge._status_text = "OPTIONS"
		2: bridge.OPTIONS_SETTINGS_SYSTEM.toggle_time_limit(bridge); bridge._status_text = "OPTIONS"
		3: bridge.OPTIONS_SETTINGS_SYSTEM.begin_language_preview(bridge); bridge._options_mode = bridge.OPTIONS_MODE_LANGUAGE
		4: bridge._options_mode = bridge.OPTIONS_MODE_BUTTON_CONFIG; bridge._button_config_index = 0; bridge._button_bindings_before_edit = bridge._button_bindings.duplicate()
		5: bridge._options_mode = bridge.OPTIONS_MODE_SOUND_TEST if bridge._sound_test_unlocked else bridge.OPTIONS_MODE_DELETE_CONFIRM; bridge._sound_test_menu_index = 0; bridge._sound_test_state = bridge.SOUND_TEST_STATE_STOPPED; bridge._delete_confirm_index = 1
		6: 
			if bridge._sound_test_unlocked: bridge._options_mode = bridge.OPTIONS_MODE_DELETE_CONFIRM; bridge._delete_confirm_index = 1
			else: bridge._persist_frontend_state(); bridge.open_title_screen_at_single_player_menu(0)
		7: bridge._persist_frontend_state(); bridge.open_title_screen_at_single_player_menu(0)

static func _accept_player_data(bridge: Object) -> void:
	match bridge._player_data_menu_index:
		0: bridge._options_mode = bridge.OPTIONS_MODE_NAME_ENTRY; bridge._reset_name_entry_navigation(); bridge._name_entry_snapshot = bridge._player_profile_name.duplicate()
		1: bridge._options_mode = bridge.OPTIONS_MODE_TIME_RECORDS; bridge._time_records_menu_index = 0; bridge._time_records_context = bridge.TIME_RECORDS_CONTEXT_OPTIONS; bridge._time_records_view = bridge.TIME_RECORDS_VIEW_MODE_CHOICE if bridge._boss_time_attack_unlocked else bridge.TIME_RECORDS_VIEW_COURSES; bridge._time_records_boss_mode = false; bridge._time_records_character_index = 0; bridge._time_records_course_index = 0; bridge._time_records_act_index = 0
		2: bridge._options_mode = bridge.OPTIONS_MODE_MULTI_RECORDS; bridge._multi_records_menu_index = 0
		3: bridge._options_mode = bridge.OPTIONS_MODE_MAIN; bridge._options_menu_index = 0

static func _accept_name_entry(bridge: Object) -> void:
	if not bridge._is_name_entry_control_cursor():
		bridge._apply_name_entry_selected_cell()
		bridge.update_save_menu_status()
		return
	match bridge._name_entry_cursor_row:
		bridge.NAME_ENTRY_CONTROL_ROW_BACK: bridge._move_name_entry_active_slot(-1)
		bridge.NAME_ENTRY_CONTROL_ROW_FORWARD: bridge._move_name_entry_active_slot(1)
		bridge.NAME_ENTRY_CONTROL_ROW_END:
			if not bridge.has_profile_name(): bridge._status_text = "PROFILE NAME REQUIRED"; return
			bridge._name_entry_snapshot = bridge._player_profile_name.duplicate()
			bridge._save_save_data()
			if bridge._return_to_multiplayer_after_name_entry: bridge._return_from_name_entry_to_multiplayer(true)
			elif bridge._return_to_title_after_new_profile: bridge._return_to_title_after_new_profile = false; bridge._creating_new_profile = false; bridge.open_title_screen_at_single_player_menu(0, "PROFILE SAVED")
			else: bridge._options_mode = bridge.OPTIONS_MODE_PLAYER_DATA; bridge._player_data_menu_index = 0; bridge._status_text = "NAME SAVED"

static func _return_delete_to_main(bridge: Object) -> void:
	bridge._options_mode = bridge.OPTIONS_MODE_MAIN
	bridge._options_menu_index = bridge._get_options_item_index("DELETE GAME DATA")
