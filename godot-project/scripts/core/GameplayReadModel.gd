class_name GameplayReadModel
extends RefCounted

## Read-only gameplay data consumed by HUD and scene presenters.
static func boost_trail_positions(bridge: Object) -> Array:
	var positions: Array = []
	for frame_offset in [2, 4, 6]:
		if frame_offset < bridge.get_dash_effect_state().boost_position_history.size():
			positions.append(bridge.get_dash_effect_state().boost_position_history[frame_offset])
		else:
			var player: PlayerState = bridge.get_player_state()
			positions.append(Vector2(player.world_x, player.world_y))
	return positions

static func is_player_boosting(bridge: Object) -> bool:
	return not bridge.is_multiplayer_run() and (bridge.get_player_state().super_sonic or bridge.get_stage_intro_state().start_boost_timer > 0.0 or bridge.get_dash_effect_state().dash_timer > 0.0 or bridge.get_dash_effect_state().boost_effect_timer > 0.0)

static func source_map_summary(bridge: Object) -> String:
	if bridge.get_source_map_manifest().is_empty():
		return "SOURCE MAP DATA UNLOADED"
	var manifest: Dictionary = bridge.get_source_map_manifest()
	var status: String = "SOURCE MAP" if manifest.valid else "SOURCE MAP FALLBACK"
	return "%s %dx%d / %d OBJECTS" % [status, manifest.region_width, manifest.region_height, manifest.entity_count]

static func level_name(bridge: Object) -> String:
	return bridge.get_level_state().name

static func level_id(bridge: Object) -> int:
	return bridge.get_level_state().level_id

static func stage_backdrop_profile(bridge: Object) -> Dictionary:
	return bridge.STAGE_BACKDROP_CATALOG.profile(bridge.get_level_state().level_id)

static func entity_visual_profile(bridge: Object, entity_type: int, activated: bool) -> Dictionary:
	return bridge.ENTITY_VISUAL_CATALOG.profile(entity_type, activated)
