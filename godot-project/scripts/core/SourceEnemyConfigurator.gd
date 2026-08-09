class_name SourceEnemyConfigurator

extends RefCounted

static func configure(entity: EntityState, kind: String, row: Dictionary) -> void:
	# Keep source enemies anchored to their imported spawn until their original
	# species-specific state machine is available in the bridge.
	entity.origin_x = entity.world_x
	entity.origin_y = entity.world_y
	entity.previous_world_y = entity.world_y
	entity.patrol_min_x = entity.world_x - 96.0
	entity.patrol_max_x = entity.world_x + 96.0
	entity.velocity_x = 0.0
	var fields: Array = row.get("fields", [])
	if fields.size() > 7:
		var source_start := float(_to_int_field(fields[5])) * 8.0
		var source_width := float(_to_int_field(fields[7])) * 8.0
		if source_width > 0.0:
			entity.patrol_min_x = entity.world_x + source_start
			entity.patrol_max_x = entity.world_x + source_start + source_width
	match kind:
		"BUZZER":
			entity.velocity_x = 45.0
			entity.state_timer = 0.0
			entity.buzzer_turn_timer = 0.0
			entity.buzzer_cooldown = 0.0
			entity.buzzer_attack_origin_x = entity.world_x
			entity.buzzer_attack_origin_y = entity.world_y
			entity.buzzer_attack_timer = 0.0
		"BALLOON":
			entity.velocity_x = 42.0
			entity.velocity_x = 30.0
			entity.state_timer = 120.0 / 60.0
			entity.variant = 0
			entity.balloon_angle = 0.0
			entity.balloon_projectile_spawned = false
			if fields.size() > 8:
				entity.balloon_amplitude_x = clampf(absf(float(_to_int_field(fields[7]))) * 4.0, 4.0, 48.0)
				entity.balloon_amplitude_y = clampf(absf(float(_to_int_field(fields[8]))) * 4.0, 4.0, 48.0)
		"BULLETBUZZER":
			entity.state_timer = 0.0
			entity.bullet_buzzer_angle = 0.0
			entity.bullet_buzzer_attack_timer = 0.0
			entity.bullet_buzzer_projectile_spawned = false
		"KOURA":
			var horizontal := fields.size() > 8 and _to_int_field(fields[7]) > _to_int_field(fields[8])
			var direction := _to_int_field(fields[6]) if fields.size() > 6 else 0
			entity.koura_motion_variant = 0 if horizontal and direction == 0 else (1 if horizontal and direction == 1 else (2 if horizontal else 3))
			entity.velocity_x = -30.0 if entity.koura_motion_variant < 2 else 0.0
			if entity.koura_motion_variant == 3:
				entity.velocity_y = -30.0
				entity.koura_patrol_min_y = entity.world_y + float(_to_int_field(fields[6])) * 8.0 if fields.size() > 6 else entity.world_y - 96.0
				entity.koura_patrol_max_y = entity.koura_patrol_min_y + float(_to_int_field(fields[8])) * 8.0 if fields.size() > 8 else entity.world_y + 96.0
		"STAR":
			entity.state_timer = 2.0
		"KIKI":
			entity.state_timer = 0.0
			entity.kiki_vertical_direction = 1.0
			entity.kiki_vertical_min = entity.world_y - 48.0
			entity.kiki_vertical_max = entity.world_y + 48.0
			entity.kiki_border_hits = 0
			entity.kiki_attack_frames = 0
			entity.kiki_projectile_spawned = false
		"PEN":
			entity.enemy_profile = 1
			entity.velocity_x = -30.0
			entity.pen_boosting = false
			entity.pen_turn_timer = 0.0
			entity.pen_direction = -1.0
		"MOUSE":
			entity.enemy_profile = 3
			entity.velocity_x = -30.0
			entity.mouse_boosting = false
			entity.mouse_turn_timer = 0.0
			entity.mouse_direction = -1.0
			entity.mouse_position_offset = 8.0 if fields.size() > 8 and _to_int_field(fields[8]) != 0 else 0.0
		"BELL":
			entity.enemy_profile = 2
			entity.state_timer = 2.0
			entity.bell_phase = 0
			entity.bell_phase_timer = 120.0 / 60.0
		"CIRCUS":
			entity.enemy_profile = 4
			entity.circus_phase = 0
			entity.circus_phase_timer = 1.0 / 60.0
			entity.circus_projectile_spawned = false
		"PIKOPIKO":
			entity.enemy_profile = 18
			entity.velocity_x = -60.0
			entity.pikopiko_clamp_ground = fields.size() > 1 and _to_int_field(fields[1]) != 0
		"YADO":
			entity.enemy_profile = 5
			entity.state_timer = 2.0
			entity.yado_phase = 0
			entity.yado_phase_timer = 2.0
			entity.yado_projectile_fired = false
			entity.yado_facing = 1
		"GOHLA":
			entity.enemy_profile = 6
			entity.state_timer = 0.0
			entity.velocity_x = -30.0
		"KURAKURA":
			entity.enemy_profile = 8
			entity.state_timer = 0.0
		"GEJIGEJI":
			entity.enemy_profile = 10
			entity.gejigeji_vertical = fields.size() > 8 and _to_int_field(fields[7]) <= _to_int_field(fields[8])
			entity.velocity_x = -33.75 if not entity.gejigeji_vertical else 0.0
			entity.velocity_y = -33.75 if entity.gejigeji_vertical else 0.0
			if entity.gejigeji_vertical:
				entity.koura_patrol_min_y = entity.world_y + float(_to_int_field(fields[6])) * 8.0 if fields.size() > 6 else entity.world_y - 96.0
				entity.koura_patrol_max_y = entity.koura_patrol_min_y + float(_to_int_field(fields[8])) * 8.0 if fields.size() > 8 else entity.world_y + 96.0
			for _history in range(64):
				entity.gejigeji_history.append(Vector2(entity.world_x, entity.world_y))
			for _segment in range(4):
				entity.trail_positions.append(Vector2(entity.world_x, entity.world_y))
		"KUBINAGA":
			entity.enemy_profile = 11
			entity.target_x = entity.world_x
			entity.target_y = entity.world_y
			entity.kubinaga_phase = 0
			entity.kubinaga_phase_timer = 2.0
			entity.kubinaga_extension = 0.0
		"MADILLO":
			entity.enemy_profile = 12
			entity.state_timer = 0.0
			entity.velocity_x = 0.0
			entity.madillo_return_timer = 0.0
		"SPINNER":
			entity.enemy_profile = 13
			entity.state_timer = 0.0
		"KYURA":
			entity.enemy_profile = 14
			entity.state_timer = 0.0
			entity.kyura_phase_units = 0.0
			entity.kyura_switch_timer = 8.0 / 60.0
			entity.kyura_recovering = false
			entity.kyura_projectile_counter = 12
			entity.kyura_projectile_variant = 0
			entity.target_x = absf(float(_to_int_field(fields[7])) * 4.0) if fields.size() > 7 else 24.0
			entity.target_y = absf(float(_to_int_field(fields[8])) * 4.0) if fields.size() > 8 else 16.0
		"FLICKEY":
			entity.enemy_profile = 15
			entity.velocity_x = -90.0
			entity.flickey_vertical_speed = -240.0
			entity.flickey_turn_timer = 0.0
			for _history in range(64):
				entity.flickey_history.append(Vector2(entity.world_x, entity.world_y))
			for _segment in range(4):
				entity.trail_positions.append(Vector2(entity.world_x, entity.world_y))
		"MON":
			entity.enemy_profile = 16
			entity.state_timer = 0.0
			entity.mon_phase_timer = 0.0
		"HAMMERHEAD":
			entity.enemy_profile = 7
			# hammerhead.c multiplies the 256-step source phase by four and
			# offsets it by half a sine cycle before sampling SIN().
			entity.state_timer = TAU * 0.5 + (float(_to_int_field(fields[8])) * 4.0 * TAU / 1024.0 if fields.size() > 8 else 0.0)
		"STRAW":
			entity.enemy_profile = 9
			entity.state_timer = 1.0
			entity.straw_phase = 0
			entity.straw_phase_timer = 30.0 / 60.0
			entity.straw_cycles = 5
			var seed_angle := fmod(absf(entity.world_x * 0.017 + entity.world_y * 0.013), TAU)
			entity.velocity_x = cos(seed_angle) * 120.0
			entity.velocity_y = sin(seed_angle) * 120.0

static func _to_int_field(value: Variant) -> int:
	return int(str(value).strip_edges())

