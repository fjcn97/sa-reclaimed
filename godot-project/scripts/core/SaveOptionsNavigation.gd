class_name SaveOptionsNavigation
extends RefCounted

## Directional behavior for the save/options state machine. Keeping it outside
## CoreBridge makes each screen's allowed directions explicit and testable.

static func move_vertical(bridge: Object, direction: int) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_SAVE_OPTIONS:
		return
	var items: Array = bridge.get_options_active_items()
	if items.is_empty():
		return
	var options_navigation = bridge.get_options_navigation_state()
	match options_navigation.mode:
		bridge.OPTIONS_MODE_MAIN:
			options_navigation.menu_index = wrapi(options_navigation.menu_index + direction, 0, items.size())
		bridge.OPTIONS_MODE_PLAYER_DATA:
			options_navigation.player_data_menu_index = wrapi(options_navigation.player_data_menu_index + direction, 0, items.size())
		bridge.OPTIONS_MODE_LANGUAGE:
			bridge.OPTIONS_SETTINGS_SYSTEM.move_language_preview(bridge, direction)
		bridge.OPTIONS_MODE_SOUND_TEST:
			bridge.move_sound_test_vertical(direction)
			if bridge.get_profile_state().sound_test_state == bridge.SOUND_TEST_STATE_STOPPED:
				bridge.set_status_text(bridge.get_sound_test_status_text())
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			var next_index := clampi(bridge.get_options_navigation_state().multiplayer_records_menu_index + direction, 0, bridge.get_multiplayer_records_scroll_max())
			if next_index != bridge.get_options_navigation_state().multiplayer_records_menu_index:
				bridge.get_options_navigation_state().multiplayer_records_menu_index = next_index
				bridge.set_status_text("VERSUS RECORDS")
		bridge.OPTIONS_MODE_DELETE_CONFIRM, bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			bridge.get_options_navigation_state().delete_confirm_index = wrapi(bridge.get_options_navigation_state().delete_confirm_index + direction, 0, 2)
		bridge.OPTIONS_MODE_TIME_RECORDS:
			if bridge.get_options_navigation_state().time_records_context == bridge.TIME_RECORDS_CONTEXT_OPTIONS and bridge.get_options_navigation_state().time_records_view == bridge.TIME_RECORDS_VIEW_COURSES:
				bridge.get_options_navigation_state().time_records_character_index = wrapi(bridge.get_options_navigation_state().time_records_character_index + direction, 0, bridge.get_time_records_character_rows().size())
		bridge.OPTIONS_MODE_NAME_ENTRY:
			bridge.move_name_entry_cursor_vertical(direction)

static func adjust_horizontal(bridge: Object, direction: int) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_SAVE_OPTIONS:
		return
	var options_navigation = bridge.get_options_navigation_state()
	match options_navigation.mode:
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			bridge.cycle_button_config_binding(direction)
		bridge.OPTIONS_MODE_SOUND_TEST:
			bridge.get_profile_state().sound_test_track_index = wrapi(bridge.get_profile_state().sound_test_track_index + direction, 0, bridge.get_sound_test_track_count())
			if bridge.get_profile_state().sound_test_state == bridge.SOUND_TEST_STATE_STOPPED:
				bridge.set_status_text(bridge.get_sound_test_status_text())
		bridge.OPTIONS_MODE_DIFFICULTY:
			bridge.get_profile_state().difficulty_index = wrapi(bridge.get_profile_state().difficulty_index + direction, 0, 3)
		bridge.OPTIONS_MODE_TIME_LIMIT:
			bridge.get_profile_state().time_limit_enabled = not bridge.get_profile_state().time_limit_enabled
		bridge.OPTIONS_MODE_TIME_RECORDS:
			if bridge.get_options_navigation_state().time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
				bridge.get_options_navigation_state().time_records_boss_mode = direction > 0
			else:
				bridge.advance_time_records_course(direction)
		bridge.OPTIONS_MODE_NAME_ENTRY:
			bridge.move_name_entry_cursor_horizontal(direction)

static func direction_consumes_action(bridge: Object, frame_input: int) -> bool:
	if bridge.get_game_state() != bridge.GAME_STATE_SAVE_OPTIONS:
		return false
	var vertical := bool(frame_input & (bridge.DPAD_UP | bridge.DPAD_DOWN))
	var horizontal := bool(frame_input & (bridge.DPAD_LEFT | bridge.DPAD_RIGHT))
	var options_navigation = bridge.get_options_navigation_state()
	if options_navigation.mode == bridge.OPTIONS_MODE_SOUND_TEST:
		return false
	match options_navigation.mode:
		bridge.OPTIONS_MODE_PLAYER_DATA, bridge.OPTIONS_MODE_LANGUAGE, bridge.OPTIONS_MODE_NAME_ENTRY:
			return vertical
		bridge.OPTIONS_MODE_BUTTON_CONFIG, bridge.OPTIONS_MODE_DIFFICULTY, bridge.OPTIONS_MODE_TIME_LIMIT:
			return horizontal
		bridge.OPTIONS_MODE_DELETE_CONFIRM, bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return vertical
		bridge.OPTIONS_MODE_TIME_RECORDS:
			return horizontal if bridge.get_options_navigation_state().time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE else vertical or horizontal
	return false
