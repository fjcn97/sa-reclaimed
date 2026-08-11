class_name OptionsSettingsSystem
extends RefCounted

## Owns the small, reversible settings edited from the Options screens.
## OptionsNavigationState owns cursor/sub-screen data; the bridge only
## coordinates routes and persistent-profile edits.

static func reset_menu_context(bridge: Object) -> void:
	var navigation: OptionsNavigationState = bridge.get_options_navigation_state()
	var profile: ProfileState = bridge.get_profile_state()
	navigation.menu_index = 0
	navigation.player_data_menu_index = 0
	navigation.button_config_index = 0
	navigation.sound_test_menu_index = 0
	profile.sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
	navigation.time_records_menu_index = 0
	navigation.time_records_view = bridge.TIME_RECORDS_VIEW_MODE_CHOICE
	navigation.time_records_context = bridge.TIME_RECORDS_CONTEXT_OPTIONS
	navigation.time_records_boss_mode = false
	navigation.time_records_character_index = 0
	navigation.time_records_course_index = 0
	navigation.time_records_act_index = 0
	navigation.multiplayer_records_menu_index = 0
	navigation.name_entry_menu_index = 0
	navigation.name_entry_cursor_col = 0
	navigation.name_entry_cursor_row = 0
	navigation.name_entry_matrix_page_index = 0
	navigation.delete_confirm_index = 1
	profile.pending_language_index = profile.language_index

static func begin_language_preview(bridge: Object) -> void:
	var profile: ProfileState = bridge.get_profile_state()
	profile.language_index_before_edit = profile.language_index
	profile.pending_language_index = profile.language_index

static func move_language_preview(bridge: Object, direction: int) -> void:
	var profile: ProfileState = bridge.get_profile_state()
	profile.pending_language_index = wrapi(profile.pending_language_index + direction, 0, bridge.get_language_items().size())

static func commit_language_preview(bridge: Object) -> void:
	var profile: ProfileState = bridge.get_profile_state()
	profile.language_index = profile.pending_language_index
	profile.language_index_before_edit = profile.language_index

static func cancel_language_preview(bridge: Object) -> void:
	var profile: ProfileState = bridge.get_profile_state()
	profile.pending_language_index = profile.language_index

static func cycle_difficulty(bridge: Object) -> void:
	var profile: ProfileState = bridge.get_profile_state()
	profile.difficulty_index = wrapi(profile.difficulty_index + 1, 0, 3)

static func toggle_time_limit(bridge: Object) -> void:
	var profile: ProfileState = bridge.get_profile_state()
	profile.time_limit_enabled = not profile.time_limit_enabled
