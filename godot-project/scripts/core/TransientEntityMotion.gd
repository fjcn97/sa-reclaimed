class_name TransientEntityMotion
extends RefCounted

## Physics and expiry rules for short-lived entities.
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
