class_name CompanionMotionSystem
extends RefCounted

## Updates companion following without owning companion references or spawning.

static func update_cheese(entity: EntityState, player_position: Vector2, facing_direction: float, player_variant: int, multiplayer_run: bool, player_alive: bool, delta: float) -> bool:
	if player_variant != 1 or multiplayer_run or not player_alive:
		entity.active = false
		return false
	entity.state_timer += delta
	var target_x := player_position.x - facing_direction * 34.0
	var target_y := player_position.y - 24.0 + sin(entity.state_timer * 4.0) * 8.0
	entity.world_x = move_toward(entity.world_x, target_x, 300.0 * delta)
	entity.world_y = move_toward(entity.world_y, target_y, 300.0 * delta)
	return true
