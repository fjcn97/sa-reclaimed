extends RefCounted
class_name StageTraversalSystem

const INPUT_BINDINGS := preload("res://scripts/core/InputBindings.gd")

static func update_turnaround_bars(level: LevelState, player: PlayerState, delta: float, velocity_y: float, boosting: bool) -> float:
	for entity in level.entities:
		if not entity.active or not entity.turnaround_bar or entity.turnaround_timer <= 0.0:
			continue
		entity.turnaround_timer = maxf(0.0, entity.turnaround_timer - delta)
		player.world_x = entity.world_x
		player.world_y = entity.world_y
		player.is_grounded = true
		player.speed_x = 0.0
		player.ground_speed = 0.0
		velocity_y = 0.0
		player.rotation = 0
		player.char_state = 8
		if entity.turnaround_timer <= 0.0:
			player.world_x = entity.world_x - entity.turnaround_direction * 6.0
			var speed_cap := 900.0 if boosting else 540.0
			var outgoing_speed := minf(absf(entity.turnaround_entry_speed) + 75.0, speed_cap)
			player.speed_x = -entity.turnaround_direction * outgoing_speed
			player.ground_speed = player.speed_x
			player.char_state = 0
			entity.activated = false
	return velocity_y

static func update_poles(level: LevelState, player: PlayerState, frame_input: int, velocity_y: float) -> float:
	for entity in level.entities:
		if not entity.active or not entity.pole or not entity.pole_sliding:
			continue
		player.world_x = entity.world_x
		player.world_y = entity.world_y
		player.is_grounded = false
		player.speed_x = 0.0
		player.ground_speed = 0.0
		velocity_y = 0.0
		player.char_state = 4
		if frame_input & INPUT_BINDINGS.A_BUTTON:
			entity.pole_sliding = false
			player.speed_x = -300.0 if frame_input & INPUT_BINDINGS.DPAD_LEFT else 300.0
			velocity_y = -330.0
			player.speed_y = velocity_y
	player.char_state = 8
	return velocity_y

static func update_cranes(level: LevelState, player: PlayerState, delta: float, velocity_y: float) -> float:
	for entity in level.entities:
		if not entity.active or not entity.crane:
			continue
		entity.crane_phase = fmod(entity.crane_phase + delta * 2.2, TAU)
		entity.crane_hook_x = entity.origin_x + sin(entity.crane_phase) * 42.0
		entity.crane_hook_y = entity.origin_y + 88.0 + cos(entity.crane_phase) * 18.0
		if entity.crane_timer <= 0.0:
			continue
		entity.crane_timer = maxf(0.0, entity.crane_timer - delta)
		if entity.crane_timer > 0.25:
			player.world_x = entity.crane_hook_x
			player.world_y = entity.crane_hook_y
			player.is_grounded = false
			player.speed_x = 0.0
			velocity_y = 0.0
			player.char_state = 8
		else:
			entity.activated = false
			player.is_grounded = false
			player.speed_x = signf(entity.crane_hook_x - entity.origin_x) * 360.0
			velocity_y = -entity.crane_launch_speed
			player.speed_y = velocity_y
			player.char_state = 5
	return velocity_y

static func update_ceiling_slopes(level: LevelState, player: PlayerState, delta: float) -> void:
	for entity in level.entities:
		if not entity.active or not entity.ceiling_slope:
			continue
		entity.ceiling_slope_timer = maxf(0.0, entity.ceiling_slope_timer - delta)
		var dx := absf(player.world_x - entity.world_x)
		var dy := absf((player.world_y - 20.0) - entity.world_y)
		if dx > entity.width * 0.5 or dy > entity.height * 0.5:
			entity.ceiling_slope_latched = false
			entity.activated = false

static func update_gapped_loops(level: LevelState, player: PlayerState, delta: float, velocity_y: float) -> float:
	for entity in level.entities:
		if not entity.active or not entity.gapped_loop or not entity.gapped_loop_active:
			continue
		entity.gapped_loop_angle -= entity.gapped_loop_direction * delta * 60.0 * 8.0 / 256.0 * TAU
		player.world_x = entity.gapped_loop_center_x + cos(entity.gapped_loop_angle) * 135.0
		player.world_y = entity.gapped_loop_center_y + sin(entity.gapped_loop_angle) * 135.0
		player.is_grounded = false
		player.rotation = int(rad_to_deg(entity.gapped_loop_angle))
		player.char_state = 5
		if absf(entity.gapped_loop_angle) >= PI * 0.85:
			entity.gapped_loop_active = false
			entity.activated = false
			player.speed_x = entity.gapped_loop_direction * 360.0
			velocity_y = 0.0
			player.speed_y = velocity_y
	return velocity_y

static func update_funnel_spheres(level: LevelState, player: PlayerState, delta: float, velocity_y: float) -> float:
	for entity in level.entities:
		if not entity.active or not entity.funnel_sphere or entity.funnel_sphere_timer <= 0.0:
			continue
		entity.funnel_sphere_timer += delta
		if entity.funnel_sphere_timer < 0.25:
			player.world_x += 300.0 * delta
			player.world_y = entity.world_y
		else:
			var progress: float = clampf((entity.funnel_sphere_timer - 0.25) / 1.0, 0.0, 1.0)
			var angle: float = progress * PI
			player.world_x = entity.world_x + cos(angle) * 32.0
			player.world_y = entity.world_y - sin(angle) * 48.0
			player.rotation = int(rad_to_deg(angle))
		if entity.funnel_sphere_timer >= 1.25:
			entity.funnel_sphere_timer = 0.0
			entity.activated = false
			player.is_grounded = false
			player.speed_x = 0.0
			velocity_y = 360.0 if entity.funnel_sphere_direction > 0.0 else -600.0
			player.speed_y = velocity_y
			player.char_state = 5
		else:
			player.is_grounded = false
			player.speed_x = 0.0
			velocity_y = 0.0
			player.char_state = 8
	return velocity_y

static func update_music_entries(level: LevelState, player: PlayerState, delta: float, velocity_y: float) -> float:
	for entity in level.entities:
		if not entity.active or not entity.music_entry or entity.music_entry_timer <= 0.0:
			continue
		entity.music_entry_timer += delta
		var progress: float = clampf(entity.music_entry_timer / entity.music_entry_duration, 0.0, 1.0)
		var direction := 1.0 if entity.music_entry_kind % 2 == 0 else -1.0
		player.world_x = entity.world_x + direction * progress * 128.0
		player.world_y = entity.world_y - sin(progress * PI) * (42.0 + entity.music_entry_kind * 4.0)
		player.is_grounded = false
		player.speed_x = 0.0
		velocity_y = 0.0
		player.rotation = int(sin(progress * PI) * 24.0)
		player.char_state = 8
		if entity.music_entry_timer >= entity.music_entry_duration:
			entity.music_entry_timer = 0.0
			entity.activated = false
			var exit_velocity := _music_entry_exit_velocity(entity.music_entry_pipe, entity.music_entry_kind)
			player.speed_x = exit_velocity.x
			velocity_y = exit_velocity.y
			player.speed_y = velocity_y
			player.char_state = 5
	return velocity_y

static func update_half_pipes(level: LevelState, player: PlayerState, frame_input: int, velocity_y: float, jump_speed: float) -> float:
	for entity in level.entities:
		if not entity.active or not entity.half_pipe or not entity.half_pipe_active:
			continue
		var moving_forward: bool = entity.half_pipe_direction > 0.0 and player.speed_x >= 135.0
		var moving_reverse: bool = entity.half_pipe_direction < 0.0 and player.speed_x <= -135.0
		if not moving_forward and not moving_reverse:
			entity.half_pipe_active = false
			entity.activated = false
			player.is_grounded = false
			player.char_state = 0
			continue
		if frame_input & INPUT_BINDINGS.A_BUTTON:
			entity.half_pipe_active = false
			entity.activated = false
			player.is_grounded = false
			velocity_y = -jump_speed
			player.speed_y = velocity_y
			player.char_state = 5
			continue
		var distance: float = (player.world_x - (entity.world_x - entity.width * 0.5)) if entity.half_pipe_direction > 0.0 else ((entity.world_x + entity.width * 0.5) - player.world_x)
		var normalized := clampf(distance / maxf(1.0, entity.width), 0.0, 1.0)
		var speed_scale := clampf(absf(player.speed_x) / 600.0, 0.0, 1.0)
		var curve_height := maxf(0.0, (entity.height - 16.0) * 0.5) * speed_scale
		player.world_y = entity.half_pipe_base_y - sin(normalized * PI) * curve_height
		player.is_grounded = true
		player.speed_y = 0.0
		velocity_y = 0.0
		player.char_state = 0
	return velocity_y

static func update_flying_handles(level: LevelState, player: PlayerState, delta: float) -> void:
	for entity in level.entities:
		if not entity.active or not entity.flying_handle:
			continue
		entity.flying_handle_cooldown = maxf(0.0, entity.flying_handle_cooldown - delta)
		entity.flying_handle_phase = fmod(entity.flying_handle_phase + delta * 60.0 * 0.015625 * TAU, TAU)
		if entity.activated:
			entity.flying_handle_speed_y = minf(180.0, entity.flying_handle_speed_y + 225.0 * delta)
			entity.world_y -= entity.flying_handle_speed_y * delta
			if entity.world_y <= entity.flying_handle_top_y:
				entity.world_y = entity.flying_handle_top_y
				entity.flying_handle_speed_y = 0.0
			entity.effect_offset = sin(entity.flying_handle_phase) * 8.0
			player.world_x = entity.world_x
			player.world_y = entity.world_y
			player.is_grounded = false
		else:
			entity.world_y = entity.flying_handle_bottom_y
			entity.effect_offset = sin(entity.flying_handle_phase) * 8.0

static func update_german_flutes(level: LevelState, player: PlayerState, delta: float, held_input: int, velocity_y: float) -> float:
	for entity in level.entities:
		if not entity.active or not entity.german_flute or entity.german_flute_timer <= 0.0:
			continue
		entity.german_flute_timer += delta
		player.is_grounded = false
		player.ground_speed = 0.0
		player.rotation = 0
		if entity.german_flute_phase == 0:
			player.world_x = move_toward(player.world_x, entity.world_x, 30.0 * delta)
			player.world_y = move_toward(player.world_y, entity.world_y + 24.0, 30.0 * delta)
			player.speed_x = 0.0
			velocity_y = 0.0
			player.char_state = 8
			if entity.german_flute_timer >= 31.0 / 60.0:
				entity.german_flute_phase = 1
				entity.german_flute_timer = 0.0001
				velocity_y = -(420.0 + entity.german_flute_kind * 60.0)
				player.speed_y = velocity_y
		elif entity.german_flute_phase == 1:
			player.world_y += velocity_y * delta
			velocity_y += 600.0 * delta
			player.char_state = 9
			player.speed_y = velocity_y
			if velocity_y >= 0.0:
				entity.german_flute_phase = 2
				entity.german_flute_timer = 0.0001
		else:
			if held_input & INPUT_BINDINGS.DPAD_RIGHT:
				player.world_x += 30.0 * delta
			if held_input & INPUT_BINDINGS.DPAD_LEFT:
				player.world_x -= 30.0 * delta
			var wave_phase: float = entity.german_flute_timer * 60.0 * 4.0 / 256.0 * TAU
			player.world_y = entity.world_y + 24.0 + sin(wave_phase) * 8.0
			player.char_state = 9
			velocity_y = 0.0
			player.speed_y = 0.0
			if absf(player.world_x - entity.world_x) > 16.0 or entity.german_flute_timer > 180.0 / 60.0:
				entity.german_flute_timer = 0.0
				entity.german_flute_phase = 0
				entity.activated = false
				player.char_state = 1
	return velocity_y

static func _music_entry_exit_velocity(is_pipe: bool, kind: int) -> Vector2:
	if is_pipe:
		var pipe_exits: Array = [Vector2(0.0, -540.0), Vector2(0.0, -720.0), Vector2(0.0, -540.0), Vector2(0.0, -720.0), Vector2(540.0, -540.0), Vector2(0.0, -540.0), Vector2(0.0, -720.0), Vector2(0.0, -540.0), Vector2(0.0, -720.0)]
		return pipe_exits[clampi(kind, 0, pipe_exits.size() - 1)]
	var horn_exits: Array = [Vector2(540.0, 0.0), Vector2(720.0, 0.0), Vector2(540.0, -540.0)]
	return horn_exits[clampi(kind, 0, horn_exits.size() - 1)]

static func music_entry_duration(is_pipe: bool, kind: int) -> float:
	var frames: Array = [69, 69, 77, 77, 63, 74, 74, 80, 80] if is_pipe else [77, 86, 74]
	return float(frames[clampi(kind, 0, frames.size() - 1)]) / 60.0
