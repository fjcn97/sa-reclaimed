class_name OptionsSettingsSystem
extends RefCounted

## Owns the small, reversible settings edited from the Options screens.
## CoreBridge remains the state owner and route coordinator; this system keeps
## preview/commit semantics out of the monolithic bridge.

static func reset_menu_context(bridge: Object) -> void:
	bridge._options_menu_index = 0
	bridge._player_data_menu_index = 0
	bridge._button_config_index = 0
	bridge._sound_test_menu_index = 0
	bridge._sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
	bridge._time_records_menu_index = 0
	bridge._time_records_view = bridge.TIME_RECORDS_VIEW_MODE_CHOICE
	bridge._time_records_context = bridge.TIME_RECORDS_CONTEXT_OPTIONS
	bridge._time_records_boss_mode = false
	bridge._time_records_character_index = 0
	bridge._time_records_course_index = 0
	bridge._time_records_act_index = 0
	bridge._multi_records_menu_index = 0
	bridge._name_entry_menu_index = 0
	bridge._name_entry_cursor_col = 0
	bridge._name_entry_cursor_row = 0
	bridge._name_entry_matrix_page_index = 0
	bridge._delete_confirm_index = 1
	bridge._pending_language_index = bridge._language_index

static func begin_language_preview(bridge: Object) -> void:
	bridge._language_index_before_edit = bridge._language_index
	bridge._pending_language_index = bridge._language_index

static func move_language_preview(bridge: Object, direction: int) -> void:
	bridge._pending_language_index = wrapi(bridge._pending_language_index + direction, 0, bridge.get_language_items().size())

static func commit_language_preview(bridge: Object) -> void:
	bridge._language_index = bridge._pending_language_index
	bridge._language_index_before_edit = bridge._language_index

static func cancel_language_preview(bridge: Object) -> void:
	bridge._pending_language_index = bridge._language_index

static func cycle_difficulty(bridge: Object) -> void:
	bridge._difficulty_index = wrapi(bridge._difficulty_index + 1, 0, 3)

static func toggle_time_limit(bridge: Object) -> void:
	bridge._time_limit_enabled = not bridge._time_limit_enabled
