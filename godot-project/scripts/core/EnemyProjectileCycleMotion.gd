class_name EnemyProjectileCycleMotion
extends RefCounted

## Timed fire/recovery cycles shared by projectile-producing enemy profiles.
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
