extends RefCounted
class_name StageSurfaceStateSystem

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")

static func is_on_slowing_snow(level: LevelState, player: PlayerState) -> bool:
	if not player.is_grounded:
		return false
	for entity in level.entities:
		if not entity.active or entity.type != ENTITY_TYPES.ENTITY_SLOWING_SNOW:
			continue
		if absf(player.world_x - entity.world_x) <= entity.width * 0.5 and absf(player.world_y - entity.world_y) <= entity.height * 0.5:
			return true
	return false

static func update_light_bridges(level: LevelState, player: PlayerState, delta: float, player_layer: int) -> int:
	for entity in level.entities:
		if not entity.active or not entity.light_bridge:
			continue
		entity.light_bridge_phase = fmod(entity.light_bridge_phase + delta * TAU / 4.0, TAU)
		entity.light_bridge_active = entity.light_bridge_phase < TAU * 0.75
		var dx: float = player.world_x - entity.world_x
		var dy: float = player.world_y - entity.world_y
		var in_range := false
		if entity.light_bridge_type == 0:
			in_range = absf(dx) <= 120.0 and dy >= -32.0 and dy <= -4.0
		else:
			in_range = dx >= 0.0 and dx <= 96.0 and dy >= -96.0 and dy <= 0.0
		if in_range:
			player_layer = 0 if entity.light_bridge_active else 1
	return player_layer

static func is_on_slidy_ice(level: LevelState, player: PlayerState) -> bool:
	for entity in level.entities:
		if not entity.active or entity.type != ENTITY_TYPES.ENTITY_SLIDY_ICE:
			continue
		if absf(player.world_x - entity.world_x) <= entity.width * 0.5 and absf(player.world_y - entity.world_y) <= entity.height * 0.5:
			return true
	return false
