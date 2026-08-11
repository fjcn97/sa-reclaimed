class_name BossMotionSystem
extends RefCounted

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")

static func update(bridge: Object, level: LevelState, player: PlayerState, elapsed: float, entity: EntityState, delta: float) -> void:
	match entity.boss_profile:
		0:
			update_hammer_tank(bridge, level, player, entity, delta)
		1:
			update_bomber_tank(bridge, level, player, entity, delta)
		2:
			update_totem(bridge, level, player, entity, delta)
		3:
			update_aero_egg(bridge, level, entity, elapsed, delta)
		4:
			update_saucer(player, entity, elapsed, delta)
		5:
			update_go_round(bridge, level, player, entity, delta)
		6:
			update_frog(bridge, level, entity, delta)
		7:
			update_super_robo_z(bridge, level, entity, delta)
		8:
			update_true_area_53(bridge, level, entity, elapsed, delta)
		_:
			update_generic(bridge, level, player, entity, delta)

static func update_aero_egg(bridge: Object, level: LevelState, entity: EntityState, elapsed: float, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.effect_offset = elapsed * 2.4 + 0.7
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 180.0, entity.origin_x + 180.0)
	if entity.world_x <= entity.origin_x - 180.0 or entity.world_x >= entity.origin_x + 180.0:
		entity.velocity_x *= -1.0
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		_spawn_projectile(bridge, level, ENTITY_TYPES.ENTITY_PROJECTILE, entity.world_x, entity.world_y + 26.0, 4, 300.0 if entity.velocity_x >= 0.0 else -300.0, 60.0, 3.0, entity)
		entity.state_timer = 1.333 if entity.health <= 4 else 2.333
	entity.target_y = entity.origin_y + sin(elapsed * 1.8) * 10.0
	entity.world_y = move_toward(entity.world_y, entity.target_y, 70.0 * delta)

static func update_hammer_tank(bridge: Object, level: LevelState, player: PlayerState, entity: EntityState, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 150.0, entity.origin_x + 150.0)
	if entity.world_x <= entity.origin_x - 150.0 or entity.world_x >= entity.origin_x + 150.0:
		entity.velocity_x *= -1.0
	var hammer_length := entity.target_x
	var hammer_angle := entity.effect_offset
	entity.state_timer -= delta
	match entity.variant:
		0:
			hammer_length = move_toward(hammer_length, 56.0, 170.0 * delta)
			hammer_angle = move_toward(hammer_angle, -PI * 0.5, 2.8 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 1
				entity.state_timer = 0.28
		1:
			hammer_length = move_toward(hammer_length, 128.0, 270.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 2
				entity.state_timer = 0.25
		2:
			var aim := Vector2(player.world_x - entity.world_x, (player.world_y - 20.0) - entity.world_y)
			if aim.length_squared() > 1.0:
				hammer_angle = lerp_angle(hammer_angle, aim.angle(), 0.18)
			if entity.state_timer <= 0.0:
				entity.variant = 3
				entity.state_timer = 0.55
		3:
			hammer_angle = move_toward(hammer_angle, PI * 0.5, 4.0 * delta)
			hammer_length = move_toward(hammer_length, 184.0, 360.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 4
				entity.state_timer = 0.45
				bridge.request_screen_shake(7.0, 0.45, 0.25, false, true, false)
		4:
			if entity.state_timer <= 0.0:
				entity.variant = 5
				entity.state_timer = 0.95
		5:
			hammer_length = move_toward(hammer_length, 96.0, 90.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 6
				entity.state_timer = 0.78
		6:
			hammer_length = move_toward(hammer_length, 56.0, 70.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 7
				entity.state_timer = 0.8
		7:
			hammer_length = move_toward(hammer_length, 42.0, 140.0 * delta)
			hammer_angle = move_toward(hammer_angle, -PI * 0.5, 3.4 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 0
				entity.state_timer = 1.2
	entity.target_x = hammer_length
	entity.effect_offset = hammer_angle

static func hammer_tank_tip(entity: EntityState) -> Vector2:
	return Vector2(entity.world_x + cos(entity.effect_offset) * entity.target_x, entity.world_y + sin(entity.effect_offset) * entity.target_x)

static func update_bomber_tank(bridge: Object, level: LevelState, player: PlayerState, entity: EntityState, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 160.0, entity.origin_x + 160.0)
	if entity.world_x <= entity.origin_x - 160.0 or entity.world_x >= entity.origin_x + 160.0:
		entity.velocity_x *= -1.0
	var target := Vector2(player.world_x - entity.world_x, (player.world_y - 22.0) - entity.world_y)
	if target.length_squared() > 1.0:
		entity.effect_offset = lerp_angle(entity.effect_offset, target.angle(), 0.12)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		_spawn_projectile(bridge, level, ENTITY_TYPES.ENTITY_PROJECTILE, entity.world_x - 8.0, entity.world_y - 22.0, 5, cos(entity.effect_offset) * 170.0, sin(entity.effect_offset) * 170.0, 4.0, entity)
		entity.state_timer = 2.5

static func update_totem(bridge: Object, level: LevelState, player: PlayerState, entity: EntityState, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 170.0, entity.origin_x + 170.0)
	if entity.world_x <= entity.origin_x - 170.0 or entity.world_x >= entity.origin_x + 170.0:
		entity.velocity_x *= -1.0
	entity.effect_offset = fmod(entity.effect_offset + delta * 1.8, TAU)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		var bullet := _new_entity(bridge, level, ENTITY_TYPES.ENTITY_PROJECTILE, entity.world_x - 40.0, entity.world_y - 98.0)
		var target := Vector2(player.world_x, player.world_y - 20.0) - Vector2(bullet.world_x, bullet.world_y)
		if target.length_squared() < 1.0:
			target = Vector2(-1.0, 0.0)
		target = target.normalized()
		bullet.velocity_x = target.x * 190.0
		bullet.velocity_y = target.y * 190.0
		bullet.enemy_profile = 6
		bullet.origin_x = entity.world_x
		bullet.origin_y = entity.world_y
		entity.state_timer = 2.2 if entity.health > 4 else 1.5

static func update_saucer(player: PlayerState, entity: EntityState, elapsed: float, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 130.0, entity.origin_x + 130.0)
	if entity.world_x <= entity.origin_x - 130.0 or entity.world_x >= entity.origin_x + 130.0:
		entity.velocity_x *= -1.0
	entity.world_y = entity.origin_y + sin(elapsed * 1.4) * 18.0
	var target := Vector2(player.world_x - entity.world_x, (player.world_y - 20.0) - entity.world_y)
	if target.length_squared() > 1.0:
		entity.effect_offset = lerp_angle(entity.effect_offset, target.angle(), 0.10)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		if entity.variant == 0:
			entity.variant = 1
			entity.state_timer = 1.0
		else:
			entity.variant = 0
			entity.state_timer = 4.0 if entity.health > 4 else 2.5

static func saucer_beam_hits_player(player: PlayerState, entity: EntityState) -> bool:
	if entity.variant != 1:
		return false
	var beam_origin := Vector2(entity.world_x, entity.world_y - 18.0)
	var to_player := Vector2(player.world_x, player.world_y - 20.0) - beam_origin
	if to_player.length_squared() > 520.0 * 520.0 or to_player.length_squared() < 1.0:
		return false
	return absf(wrapf(to_player.angle() - entity.effect_offset, -PI, PI)) < 0.10

static func update_go_round(bridge: Object, level: LevelState, player: PlayerState, entity: EntityState, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 150.0, entity.origin_x + 150.0)
	if entity.world_x <= entity.origin_x - 150.0 or entity.world_x >= entity.origin_x + 150.0:
		entity.velocity_x *= -1.0
	entity.effect_offset = fmod(entity.effect_offset + delta * (1.8 if entity.health > 4 else 2.8), TAU)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		for shot_index in range(3):
			var bullet := _new_entity(bridge, level, ENTITY_TYPES.ENTITY_PROJECTILE, entity.world_x, entity.world_y + 26.0)
			var spread := (float(shot_index) - 1.0) * 0.22
			var direction := Vector2(player.world_x - entity.world_x, (player.world_y - 20.0) - bullet.world_y)
			if direction.length_squared() < 1.0:
				direction = Vector2(-1.0, 0.0)
			direction = direction.normalized().rotated(spread)
			bullet.velocity_x = direction.x * 185.0
			bullet.velocity_y = direction.y * 185.0
			bullet.enemy_profile = 7
			bullet.origin_x = entity.world_x
			bullet.origin_y = entity.world_y
		entity.state_timer = 2.8 if entity.health > 4 else 1.8

static func update_frog(bridge: Object, level: LevelState, entity: EntityState, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += entity.velocity_x * delta
	entity.world_x = clampf(entity.world_x, entity.origin_x - 150.0, entity.origin_x + 150.0)
	if entity.world_x <= entity.origin_x - 150.0 or entity.world_x >= entity.origin_x + 150.0:
		entity.velocity_x *= -1.0
	if entity.variant == 0:
		entity.state_timer -= delta
		if entity.state_timer <= 0.0:
			entity.variant = 1
			entity.velocity_y = -330.0
			entity.state_timer = 0.0
	else:
		entity.velocity_y += 640.0 * delta
		entity.world_y += entity.velocity_y * delta
		if entity.variant == 1 and entity.velocity_y < -80.0:
			var bomb := _new_entity(bridge, level, ENTITY_TYPES.ENTITY_PROJECTILE, entity.world_x + 28.0, entity.world_y - 20.0)
			bomb.enemy_profile = 8
			bomb.velocity_x = 180.0 if entity.velocity_x >= 0.0 else -180.0
			bomb.velocity_y = -90.0
			bomb.state_timer = 3.0
			bomb.origin_x = entity.world_x
			bomb.origin_y = entity.world_y
			entity.variant = 2
		if entity.world_y >= entity.origin_y:
			entity.world_y = entity.origin_y
			entity.velocity_y = 0.0
			entity.variant = 0
			entity.state_timer = 1.8 if entity.health > 4 else 1.2

static func update_super_robo_z(bridge: Object, level: LevelState, entity: EntityState, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.effect_offset = fmod(entity.effect_offset + delta * 0.9, TAU)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		for shot_index in range(3):
			var arm_angle: float = entity.effect_offset + (float(shot_index) - 1.0) * 0.24
			var spawn := Vector2(entity.world_x, entity.world_y - 36.0) + Vector2(cos(arm_angle), sin(arm_angle)) * 48.0
			var cloud := _new_entity(bridge, level, ENTITY_TYPES.ENTITY_PROJECTILE, spawn.x, spawn.y)
			cloud.enemy_profile = 9
			cloud.velocity_x = cos(arm_angle) * 150.0
			cloud.velocity_y = sin(arm_angle) * 150.0
			cloud.state_timer = 2.4
			cloud.origin_x = entity.world_x
			cloud.origin_y = entity.world_y
		entity.state_timer = 2.4 if entity.health > 3 else 1.4

static func update_true_area_53(bridge: Object, level: LevelState, entity: EntityState, elapsed: float, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.world_x += sin(elapsed * 0.8) * 18.0 * delta
	entity.world_y = entity.origin_y + sin(elapsed * 1.2) * 24.0
	entity.effect_offset = fmod(entity.effect_offset + delta * 1.2, TAU)
	entity.state_timer -= delta
	if entity.state_timer <= 0.0:
		for shot_index in range(2):
			var projectile := _new_entity(bridge, level, ENTITY_TYPES.ENTITY_PROJECTILE, entity.world_x + (float(shot_index) * 26.0) - 13.0, entity.world_y + 20.0)
			var angle := PI * 0.5 + (float(shot_index) - 0.5) * 0.28 + sin(entity.effect_offset) * 0.18
			projectile.enemy_profile = 10
			projectile.velocity_x = cos(angle) * 175.0
			projectile.velocity_y = sin(angle) * 175.0
			projectile.state_timer = 3.0
			projectile.origin_x = entity.world_x
			projectile.origin_y = entity.world_y
		entity.state_timer = 2.0 if entity.health > 4 else 1.1

static func update_generic(bridge: Object, level: LevelState, player: PlayerState, entity: EntityState, delta: float) -> void:
	entity.hit_timer = maxf(0.0, entity.hit_timer - delta)
	entity.state_timer -= delta
	match entity.variant:
		0:
			var elapsed := 1.2 - entity.state_timer
			entity.world_x = entity.origin_x + sin(elapsed * 1.6) * 70.0
			entity.world_y = entity.origin_y + sin(elapsed * 2.0) * 24.0
			if entity.state_timer <= 0.0:
				entity.variant = 1
				entity.state_timer = 0.28
		1:
			if entity.state_timer <= 0.0:
				entity.variant = 2
				entity.state_timer = 0.36
		2:
			if entity.state_timer <= 0.0:
				var projectile := _new_entity(bridge, level, ENTITY_TYPES.ENTITY_PROJECTILE, entity.world_x - 36.0, entity.world_y + 18.0)
				var direction := Vector2(player.world_x, player.world_y - 20.0) - Vector2(projectile.world_x, projectile.world_y)
				if direction.length_squared() < 1.0:
					direction = Vector2(-1.0, 0.0)
				direction = direction.normalized()
				projectile.velocity_x = direction.x * 180.0
				projectile.velocity_y = direction.y * 180.0
				projectile.origin_x = entity.world_x
				projectile.origin_y = entity.world_y
				entity.variant = 3
				entity.state_timer = 0.30
		3:
			var plunge_ratio := clampf(1.0 - (entity.state_timer / 0.30), 0.0, 1.0)
			entity.world_y = entity.origin_y + plunge_ratio * 45.0
			if entity.state_timer <= 0.0:
				entity.variant = 4
				entity.state_timer = 0.35
		4:
			if entity.state_timer <= 0.0:
				entity.target_x = player.world_x
				entity.variant = 5
				entity.state_timer = 0.60
		5:
			if entity.state_timer <= 0.0:
				entity.variant = 6
				entity.state_timer = 0.45
		6:
			entity.world_x = move_toward(entity.world_x, entity.target_x, 220.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 7
				entity.state_timer = 0.35
		7:
			entity.world_y = move_toward(entity.world_y, entity.origin_y, 180.0 * delta)
			if entity.state_timer <= 0.0:
				entity.variant = 0
				entity.state_timer = 0.90

static func _new_entity(bridge: Object, level: LevelState, entity_type: int, x: float, y: float) -> EntityState:
	return bridge.add_entity(level, entity_type, x, y) as EntityState

static func _spawn_projectile(bridge: Object, level: LevelState, entity_type: int, x: float, y: float, profile: int, velocity_x: float, velocity_y: float, lifetime: float, source: EntityState) -> void:
	var projectile := _new_entity(bridge, level, entity_type, x, y)
	projectile.enemy_profile = profile
	projectile.velocity_x = velocity_x
	projectile.velocity_y = velocity_y
	projectile.state_timer = lifetime
	projectile.origin_x = source.world_x
	projectile.origin_y = source.world_y
