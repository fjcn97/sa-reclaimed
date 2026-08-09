class_name EntityFactory

extends RefCounted

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")

static func add_entity(level: LevelState, entity_type: int, x: float, y: float) -> EntityState:
	var entity := EntityState.new()
	entity.type = entity_type
	entity.world_x = x
	entity.world_y = y
	entity.active = true
	match entity_type:
		ENTITY_TYPES.ENTITY_RING:
			entity.radius = 14.0
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 0
		ENTITY_TYPES.ENTITY_SCATTER_RING:
			entity.radius = 14.0
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 0
		ENTITY_TYPES.ENTITY_SPECIAL_RING:
			entity.radius = 15.0
			entity.width = 30.0
			entity.height = 30.0
			entity.anim_id = 5
		ENTITY_TYPES.ENTITY_WHIRLWIND:
			entity.anim_id = 6
		ENTITY_TYPES.ENTITY_FAN:
			entity.anim_id = 7
		ENTITY_TYPES.ENTITY_SPIKES:
			entity.anim_id = 8
		ENTITY_TYPES.ENTITY_ITEM_BOX:
			entity.anim_id = 9
		ENTITY_TYPES.ENTITY_PROPELLER:
			entity.anim_id = 10
		ENTITY_TYPES.ENTITY_BOOSTER:
			entity.width = 34.0
			entity.height = 24.0
			entity.anim_id = 11
		ENTITY_TYPES.ENTITY_DASH_RING:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 12
		ENTITY_TYPES.ENTITY_GRIND_RAIL:
			entity.width = 160.0
			entity.height = 18.0
			entity.anim_id = 13
		ENTITY_TYPES.ENTITY_GRAVITY_TOGGLE:
			entity.width = 128.0
			entity.height = 128.0
			entity.anim_id = 14
		ENTITY_TYPES.ENTITY_BOUNCY_SPRING:
			entity.width = 42.0
			entity.height = 22.0
			entity.anim_id = 15
		ENTITY_TYPES.ENTITY_NOTE_BLOCK:
			entity.width = 32.0
			entity.height = 24.0
			entity.anim_id = 584
			entity.note_block = true
		ENTITY_TYPES.ENTITY_NOTE_SPHERE:
			entity.width = 48.0
			entity.height = 48.0
			entity.anim_id = 585
			entity.note_sphere = true
		ENTITY_TYPES.ENTITY_NOTE_PARTICLE:
			entity.width = 18.0
			entity.height = 18.0
			entity.anim_id = 587
			entity.note_particle = true
		ENTITY_TYPES.ENTITY_CONVEYOR:
			entity.width = 160.0
			entity.height = 24.0
			entity.anim_id = 16
		ENTITY_TYPES.ENTITY_LAYER_TOGGLE:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 14
		ENTITY_TYPES.ENTITY_RAMP:
			entity.width = 96.0
			entity.height = 64.0
			entity.anim_id = 543
		ENTITY_TYPES.ENTITY_ROTATING_HANDLE:
			entity.width = 42.0
			entity.height = 42.0
			entity.anim_id = 546
		ENTITY_TYPES.ENTITY_FLYING_HANDLE:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 586
		ENTITY_TYPES.ENTITY_CORK_SCREW:
			entity.width = 48.0
			entity.height = 48.0
			entity.anim_id = 539
		ENTITY_TYPES.ENTITY_CANNON:
			entity.width = 48.0
			entity.height = 48.0
			entity.anim_id = 547
		ENTITY_TYPES.ENTITY_LAUNCHER:
			entity.width = 34.0
			entity.height = 30.0
			entity.anim_id = 548
		ENTITY_TYPES.ENTITY_PIPE_START, ENTITY_TYPES.ENTITY_PIPE_END:
			entity.width = 24.0
			entity.height = 24.0
			entity.anim_id = 549
		ENTITY_TYPES.ENTITY_HOOK_RAIL:
			entity.width = 64.0
			entity.height = 32.0
			entity.anim_id = 550
		ENTITY_TYPES.ENTITY_SLIDY_ICE:
			entity.anim_id = 551
		ENTITY_TYPES.ENTITY_LIGHT_BRIDGE:
			entity.width = 240.0
			entity.height = 32.0
			entity.anim_id = 552
		ENTITY_TYPES.ENTITY_SLOWING_SNOW:
			entity.anim_id = 553
		ENTITY_TYPES.ENTITY_SPIKE_PLATFORM:
			entity.width = 48.0
			entity.height = 24.0
			entity.anim_id = 554
		ENTITY_TYPES.ENTITY_TURNAROUND_BAR:
			entity.width = 24.0
			entity.height = 48.0
			entity.anim_id = 567
		ENTITY_TYPES.ENTITY_KEYBOARD:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 568
		ENTITY_TYPES.ENTITY_POLE:
			entity.width = 16.0
			entity.height = 64.0
			entity.anim_id = 569
		ENTITY_TYPES.ENTITY_LIGHT_GLOBE:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 570
		ENTITY_TYPES.ENTITY_WINDUP_STICK:
			entity.width = 48.0
			entity.height = 24.0
			entity.anim_id = 571
		ENTITY_TYPES.ENTITY_GERMAN_FLUTE:
			entity.width = 40.0
			entity.height = 32.0
			entity.anim_id = 572
		ENTITY_TYPES.ENTITY_SMALL_WINDMILL:
			entity.width = 64.0
			entity.height = 64.0
			entity.anim_id = 573
		ENTITY_TYPES.ENTITY_CHORD:
			entity.width = 48.0
			entity.height = 24.0
			entity.anim_id = 574
		ENTITY_TYPES.ENTITY_HALF_PIPE:
			entity.width = 96.0
			entity.height = 104.0
			entity.anim_id = 575
		ENTITY_TYPES.ENTITY_IRON_BALL:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 576
		ENTITY_TYPES.ENTITY_CRANE:
			entity.width = 32.0
			entity.height = 112.0
			entity.anim_id = 577
		ENTITY_TYPES.ENTITY_CEILING_SLOPE:
			entity.width = 48.0
			entity.height = 96.0
			entity.anim_id = 578
		ENTITY_TYPES.ENTITY_GAPPED_LOOP:
			entity.width = 64.0
			entity.height = 64.0
			entity.anim_id = 579
		ENTITY_TYPES.ENTITY_FUNNEL_SPHERE:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 580
		ENTITY_TYPES.ENTITY_MUSIC_ENTRY:
			entity.width = 40.0
			entity.height = 40.0
			entity.anim_id = 581
		ENTITY_TYPES.ENTITY_DAMAGE_REGION:
			entity.width = 24.0
			entity.height = 24.0
			entity.anim_id = 582
		ENTITY_TYPES.ENTITY_DECORATION:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 583
		ENTITY_TYPES.ENTITY_LAP_TRIGGER:
			entity.width = 8.0
			entity.height = 8.0
		ENTITY_TYPES.ENTITY_GOAL_LEVER:
			entity.width = 24.0
			entity.height = 64.0
			entity.anim_id = 4
		ENTITY_TYPES.ENTITY_BUZZER:
			entity.width = 30.0
			entity.height = 30.0
			entity.anim_id = 17
		ENTITY_TYPES.ENTITY_BALLOON:
			entity.width = 34.0
			entity.height = 34.0
			entity.anim_id = 18
		ENTITY_TYPES.ENTITY_PROJECTILE:
			entity.width = 12.0
			entity.height = 12.0
			entity.anim_id = 19
		ENTITY_TYPES.ENTITY_BULLET_BUZZER:
			entity.width = 32.0
			entity.height = 32.0
			entity.anim_id = 20
		ENTITY_TYPES.ENTITY_KOURA:
			entity.width = 34.0
			entity.height = 26.0
			entity.anim_id = 21
		ENTITY_TYPES.ENTITY_STAR:
			entity.width = 34.0
			entity.height = 34.0
			entity.anim_id = 22
		ENTITY_TYPES.ENTITY_KIKI:
			entity.width = 30.0
			entity.height = 36.0
			entity.anim_id = 23
		ENTITY_TYPES.ENTITY_KIKI_PROJECTILE:
			entity.width = 16.0
			entity.height = 16.0
			entity.anim_id = 24
		ENTITY_TYPES.ENTITY_KIKI_PIECE:
			entity.width = 18.0
			entity.height = 18.0
			entity.anim_id = 25
		ENTITY_TYPES.ENTITY_BOSS:
			entity.width = 92.0
			entity.height = 68.0
			entity.anim_id = 26
		ENTITY_TYPES.ENTITY_TRAPPED_ANIMAL:
			entity.width = 30.0
			entity.height = 34.0
			entity.anim_id = 28
		ENTITY_TYPES.ENTITY_RING_EFFECT:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 29
		ENTITY_TYPES.ENTITY_HEART_EFFECT:
			entity.width = 24.0
			entity.height = 24.0
			entity.anim_id = 30
		ENTITY_TYPES.ENTITY_DUST_EFFECT:
			entity.width = 42.0
			entity.height = 28.0
			entity.anim_id = 31
		ENTITY_TYPES.ENTITY_GRIND_EFFECT:
			entity.width = 26.0
			entity.height = 26.0
			entity.anim_id = 32
		ENTITY_TYPES.ENTITY_CHEESE:
			entity.width = 28.0
			entity.height = 28.0
			entity.anim_id = 33
		ENTITY_TYPES.ENTITY_TAIL_SWIPE:
			entity.width = 48.0
			entity.height = 42.0
			entity.anim_id = 34
		ENTITY_TYPES.ENTITY_KNUCKLES_FIRE:
			entity.width = 34.0
			entity.height = 34.0
			entity.anim_id = 35
		ENTITY_TYPES.ENTITY_SONIC_SKID:
			entity.width = 44.0
			entity.height = 38.0
			entity.anim_id = 36
		ENTITY_TYPES.ENTITY_SPRING:
			entity.width = 24.0
			entity.height = 20.0
			entity.anim_id = 1
		ENTITY_TYPES.ENTITY_ENEMY:
			entity.width = 30.0
			entity.height = 20.0
			entity.anim_id = 2
		ENTITY_TYPES.ENTITY_CHECKPOINT:
			entity.width = 20.0
			entity.height = 72.0
			entity.anim_id = 3
		ENTITY_TYPES.ENTITY_GOAL:
			entity.width = 24.0
			entity.height = 96.0
			entity.anim_id = 4
		_:
			entity.width = 16.0
			entity.height = 16.0
	level.entities.append(entity)
	return entity
