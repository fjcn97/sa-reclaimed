class_name StageInteractionSystem
extends RefCounted

## Pure player-facing stage interactions that update entity and player state.

static func update_small_windmills(level: LevelState, player: PlayerState, delta: float, velocity_y: float) -> float:
	var updated_velocity_y := velocity_y
	for entity in level.entities:
		if not entity.active or not entity.small_windmill or entity.small_windmill_timer <= 0.0:
			continue
		entity.small_windmill_timer += delta
		if entity.small_windmill_timer < 0.7:
			var rotation_sign := 1.0 if entity.small_windmill_touch_angle in [1, 3, 5, 7] else -1.0
			entity.small_windmill_angle += rotation_sign * delta * 60.0 * 8.0 / 256.0 * TAU
			player.world_x = entity.world_x + cos(entity.small_windmill_angle) * 24.0
			player.world_y = entity.world_y + sin(entity.small_windmill_angle) * 24.0
			player.is_grounded = false
			player.speed_x = 0.0
			player.ground_speed = 0.0
			updated_velocity_y = 0.0
			player.rotation = 0
			player.char_state = 8
		else:
			var release_direction := Vector2.ZERO
			match entity.small_windmill_touch_angle:
				1, 4:
					release_direction = Vector2(0.0, -1.0)
				2, 5:
					release_direction = Vector2(-1.0, 0.0)
				3, 8:
					release_direction = Vector2(1.0, 0.0)
				6, 7:
					release_direction = Vector2(0.0, 1.0)
			entity.small_windmill_timer = 0.0
			entity.activated = false
			player.is_grounded = false
			player.speed_x = release_direction.x * 480.0
			updated_velocity_y = release_direction.y * 480.0
			player.speed_y = updated_velocity_y
			player.char_state = 5
	return updated_velocity_y

static func update_chords(level: LevelState, player: PlayerState, delta: float, velocity_y: float) -> float:
	var updated_velocity_y := velocity_y
	for entity in level.entities:
		if not entity.active or not entity.chord or entity.chord_phase == 0:
			continue
		entity.chord_timer += delta
		if entity.chord_phase == 1:
			var progress := clampf(entity.chord_timer / 0.35, 0.0, 1.0)
			player.world_x = move_toward(player.world_x, entity.world_x + 48.0, 30.0 * delta)
			player.world_y = entity.world_y - 16.0 - sin(progress * PI) * 20.0
			player.is_grounded = false
			player.speed_x = 0.0
			updated_velocity_y = 0.0
			player.char_state = 6
			if progress >= 1.0:
				entity.chord_phase = 2
				entity.chord_timer = 0.0
				updated_velocity_y = -entity.chord_bounce_speed
				player.speed_y = updated_velocity_y
				player.char_state = 5
		elif entity.chord_timer >= 0.35:
			entity.chord_phase = 0
			entity.chord_timer = 0.0
			entity.activated = false
	return updated_velocity_y
