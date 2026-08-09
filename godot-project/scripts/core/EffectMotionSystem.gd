class_name EffectMotionSystem
extends RefCounted

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")

## Pure transient visual-effect motion and lifetime updates.

static func update_ring(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	if entity.state_timer >= 0.34:
		entity.active = false

static func update_heart(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	entity.world_x += entity.velocity_x * delta
	entity.world_y += entity.velocity_y * delta
	entity.velocity_y = move_toward(entity.velocity_y, -8.0, 18.0 * delta)
	if entity.state_timer >= 0.72:
		entity.active = false

static func update_dust(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	entity.world_y -= 8.0 * delta
	if entity.state_timer >= 0.48:
		entity.active = false

static func update_character_attack(entity: EntityState, delta: float) -> void:
	entity.state_timer += delta
	entity.world_x += entity.velocity_x * delta
	var lifetime := 0.28 if entity.type == EntityTypes.ENTITY_TAIL_SWIPE else (0.32 if entity.type == EntityTypes.ENTITY_SONIC_SKID else 0.36)
	if entity.state_timer >= lifetime:
		entity.active = false

static func update_item_box(entity: EntityState, delta: float, apply_effect: Callable) -> void:
	if not entity.activated:
		return
	entity.state_timer += delta
	entity.effect_offset = minf(34.0, entity.state_timer * 92.0)
	if entity.state_timer >= 0.60:
		apply_effect.call(entity)
		entity.active = false
