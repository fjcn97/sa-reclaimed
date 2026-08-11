class_name EnemyPatrolMotion
extends RefCounted

## Shared source-faithful patrol updates for the basic ground enemies.
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
	entity.velocity_x = entity.pen_direction * (120.0 if entity.pen_boosting else 30.0)
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
	entity.velocity_x = entity.mouse_direction * (120.0 if entity.mouse_boosting else 30.0)
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
