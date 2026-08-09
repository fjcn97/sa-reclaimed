extends RefCounted
class_name StageMotionSystem

static func update_flying_springs(level: LevelState, delta: float) -> void:
	for entity in level.entities:
		if not entity.active or (not entity.flying_spring and not entity.floating_spring):
			continue
		if entity.floating_spring:
			entity.floating_spring_phase = fmod(entity.floating_spring_phase + 4.0 * TAU / 256.0 * 60.0 * delta, TAU)
			entity.world_x = entity.origin_x + sin(entity.floating_spring_phase) * entity.floating_spring_amplitude_x
			entity.world_y = entity.origin_y + sin(entity.floating_spring_phase) * entity.floating_spring_amplitude_y
			continue
		# flying_spring.c advances its shared animation in byte-sized frames.
		match entity.flying_spring_motion_state:
			0:
				entity.flying_spring_step = (entity.flying_spring_step + 2) & 0xFF
				entity.world_y = entity.origin_y + sin(float(entity.flying_spring_step * 4) / 256.0 * TAU) * 2.0
			1:
				entity.world_y = entity.origin_y + sin(float(entity.flying_spring_step * 4) / 256.0 * TAU) * 16.0
				var remaining_steps: int = (64 - entity.flying_spring_step) >> 2
				var step_delta: int = 4 if remaining_steps <= 3 else mini(6, remaining_steps)
				entity.flying_spring_step += step_delta
				if entity.flying_spring_step >= 64:
					entity.flying_spring_step = 0
					entity.flying_spring_motion_state = 2
			2:
				entity.flying_spring_step += 1
				if entity.flying_spring_step > 0:
					entity.flying_spring_step = 64
					entity.flying_spring_motion_state = 3
			3:
				entity.world_y = entity.origin_y + sin(float(entity.flying_spring_step * 4) / 256.0 * TAU) * 16.0
				entity.flying_spring_step += 8
				if entity.flying_spring_step > 127:
					entity.flying_spring_step = 128
					entity.flying_spring_motion_state = 4
			4:
				entity.flying_spring_step = (entity.flying_spring_step + 8) & 0xFF
				if entity.flying_spring_step == 128:
					entity.flying_spring_step = 0
					entity.flying_spring_motion_state = 0
				else:
					var recovery_amplitude := 6.0 if entity.flying_spring_step > 128 else 3.0
					entity.world_y = entity.origin_y + sin(float(entity.flying_spring_step * 4) / 256.0 * TAU) * recovery_amplitude

static func update_iron_balls(level: LevelState, delta: float) -> void:
	for entity in level.entities:
		if not entity.active or not entity.iron_ball:
			continue
		entity.iron_ball_phase = fmod(entity.iron_ball_phase + delta * 60.0 * 4.0 / 256.0 * TAU, TAU)
		var offset: float = sin(entity.iron_ball_phase) * entity.iron_ball_amplitude
		if entity.iron_ball_horizontal:
			entity.world_x = entity.origin_x + offset
		else:
			entity.world_y = entity.origin_y + offset

static func update_notes(level: LevelState, delta: float) -> void:
	for entity in level.entities:
		if not entity.active or (not entity.note_block and not entity.note_sphere):
			continue
		if entity.note_timer <= 0.0:
			entity.note_offset_x = 0.0
			entity.note_offset_y = 0.0
			continue
		entity.note_timer = maxf(0.0, entity.note_timer - delta)
		var phase: float = 1.0 - entity.note_timer / (4.0 / 60.0 if entity.note_block else 6.0 / 60.0)
		var amplitude := 4.0 if entity.note_block else 8.0
		entity.note_offset_x = cos(entity.note_angle) * amplitude * (1.0 - phase)
		entity.note_offset_y = sin(entity.note_angle) * amplitude * (1.0 - phase)
		if entity.note_timer <= 0.0:
			entity.note_offset_x = 0.0
			entity.note_offset_y = 0.0
			entity.activated = false
			if entity.note_block and entity.note_health <= 0:
				entity.active = false

static func update_note_particles(level: LevelState, delta: float) -> void:
	for entity in level.entities:
		if not entity.active or not entity.note_particle:
			continue
		entity.note_particle_delay = maxf(0.0, entity.note_particle_delay - delta)
		if entity.note_particle_delay > 0.0:
			continue
		entity.state_timer -= delta
		entity.world_x += entity.velocity_x * delta
		entity.world_y += entity.velocity_y * delta
		entity.velocity_y += 48.0 * delta
		if entity.state_timer <= 0.0:
			entity.active = false

static func update_gohla(entity: EntityState, delta: float) -> void:
	entity.state_timer = fmod(entity.state_timer + delta * 2.5, TAU)
	if entity.gohla_turn_timer > 0.0:
		entity.gohla_turn_timer = maxf(0.0, entity.gohla_turn_timer - delta)
		return
	entity.world_x += entity.velocity_x * delta
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.velocity_x = absf(entity.velocity_x)
		entity.gohla_turn_timer = 0.25
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.velocity_x = -absf(entity.velocity_x)
		entity.gohla_turn_timer = 0.25

static func update_kura_kura(entity: EntityState, delta: float) -> void:
	entity.state_timer = fmod(entity.state_timer + delta * 4.0 * TAU / 256.0 * 60.0, TAU)

static func kura_kura_fireball_position(entity: EntityState) -> Vector2:
	return Vector2(entity.world_x + sin(entity.state_timer) * 21.0, entity.world_y + cos(entity.state_timer) * 21.0)

static func update_bell(entity: EntityState, delta: float) -> void:
	if entity.bell_phase == 0:
		entity.bell_phase_timer -= delta
		if entity.bell_phase_timer <= 0.000001:
			entity.bell_phase = 1
			entity.variant = 1
			entity.bell_phase_timer = 124.0 / 60.0 if int(entity.world_x) & 1 else 180.0 / 60.0
	else:
		entity.bell_phase_timer -= delta
		if entity.bell_phase_timer <= 0.000001:
			entity.bell_phase = 0
			entity.variant = 0
			entity.bell_phase_timer = 120.0 / 60.0

static func update_hammerhead(entity: EntityState, delta: float) -> void:
	entity.previous_world_y = entity.world_y
	entity.state_timer = fmod(entity.state_timer + delta * 1.5 * 4.0 * TAU / 1024.0 * 60.0, TAU)
	entity.world_y = entity.origin_y + sin(entity.state_timer) * 120.0

static func update_star(entity: EntityState, delta: float) -> void:
	entity.state_timer -= delta
	if entity.state_timer > 0.0:
		return
	match entity.variant:
		0:
			entity.variant = 1
			entity.state_timer = 0.333
		1:
			entity.variant = 2
			entity.state_timer = 2.0
		2:
			entity.variant = 3
			entity.state_timer = 0.333
		_:
			entity.variant = 0
			entity.state_timer = 2.0
