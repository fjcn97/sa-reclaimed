class_name EntitySpawner
extends RefCounted

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")
const ENTITY_FACTORY := preload("res://scripts/core/EntityFactory.gd")

const SPRING_UP := 0
const SPRING_DOWN_RIGHT := 7
const DASH_RING_UP := 0
const DASH_RING_RIGHT := 2
const DASH_RING_UP_LEFT := 7
const GRAVITY_KIND_DOWN := 0
const GRAVITY_KIND_TOGGLE := 2
const ITEM_BOX_KIND_RINGS := 0

static func add_ring_line(level: LevelState, start_x: float, y: float, count: int, spacing: float) -> void:
	for i in range(count):
		ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_RING, start_x + (float(i) * spacing), y)

static func add_spring(level: LevelState, x: float, y: float, direction: int = SPRING_UP) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_SPRING, x, y)
	entity.variant = clampi(direction, SPRING_UP, SPRING_DOWN_RIGHT)

static func add_enemy(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float, speed: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_ENEMY, x, y)
	entity.velocity_x = speed
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x

static func add_buzzer(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_BUZZER, x, y)
	entity.velocity_x = 45.0
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x
	entity.origin_x = x
	entity.origin_y = y
	entity.target_x = x
	entity.target_y = y
	entity.buzzer_turn_timer = 0.0
	entity.buzzer_cooldown = 0.0
	entity.buzzer_attack_origin_x = x
	entity.buzzer_attack_origin_y = y
	entity.buzzer_attack_timer = 0.0

static func add_balloon(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_BALLOON, x, y)
	entity.velocity_x = 30.0
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 120.0 / 60.0
	entity.balloon_angle = 0.0
	entity.balloon_projectile_spawned = false

static func add_bullet_buzzer(level: LevelState, x: float, y: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_BULLET_BUZZER, x, y)
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 0.0
	entity.bullet_buzzer_angle = 0.0
	entity.bullet_buzzer_attack_timer = 0.0
	entity.bullet_buzzer_projectile_spawned = false

static func add_koura(level: LevelState, x: float, y: float, patrol_min_x: float, patrol_max_x: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_KOURA, x, y)
	entity.velocity_x = -30.0
	entity.koura_motion_variant = 0
	entity.patrol_min_x = patrol_min_x
	entity.patrol_max_x = patrol_max_x
	entity.origin_x = x
	entity.origin_y = y

static func add_star(level: LevelState, x: float, y: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_STAR, x, y)
	entity.width = 32.0
	entity.height = 32.0
	entity.state_timer = 2.0

static func add_kiki(level: LevelState, x: float, y: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_KIKI, x, y)
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 0.0
	entity.kiki_vertical_direction = 1.0
	entity.kiki_vertical_min = y - 48.0
	entity.kiki_vertical_max = y + 48.0
	entity.kiki_border_hits = 0
	entity.kiki_attack_frames = 0
	entity.kiki_projectile_spawned = false

static func add_trapped_animal(level: LevelState, x: float, y: float, animal_type: int) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_TRAPPED_ANIMAL, x, y)
	entity.variant = clampi(animal_type, 0, 2)
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 0.0
	entity.velocity_x = 16.0 if entity.variant == 2 else 0.0

static func add_boss_for_level(level: LevelState, x: float, y: float, selected_level_index: int) -> EntityState:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_BOSS, x, y)
	entity.width = 92.0
	entity.height = 68.0
	entity.origin_x = x
	entity.origin_y = y
	entity.state_timer = 1.2
	entity.boss_profile = 8 if selected_level_index >= 15 else (7 if selected_level_index >= 14 else clampi(int(selected_level_index / 2), 0, 6))
	entity.health = 8
	entity.max_health = 8
	if entity.boss_profile == 0:
		entity.target_x = 42.0
		entity.effect_offset = -PI * 0.5
		entity.state_timer = 1.2
	elif entity.boss_profile == 1:
		entity.health = 4
		entity.max_health = 4
		entity.velocity_x = 82.0
		entity.state_timer = 2.5
		entity.effect_offset = PI
	elif entity.boss_profile == 2:
		entity.velocity_x = 96.0
		entity.state_timer = 2.2
		entity.effect_offset = 0.0
	elif entity.boss_profile == 4:
		entity.velocity_x = 54.0
		entity.state_timer = 2.5
		entity.effect_offset = PI
	elif entity.boss_profile == 5:
		entity.velocity_x = 78.0
		entity.state_timer = 2.0
		entity.effect_offset = 0.0
	elif entity.boss_profile == 6:
		entity.velocity_x = 62.0
		entity.state_timer = 1.8
	elif entity.boss_profile == 7:
		entity.health = 6
		entity.max_health = 6
		entity.state_timer = 1.8
		entity.effect_offset = 0.0
	elif entity.boss_profile == 8:
		entity.health = 12
		entity.max_health = 12
		entity.state_timer = 1.5
		entity.effect_offset = 0.0
	elif entity.boss_profile == 3:
		# boss_4.c starts the Aero Egg on a long approach before its bomb loop.
		entity.velocity_x = 132.0
		entity.state_timer = 2.0
	return entity

static func add_checkpoint(level: LevelState, x: float, y: float) -> void:
	ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_CHECKPOINT, x, y)

static func add_special_ring(level: LevelState, x: float, y: float) -> void:
	ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_SPECIAL_RING, x, y)

static func add_whirlwind(level: LevelState, x: float, y: float, width: float, height: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_WHIRLWIND, x, y)
	entity.width = width
	entity.height = height
	entity.whirlwind_active = false
	entity.whirlwind_timer = 0.0
	entity.whirlwind_release_latch = false

static func add_fan(level: LevelState, x: float, y: float, width: float, height: float, direction: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_FAN, x, y)
	entity.width = width
	entity.height = height
	entity.velocity_x = signf(direction)
	entity.fan_speed = 1.0

static func add_spikes(level: LevelState, x: float, y: float, width: float, height: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_SPIKES, x, y)
	entity.width = width
	entity.height = height

static func add_item_box(level: LevelState, x: float, y: float, ring_amount: int, item_kind: int = ITEM_BOX_KIND_RINGS) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_ITEM_BOX, x, y)
	entity.width = 30.0
	entity.height = 30.0
	entity.item_kind = item_kind
	entity.variant = maxi(1, ring_amount) if item_kind == ITEM_BOX_KIND_RINGS else 1

static func add_propeller(level: LevelState, x: float, y: float) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_PROPELLER, x, y)
	entity.width = 148.0
	entity.height = 128.0

static func add_booster(level: LevelState, x: float, y: float, direction: float = 1.0) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_BOOSTER, x, y)
	entity.width = 34.0
	entity.height = 24.0
	entity.velocity_x = -1.0 if direction < 0.0 else 1.0

static func add_dash_ring(level: LevelState, x: float, y: float, orientation: int = DASH_RING_RIGHT) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_DASH_RING, x, y)
	entity.width = 28.0
	entity.height = 28.0
	entity.variant = clampi(orientation, DASH_RING_UP, DASH_RING_UP_LEFT)

static func add_grind_rail(level: LevelState, x: float, y: float, width: float, direction: float = 1.0, end_mode: int = 0) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_GRIND_RAIL, x, y)
	entity.width = maxf(48.0, width)
	entity.height = 18.0
	entity.rail_direction = -1.0 if direction < 0.0 else 1.0
	entity.rail_end_mode = 1 if end_mode != 0 else 0
	entity.rail_is_start = true
	entity.rail_air_start = false

static func add_gravity_toggle(level: LevelState, x: float, y: float, width: float, height: float, kind: int = GRAVITY_KIND_TOGGLE) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_GRAVITY_TOGGLE, x, y)
	entity.width = maxf(32.0, width)
	entity.height = maxf(32.0, height)
	entity.gravity_kind = clampi(kind, GRAVITY_KIND_DOWN, GRAVITY_KIND_TOGGLE)

static func add_bouncy_spring(level: LevelState, x: float, y: float, strength: float = 1.125) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_BOUNCY_SPRING, x, y)
	entity.width = 42.0
	entity.height = 22.0
	entity.bounce_strength = clampf(strength, 1.0, 1.5)

static func add_conveyor(level: LevelState, x: float, y: float, width: float, height: float, direction: float = 1.0) -> void:
	var entity := ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_CONVEYOR, x, y)
	entity.width = maxf(32.0, width)
	entity.height = maxf(16.0, height)
	entity.surface_speed = 37.5 * (-1.0 if direction < 0.0 else 1.0)

static func add_goal(level: LevelState, x: float, y: float) -> void:
	ENTITY_FACTORY.add_entity(level, ENTITY_TYPES.ENTITY_GOAL, x, y)
