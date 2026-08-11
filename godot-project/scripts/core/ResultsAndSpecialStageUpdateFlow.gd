class_name ResultsAndSpecialStageUpdateFlow
extends RefCounted

## Keeps end-of-run counters and special-stage simulation out of the generic
## UI timer coordinator. Returns true when it consumed the current state.
static func advance(bridge: Object, delta: float, held_input: int, frame_input: int) -> bool:
	var run_mode = bridge.get_run_mode_state()
	var clear_result: ClearResultState = bridge.get_clear_result_state()
	if bridge.get_game_state() == bridge.GAME_STATE_CLEAR:
		clear_result.input_lock_timer = maxf(0.0, clear_result.input_lock_timer - delta)
		clear_result.count_delay_timer = maxf(0.0, clear_result.count_delay_timer - delta)
		if run_mode.from_multiplayer:
			bridge.prepare_multiplayer_results_snapshot(bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
			bridge.open_singlepak_results_screen(bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE, 0)
			return true
		if run_mode.from_time_attack:
			var time_attack = bridge.get_time_attack_session_state()
			if time_attack.exit_timer > 0.0:
				time_attack.exit_timer = maxf(0.0, time_attack.exit_timer - delta)
				if time_attack.exit_timer <= 0.0:
					bridge.open_time_attack_lobby(time_attack.boss_mode)
				return true
			time_attack.result_timer += delta
			if time_attack.result_timer >= 10.0:
				bridge.open_time_attack_lobby(time_attack.boss_mode)
				return true
		if not run_mode.from_time_attack and not clear_result.counting_done and clear_result.count_delay_timer <= 0.0:
			bridge.advance_clear_count_step()
		elif not run_mode.from_time_attack and not run_mode.from_multiplayer and clear_result.counting_done and clear_result.input_lock_timer <= 0.0:
			if bridge.get_character_unlock_state().pending_character >= 0:
				bridge.open_character_unlock()
			elif bridge.get_special_stage_state().pending:
				bridge.open_special_stage()
			elif bridge.should_show_to_be_continued():
				bridge.open_to_be_continued()
			elif bridge.should_show_chaos_emeralds_message():
				if bridge.get_chaos_emerald_count() >= 7:
					bridge.open_chaos_emeralds_message()
				else:
					bridge.open_missing_emeralds_message()
			else:
				bridge.open_next_single_player_course()
		return true
	if bridge.get_game_state() != bridge.GAME_STATE_SPECIAL_STAGE:
		return false
	var special_stage = bridge.get_special_stage_state()
	if special_stage.paused:
		return true
	if special_stage.phase == 1:
		bridge.update_special_stage_guard_robo(delta)
		bridge.update_special_stage_run(delta, held_input, frame_input)
	elif special_stage.phase == 2:
		bridge.update_special_stage_results(delta)
	special_stage.timer = maxf(0.0, special_stage.timer - delta)
	if special_stage.timer <= 0.0 and (special_stage.phase != 2 or (special_stage.points_remaining == 0 and special_stage.bonus_remaining == 0)):
		bridge.advance_special_stage()
	return true
