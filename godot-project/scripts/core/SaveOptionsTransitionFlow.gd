class_name SaveOptionsTransitionFlow
extends RefCounted

## Owns save-options confirm/back state transitions. CoreBridge supplies state
## and lower-level operations, while this flow keeps routing decisions together.

static func accept(bridge: Object) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_SAVE_OPTIONS:
		return
	var options_navigation = bridge.get_options_navigation_state()
	var profile: ProfileState = bridge.get_profile_state()
	var multiplayer = bridge.get_multiplayer_frontend_state()
	if bridge.is_save_reset_pending():
		bridge.reset_progress()
		bridge.set_save_reset_pending(false)
		options_navigation.mode = bridge.OPTIONS_MODE_PLAYER_DATA
		options_navigation.player_data_menu_index = 0
		bridge.set_status_text("PLAYER DATA")
		return
	match options_navigation.mode:
		bridge.OPTIONS_MODE_MAIN:
			_accept_main(bridge)
			if not bridge.is_save_options():
				return
		bridge.OPTIONS_MODE_PLAYER_DATA:
			_accept_player_data(bridge)
		bridge.OPTIONS_MODE_LANGUAGE:
			bridge.OPTIONS_SETTINGS_SYSTEM.commit_language_preview(bridge)
			if multiplayer.creating_new_profile:
				profile.player_profile_name = [" ", " ", " ", " ", " ", " "]
				options_navigation.name_entry_snapshot = profile.player_profile_name.duplicate()
				options_navigation.multiplayer_name_entry_snapshot = profile.player_profile_name.duplicate()
				bridge.reset_name_entry_navigation()
				options_navigation.mode = bridge.OPTIONS_MODE_NAME_ENTRY
				bridge.set_status_text("NAME ENTRY")
			else:
				options_navigation.mode = bridge.OPTIONS_MODE_MAIN
				options_navigation.menu_index = 3
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			if options_navigation.button_config_index == 0:
				bridge.finalize_button_config_a_stage()
			elif options_navigation.button_config_index == 1:
				bridge.finalize_button_config_b_stage()
			else:
				bridge.commit_button_config_bindings()
				options_navigation.mode = bridge.OPTIONS_MODE_MAIN
				options_navigation.menu_index = 4
		bridge.OPTIONS_MODE_SOUND_TEST:
			profile.sound_test_state = bridge.SOUND_TEST_STATE_PLAYING
			bridge.set_status_text(bridge.get_sound_test_status_text())
			return
		bridge.OPTIONS_MODE_DIFFICULTY:
			options_navigation.mode = bridge.OPTIONS_MODE_MAIN
			options_navigation.menu_index = 1
		bridge.OPTIONS_MODE_TIME_LIMIT:
			options_navigation.mode = bridge.OPTIONS_MODE_MAIN
			options_navigation.menu_index = 2
		bridge.OPTIONS_MODE_DELETE_CONFIRM:
			if options_navigation.delete_confirm_index == 0:
				options_navigation.mode = bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL
				options_navigation.delete_confirm_index = 1
			else:
				_return_delete_to_main(bridge)
		bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			if options_navigation.delete_confirm_index == 0:
				bridge.reset_progress()
				options_navigation.mode = bridge.OPTIONS_MODE_MAIN
				options_navigation.menu_index = 0
				bridge.set_status_text("SAVE DATA DELETED")
				return
			_return_delete_to_main(bridge)
		bridge.OPTIONS_MODE_TIME_RECORDS:
			if options_navigation.time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
				options_navigation.time_records_view = bridge.TIME_RECORDS_VIEW_COURSES
				options_navigation.time_records_menu_index = 0
			elif options_navigation.time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
				bridge.get_character_selection_state().selected_index = options_navigation.time_records_character_index
				bridge.get_player_state().variant = bridge.get_character_selection_state().selected_index
				bridge.get_time_attack_session_state().boss_mode = options_navigation.time_records_boss_mode
				profile.selected_level_index = bridge.get_time_records_level_index()
				bridge.begin_level_run(profile.selected_level_index, true)
				return
			else:
				bridge.update_save_menu_status()
				return
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			bridge.set_status_text("VERSUS RECORDS")
			return
		bridge.OPTIONS_MODE_NAME_ENTRY:
			_accept_name_entry(bridge)
			if not bridge.is_save_options():
				return
	bridge.update_save_menu_status()

static func cancel(bridge: Object) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_SAVE_OPTIONS:
		return
	var options_navigation = bridge.get_options_navigation_state()
	var profile: ProfileState = bridge.get_profile_state()
	var multiplayer = bridge.get_multiplayer_frontend_state()
	if bridge.is_save_reset_pending():
		bridge.set_save_reset_pending(false)
		bridge.update_save_menu_status()
		return
	match options_navigation.mode:
		bridge.OPTIONS_MODE_MAIN:
			bridge.persist_frontend_state()
			bridge.open_title_screen_at_single_player_menu(0)
		bridge.OPTIONS_MODE_PLAYER_DATA:
			options_navigation.mode = bridge.OPTIONS_MODE_MAIN
			options_navigation.menu_index = 0
		bridge.OPTIONS_MODE_LANGUAGE:
			bridge.OPTIONS_SETTINGS_SYSTEM.cancel_language_preview(bridge)
			if multiplayer.creating_new_profile:
				multiplayer.creating_new_profile = false
				if multiplayer.return_to_multiplayer_after_name_entry:
					multiplayer.return_to_multiplayer_after_name_entry = false
					bridge.open_title_screen_at_multiplayer_menu(clampi(multiplayer.return_to_multiplayer_menu_index, 0, 1), "PROFILE CREATION CANCELED")
				else:
					multiplayer.return_to_title_after_new_profile = false
					bridge.open_title_screen_at_single_player_menu(0, "PROFILE CREATION CANCELED")
				return
			options_navigation.mode = bridge.OPTIONS_MODE_MAIN
			options_navigation.menu_index = 3
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			if options_navigation.button_config_index == 0:
				profile.button_bindings = profile.button_bindings_before_edit.duplicate()
				options_navigation.mode = bridge.OPTIONS_MODE_MAIN
				options_navigation.menu_index = 4
			elif options_navigation.button_config_index == 1:
				options_navigation.button_config_index = 0
			else:
				options_navigation.button_config_index = 1
		bridge.OPTIONS_MODE_SOUND_TEST:
			if profile.sound_test_state == bridge.SOUND_TEST_STATE_PLAYING:
				profile.sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
			else:
				options_navigation.mode = bridge.OPTIONS_MODE_MAIN
				options_navigation.menu_index = 5
		bridge.OPTIONS_MODE_DIFFICULTY:
			profile.difficulty_index = profile.difficulty_before_edit
			options_navigation.mode = bridge.OPTIONS_MODE_MAIN
			options_navigation.menu_index = 1
		bridge.OPTIONS_MODE_TIME_LIMIT:
			profile.time_limit_enabled = profile.time_limit_before_edit
			options_navigation.mode = bridge.OPTIONS_MODE_MAIN
			options_navigation.menu_index = 2
		bridge.OPTIONS_MODE_DELETE_CONFIRM, bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			_return_delete_to_main(bridge)
		bridge.OPTIONS_MODE_TIME_RECORDS:
			if options_navigation.time_records_context == bridge.TIME_RECORDS_CONTEXT_TIME_ATTACK:
				bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS if options_navigation.time_records_boss_mode else bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE, options_navigation.time_records_character_index)
			else:
				options_navigation.mode = bridge.OPTIONS_MODE_PLAYER_DATA
				options_navigation.player_data_menu_index = 1
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			options_navigation.mode = bridge.OPTIONS_MODE_PLAYER_DATA
			options_navigation.player_data_menu_index = 2
		bridge.OPTIONS_MODE_NAME_ENTRY:
			profile.player_profile_name = options_navigation.name_entry_snapshot.duplicate()
			if multiplayer.return_to_multiplayer_after_name_entry:
				bridge.return_from_name_entry_to_multiplayer(false)
			elif multiplayer.return_to_title_after_new_profile:
				multiplayer.return_to_title_after_new_profile = false
				multiplayer.creating_new_profile = false
				bridge.open_title_screen_at_single_player_menu(0, "PROFILE CREATION CANCELED")
			else:
				options_navigation.mode = bridge.OPTIONS_MODE_PLAYER_DATA
				options_navigation.player_data_menu_index = 0
	bridge.update_save_menu_status()

static func _accept_main(bridge: Object) -> void:
	var options_navigation = bridge.get_options_navigation_state()
	var profile: ProfileState = bridge.get_profile_state()
	match options_navigation.menu_index:
		0: options_navigation.mode = bridge.OPTIONS_MODE_PLAYER_DATA; options_navigation.player_data_menu_index = 0
		1: bridge.OPTIONS_SETTINGS_SYSTEM.cycle_difficulty(bridge); bridge.set_status_text("OPTIONS")
		2: bridge.OPTIONS_SETTINGS_SYSTEM.toggle_time_limit(bridge); bridge.set_status_text("OPTIONS")
		3: bridge.OPTIONS_SETTINGS_SYSTEM.begin_language_preview(bridge); options_navigation.mode = bridge.OPTIONS_MODE_LANGUAGE
		4: options_navigation.mode = bridge.OPTIONS_MODE_BUTTON_CONFIG; options_navigation.button_config_index = 0; profile.button_bindings_before_edit = profile.button_bindings.duplicate()
		5: options_navigation.mode = bridge.OPTIONS_MODE_SOUND_TEST if profile.sound_test_unlocked else bridge.OPTIONS_MODE_DELETE_CONFIRM; options_navigation.sound_test_menu_index = 0; profile.sound_test_state = bridge.SOUND_TEST_STATE_STOPPED; options_navigation.delete_confirm_index = 1
		6: 
			if profile.sound_test_unlocked: options_navigation.mode = bridge.OPTIONS_MODE_DELETE_CONFIRM; options_navigation.delete_confirm_index = 1
			else: bridge.persist_frontend_state(); bridge.open_title_screen_at_single_player_menu(0)
		7: bridge.persist_frontend_state(); bridge.open_title_screen_at_single_player_menu(0)

static func _accept_player_data(bridge: Object) -> void:
	var options_navigation = bridge.get_options_navigation_state()
	var profile: ProfileState = bridge.get_profile_state()
	match options_navigation.player_data_menu_index:
		0: options_navigation.mode = bridge.OPTIONS_MODE_NAME_ENTRY; bridge.reset_name_entry_navigation(); options_navigation.name_entry_snapshot = profile.player_profile_name.duplicate()
		1: options_navigation.mode = bridge.OPTIONS_MODE_TIME_RECORDS; options_navigation.time_records_menu_index = 0; options_navigation.time_records_context = bridge.TIME_RECORDS_CONTEXT_OPTIONS; options_navigation.time_records_view = bridge.TIME_RECORDS_VIEW_MODE_CHOICE if profile.boss_time_attack_unlocked else bridge.TIME_RECORDS_VIEW_COURSES; options_navigation.time_records_boss_mode = false; options_navigation.time_records_character_index = 0; options_navigation.time_records_course_index = 0; options_navigation.time_records_act_index = 0
		2: options_navigation.mode = bridge.OPTIONS_MODE_MULTI_RECORDS; options_navigation.multi_records_menu_index = 0
		3: options_navigation.mode = bridge.OPTIONS_MODE_MAIN; options_navigation.menu_index = 0

static func _accept_name_entry(bridge: Object) -> void:
	var options_navigation = bridge.get_options_navigation_state()
	var profile: ProfileState = bridge.get_profile_state()
	var multiplayer = bridge.get_multiplayer_frontend_state()
	if not bridge.is_name_entry_control_cursor():
		bridge.apply_name_entry_selected_cell()
		bridge.update_save_menu_status()
		return
	match options_navigation.name_entry_cursor_row:
		bridge.NAME_ENTRY_CONTROL_ROW_BACK: bridge.move_name_entry_active_slot(-1)
		bridge.NAME_ENTRY_CONTROL_ROW_FORWARD: bridge.move_name_entry_active_slot(1)
		bridge.NAME_ENTRY_CONTROL_ROW_END:
			if not bridge.has_profile_name(): bridge.set_status_text("PROFILE NAME REQUIRED"); return
			options_navigation.name_entry_snapshot = profile.player_profile_name.duplicate()
			bridge.save_profile()
			if multiplayer.return_to_multiplayer_after_name_entry: bridge.return_from_name_entry_to_multiplayer(true)
			elif multiplayer.return_to_title_after_new_profile: multiplayer.return_to_title_after_new_profile = false; multiplayer.creating_new_profile = false; bridge.open_title_screen_at_single_player_menu(0, "PROFILE SAVED")
			else: options_navigation.mode = bridge.OPTIONS_MODE_PLAYER_DATA; options_navigation.player_data_menu_index = 0; bridge.set_status_text("NAME SAVED")

static func _return_delete_to_main(bridge: Object) -> void:
	var options_navigation = bridge.get_options_navigation_state()
	options_navigation.mode = bridge.OPTIONS_MODE_MAIN
	options_navigation.menu_index = bridge.get_options_item_index("DELETE GAME DATA")
