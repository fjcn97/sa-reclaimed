class_name TitleFrontendResetFlow
extends RefCounted

## Restores all title, options, profile, and multiplayer frontend state without
## touching the active level or player simulation state.
static func reset(bridge: Object) -> void:
	var multiplayer = bridge.get_multiplayer_frontend_state()
	bridge.set_save_reset_pending(false)
	bridge.set_status_text(bridge.get_title_prompt_text())
	bridge.set_title_text("SONIC ADVANCE RECLAIMED")
	bridge.set_pause_text(bridge.get_pause_text())
	bridge.set_save_menu_text("SAVE OPTIONS")
	bridge.set_selected_level_index(clampi(bridge.get_selected_level_index(), 0, bridge.get_profile_state().unlocked_level_index))
	bridge.get_options_navigation_state().save_menu_index = 0
	bridge.get_title_navigation_state().reset(bridge.TITLE_PHASE_PRESS_START)
	bridge.get_title_demo_state().reset()
	bridge.get_options_navigation_state().reset(bridge.OPTIONS_MODE_MAIN)
	bridge.get_options_navigation_state().button_config_index = 0
	bridge.get_options_navigation_state().sound_test_menu_index = 0
	bridge.get_profile_state().sound_test_track_index = 0
	bridge.get_profile_state().sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
	bridge.get_options_navigation_state().time_records_menu_index = 0
	bridge.get_options_navigation_state().time_records_view = bridge.TIME_RECORDS_VIEW_MODE_CHOICE
	bridge.get_options_navigation_state().time_records_context = bridge.TIME_RECORDS_CONTEXT_OPTIONS
	bridge.get_options_navigation_state().time_records_boss_mode = false
	bridge.get_options_navigation_state().time_records_character_index = 0
	bridge.get_options_navigation_state().time_records_course_index = 0
	bridge.get_options_navigation_state().time_records_act_index = 0
	bridge.get_options_navigation_state().multiplayer_records_menu_index = 0
	bridge.get_options_navigation_state().name_entry_menu_index = 0
	bridge.get_options_navigation_state().delete_confirm_index = 1
	bridge.get_character_selection_state().reset()
	multiplayer.return_to_multiplayer_after_name_entry = false
	multiplayer.return_to_title_after_new_profile = false
	multiplayer.creating_new_profile = false
	multiplayer.pak_mode = 0
	multiplayer.link_connected = [true, false, false, false]
	multiplayer.player_characters = [0, 1, 2, 3]
	multiplayer.player_ranks = [0, 1, 2, 3]
	multiplayer.link_ready = false
	multiplayer.disconnect_timer = 0.0
	multiplayer.download_progress = 0
	multiplayer.download_timer = 0.0
	multiplayer.sync_step = 0
	multiplayer.result_mode = bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE
	multiplayer.result_snapshot = []
	multiplayer.results_cursor = 0
	multiplayer.results_timer = 0.0
	bridge.get_multiplayer_lobby_state().reset(bridge.TITLE_PHASE_MULTI_CONNECT)
	bridge.get_time_attack_session_state().lobby_cursor = 0
	bridge.get_time_attack_session_state().boss_mode = false
	bridge.get_course_select_presentation_state().reset(bridge.TITLE_PHASE_TIME_ATTACK_LOBBY)
	bridge.get_course_select_travel_state().reset(bridge.get_selected_level_index())
	bridge.get_course_select_unlock_flow().reset()
	bridge.get_run_mode_state().reset()
	bridge.get_tiny_chao_state().reset_runtime()
