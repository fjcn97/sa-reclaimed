class_name EnemyMotionSystem
extends RefCounted

## Pure motion implementations used by EnemyMotionDispatcher.

static func update_pen(entity: EntityState, player_x: float, delta: float) -> void:
	if entity.pen_turn_timer > 0.0:
		entity.pen_turn_timer = maxf(0.0, entity.pen_turn_timer - delta)
		if entity.pen_turn_timer <= 0.000001:
			entity.pen_turn_timer = 0.0
			entity.pen_direction = -entity.pen_direction
			entity.velocity_x = entity.pen_direction * 30.0
			entity.pen_boosting = false
		return
	var player_delta := player_x - entity.world_x
	entity.pen_boosting = absf(player_delta) < 100.0 and signf(player_delta) == signf(entity.pen_direction) and not is_zero_approx(player_delta)
	var speed := 120.0 if entity.pen_boosting else 30.0
	entity.velocity_x = entity.pen_direction * speed
	entity.world_x += entity.velocity_x * delta
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.pen_turn_timer = 18.0 / 60.0
		entity.pen_direction = -1.0
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.pen_turn_timer = 18.0 / 60.0
		entity.pen_direction = 1.0

static func update_mouse(entity: EntityState, player_x: float, delta: float) -> void:
	if entity.mouse_turn_timer > 0.0:
		entity.mouse_turn_timer = maxf(0.0, entity.mouse_turn_timer - delta)
		if entity.mouse_turn_timer <= 0.000001:
			entity.mouse_turn_timer = 0.0
			entity.mouse_direction = -entity.mouse_direction
			entity.velocity_x = entity.mouse_direction * 30.0
			entity.mouse_boosting = false
		return
	var player_delta := player_x - entity.world_x
	entity.mouse_boosting = absf(player_delta) < 100.0 and signf(player_delta) == entity.mouse_direction and not is_zero_approx(player_delta)
	var speed := 120.0 if entity.mouse_boosting else 30.0
	entity.velocity_x = entity.mouse_direction * speed
	entity.world_x += entity.velocity_x * delta
	entity.world_y = entity.origin_y + entity.mouse_position_offset
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.mouse_turn_timer = 18.0 / 60.0
		entity.mouse_direction = -1.0
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.mouse_turn_timer = 18.0 / 60.0
		entity.mouse_direction = 1.0

static func update_circus(entity: EntityState, delta: float, spawn_projectile: Callable) -> void:
	entity.circus_phase_timer -= delta
	if entity.circus_phase == 0:
		if entity.circus_phase_timer > 0.000001:
			return
		entity.circus_phase = 1
		entity.circus_phase_timer = 30.0 / 60.0
		entity.circus_projectile_spawned = false
		entity.variant = 1
		return
	if entity.circus_phase == 1:
		if entity.circus_phase_timer > 0.000001:
			return
		entity.circus_phase = 2
		entity.circus_phase_timer = 50.0 / 60.0
		entity.variant = 2
		if not entity.circus_projectile_spawned:
			entity.circus_projectile_spawned = true
			spawn_projectile.call(entity)
		return
	if entity.circus_phase == 2:
		if entity.circus_phase_timer > 0.000001:
			return
		entity.circus_phase = 3
		entity.circus_phase_timer = 30.0 / 60.0
		entity.variant = 3
		return
	if entity.circus_phase_timer <= 0.000001:
		entity.circus_phase = 0
		entity.circus_phase_timer = 30.0 / 60.0
		entity.variant = 0

static func update_yado(entity: EntityState, player_x: float, delta: float, spawn_projectile: Callable) -> void:
	if entity.yado_phase == 0:
		entity.yado_phase_timer -= delta
		var player_side := -1 if player_x < entity.world_x else 1
		if player_side != entity.yado_facing and entity.yado_phase_timer > 0.000001:
			entity.yado_facing = player_side
			entity.yado_phase = 2
			entity.yado_phase_timer = 18.0 / 60.0
			return
		if entity.yado_phase_timer <= 0.000001:
			entity.yado_phase = 1
			entity.yado_phase_timer = 2.0
			entity.yado_projectile_fired = false
			entity.variant = 1
		return
	if entity.yado_phase == 1:
		entity.yado_phase_timer -= delta
		if not entity.yado_projectile_fired and entity.yado_phase_timer <= 1.0:
			spawn_projectile.call(entity)
			entity.yado_projectile_fired = true
		if entity.yado_phase_timer <= 6.0 / 60.0:
			entity.variant = 2
		if entity.yado_phase_timer <= 0.000001:
			entity.yado_phase = 0
			entity.yado_phase_timer = 2.0
			entity.variant = 0
		return
	entity.yado_phase_timer -= delta
	if entity.yado_phase_timer <= 0.000001:
		entity.yado_phase = 0
		entity.yado_phase_timer = 2.0
		entity.variant = 0

static func update_straw(entity: EntityState, player_position: Vector2, delta: float) -> void:
	if entity.straw_phase == 0:
		var target := player_position - Vector2(0.0, 24.0)
		var offset := target - Vector2(entity.world_x, entity.world_y)
		if offset.x < 0.0:
			entity.velocity_x -= 3.75
		else:
			entity.velocity_x += 2.578125
		if offset.y < 0.0:
			entity.velocity_y -= 3.75
		else:
			entity.velocity_y += 2.578125
		entity.straw_phase_timer -= delta
		if entity.straw_phase_timer <= 0.000001:
			entity.straw_phase_timer = 100.0 / 60.0
			entity.straw_cycles -= 1
			entity.straw_phase = 2 if entity.straw_cycles <= 0 else 1
	elif entity.straw_phase == 1:
		entity.straw_phase_timer -= delta
		if entity.straw_phase_timer <= 0.000001:
			entity.straw_phase = 0
			entity.straw_phase_timer = 30.0 / 60.0
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta

static func update_gejigeji(entity: EntityState, delta: float) -> void:
	if entity.gejigeji_history.is_empty():
		for _history in range(64):
			entity.gejigeji_history.append(Vector2(entity.world_x, entity.world_y))
		for _segment in range(4):
			entity.trail_positions.append(Vector2(entity.world_x, entity.world_y))
	if entity.gejigeji_pause_timer > 0.0:
		entity.gejigeji_pause_timer = maxf(0.0, entity.gejigeji_pause_timer - delta)
	else:
		if entity.gejigeji_vertical:
			entity.world_y += entity.velocity_y * delta
			if entity.world_y <= entity.koura_patrol_min_y:
				entity.world_y = entity.koura_patrol_min_y
				entity.velocity_y = absf(entity.velocity_y)
				entity.gejigeji_pause_timer = 1.0
			elif entity.world_y >= entity.koura_patrol_max_y:
				entity.world_y = entity.koura_patrol_max_y
				entity.velocity_y = -absf(entity.velocity_y)
				entity.gejigeji_pause_timer = 1.0
		else:
			entity.world_x += entity.velocity_x * delta
			if entity.world_x <= entity.patrol_min_x:
				entity.world_x = entity.patrol_min_x
				entity.velocity_x = absf(entity.velocity_x)
				entity.gejigeji_pause_timer = 1.0
			elif entity.world_x >= entity.patrol_max_x:
				entity.world_x = entity.patrol_max_x
				entity.velocity_x = -absf(entity.velocity_x)
				entity.gejigeji_pause_timer = 1.0
	entity.gejigeji_history.push_front(Vector2(entity.world_x, entity.world_y))
	if entity.gejigeji_history.size() > 64:
		entity.gejigeji_history.pop_back()
	for i in range(4):
		var history_index := mini((i + 1) * 13, entity.gejigeji_history.size() - 1)
		entity.trail_positions[i] = entity.gejigeji_history[history_index]

static func update_kubinaga(entity: EntityState, player_position: Vector2, delta: float, spawn_projectile: Callable) -> void:
	var base := Vector2(entity.origin_x, entity.origin_y)
	if entity.kubinaga_phase == 0:
		entity.kubinaga_phase_timer -= delta
		entity.kubinaga_extension = 0.0
		if entity.kubinaga_phase_timer <= 0.0:
			var player_offset := player_position - Vector2(0.0, 16.0) - base
			if absf(player_offset.x) <= 120.0 and absf(player_offset.y) <= 100.0:
				entity.kubinaga_angle = player_offset.angle()
				entity.kubinaga_phase = 1
				entity.kubinaga_extension = 0.0
	elif entity.kubinaga_phase == 1:
		entity.kubinaga_extension = minf(68.0, entity.kubinaga_extension + 120.0 * delta)
		if entity.kubinaga_extension >= 68.0:
			entity.kubinaga_phase = 2
			entity.kubinaga_phase_timer = 32.0 / 60.0
			entity.kubinaga_shot_fired = false
	elif entity.kubinaga_phase == 2:
		entity.kubinaga_phase_timer -= delta
		if not entity.kubinaga_shot_fired and entity.kubinaga_phase_timer <= 17.0 / 60.0:
			spawn_projectile.call(entity)
			entity.kubinaga_shot_fired = true
		if entity.kubinaga_phase_timer <= 0.0:
			entity.kubinaga_phase = 3
	else:
		entity.kubinaga_extension = maxf(0.0, entity.kubinaga_extension - 120.0 * delta)
		if entity.kubinaga_extension <= 0.0:
			entity.kubinaga_phase = 0
			entity.kubinaga_phase_timer = 120.0 / 60.0
	var head_offset := Vector2(cos(entity.kubinaga_angle), sin(entity.kubinaga_angle)) * entity.kubinaga_extension
	entity.target_x = base.x + head_offset.x
	entity.target_y = base.y + head_offset.y

static func update_madillo(entity: EntityState, player_position: Vector2, delta: float) -> void:
	if entity.variant == 0:
		var player_delta := player_position.x - entity.world_x
		if absf(player_delta) < 120.0 and absf(player_position.y - entity.world_y) < 50.0:
			entity.variant = 1
			if player_delta < 0.0 and entity.world_x > entity.patrol_min_x:
				entity.velocity_x = -90.0
			elif player_delta > 0.0 and entity.world_x < entity.patrol_max_x:
				entity.velocity_x = 90.0
			else:
				entity.variant = 0
				entity.velocity_x = 0.0
		return
	if entity.variant == 1:
		entity.world_x += entity.velocity_x * delta
		if (entity.velocity_x < 0.0 and entity.world_x <= entity.patrol_min_x) or (entity.velocity_x > 0.0 and entity.world_x >= entity.patrol_max_x):
			entity.world_x = clampf(entity.world_x, entity.patrol_min_x, entity.patrol_max_x)
			entity.variant = 2
			entity.madillo_return_timer = 120.0 / 60.0
		return
	entity.world_x += entity.velocity_x * delta
	entity.velocity_x *= pow(0.9, delta * 60.0)
	entity.madillo_return_timer -= delta
	if entity.madillo_return_timer <= 0.0:
		entity.variant = 0
		entity.velocity_x = 0.0

static func update_kyura(entity: EntityState, delta: float, spawn_projectile: Callable) -> void:
	entity.kyura_switch_timer -= delta
	if entity.kyura_switch_timer <= 0.000001:
		if not entity.kyura_recovering:
			entity.kyura_recovering = true
			entity.kyura_switch_timer = 4.0 / 60.0
			entity.kyura_projectile_counter -= 1
			if entity.kyura_projectile_counter == 1:
				spawn_projectile.call(entity)
				entity.kyura_projectile_counter = 12
		else:
			entity.kyura_recovering = false
			entity.kyura_switch_timer = 8.0 / 60.0
			entity.kyura_phase_units = fmod(entity.kyura_phase_units + 8.0, 256.0)
	var phase := entity.kyura_phase_units * TAU / 256.0
	entity.state_timer = phase
	entity.world_x = entity.origin_x + cos(phase * 5.0) * entity.target_x
	entity.world_y = entity.origin_y + sin(phase * 3.0) * entity.target_y

static func update_flickey(entity: EntityState, ground_y: float, delta: float) -> void:
	if entity.flickey_history.is_empty():
		for _history in range(64):
			entity.flickey_history.append(Vector2(entity.world_x, entity.world_y))
		for _segment in range(4):
			entity.trail_positions.append(Vector2(entity.world_x, entity.world_y))
	if entity.flickey_turn_timer > 0.0:
		entity.flickey_turn_timer = maxf(0.0, entity.flickey_turn_timer - delta)
		if entity.flickey_turn_timer <= 0.000001:
			entity.flickey_turn_timer = 0.0
			entity.velocity_x = absf(entity.velocity_x) if entity.velocity_x < 0.0 else -absf(entity.velocity_x)
			entity.flickey_vertical_speed = -240.0
	else:
		entity.flickey_vertical_speed += 7.5 * delta * 60.0
		entity.world_x += entity.velocity_x * delta
		entity.world_y += entity.flickey_vertical_speed * delta
		var floor_y := ground_y - 16.0
		if entity.world_y >= floor_y:
			entity.world_y = floor_y
			entity.flickey_vertical_speed = -240.0
		if (entity.velocity_x < 0.0 and entity.world_x <= entity.patrol_min_x) or (entity.velocity_x > 0.0 and entity.world_x >= entity.patrol_max_x):
			entity.world_x = clampf(entity.world_x, entity.patrol_min_x, entity.patrol_max_x)
			entity.flickey_turn_timer = 0.4
	entity.flickey_history.push_front(Vector2(entity.world_x, entity.world_y))
	if entity.flickey_history.size() > 64:
		entity.flickey_history.pop_back()
	for i in range(4):
		var history_index := mini((i + 1) * 16, entity.flickey_history.size() - 1)
		entity.trail_positions[i] = entity.flickey_history[history_index]

static func update_mon(entity: EntityState, player_position: Vector2, delta: float) -> void:
	if entity.variant == 0:
		if absf(player_position.x - entity.world_x) < 120.0 and absf(player_position.y - entity.world_y) < 50.0:
			entity.variant = 1
			entity.mon_phase_timer = 18.0 / 60.0
		return
	if entity.variant == 1:
		entity.mon_phase_timer -= delta
		if entity.mon_phase_timer <= 0.000001:
			entity.variant = 2
			entity.velocity_y = -330.0
			entity.mon_phase_timer = 0.0
		return
	if entity.variant == 3:
		entity.mon_phase_timer -= delta
		if entity.mon_phase_timer <= 0.000001:
			entity.mon_phase_timer = 0.0
			if absf(player_position.x - entity.world_x) < 120.0 and absf(player_position.y - entity.world_y) < 50.0:
				entity.variant = 1
				entity.mon_phase_timer = 18.0 / 60.0
			else:
				entity.variant = 0
		return
	entity.velocity_y += 12.1875 * delta * 60.0
	entity.world_y += entity.velocity_y * delta
	if entity.world_y >= entity.origin_y:
		entity.world_y = entity.origin_y
		entity.velocity_y = 0.0
		entity.variant = 3
		entity.mon_phase_timer = 18.0 / 60.0

static func update_buzzer(entity: EntityState, player_position: Vector2, player_alive: bool, delta: float) -> void:
	if entity.variant == 0:
		if entity.buzzer_turn_timer > 0.0:
			entity.buzzer_turn_timer = maxf(0.0, entity.buzzer_turn_timer - delta)
			if entity.buzzer_turn_timer <= 0.000001:
				entity.buzzer_turn_timer = 0.0
				entity.velocity_x = -entity.velocity_x
			return
		entity.buzzer_cooldown = maxf(0.0, entity.buzzer_cooldown - delta)
		entity.world_x += entity.velocity_x * delta
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			if entity.velocity_x < 0.0:
				entity.buzzer_turn_timer = 18.0 / 60.0
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			if entity.velocity_x > 0.0:
				entity.buzzer_turn_timer = 18.0 / 60.0
		var dx := player_position.x - entity.world_x
		var player_y := player_position.y - 20.0
		var facing_player := (entity.velocity_x > 0.0 and dx > 0.0 and dx < 60.0) or (entity.velocity_x < 0.0 and dx < 0.0 and dx > -60.0)
		if entity.buzzer_cooldown <= 0.000001 and player_alive and facing_player and player_y > entity.world_y and player_y < entity.world_y + 80.0:
			entity.variant = 1
			entity.buzzer_attack_timer = 32.0 / 60.0
			entity.buzzer_attack_origin_x = entity.world_x
			entity.buzzer_attack_origin_y = entity.world_y
			entity.target_x = player_position.x
			entity.target_y = player_y
		return
	if entity.variant == 1:
		entity.buzzer_attack_timer = maxf(0.0, entity.buzzer_attack_timer - delta)
		var attack_ratio := 1.0 - entity.buzzer_attack_timer / (32.0 / 60.0)
		entity.world_x = lerpf(entity.buzzer_attack_origin_x, entity.target_x, clampf(attack_ratio, 0.0, 1.0))
		entity.world_y = lerpf(entity.buzzer_attack_origin_y, entity.target_y, clampf(attack_ratio, 0.0, 1.0))
		if entity.buzzer_attack_timer <= 0.000001:
			entity.variant = 2
			entity.buzzer_attack_timer = 32.0 / 60.0
	else:
		entity.buzzer_attack_timer = maxf(0.0, entity.buzzer_attack_timer - delta)
		var return_ratio := 1.0 - entity.buzzer_attack_timer / (32.0 / 60.0)
		entity.world_x = lerpf(entity.target_x, entity.buzzer_attack_origin_x, clampf(return_ratio, 0.0, 1.0))
		entity.world_y = lerpf(entity.target_y, entity.buzzer_attack_origin_y, clampf(return_ratio, 0.0, 1.0))
		if entity.buzzer_attack_timer <= 0.000001:
			entity.variant = 0
			entity.buzzer_cooldown = 60.0 / 60.0

static func update_balloon(entity: EntityState, delta: float, spawn_projectile: Callable) -> void:
	if entity.variant == 0:
		entity.state_timer -= delta
		entity.balloon_angle = fmod(entity.balloon_angle + delta * 60.0, 1024.0)
		var x_phase := entity.balloon_angle * 5.0 * TAU / 1024.0
		var y_phase := entity.balloon_angle * 3.0 * TAU / 1024.0
		entity.world_x += entity.velocity_x * delta + cos(x_phase) * entity.balloon_amplitude_x * delta * 0.5
		entity.world_y = entity.origin_y + sin(y_phase) * entity.balloon_amplitude_y
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			entity.velocity_x = absf(entity.velocity_x)
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			entity.velocity_x = -absf(entity.velocity_x)
		if entity.state_timer <= 0.0:
			entity.variant = 1
			entity.state_timer = 45.0 / 60.0
			entity.balloon_projectile_spawned = false
	elif entity.variant == 1:
		entity.state_timer -= delta
		if not entity.balloon_projectile_spawned and entity.state_timer <= 0.000001:
			entity.balloon_projectile_spawned = true
			spawn_projectile.call(entity)
		if entity.state_timer <= 0.0:
			entity.variant = 0
			entity.state_timer = 120.0 / 60.0
			entity.balloon_projectile_spawned = false

static func update_scattered_ring(entity: EntityState, ground_y: float, min_x: float, max_x: float, delta: float) -> void:
	entity.state_timer -= delta
	entity.velocity_y += 620.0 * delta
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	if entity.world_y >= ground_y - 12.0:
		entity.world_y = ground_y - 12.0
		entity.velocity_y = -absf(entity.velocity_y) * 0.56
		entity.velocity_x *= 0.82
	if entity.state_timer <= 0.0 or entity.world_x < min_x - 40.0 or entity.world_x > max_x + 40.0:
		entity.active = false

static func update_bullet_buzzer(entity: EntityState, delta: float, spawn_projectiles: Callable) -> void:
	entity.bullet_buzzer_angle = fmod(entity.bullet_buzzer_angle + delta * 60.0, 1024.0)
	var x_phase := entity.bullet_buzzer_angle * 5.0 * TAU / 1024.0
	var y_phase := entity.bullet_buzzer_angle * 3.0 * TAU / 1024.0
	entity.world_x = entity.origin_x + cos(x_phase) * 48.0
	entity.world_y = entity.origin_y + sin(y_phase) * 28.0
	if entity.variant == 0:
		entity.state_timer -= delta
		if entity.state_timer <= 0.0:
			entity.variant = 1
			entity.bullet_buzzer_attack_timer = 50.0 / 60.0
			entity.bullet_buzzer_projectile_spawned = false
	else:
		entity.bullet_buzzer_attack_timer -= delta
		if not entity.bullet_buzzer_projectile_spawned and entity.bullet_buzzer_attack_timer <= 16.0 / 60.0:
			entity.bullet_buzzer_projectile_spawned = true
			spawn_projectiles.call(entity)
		if entity.bullet_buzzer_attack_timer <= 0.0:
			entity.variant = 0
			entity.state_timer = 60.0 / 60.0

static func update_koura(entity: EntityState, delta: float) -> void:
	entity.state_timer = fmod(entity.state_timer + delta * 20.0 * TAU / 256.0 * 60.0, TAU)
	if entity.koura_motion_variant < 2:
		entity.world_x += entity.velocity_x * delta
		if entity.world_x <= entity.patrol_min_x:
			entity.world_x = entity.patrol_min_x
			entity.velocity_x = absf(entity.velocity_x)
		if entity.world_x >= entity.patrol_max_x:
			entity.world_x = entity.patrol_max_x
			entity.velocity_x = -absf(entity.velocity_x)
		if entity.koura_motion_variant == 0 or entity.koura_motion_variant == 1:
			entity.world_y = entity.origin_y
		else:
			entity.world_y = entity.origin_y + sin(entity.state_timer) * 8.0
	else:
		if entity.koura_motion_variant == 2:
			entity.world_y = entity.origin_y + sin(entity.state_timer) * 8.0
		else:
			entity.world_y += entity.velocity_y * delta
			if entity.koura_patrol_min_y == entity.koura_patrol_max_y:
				entity.koura_patrol_min_y = entity.origin_y - 96.0
				entity.koura_patrol_max_y = entity.origin_y + 96.0
			if entity.world_y <= entity.koura_patrol_min_y:
				entity.world_y = entity.koura_patrol_min_y
				entity.velocity_y = absf(entity.velocity_y)
			if entity.world_y >= entity.koura_patrol_max_y:
				entity.world_y = entity.koura_patrol_max_y
				entity.velocity_y = -absf(entity.velocity_y)

static func update_pikopiko(entity: EntityState, ground_y: float, delta: float) -> void:
	entity.world_x += entity.velocity_x * delta
	if entity.pikopiko_clamp_ground:
		entity.world_y = ground_y - 16.0
	if entity.world_x <= entity.patrol_min_x:
		entity.world_x = entity.patrol_min_x
		entity.velocity_x = absf(entity.velocity_x)
	elif entity.world_x >= entity.patrol_max_x:
		entity.world_x = entity.patrol_max_x
		entity.velocity_x = -absf(entity.velocity_x)

static func update_kiki(entity: EntityState, delta: float, spawn_projectile: Callable) -> void:
	if entity.variant == 0:
		entity.world_y += entity.kiki_vertical_direction * 60.0 * delta
		if entity.world_y >= entity.kiki_vertical_max:
			entity.world_y = entity.kiki_vertical_max
			entity.kiki_vertical_direction = -1.0
		elif entity.world_y <= entity.kiki_vertical_min:
			entity.world_y = entity.kiki_vertical_min
			entity.kiki_vertical_direction = 1.0
			entity.kiki_border_hits += 1
			if (entity.kiki_border_hits & 1) == 0:
				entity.variant = 1
				entity.kiki_attack_frames = 0
				entity.kiki_projectile_spawned = false
		return
	entity.kiki_attack_frames += 1
	if not entity.kiki_projectile_spawned and entity.kiki_attack_frames == 18:
		entity.kiki_projectile_spawned = true
		spawn_projectile.call(entity)
	if entity.kiki_attack_frames >= 30:
		entity.variant = 0
		entity.kiki_projectile_spawned = false

static func update_kiki_projectile(entity: EntityState, ground_y: float, delta: float, split_projectile: Callable) -> void:
	entity.state_timer -= delta
	entity.velocity_y += 156.25 * delta
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	if entity.world_y >= ground_y - 8.0 or entity.state_timer <= 0.0:
		split_projectile.call(entity)

static func update_kiki_piece(entity: EntityState, max_y: float, delta: float) -> void:
	entity.state_timer -= delta
	entity.velocity_y += 156.25 * delta
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	if entity.state_timer <= 0.0 or entity.world_y > max_y + 40.0:
		entity.active = false

static func update_trapped_animal(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	match entity.variant:
		1:
			entity.world_y = entity.origin_y + sin(entity.state_timer * 3.0) * 16.0
		2:
			entity.world_x += entity.velocity_x * delta
			entity.world_y = entity.origin_y + absf(sin(entity.state_timer * 3.4)) * -24.0
			if entity.state_timer >= 1.8:
				entity.state_timer = 0.0
				entity.velocity_x = -entity.velocity_x
				entity.world_x = entity.origin_x
