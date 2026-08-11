# Special-stage state machine extracted from CoreBridge.
extends RefCounted
class_name SpecialStageSystem

static func open_special_stage(bridge: Object) -> void:
	var special_stage = bridge.get_special_stage_state()
	bridge.set_game_state(bridge.GAME_STATE_SPECIAL_STAGE)
	special_stage.pending = false
	special_stage.phase = 0
	special_stage.timer = special_stage.entry_duration
	special_stage.ring_count = 0
	special_stage.score = 0
	special_stage.emerald_index = bridge.get_selected_zone_index()
	special_stage.lane = 1
	special_stage.progress = 0.0
	special_stage.last_segment = -1
	special_stage.target_reached = false
	special_stage.paused = false
	special_stage.pause_cursor = 0
	special_stage.multiplier = 1
	special_stage.multiplier_streak = 0
	special_stage.multiplier_timer = 0.0
	special_stage.robo_progress = 0.15
	special_stage.robo_lane = 1
	special_stage.robo_speed = float(special_stage.robo_zone_speeds[special_stage.emerald_index])
	special_stage.robo_lane_timer = 0.35
	special_stage.robo_cooldown = 0.0
	special_stage.points_remaining = 0
	special_stage.bonus_remaining = 0
	special_stage.result_hold_started = false
	bridge.set_status_text("SPECIAL STAGE READY")

static func advance_special_stage(bridge: Object) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_SPECIAL_STAGE:
		return
	var special_stage = bridge.get_special_stage_state()
	if special_stage.phase == 0:
		special_stage.phase = 1
		special_stage.timer = special_stage.run_duration
		bridge.set_status_text("SPECIAL STAGE RUN")
		return
	if special_stage.phase == 1:
		special_stage.phase = 2
		# special_stage/main.c caps the ring points at MAX_POINTS (99,900)
		# before the results task starts counting them.
		special_stage.timer = 0.0
		special_stage.points_remaining = mini(99900, special_stage.ring_count * 100)
		special_stage.bonus_remaining = 10000 if special_stage.target_reached else 0
		special_stage.result_hold_started = false
		special_stage.score = 0
		bridge.set_status_text("SPECIAL STAGE RESULTS")
		return
	if special_stage.points_remaining > 0 or special_stage.bonus_remaining > 0:
		# A skips both result counters in sub_806C25C/sub_806C338 and
		# leaves only the 60-frame result hold before the fade.
		special_stage.score += special_stage.points_remaining + special_stage.bonus_remaining
		special_stage.points_remaining = 0
		special_stage.bonus_remaining = 0
		special_stage.result_hold_started = true
		special_stage.timer = 1.0
		return
	bridge.finish_special_stage()

static func update_special_stage_run(bridge: Object, delta: float, held_input: int, frame_input: int = 0) -> void:
	var special_stage = bridge.get_special_stage_state()
	if special_stage.phase != 1:
		return
	special_stage.jump_timer = maxf(0.0, special_stage.jump_timer - delta)
	# physics.c accelerates on Up, brakes on Down, and coasts toward rest.
	if held_input & bridge.DPAD_UP:
		special_stage.speed = minf(1.6, special_stage.speed + delta * 1.8)
	elif held_input & bridge.DPAD_DOWN:
		special_stage.speed = maxf(0.35, special_stage.speed - delta * 2.4)
	else:
		special_stage.speed = move_toward(special_stage.speed, 1.0, delta * 0.8)
	# HandleJumpControls uses the newly pressed jump button, not a held A.
	if frame_input & bridge.A_BUTTON:
		special_stage.jump_timer = 0.72
		bridge.set_status_text("SPECIAL STAGE JUMP")
	special_stage.multiplier_timer = maxf(0.0, special_stage.multiplier_timer - delta)
	if special_stage.multiplier_timer <= 0.0:
		special_stage.multiplier = 1
		special_stage.multiplier_streak = 0
	if held_input & bridge.DPAD_LEFT:
		special_stage.lane = maxi(0, special_stage.lane - 1)
	if held_input & bridge.DPAD_RIGHT:
		special_stage.lane = mini(2, special_stage.lane + 1)
	# The original Special Stage keeps its collectible field active for the
	# complete 120-second countdown. The lane checkpoints are a compact bridge
	# for the source object field, so advance them over that same duration.
	var jump_speed := 1.25 if special_stage.jump_timer > 0.0 else 1.0
	special_stage.progress = minf(1.0, special_stage.progress + delta * special_stage.speed * jump_speed / special_stage.run_duration)
	var segment := mini(special_stage.ring_targets.size() - 1, int(special_stage.progress * float(special_stage.ring_targets.size())))
	if segment <= special_stage.last_segment:
		return
	for i in range(special_stage.last_segment + 1, segment + 1):
		if int(special_stage.ring_targets[i]) == special_stage.lane:
			var pickup_kind := int(special_stage.ring_kinds[i]) if i < special_stage.ring_kinds.size() else 0
			var pickup_value: int = special_stage.multiplier * (5 if pickup_kind != 0 else 1)
			special_stage.ring_count = mini(999, special_stage.ring_count + pickup_value)
			special_stage.multiplier_streak += 1
			special_stage.multiplier_timer = 1.0
			special_stage.multiplier = mini(9, int(special_stage.multiplier_streak / 6.0) + 1)
	special_stage.last_segment = segment
	special_stage.target_reached = special_stage.ring_count >= special_stage.run_target

static func update_special_stage_guard_robo(bridge: Object, delta: float) -> void:
	var special_stage = bridge.get_special_stage_state()
	special_stage.robo_cooldown = maxf(0.0, special_stage.robo_cooldown - delta)
	special_stage.robo_lane_timer = maxf(0.0, special_stage.robo_lane_timer - delta)
	special_stage.robo_progress = minf(1.0, special_stage.robo_progress + special_stage.robo_speed * delta)
	# The original guard moves independently and turns toward the player; do
	# not mirror the player's lane every frame or avoidance becomes impossible.
	if special_stage.robo_lane_timer <= 0.0:
		if special_stage.robo_lane < special_stage.lane:
			special_stage.robo_lane += 1
		elif special_stage.robo_lane > special_stage.lane:
			special_stage.robo_lane -= 1
		special_stage.robo_lane_timer = 0.35
	var progress_gap := absf(special_stage.robo_progress - special_stage.progress)
	if special_stage.jump_timer > 0.0 or progress_gap > 0.045 or special_stage.robo_lane != special_stage.lane or special_stage.robo_cooldown > 0.0:
		return
	special_stage.robo_cooldown = 1.5
	special_stage.multiplier = 1
	special_stage.multiplier_streak = 0
	special_stage.multiplier_timer = 0.0
	if special_stage.ring_count > 0:
		special_stage.ring_count = maxi(0, special_stage.ring_count - 10)
		bridge.set_status_text("GUARD ROBO HIT - 10 RINGS LOST")
	else:
		bridge.set_status_text("GUARD ROBO HIT - NO RINGS")

static func update_special_stage_results(bridge: Object, _delta: float) -> void:
	var special_stage = bridge.get_special_stage_state()
	# The original result tasks remove exactly 100 points per GBA frame;
	# the four-frame cadence is only used for the counter sound effect.
	var step := 100
	if special_stage.points_remaining > 0:
		var points_step := mini(step, special_stage.points_remaining)
		special_stage.points_remaining -= points_step
		special_stage.score += points_step
	elif special_stage.bonus_remaining > 0:
		var bonus_step := mini(step, special_stage.bonus_remaining)
		special_stage.bonus_remaining -= bonus_step
		special_stage.score += bonus_step
	else:
		# sub_806C49C waits 60 frames before beginning the result fade.
		if not special_stage.result_hold_started:
			special_stage.result_hold_started = true
			special_stage.timer = 1.0

static func finish_special_stage(bridge: Object) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_SPECIAL_STAGE:
		return
	# save.c adds Special Stage rings to the persistent profile score after
	# the result hold, regardless of whether the emerald target was reached.
	var special_stage = bridge.get_special_stage_state()
	bridge.get_profile_state().profile_score = maxi(0, bridge.get_profile_state().profile_score + special_stage.ring_count)
	bridge.save_profile()
	if special_stage.target_reached:
		bridge.collect_chaos_emerald_for_clear()
	if bridge.should_show_to_be_continued():
		bridge.open_to_be_continued()
	elif bridge.should_show_chaos_emeralds_message():
		if bridge.get_chaos_emerald_count() >= 7:
			bridge.open_chaos_emeralds_message()
		else:
			bridge.open_missing_emeralds_message()
	else:
		bridge.set_game_state(bridge.GAME_STATE_CLEAR)
		bridge.open_next_single_player_course()
