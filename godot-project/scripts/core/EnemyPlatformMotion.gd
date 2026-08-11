class_name EnemyPlatformMotion
extends RefCounted

## Platform-bound patrol and hover behavior.
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
		entity.world_y = entity.origin_y if entity.koura_motion_variant < 2 else entity.origin_y + sin(entity.state_timer) * 8.0
		return
	if entity.koura_motion_variant == 2:
		entity.world_y = entity.origin_y + sin(entity.state_timer) * 8.0
		return
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
