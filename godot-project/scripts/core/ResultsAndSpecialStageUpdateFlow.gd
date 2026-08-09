class_name ResultsAndSpecialStageUpdateFlow
extends RefCounted

## Keeps end-of-run counters and special-stage simulation out of the generic
## UI timer coordinator. Returns true when it consumed the current state.
static func advance(bridge: Object, delta: float, held_input: int, frame_input: int) -> bool:
	if bridge._game_state == bridge.GAME_STATE_CLEAR:
		bridge._clear_input_lock_timer = maxf(0.0, bridge._clear_input_lock_timer - delta)
		bridge._clear_count_delay_timer = maxf(0.0, bridge._clear_count_delay_timer - delta)
		if bridge._run_from_multiplayer:
			bridge._prepare_multiplayer_results_snapshot(bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
			bridge.open_singlepak_results_screen(bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE, 0)
			return true
		if bridge._run_from_time_attack:
			if bridge._time_attack_exit_timer > 0.0:
				bridge._time_attack_exit_timer = maxf(0.0, bridge._time_attack_exit_timer - delta)
				if bridge._time_attack_exit_timer <= 0.0:
					bridge.open_time_attack_lobby(bridge._time_attack_boss_mode)
				return true
			bridge._time_attack_result_timer += delta
			if bridge._time_attack_result_timer >= 10.0:
				bridge.open_time_attack_lobby(bridge._time_attack_boss_mode)
				return true
		if not bridge._run_from_time_attack and not bridge._clear_counting_done and bridge._clear_count_delay_timer <= 0.0:
			bridge._advance_clear_count_step()
		elif not bridge._run_from_time_attack and not bridge._run_from_multiplayer and bridge._clear_counting_done and bridge._clear_input_lock_timer <= 0.0:
			if bridge._character_unlock_pending >= 0:
				bridge._open_character_unlock()
			elif bridge._special_stage_pending:
				bridge._open_special_stage()
			elif bridge._should_show_to_be_continued():
				bridge._open_to_be_continued()
			elif bridge._should_show_chaos_emeralds_message():
				if bridge.get_chaos_emerald_count() >= 7:
					bridge._open_chaos_emeralds_message()
				else:
					bridge._open_missing_emeralds_message()
			else:
				bridge._open_next_single_player_course()
		return true
	if bridge._game_state != bridge.GAME_STATE_SPECIAL_STAGE:
		return false
	if bridge._special_stage_paused:
		return true
	if bridge._special_stage_phase == 1:
		bridge._update_special_stage_guard_robo(delta)
		bridge._update_special_stage_run(delta, held_input, frame_input)
	elif bridge._special_stage_phase == 2:
		bridge._update_special_stage_results(delta)
	bridge._special_stage_timer = maxf(0.0, bridge._special_stage_timer - delta)
	if bridge._special_stage_timer <= 0.0 and (bridge._special_stage_phase != 2 or (bridge._special_stage_points_remaining == 0 and bridge._special_stage_bonus_remaining == 0)):
		bridge._advance_special_stage()
	return true
