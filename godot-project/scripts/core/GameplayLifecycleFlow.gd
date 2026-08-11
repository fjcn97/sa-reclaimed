class_name GameplayLifecycleFlow
extends RefCounted

## Owns deterministic setup of a playable level run.
static func initialize(bridge: Object, level_id: int, from_time_attack: bool, from_multiplayer: bool) -> void:
	level_id = clampi(level_id, 0, bridge.get_profile_state().unlocked_level_index)
	bridge.get_run_mode_state().begin(from_time_attack, from_multiplayer)
	if from_multiplayer: bridge.get_multiplayer_lobby_state().course_results_committed = false
	bridge.get_gameplay_runtime_state().elapsed_time = 0.0
	bridge.get_gameplay_runtime_state().velocity_y = 0.0
	bridge.set_level_complete(false)
	bridge.get_stage_intro_state().begin(bridge.STAGE_INTRO_DURATION if bridge.is_boss_intro() else bridge.INTRO_TOTAL_TIME)
	bridge.get_clear_result_state().reset()
	bridge.get_game_over_state().reset()
	bridge.set_save_reset_pending(false)
	bridge.set_status_text("READY!")
	bridge.set_title_text(bridge.get_level_name_by_index(level_id))
	bridge.set_source_map_manifest(bridge.SOURCE_MAP_LOADER.load_level(level_id, from_time_attack and bridge.get_time_attack_session_state().boss_mode))
	bridge.set_pause_text(bridge.get_pause_text())
	bridge.set_level_state(bridge.build_level(level_id))
	bridge.get_checkpoint_state().begin(Vector2(bridge.get_level_state().spawn_x, bridge.get_level_state().spawn_y))
	bridge.get_player_ability_state().reset()
	bridge.clear_screen_shake()
	bridge.reset_input_buffer()
	bridge.get_gameplay_runtime_state().speed_up_timer = 0.0
	bridge.get_gameplay_runtime_state().magnetic_shielded = false
	bridge.get_gameplay_runtime_state().defeat_score_index = 0
	bridge.reset_player()
	bridge.get_player_state().is_alive = true
	if bridge.get_player_state().variant == 1 and not bridge.is_multiplayer_run() and level_id < 15:
		bridge.spawn_cheese_companion()
	if level_id == bridge.get_level_count() - 1 and not from_time_attack and not from_multiplayer:
		bridge.set_game_state(bridge.GAME_STATE_FINAL_INTRO)
		bridge.get_stage_intro_state().final_intro_timer = 10.0
		bridge.get_stage_intro_state().final_intro_pending = true
		bridge.set_status_text("TRUE AREA 53 INTRO")
	else:
		bridge.set_game_state(bridge.GAME_STATE_INTRO)
