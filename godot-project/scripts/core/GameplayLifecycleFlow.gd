class_name GameplayLifecycleFlow
extends RefCounted

## Owns deterministic setup of a playable level run.
static func initialize(bridge: Object, level_id: int, from_time_attack: bool, from_multiplayer: bool) -> void:
	level_id = clampi(level_id, 0, bridge._unlocked_level_index)
	bridge._run_from_time_attack = from_time_attack
	bridge._run_from_multiplayer = from_multiplayer
	if from_multiplayer: bridge._multiplayer_course_results_committed = false
	bridge._elapsed_time = 0.0
	bridge._velocity_y = 0.0
	bridge._level_complete = false
	bridge._intro_timer = bridge.STAGE_INTRO_DURATION if bridge._is_boss_intro() else bridge.INTRO_TOTAL_TIME
	bridge._final_intro_timer = 0.0
	bridge._final_intro_pending = false
	bridge._intro_primed = false
	bridge._intro_speed_boost = false
	bridge._intro_boost_disabled = false
	bridge._race_start_message_timer = 0.0
	bridge._start_boost_timer = 0.0
	bridge._clear_time_snapshot = 0.0
	bridge._clear_score_snapshot = 0
	bridge._clear_final_score_snapshot = 0
	bridge._clear_rank_text = "D"
	bridge._clear_ring_snapshot = 0
	bridge._clear_special_ring_snapshot = 0
	bridge._clear_previous_best_time = -1.0
	bridge._clear_new_best_time = false
	bridge._clear_time_attack_record_rank = 0
	bridge._clear_time_bonus_remaining = 0
	bridge._clear_ring_bonus_remaining = 0
	bridge._clear_special_ring_bonus_remaining = 0
	bridge._clear_total_display_score = 0
	bridge._clear_count_step_accumulator = 0.0
	bridge._clear_count_delay_timer = 0.0
	bridge._clear_input_lock_timer = 0.0
	bridge._clear_counting_done = false
	bridge._clear_from_goal = false
	bridge._game_over_timer = 0.0
	bridge._game_over_input_lock_timer = 0.0
	bridge._game_over_time_over = false
	bridge._save_reset_pending = false
	bridge._status_text = "READY!"
	bridge._title_text = bridge._level_names[level_id]
	bridge._source_map_manifest = bridge.SOURCE_MAP_LOADER.load_level(level_id, from_time_attack and bridge._time_attack_boss_mode)
	bridge._pause_text = bridge.get_pause_text()
	bridge._level_state = bridge._build_level(level_id)
	bridge._spawn_x = bridge._level_state.spawn_x
	bridge._spawn_y = bridge._level_state.spawn_y
	bridge._respawn_x = bridge._spawn_x
	bridge._respawn_y = bridge._spawn_y
	bridge._checkpoint_time = 0.0
	bridge._damage_cooldown = 0.0
	bridge._invincibility_timer = 0.0
	bridge._clear_screen_shake()
	bridge._reset_input_buffer()
	bridge._speed_up_timer = 0.0
	bridge._magnetic_shielded = false
	bridge._defeat_score_index = 0
	bridge._reset_player()
	bridge._player_state.is_alive = true
	if bridge._player_state.variant == 1 and not bridge._run_from_multiplayer and level_id < 15:
		bridge._spawn_cheese_companion()
	if level_id == bridge._level_names.size() - 1 and not from_time_attack and not from_multiplayer:
		bridge._game_state = bridge.GAME_STATE_FINAL_INTRO
		bridge._final_intro_timer = 10.0
		bridge._final_intro_pending = true
		bridge._status_text = "TRUE AREA 53 INTRO"
	else:
		bridge._game_state = bridge.GAME_STATE_INTRO
