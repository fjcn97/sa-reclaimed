# Special-stage state machine extracted from CoreBridge.
extends RefCounted
class_name SpecialStageSystem

static func open_special_stage(bridge: Object) -> void:
	bridge._game_state = bridge.GAME_STATE_SPECIAL_STAGE
	bridge._special_stage_pending = false
	bridge._special_stage_phase = 0
	bridge._special_stage_timer = bridge._special_stage_entry_duration
	bridge._special_stage_ring_count = 0
	bridge._special_stage_score = 0
	bridge._special_stage_emerald_index = bridge._get_selected_zone_index()
	bridge._special_stage_lane = 1
	bridge._special_stage_progress = 0.0
	bridge._special_stage_last_segment = -1
	bridge._special_stage_target_reached = false
	bridge._special_stage_paused = false
	bridge._special_stage_pause_cursor = 0
	bridge._special_stage_multiplier = 1
	bridge._special_stage_multiplier_streak = 0
	bridge._special_stage_multiplier_timer = 0.0
	bridge._special_stage_robo_progress = 0.15
	bridge._special_stage_robo_lane = 1
	bridge._special_stage_robo_speed = float(bridge._special_stage_robo_zone_speeds[bridge._special_stage_emerald_index])
	bridge._special_stage_robo_lane_timer = 0.35
	bridge._special_stage_robo_cooldown = 0.0
	bridge._special_stage_points_remaining = 0
	bridge._special_stage_bonus_remaining = 0
	bridge._special_stage_result_hold_started = false
	bridge._status_text = "SPECIAL STAGE READY"

static func advance_special_stage(bridge: Object) -> void:
	if bridge._game_state != bridge.GAME_STATE_SPECIAL_STAGE:
		return
	if bridge._special_stage_phase == 0:
		bridge._special_stage_phase = 1
		bridge._special_stage_timer = bridge._special_stage_run_duration
		bridge._status_text = "SPECIAL STAGE RUN"
		return
	if bridge._special_stage_phase == 1:
		bridge._special_stage_phase = 2
		# special_stage/main.c caps the ring points at MAX_POINTS (99,900)
		# before the results task starts counting them.
		bridge._special_stage_timer = 0.0
		bridge._special_stage_points_remaining = mini(99900, bridge._special_stage_ring_count * 100)
		bridge._special_stage_bonus_remaining = 10000 if bridge._special_stage_target_reached else 0
		bridge._special_stage_result_hold_started = false
		bridge._special_stage_score = 0
		bridge._status_text = "SPECIAL STAGE RESULTS"
		return
	if bridge._special_stage_points_remaining > 0 or bridge._special_stage_bonus_remaining > 0:
		# A skips both result counters in sub_806C25C/sub_806C338 and
		# leaves only the 60-frame result hold before the fade.
		bridge._special_stage_score += bridge._special_stage_points_remaining + bridge._special_stage_bonus_remaining
		bridge._special_stage_points_remaining = 0
		bridge._special_stage_bonus_remaining = 0
		bridge._special_stage_result_hold_started = true
		bridge._special_stage_timer = 1.0
		return
	bridge._finish_special_stage()

static func update_special_stage_run(bridge: Object, delta: float, held_input: int, frame_input: int = 0) -> void:
	if bridge._special_stage_phase != 1:
		return
	bridge._special_stage_jump_timer = maxf(0.0, bridge._special_stage_jump_timer - delta)
	# physics.c accelerates on Up, brakes on Down, and coasts toward rest.
	if held_input & bridge.DPAD_UP:
		bridge._special_stage_speed = minf(1.6, bridge._special_stage_speed + delta * 1.8)
	elif held_input & bridge.DPAD_DOWN:
		bridge._special_stage_speed = maxf(0.35, bridge._special_stage_speed - delta * 2.4)
	else:
		bridge._special_stage_speed = move_toward(bridge._special_stage_speed, 1.0, delta * 0.8)
	# HandleJumpControls uses the newly pressed jump button, not a held A.
	if frame_input & bridge.A_BUTTON:
		bridge._special_stage_jump_timer = 0.72
		bridge._status_text = "SPECIAL STAGE JUMP"
	bridge._special_stage_multiplier_timer = maxf(0.0, bridge._special_stage_multiplier_timer - delta)
	if bridge._special_stage_multiplier_timer <= 0.0:
		bridge._special_stage_multiplier = 1
		bridge._special_stage_multiplier_streak = 0
	if held_input & bridge.DPAD_LEFT:
		bridge._special_stage_lane = maxi(0, bridge._special_stage_lane - 1)
	if held_input & bridge.DPAD_RIGHT:
		bridge._special_stage_lane = mini(2, bridge._special_stage_lane + 1)
	# The original Special Stage keeps its collectible field active for the
	# complete 120-second countdown. The lane checkpoints are a compact bridge
	# for the source object field, so advance them over that same duration.
	var jump_speed := 1.25 if bridge._special_stage_jump_timer > 0.0 else 1.0
	bridge._special_stage_progress = minf(1.0, bridge._special_stage_progress + delta * bridge._special_stage_speed * jump_speed / bridge._special_stage_run_duration)
	var segment := mini(bridge._special_stage_ring_targets.size() - 1, int(bridge._special_stage_progress * float(bridge._special_stage_ring_targets.size())))
	if segment <= bridge._special_stage_last_segment:
		return
	for i in range(bridge._special_stage_last_segment + 1, segment + 1):
		if int(bridge._special_stage_ring_targets[i]) == bridge._special_stage_lane:
			var pickup_kind := int(bridge._special_stage_ring_kinds[i]) if i < bridge._special_stage_ring_kinds.size() else 0
			var pickup_value: int = bridge._special_stage_multiplier * (5 if pickup_kind != 0 else 1)
			bridge._special_stage_ring_count = mini(999, bridge._special_stage_ring_count + pickup_value)
			bridge._special_stage_multiplier_streak += 1
			bridge._special_stage_multiplier_timer = 1.0
			bridge._special_stage_multiplier = mini(9, int(bridge._special_stage_multiplier_streak / 6.0) + 1)
	bridge._special_stage_last_segment = segment
	bridge._special_stage_target_reached = bridge._special_stage_ring_count >= bridge._special_stage_run_target

static func update_special_stage_guard_robo(bridge: Object, delta: float) -> void:
	bridge._special_stage_robo_cooldown = maxf(0.0, bridge._special_stage_robo_cooldown - delta)
	bridge._special_stage_robo_lane_timer = maxf(0.0, bridge._special_stage_robo_lane_timer - delta)
	bridge._special_stage_robo_progress = minf(1.0, bridge._special_stage_robo_progress + bridge._special_stage_robo_speed * delta)
	# The original guard moves independently and turns toward the player; do
	# not mirror the player's lane every frame or avoidance becomes impossible.
	if bridge._special_stage_robo_lane_timer <= 0.0:
		if bridge._special_stage_robo_lane < bridge._special_stage_lane:
			bridge._special_stage_robo_lane += 1
		elif bridge._special_stage_robo_lane > bridge._special_stage_lane:
			bridge._special_stage_robo_lane -= 1
		bridge._special_stage_robo_lane_timer = 0.35
	var progress_gap := absf(bridge._special_stage_robo_progress - bridge._special_stage_progress)
	if bridge._special_stage_jump_timer > 0.0 or progress_gap > 0.045 or bridge._special_stage_robo_lane != bridge._special_stage_lane or bridge._special_stage_robo_cooldown > 0.0:
		return
	bridge._special_stage_robo_cooldown = 1.5
	bridge._special_stage_multiplier = 1
	bridge._special_stage_multiplier_streak = 0
	bridge._special_stage_multiplier_timer = 0.0
	if bridge._special_stage_ring_count > 0:
		bridge._special_stage_ring_count = maxi(0, bridge._special_stage_ring_count - 10)
		bridge._status_text = "GUARD ROBO HIT - 10 RINGS LOST"
	else:
		bridge._status_text = "GUARD ROBO HIT - NO RINGS"

static func update_special_stage_results(bridge: Object, _delta: float) -> void:
	# The original result tasks remove exactly 100 points per GBA frame;
	# the four-frame cadence is only used for the counter sound effect.
	var step := 100
	if bridge._special_stage_points_remaining > 0:
		var points_step := mini(step, bridge._special_stage_points_remaining)
		bridge._special_stage_points_remaining -= points_step
		bridge._special_stage_score += points_step
	elif bridge._special_stage_bonus_remaining > 0:
		var bonus_step := mini(step, bridge._special_stage_bonus_remaining)
		bridge._special_stage_bonus_remaining -= bonus_step
		bridge._special_stage_score += bonus_step
	else:
		# sub_806C49C waits 60 frames before beginning the result fade.
		if not bridge._special_stage_result_hold_started:
			bridge._special_stage_result_hold_started = true
			bridge._special_stage_timer = 1.0

static func finish_special_stage(bridge: Object) -> void:
	if bridge._game_state != bridge.GAME_STATE_SPECIAL_STAGE:
		return
	# save.c adds Special Stage rings to the persistent profile score after
	# the result hold, regardless of whether the emerald target was reached.
	bridge._profile_score = maxi(0, bridge._profile_score + bridge._special_stage_ring_count)
	bridge._save_save_data()
	if bridge._special_stage_target_reached:
		bridge._collect_chaos_emerald_for_clear()
	if bridge._should_show_to_be_continued():
		bridge._open_to_be_continued()
	elif bridge._should_show_chaos_emeralds_message():
		if bridge.get_chaos_emerald_count() >= 7:
			bridge._open_chaos_emeralds_message()
		else:
			bridge._open_missing_emeralds_message()
	else:
		bridge._game_state = bridge.GAME_STATE_CLEAR
		bridge._open_next_single_player_course()
