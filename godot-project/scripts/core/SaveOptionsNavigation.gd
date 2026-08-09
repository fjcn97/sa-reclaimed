class_name SaveOptionsNavigation
extends RefCounted

## Directional behavior for the save/options state machine. Keeping it outside
## CoreBridge makes each screen's allowed directions explicit and testable.

static func move_vertical(bridge: Object, direction: int) -> void:
	if bridge._game_state != bridge.GAME_STATE_SAVE_OPTIONS:
		return
	var items: Array = bridge.get_options_active_items()
	if items.is_empty():
		return
	match bridge._options_mode:
		bridge.OPTIONS_MODE_MAIN:
			bridge._options_menu_index = wrapi(bridge._options_menu_index + direction, 0, items.size())
		bridge.OPTIONS_MODE_PLAYER_DATA:
			bridge._player_data_menu_index = wrapi(bridge._player_data_menu_index + direction, 0, items.size())
		bridge.OPTIONS_MODE_LANGUAGE:
			bridge.OPTIONS_SETTINGS_SYSTEM.move_language_preview(bridge, direction)
		bridge.OPTIONS_MODE_SOUND_TEST:
			bridge._move_sound_test_vertical(direction)
			if bridge._sound_test_state == bridge.SOUND_TEST_STATE_STOPPED:
				bridge._status_text = bridge.get_sound_test_status_text()
		bridge.OPTIONS_MODE_MULTI_RECORDS:
			var next_index := clampi(bridge._multi_records_menu_index + direction, 0, bridge.get_multiplayer_records_scroll_max())
			if next_index != bridge._multi_records_menu_index:
				bridge._multi_records_menu_index = next_index
				bridge._status_text = "VERSUS RECORDS"
		bridge.OPTIONS_MODE_DELETE_CONFIRM, bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			bridge._delete_confirm_index = wrapi(bridge._delete_confirm_index + direction, 0, 2)
		bridge.OPTIONS_MODE_TIME_RECORDS:
			if bridge._time_records_context == bridge.TIME_RECORDS_CONTEXT_OPTIONS and bridge._time_records_view == bridge.TIME_RECORDS_VIEW_COURSES:
				bridge._time_records_character_index = wrapi(bridge._time_records_character_index + direction, 0, bridge.get_time_records_character_rows().size())
		bridge.OPTIONS_MODE_NAME_ENTRY:
			bridge._move_name_entry_cursor_vertical(direction)

static func adjust_horizontal(bridge: Object, direction: int) -> void:
	if bridge._game_state != bridge.GAME_STATE_SAVE_OPTIONS:
		return
	match bridge._options_mode:
		bridge.OPTIONS_MODE_BUTTON_CONFIG:
			bridge._cycle_button_config_binding(direction)
		bridge.OPTIONS_MODE_SOUND_TEST:
			bridge._sound_test_track_index = wrapi(bridge._sound_test_track_index + direction, 0, bridge.get_sound_test_track_count())
			if bridge._sound_test_state == bridge.SOUND_TEST_STATE_STOPPED:
				bridge._status_text = bridge.get_sound_test_status_text()
		bridge.OPTIONS_MODE_DIFFICULTY:
			bridge._difficulty_index = wrapi(bridge._difficulty_index + direction, 0, 3)
		bridge.OPTIONS_MODE_TIME_LIMIT:
			bridge._time_limit_enabled = not bridge._time_limit_enabled
		bridge.OPTIONS_MODE_TIME_RECORDS:
			if bridge._time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE:
				bridge._time_records_boss_mode = direction > 0
			else:
				bridge._advance_time_records_course(direction)
		bridge.OPTIONS_MODE_NAME_ENTRY:
			bridge._move_name_entry_cursor_horizontal(direction)

static func direction_consumes_action(bridge: Object, frame_input: int) -> bool:
	if bridge._game_state != bridge.GAME_STATE_SAVE_OPTIONS:
		return false
	var vertical := bool(frame_input & (bridge.DPAD_UP | bridge.DPAD_DOWN))
	var horizontal := bool(frame_input & (bridge.DPAD_LEFT | bridge.DPAD_RIGHT))
	if bridge._options_mode == bridge.OPTIONS_MODE_SOUND_TEST:
		return false
	match bridge._options_mode:
		bridge.OPTIONS_MODE_PLAYER_DATA, bridge.OPTIONS_MODE_LANGUAGE, bridge.OPTIONS_MODE_NAME_ENTRY:
			return vertical
		bridge.OPTIONS_MODE_BUTTON_CONFIG, bridge.OPTIONS_MODE_DIFFICULTY, bridge.OPTIONS_MODE_TIME_LIMIT:
			return horizontal
		bridge.OPTIONS_MODE_DELETE_CONFIRM, bridge.OPTIONS_MODE_DELETE_CONFIRM_FINAL:
			return vertical
		bridge.OPTIONS_MODE_TIME_RECORDS:
			return horizontal if bridge._time_records_view == bridge.TIME_RECORDS_VIEW_MODE_CHOICE else vertical or horizontal
	return false
