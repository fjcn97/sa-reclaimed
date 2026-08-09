# EntityVisualCatalog.gd
# Presentation profiles for source entities. Simulation remains in CoreBridge.
class_name EntityVisualCatalog
extends RefCounted

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")

static func profile(entity_type: int, activated: bool = false) -> Dictionary:
	match entity_type:
		ENTITY_TYPES.ENTITY_RING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2(0.55, 0.55),
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(1.0, 1.0, 1.0, 0.75),
			}
		ENTITY_TYPES.ENTITY_SPRING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2(0.0, 4.0),
				"overlay_offset": Vector2(0.0, -6.0),
				"overlay_color": Color.WHITE,
			}
		ENTITY_TYPES.ENTITY_ENEMY:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2(0.0, 2.0),
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color.WHITE,
			}
		ENTITY_TYPES.ENTITY_CHECKPOINT:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2(16.0, -20.0),
				"overlay_color": Color(0.95, 0.38, 0.16, 1.0) if activated else Color(0.16, 0.76, 0.34, 1.0),
			}
		ENTITY_TYPES.ENTITY_GOAL:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2(18.0, -28.0),
				"overlay_color": Color.WHITE,
			}
		ENTITY_TYPES.ENTITY_GOAL_LEVER:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2(18.0, -28.0),
				"overlay_color": Color(1.0, 0.82, 0.28, 1.0) if activated else Color.WHITE,
			}
		ENTITY_TYPES.ENTITY_SPECIAL_RING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.48, 0.92, 1.0, 1.0),
			}
		ENTITY_TYPES.ENTITY_PROPELLER:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2(1.0, 1.0),
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(1.0, 0.88, 0.38, 0.92) if activated else Color(0.54, 0.86, 1.0, 0.78),
			}
		ENTITY_TYPES.ENTITY_BOOSTER:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(1.0, 0.84, 0.26, 0.92),
			}
		ENTITY_TYPES.ENTITY_DASH_RING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.42, 0.92, 1.0, 0.92),
			}
		ENTITY_TYPES.ENTITY_GRIND_RAIL:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.62, 0.72, 0.84, 0.92),
			}
		ENTITY_TYPES.ENTITY_GRAVITY_TOGGLE:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.78, 0.42, 1.0, 0.88),
			}
		ENTITY_TYPES.ENTITY_BOUNCY_SPRING:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.92, 0.42, 0.68, 0.92),
			}
		ENTITY_TYPES.ENTITY_CONVEYOR:
			return {
				"body_scale": Vector2.ONE,
				"overlay_scale": Vector2.ONE,
				"body_offset": Vector2.ZERO,
				"overlay_offset": Vector2.ZERO,
				"overlay_color": Color(0.28, 0.84, 0.72, 0.92),
			}
	return {
		"body_scale": Vector2.ONE,
		"overlay_scale": Vector2.ONE,
		"body_offset": Vector2.ZERO,
		"overlay_offset": Vector2.ZERO,
		"overlay_color": Color.WHITE,
	}


