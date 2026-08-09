class_name SourceEntityCatalog

extends RefCounted

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")
const GRAVITY_KIND_DOWN := 0
const GRAVITY_KIND_UP := 1
const GRAVITY_KIND_TOGGLE := 2
const SPRING_UP := 0
const SPRING_DOWN := 1
const SPRING_LEFT := 2
const SPRING_RIGHT := 3
const SPRING_UP_LEFT := 4
const SPRING_UP_RIGHT := 5
const SPRING_DOWN_LEFT := 6
const SPRING_DOWN_RIGHT := 7
const ITEM_BOX_KIND_RINGS := 0
const ITEM_BOX_KIND_SHIELD := 1
const ITEM_BOX_KIND_INVINCIBILITY := 2
const ITEM_BOX_KIND_ONE_UP := 3
const ITEM_BOX_KIND_SPEED_UP := 4
const ITEM_BOX_KIND_MAGNETIC_SHIELD := 5
const ITEM_BOX_KIND_RINGS_RANDOM := 6
const ITEM_BOX_KIND_RINGS_5 := 7
const ITEM_BOX_KIND_RINGS_10 := 8

static func _source_interactable_type(kind: String) -> int:
	if kind == "COLLECT_RINGS_LAP_TRIGGER":
		return ENTITY_TYPES.ENTITY_LAP_TRIGGER
	if kind == "GOAL_LEVER":
		return ENTITY_TYPES.ENTITY_GOAL_LEVER
	if kind == "SPECIAL_RING":
		return ENTITY_TYPES.ENTITY_SPECIAL_RING
	if kind.begins_with("LAUNCHER__"):
		return ENTITY_TYPES.ENTITY_LAUNCHER
	if kind == "PIPE__START":
		return ENTITY_TYPES.ENTITY_PIPE_START
	if kind == "PIPE__END":
		return ENTITY_TYPES.ENTITY_PIPE_END
	if kind == "HOOK_RAIL__START" or kind == "HOOK_RAIL__END":
		return ENTITY_TYPES.ENTITY_HOOK_RAIL
	if kind == "SLIDY_ICE":
		return ENTITY_TYPES.ENTITY_SLIDY_ICE
	if kind == "LIGHT_BRIDGE":
		return ENTITY_TYPES.ENTITY_LIGHT_BRIDGE
	if kind == "SLOWING_SNOW":
		return ENTITY_TYPES.ENTITY_SLOWING_SNOW
	if kind == "SPIKE_PLATFORM":
		return ENTITY_TYPES.ENTITY_SPIKE_PLATFORM
	if kind == "TURNAROUND_BAR":
		return ENTITY_TYPES.ENTITY_TURNAROUND_BAR
	if kind == "KEYBOARD_VERTICAL" or kind == "KEYBOARD_HORIZONTAL_LEFT" or kind == "KEYBOARD_HORIZONTAL_RIGHT":
		return ENTITY_TYPES.ENTITY_KEYBOARD
	if kind == "POLE":
		return ENTITY_TYPES.ENTITY_POLE
	if kind == "LIGHT_GLOBE":
		return ENTITY_TYPES.ENTITY_LIGHT_GLOBE
	if kind == "WINDUP_STICK":
		return ENTITY_TYPES.ENTITY_WINDUP_STICK
	if kind == "GERMAN_FLUTE":
		return ENTITY_TYPES.ENTITY_GERMAN_FLUTE
	if kind == "SMALL_WINDMILL":
		return ENTITY_TYPES.ENTITY_SMALL_WINDMILL
	if kind == "CHORD":
		return ENTITY_TYPES.ENTITY_CHORD
	if kind == "HALFPIPE__START" or kind == "HALFPIPE__END":
		return ENTITY_TYPES.ENTITY_HALF_PIPE
	if kind == "IRON_BALL":
		return ENTITY_TYPES.ENTITY_IRON_BALL
	if kind == "CRANE":
		return ENTITY_TYPES.ENTITY_CRANE
	if kind.begins_with("CEILING_SLOPE__"):
		return ENTITY_TYPES.ENTITY_CEILING_SLOPE
	if kind == "GAPPED_LOOP__START" or kind == "GAPPED_LOOP__END":
		return ENTITY_TYPES.ENTITY_GAPPED_LOOP
	if kind == "FUNNEL_SPHERE":
		return ENTITY_TYPES.ENTITY_FUNNEL_SPHERE
	if kind == "TRUMPET_ENTRY" or kind == "PIPE_INSTRUMENT_ENTRY":
		return ENTITY_TYPES.ENTITY_MUSIC_ENTRY
	if kind == "IA105":
		return ENTITY_TYPES.ENTITY_DAMAGE_REGION
	if kind == "DECORATION":
		return ENTITY_TYPES.ENTITY_DECORATION
	if kind == "CANNON":
		return ENTITY_TYPES.ENTITY_CANNON
	if kind.begins_with("WHIRLWIND"):
		return ENTITY_TYPES.ENTITY_WHIRLWIND
	if kind.begins_with("FAN"):
		return ENTITY_TYPES.ENTITY_FAN
	if kind == "PROPELLER":
		return ENTITY_TYPES.ENTITY_PROPELLER
	if kind == "DASH_RING":
		return ENTITY_TYPES.ENTITY_DASH_RING
	if kind.begins_with("TOGGLE_GRAVITY"):
		return ENTITY_TYPES.ENTITY_GRAVITY_TOGGLE
	if kind.find("TOGGLE_PLAYER_LAYER") >= 0:
		return ENTITY_TYPES.ENTITY_LAYER_TOGGLE
	if kind == "RAMP" or kind == "INCLINE_RAMP":
		return ENTITY_TYPES.ENTITY_RAMP
	if kind == "FLYING_HANDLE":
		return ENTITY_TYPES.ENTITY_FLYING_HANDLE
	if kind == "ROTATING_HANDLE":
		return ENTITY_TYPES.ENTITY_ROTATING_HANDLE
	if kind.find("CORK_SCREW") >= 0 or kind.find("CORKSCREW") >= 0:
		return ENTITY_TYPES.ENTITY_CORK_SCREW
	if kind.begins_with("NOTE_BLOCK") and kind.ends_with("__SPHERE"):
		return ENTITY_TYPES.ENTITY_NOTE_SPHERE
	if kind.begins_with("NOTE_BLOCK"):
		return ENTITY_TYPES.ENTITY_NOTE_BLOCK
	if kind == "BOUNCY_BAR":
		return ENTITY_TYPES.ENTITY_BOUNCY_SPRING
	if kind.find("CHECKPOINT") >= 0:
		return ENTITY_TYPES.ENTITY_CHECKPOINT
	if kind.find("GOAL") >= 0:
		return ENTITY_TYPES.ENTITY_GOAL
	if kind.find("SPRING") >= 0:
		return ENTITY_TYPES.ENTITY_BOUNCY_SPRING if kind == "BOUNCY_SPRING" else ENTITY_TYPES.ENTITY_SPRING
	if kind.find("SPIKES") >= 0 or kind == "SPIKE_PLATFORM":
		return ENTITY_TYPES.ENTITY_SPIKES
	if kind == "BOOSTER":
		return ENTITY_TYPES.ENTITY_BOOSTER
	if kind.find("GRIND_RAIL") >= 0:
		return ENTITY_TYPES.ENTITY_GRIND_RAIL
	return -1

static func _source_gravity_kind(kind: String) -> int:
	if kind.ends_with("DOWN"):
		return GRAVITY_KIND_DOWN
	if kind.ends_with("UP"):
		return GRAVITY_KIND_UP
	return GRAVITY_KIND_TOGGLE

static func _source_spring_variant(kind: String) -> int:
	if kind.ends_with("DOWNLEFT"):
		return SPRING_DOWN_LEFT
	if kind.ends_with("DOWNRIGHT"):
		return SPRING_DOWN_RIGHT
	if kind.ends_with("UPLEFT"):
		return SPRING_UP_LEFT
	if kind.ends_with("UPRIGHT"):
		return SPRING_UP_RIGHT
	if kind.ends_with("DOWN"):
		return SPRING_DOWN
	if kind.ends_with("LEFT"):
		return SPRING_LEFT
	if kind.ends_with("RIGHT"):
		return SPRING_RIGHT
	return SPRING_UP

static func _source_enemy_type(kind: String) -> int:
	match kind:
		"BUZZER":
			return ENTITY_TYPES.ENTITY_BUZZER
		"KIKI":
			return ENTITY_TYPES.ENTITY_KIKI
		"MON":
			return ENTITY_TYPES.ENTITY_ENEMY
		"BALLOON":
			return ENTITY_TYPES.ENTITY_BALLOON
		"BULLETBUZZER":
			return ENTITY_TYPES.ENTITY_BULLET_BUZZER
		"KOURA":
			return ENTITY_TYPES.ENTITY_KOURA
		"STAR":
			return ENTITY_TYPES.ENTITY_STAR
		# These source enemies share the generic contact/damage path until their
		# individual animation and attack state machines are migrated.
		"KUBINAGA", "GOHLA", "KURAKURA", "KOURA", "CIRCUS", "BELL", "YADO", "PIKOPIKO", "MADILLO", "STRAW", "HAMMERHEAD", "SPINNER", "MOUSE", "PEN", "GEJIGEJI", "BALLOON", "FLICKEY", "KYURA", "STAR", "BULLETBUZZER":
			return ENTITY_TYPES.ENTITY_ENEMY
	return -1

static func _source_item_kind(kind: String) -> int:
	match kind:
		"SHIELD":
			return ITEM_BOX_KIND_SHIELD
		"SHIELD_MAGNETIC":
			return ITEM_BOX_KIND_MAGNETIC_SHIELD
		"INVINCIBILITY":
			return ITEM_BOX_KIND_INVINCIBILITY
		"ONE_UP":
			return ITEM_BOX_KIND_ONE_UP
		"SPEED_UP":
			return ITEM_BOX_KIND_SPEED_UP
		"RINGS_5":
			return ITEM_BOX_KIND_RINGS_5
		"RINGS_10":
			return ITEM_BOX_KIND_RINGS_10
		"RINGS_RANDOM":
			return ITEM_BOX_KIND_RINGS_RANDOM
	return ITEM_BOX_KIND_RINGS
