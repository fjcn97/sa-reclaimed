class_name GameplayResultsResetFlow
extends RefCounted

## Resets runtime gameplay, clear-result, and transient presentation state
## before the bridge returns to the title front end.
static func reset(bridge: Object) -> void:
	bridge.get_screen_fade_state().reset()
	var clear_result: ClearResultState = bridge.get_clear_result_state()
	var special_stage: SpecialStageState = bridge.get_special_stage_state()
	bridge.get_gameplay_runtime_state().elapsed_time = 0.0
	bridge.get_gameplay_runtime_state().velocity_y = 0.0
	bridge.set_level_complete(false)
	bridge.get_stage_intro_state().reset()
	clear_result.time_snapshot = 0.0
	clear_result.score_snapshot = 0
	clear_result.final_score_snapshot = 0
	clear_result.rank_text = "D"
	clear_result.ring_snapshot = 0
	clear_result.special_ring_snapshot = 0
	clear_result.previous_best_time = -1.0
	clear_result.new_best_time = false
	clear_result.time_attack_record_rank = 0
	bridge.get_time_attack_session_state().reset()
	clear_result.time_bonus_remaining = 0
	clear_result.ring_bonus_remaining = 0
	clear_result.special_ring_bonus_remaining = 0
	clear_result.total_display_score = 0
	clear_result.count_step_accumulator = 0.0
	clear_result.count_delay_timer = 0.0
	clear_result.input_lock_timer = 0.0
	clear_result.counting_done = false
	clear_result.from_goal = false
	clear_result.reset()
	bridge.get_pause_menu_state().reset()
	bridge.get_game_over_state().reset()
	bridge.get_message_card_state().reset_transient()
	bridge.set_copyright_timer(0.0)
	bridge.get_credits_state().reset()
	bridge.get_character_unlock_state().reset()
	bridge.get_frontend_intro_state().reset()
	special_stage.reset()
