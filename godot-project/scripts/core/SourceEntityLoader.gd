class_name SourceEntityLoader
extends RefCounted

const PLATFORM_BUILDER := preload("res://scripts/core/PlatformBuilder.gd")
const ENTITY_FACTORY := preload("res://scripts/core/EntityFactory.gd")
const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")
const SOURCE_ENTITY_CATALOG := preload("res://scripts/core/SourceEntityCatalog.gd")
const SOURCE_ENEMY_CONFIGURATOR := preload("res://scripts/core/SourceEnemyConfigurator.gd")
const SOURCE_TERRAIN_LOADER := preload("res://scripts/core/SourceTerrainLoader.gd")

const DASH_RING_UP := 0
const DASH_RING_RIGHT := 2
const DASH_RING_UP_LEFT := 7

var _source_manifest: Dictionary = {}
var _player_state: PlayerState
var _checkpoint_time: float = 0.0

func apply(level: LevelState, source_manifest: Dictionary, player_state: PlayerState, checkpoint_time: float) -> void:
	_source_manifest = source_manifest
	_player_state = player_state
	_checkpoint_time = checkpoint_time
	if _source_manifest.is_empty() or not bool(_source_manifest.get("valid", false)):
		return
	var source_width := maxf(1.0, float(_source_manifest.get("region_width", 1)) * 256.0)
	var source_height := maxf(1.0, float(_source_manifest.get("region_height", 1)) * 256.0)
	var source_entities: Dictionary = _source_manifest.get("entities", {})
	for row in source_entities.get("rings", []):
		_add_source_entity(level, ENTITY_TYPES.ENTITY_RING, row, source_width, source_height)
	for row in source_entities.get("itemboxes", []):
		var item := _add_source_entity(level, ENTITY_TYPES.ENTITY_ITEM_BOX, row, source_width, source_height)
		item.item_kind = _source_item_kind(str(row.get("kind", "")))
	for row in source_entities.get("enemies", []):
		var enemy_kind := str(row.get("kind", ""))
		var enemy_type := _source_enemy_type(enemy_kind)
		if enemy_type >= 0:
			var source_enemy := _add_source_entity(level, enemy_type, row, source_width, source_height)
			_configure_source_enemy(source_enemy, enemy_kind, row)
	var goal_added := false
	for row in source_entities.get("interactables", []):
		var kind := str(row.get("kind", ""))
		if kind == "PLATFORM_CRUMBLING":
			_add_source_crumbling_platform(level, row, source_width, source_height)
			continue
		if kind == "PLATFORM_SQUARE":
			_add_source_square_platform(level, row, source_width, source_height)
			continue
		if kind == "COMMON_THIN_PLATFORM":
			_add_source_thin_platform(level, row, source_width, source_height)
			continue
		if kind == "PLATFORM_A":
			_add_source_platform_a(level, row, source_width, source_height)
			continue
		if kind == "PLATFORM_B":
			_add_source_platform_b(level, row, source_width, source_height)
			continue
		if kind.begins_with("ARROW_PLATFORM"):
			_add_source_arrow_platform(level, row, kind, source_width, source_height)
			continue
		if kind == "SPEEDING_PLATFORM":
			_add_source_speeding_platform(level, row, source_width, source_height)
			continue
		var entity_type := _source_interactable_type(kind)
		if entity_type < 0:
			continue
		if entity_type == ENTITY_TYPES.ENTITY_GOAL:
			if goal_added:
				continue
			goal_added = true
		var source_entity := _add_source_entity(level, entity_type, row, source_width, source_height)
		if entity_type == ENTITY_TYPES.ENTITY_LAP_TRIGGER:
			_configure_source_lap_trigger(source_entity, row, source_width, source_height, level)
			continue
		if entity_type == ENTITY_TYPES.ENTITY_LAUNCHER:
			_add_source_launcher(source_entity, row, kind, source_width, source_height, level)
		elif entity_type == ENTITY_TYPES.ENTITY_CANNON:
			var cannon_fields: Array = row.get("fields", [])
			source_entity.cannon_facing_right = cannon_fields.size() > 5 and _to_int_field(cannon_fields[5]) != 0
			source_entity.cannon_angle = 0.0 if source_entity.cannon_facing_right else PI
		elif entity_type == ENTITY_TYPES.ENTITY_HOOK_RAIL:
			var hook_fields: Array = row.get("fields", [])
			source_entity.variant = 1 if kind.ends_with("END") else 0
			if hook_fields.size() > 8:
				var hook_scale := _source_runtime_scale(source_width, source_height, level)
				var hook_base_x := float(row.get("world_x", 0))
				var hook_base_y := float(row.get("world_y", 0))
				var hook_left := float(_to_int_field(hook_fields[5])) * 8.0
				var hook_top := float(_to_int_field(hook_fields[6])) * 8.0
				var hook_right := hook_left + float(_to_int_field(hook_fields[7])) * 8.0
				var hook_start := _source_runtime_position(level, hook_base_x + hook_left, hook_base_y + hook_top + 20.0, source_width, source_height)
				var hook_end := _source_runtime_position(level, hook_base_x + hook_right, hook_base_y + hook_top + 20.0, source_width, source_height)
				source_entity.world_x = hook_start.x
				source_entity.world_y = hook_start.y
				source_entity.target_x = hook_end.x
				source_entity.target_y = hook_end.y
				source_entity.width = maxf(24.0, absf(hook_right - hook_left) * hook_scale)
		elif entity_type == ENTITY_TYPES.ENTITY_SLIDY_ICE:
			var ice_fields: Array = row.get("fields", [])
			if ice_fields.size() > 8:
				var ice_scale := _source_runtime_scale(source_width, source_height, level)
				var ice_base_x := float(row.get("world_x", 0))
				var ice_base_y := float(row.get("world_y", 0))
				var ice_top_left := _source_runtime_position(level, ice_base_x + float(_to_int_field(ice_fields[5])) * 8.0, ice_base_y + float(_to_int_field(ice_fields[6])) * 8.0, source_width, source_height)
				source_entity.world_x = ice_top_left.x
				source_entity.world_y = ice_top_left.y
				source_entity.width = maxf(16.0, float(_to_int_field(ice_fields[7])) * 8.0 * ice_scale)
				source_entity.height = maxf(16.0, float(_to_int_field(ice_fields[8])) * 8.0 * ice_scale)
		elif entity_type == ENTITY_TYPES.ENTITY_LIGHT_BRIDGE:
			var bridge_fields: Array = row.get("fields", [])
			source_entity.light_bridge = true
			if bridge_fields.size() > 6:
				source_entity.light_bridge_type = clampi(_to_int_field(bridge_fields[5]), 0, 1)
				source_entity.light_bridge_phase = float(_to_int_field(bridge_fields[6])) * TAU / 240.0
				source_entity.width = 240.0 if source_entity.light_bridge_type == 0 else 96.0
				source_entity.height = 32.0 if source_entity.light_bridge_type == 0 else 96.0
		elif entity_type == ENTITY_TYPES.ENTITY_SLOWING_SNOW:
			var snow_fields: Array = row.get("fields", [])
			if snow_fields.size() > 8:
				var snow_scale := _source_runtime_scale(source_width, source_height, level)
				var snow_base_x := float(row.get("world_x", 0))
				var snow_base_y := float(row.get("world_y", 0))
				var snow_top_left := _source_runtime_position(level, snow_base_x + float(_to_int_field(snow_fields[5])) * 8.0, snow_base_y + float(_to_int_field(snow_fields[6])) * 8.0, source_width, source_height)
				source_entity.world_x = snow_top_left.x
				source_entity.world_y = snow_top_left.y
				source_entity.width = maxf(16.0, float(_to_int_field(snow_fields[7])) * 8.0 * snow_scale)
				source_entity.height = maxf(16.0, float(_to_int_field(snow_fields[8])) * 8.0 * snow_scale)
		elif entity_type == ENTITY_TYPES.ENTITY_SPIKE_PLATFORM:
			var spike_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = spike_position.x
			source_entity.world_y = spike_position.y
			source_entity.spike_platform = true
			PLATFORM_BUILDER.add_platform(level, spike_position.x - 24.0, spike_position.y + 12.0, 48.0, 12.0)
		elif entity_type == ENTITY_TYPES.ENTITY_TURNAROUND_BAR:
			var turnaround_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = turnaround_position.x
			source_entity.world_y = turnaround_position.y
			source_entity.turnaround_bar = true
		elif entity_type == ENTITY_TYPES.ENTITY_KEYBOARD:
			var keyboard_fields: Array = row.get("fields", [])
			var keyboard_scale := _source_runtime_scale(source_width, source_height, level)
			var keyboard_base_x := float(row.get("world_x", 0))
			var keyboard_base_y := float(row.get("world_y", 0))
			var keyboard_left := float(_to_int_field(keyboard_fields[5])) * 8.0 if keyboard_fields.size() > 5 else -16.0
			var keyboard_top := float(_to_int_field(keyboard_fields[6])) * 8.0 if keyboard_fields.size() > 6 else -16.0
			var keyboard_width := float(_to_int_field(keyboard_fields[7])) * 8.0 if keyboard_fields.size() > 7 else 32.0
			var keyboard_height := float(_to_int_field(keyboard_fields[8])) * 8.0 if keyboard_fields.size() > 8 else 32.0
			var keyboard_position := _source_runtime_position(level, keyboard_base_x + keyboard_left + keyboard_width * 0.5, keyboard_base_y + keyboard_top + keyboard_height * 0.5, source_width, source_height)
			source_entity.world_x = keyboard_position.x
			source_entity.world_y = keyboard_position.y
			source_entity.width = maxf(16.0, keyboard_width * keyboard_scale)
			source_entity.height = maxf(16.0, keyboard_height * keyboard_scale)
			source_entity.keyboard = true
			source_entity.keyboard_type = 0 if kind == "KEYBOARD_VERTICAL" else (1 if kind == "KEYBOARD_HORIZONTAL_LEFT" else 2)
			source_entity.velocity_x = signf(keyboard_left) if source_entity.keyboard_type == 0 else float(source_entity.keyboard_type * 2 - 3)
			source_entity.velocity_y = signf(keyboard_top)
		elif entity_type == ENTITY_TYPES.ENTITY_POLE:
			var pole_fields: Array = row.get("fields", [])
			var pole_scale := _source_runtime_scale(source_width, source_height, level)
			var pole_base_x := float(row.get("world_x", 0))
			var pole_base_y := float(row.get("world_y", 0))
			var pole_left := float(_to_int_field(pole_fields[5])) * 8.0 if pole_fields.size() > 5 else -8.0
			var pole_top := float(_to_int_field(pole_fields[6])) * 8.0 if pole_fields.size() > 6 else -32.0
			var pole_width := float(_to_int_field(pole_fields[7])) * 8.0 if pole_fields.size() > 7 else 16.0
			var pole_height := float(_to_int_field(pole_fields[8])) * 8.0 if pole_fields.size() > 8 else 64.0
			var pole_position := _source_runtime_position(level, pole_base_x + pole_left + pole_width * 0.5, pole_base_y + pole_top + pole_height * 0.5, source_width, source_height)
			source_entity.world_x = pole_position.x
			source_entity.world_y = pole_position.y
			source_entity.width = maxf(12.0, pole_width * pole_scale)
			source_entity.height = maxf(24.0, pole_height * pole_scale)
			source_entity.pole = true
		elif entity_type == ENTITY_TYPES.ENTITY_LIGHT_GLOBE:
			var globe_position := _source_runtime_position(level, float(row.get("world_x", 0)) + 4.0, float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = globe_position.x
			source_entity.world_y = globe_position.y
			source_entity.light_globe = true
		elif entity_type == ENTITY_TYPES.ENTITY_WINDUP_STICK:
			var stick_fields: Array = row.get("fields", [])
			var stick_scale := _source_runtime_scale(source_width, source_height, level)
			var stick_base_x := float(row.get("world_x", 0))
			var stick_base_y := float(row.get("world_y", 0))
			var stick_left := float(_to_int_field(stick_fields[5])) * 8.0 if stick_fields.size() > 5 else -24.0
			var stick_top := float(_to_int_field(stick_fields[6])) * 8.0 if stick_fields.size() > 6 else -8.0
			var stick_width := float(_to_int_field(stick_fields[7])) * 8.0 if stick_fields.size() > 7 else 48.0
			var stick_height := float(_to_int_field(stick_fields[8])) * 8.0 if stick_fields.size() > 8 else 24.0
			var stick_position := _source_runtime_position(level, stick_base_x + stick_left + stick_width * 0.5, stick_base_y + stick_top + stick_height * 0.5, source_width, source_height)
			source_entity.world_x = stick_position.x
			source_entity.world_y = stick_position.y
			source_entity.width = maxf(16.0, stick_width * stick_scale)
			source_entity.height = maxf(16.0, stick_height * stick_scale)
			source_entity.windup_stick = true
		elif entity_type == ENTITY_TYPES.ENTITY_GERMAN_FLUTE:
			var flute_position := _source_runtime_position(level, float(row.get("world_x", 0)) + 4.0, float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = flute_position.x
			source_entity.world_y = flute_position.y
			source_entity.german_flute = true
			var flute_fields: Array = row.get("fields", [])
			source_entity.german_flute_kind = clampi(_to_int_field(flute_fields[5]) if flute_fields.size() > 5 else 0, 0, 3)
		elif entity_type == ENTITY_TYPES.ENTITY_SMALL_WINDMILL:
			var windmill_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = windmill_position.x
			source_entity.world_y = windmill_position.y
			source_entity.small_windmill = true
			var windmill_fields: Array = row.get("fields", [])
			source_entity.small_windmill_type = _to_int_field(windmill_fields[5]) if windmill_fields.size() > 5 else 15
		elif entity_type == ENTITY_TYPES.ENTITY_CHORD:
			var chord_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = chord_position.x
			source_entity.world_y = chord_position.y
			source_entity.chord = true
		elif entity_type == ENTITY_TYPES.ENTITY_HALF_PIPE:
			var half_pipe_fields: Array = row.get("fields", [])
			var half_pipe_scale := _source_runtime_scale(source_width, source_height, level)
			var half_pipe_base_x := float(row.get("world_x", 0))
			var half_pipe_base_y := float(row.get("world_y", 0))
			var half_pipe_left := float(_to_int_field(half_pipe_fields[5])) * 8.0 if half_pipe_fields.size() > 5 else 0.0
			var half_pipe_top := float(_to_int_field(half_pipe_fields[6])) * 8.0 if half_pipe_fields.size() > 6 else -104.0
			var half_pipe_width := float(_to_int_field(half_pipe_fields[7])) * 8.0 if half_pipe_fields.size() > 7 else 96.0
			var half_pipe_height := float(_to_int_field(half_pipe_fields[8])) * 8.0 if half_pipe_fields.size() > 8 else 104.0
			var half_pipe_position := _source_runtime_position(level, half_pipe_base_x + half_pipe_left + half_pipe_width * 0.5, half_pipe_base_y + half_pipe_top + half_pipe_height * 0.5, source_width, source_height)
			source_entity.world_x = half_pipe_position.x
			source_entity.world_y = half_pipe_position.y
			source_entity.width = maxf(32.0, half_pipe_width * half_pipe_scale)
			source_entity.height = maxf(32.0, half_pipe_height * half_pipe_scale)
			source_entity.half_pipe = true
			source_entity.half_pipe_direction = 1.0 if kind == "HALFPIPE__START" else -1.0
		elif entity_type == ENTITY_TYPES.ENTITY_IRON_BALL:
			var iron_fields: Array = row.get("fields", [])
			var iron_scale := _source_runtime_scale(source_width, source_height, level)
			var iron_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = iron_position.x
			source_entity.world_y = iron_position.y
			source_entity.origin_x = iron_position.x
			source_entity.origin_y = iron_position.y
			var iron_width := absf(float(_to_int_field(iron_fields[7])) * 8.0 * iron_scale) if iron_fields.size() > 7 else 32.0
			var iron_height := absf(float(_to_int_field(iron_fields[8])) * 8.0 * iron_scale) if iron_fields.size() > 8 else 32.0
			source_entity.iron_ball = true
			source_entity.iron_ball_horizontal = iron_width > iron_height
			source_entity.iron_ball_amplitude = maxf(16.0, iron_width if source_entity.iron_ball_horizontal else iron_height)
			source_entity.iron_ball_phase = PI if iron_fields.size() > 5 and _to_int_field(iron_fields[5]) < 0 else 0.0
		elif entity_type == ENTITY_TYPES.ENTITY_CRANE:
			var crane_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = crane_position.x
			source_entity.world_y = crane_position.y
			source_entity.origin_x = crane_position.x
			source_entity.origin_y = crane_position.y
			source_entity.crane = true
			source_entity.crane_hook_x = crane_position.x
			source_entity.crane_hook_y = crane_position.y + 88.0
		elif entity_type == ENTITY_TYPES.ENTITY_CEILING_SLOPE:
			var ceiling_fields: Array = row.get("fields", [])
			var ceiling_scale := _source_runtime_scale(source_width, source_height, level)
			var ceiling_base_x := float(row.get("world_x", 0))
			var ceiling_base_y := float(row.get("world_y", 0))
			var ceiling_left := float(_to_int_field(ceiling_fields[5])) * 8.0 if ceiling_fields.size() > 5 else 0.0
			var ceiling_top := float(_to_int_field(ceiling_fields[6])) * 8.0 if ceiling_fields.size() > 6 else 0.0
			var ceiling_width := float(_to_int_field(ceiling_fields[7])) * 8.0 if ceiling_fields.size() > 7 else 48.0
			var ceiling_height := float(_to_int_field(ceiling_fields[8])) * 8.0 if ceiling_fields.size() > 8 else 96.0
			var ceiling_position := _source_runtime_position(level, ceiling_base_x + ceiling_left + ceiling_width * 0.5, ceiling_base_y + ceiling_top + ceiling_height * 0.5, source_width, source_height)
			source_entity.world_x = ceiling_position.x
			source_entity.world_y = ceiling_position.y
			source_entity.width = maxf(16.0, ceiling_width * ceiling_scale)
			source_entity.height = maxf(16.0, ceiling_height * ceiling_scale)
			source_entity.ceiling_slope = true
			source_entity.ceiling_slope_variant = 1 if kind.ends_with("__B") else 0
		elif entity_type == ENTITY_TYPES.ENTITY_GAPPED_LOOP:
			var loop_base_x := float(row.get("world_x", 0))
			var loop_base_y := float(row.get("world_y", 0))
			var loop_position := _source_runtime_position(level, loop_base_x, loop_base_y, source_width, source_height)
			source_entity.world_x = loop_position.x
			source_entity.world_y = loop_position.y
			source_entity.gapped_loop = true
			source_entity.gapped_loop_direction = 1.0 if kind.ends_with("START") else -1.0
			source_entity.gapped_loop_center_x = loop_position.x - 96.0 * source_entity.gapped_loop_direction
			source_entity.gapped_loop_center_y = loop_position.y + 96.0
		elif entity_type == ENTITY_TYPES.ENTITY_FUNNEL_SPHERE:
			var funnel_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = funnel_position.x
			source_entity.world_y = funnel_position.y
			source_entity.funnel_sphere = true
		elif entity_type == ENTITY_TYPES.ENTITY_MUSIC_ENTRY:
			var entry_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = entry_position.x
			source_entity.world_y = entry_position.y
			source_entity.music_entry = true
			source_entity.music_entry_pipe = kind == "PIPE_INSTRUMENT_ENTRY"
			var entry_fields: Array = row.get("fields", [])
			source_entity.music_entry_kind = clampi(_to_int_field(entry_fields[5]) if entry_fields.size() > 5 else 0, 0, 8)
			source_entity.music_entry_duration = music_entry_duration(source_entity.music_entry_pipe, source_entity.music_entry_kind)
		elif entity_type == ENTITY_TYPES.ENTITY_DAMAGE_REGION:
			var damage_fields: Array = row.get("fields", [])
			var damage_scale := _source_runtime_scale(source_width, source_height, level)
			var damage_base_x := float(row.get("world_x", 0))
			var damage_base_y := float(row.get("world_y", 0))
			var damage_left := float(_to_int_field(damage_fields[5])) * 8.0 if damage_fields.size() > 5 else 0.0
			var damage_top := float(_to_int_field(damage_fields[6])) * 8.0 if damage_fields.size() > 6 else 0.0
			var damage_width := float(_to_int_field(damage_fields[7])) * 8.0 if damage_fields.size() > 7 else 24.0
			var damage_height := float(_to_int_field(damage_fields[8])) * 8.0 if damage_fields.size() > 8 else 24.0
			var damage_position := _source_runtime_position(level, damage_base_x + damage_left + damage_width * 0.5, damage_base_y + damage_top + damage_height * 0.5, source_width, source_height)
			source_entity.world_x = damage_position.x
			source_entity.world_y = damage_position.y
			source_entity.width = maxf(16.0, damage_width * damage_scale)
			source_entity.height = maxf(16.0, damage_height * damage_scale)
			source_entity.damage_region = true
		elif entity_type == ENTITY_TYPES.ENTITY_DECORATION:
			var decoration_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			source_entity.world_x = decoration_position.x
			source_entity.world_y = decoration_position.y
			source_entity.decoration = true
			var decoration_fields: Array = row.get("fields", [])
			source_entity.decoration_id = maxi(0, _to_int_field(decoration_fields[5]) if decoration_fields.size() > 5 else 0)
		elif entity_type == ENTITY_TYPES.ENTITY_GOAL:
			source_entity.goal_toggle = kind == "TOGGLE__GOAL"
		elif entity_type == ENTITY_TYPES.ENTITY_LAYER_TOGGLE:
			source_entity.variant = 1 if kind.find("BACKGROUND") >= 0 else 0
			var fields: Array = row.get("fields", [])
			if fields.size() > 8:
				source_entity.width = maxf(32.0, float(_to_int_field(fields[7])) * 8.0 * _source_runtime_scale(source_width, source_height, level))
				source_entity.height = maxf(32.0, float(_to_int_field(fields[8])) * 8.0 * _source_runtime_scale(source_width, source_height, level))
		elif entity_type == ENTITY_TYPES.ENTITY_RAMP:
			if kind == "INCLINE_RAMP":
				source_entity.ramp_incline = true
				var incline_fields: Array = row.get("fields", [])
				source_entity.variant = (_to_int_field(incline_fields[5]) & 1) if incline_fields.size() > 5 else 0
			else:
				var ramp_fields: Array = row.get("fields", [])
				source_entity.variant = (_to_int_field(ramp_fields[5]) & 1) if ramp_fields.size() > 5 else 0
		elif entity_type == ENTITY_TYPES.ENTITY_PIPE_END:
			var pipe_end_fields: Array = row.get("fields", [])
			source_entity.pipe_exit_back_layer = pipe_end_fields.size() > 3 and _to_int_field(pipe_end_fields[3]) != 0
			source_entity.pipe_exit_uncurl = pipe_end_fields.size() > 4 and _to_int_field(pipe_end_fields[4]) != 0
		elif entity_type == ENTITY_TYPES.ENTITY_CORK_SCREW:
			source_entity.variant = 1 if kind.find("STOP") >= 0 or kind.find("END") >= 0 else 0
		elif entity_type == ENTITY_TYPES.ENTITY_FLYING_HANDLE:
			var flying_fields: Array = row.get("fields", [])
			var flying_scale := _source_runtime_scale(source_width, source_height, level)
			var flying_base := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
			var flying_top := float(_to_int_field(flying_fields[6])) * 8.0 * flying_scale if flying_fields.size() > 6 else -72.0 * flying_scale
			var flying_bottom := float(_to_int_field(flying_fields[8])) * 8.0 * flying_scale if flying_fields.size() > 8 else 72.0 * flying_scale
			source_entity.world_x = flying_base.x
			source_entity.world_y = flying_base.y + flying_bottom
			source_entity.origin_x = flying_base.x
			source_entity.origin_y = flying_base.y
			source_entity.flying_handle_top_y = flying_base.y + flying_top
			source_entity.flying_handle_bottom_y = flying_base.y + flying_bottom
			source_entity.flying_handle = true
		elif entity_type == ENTITY_TYPES.ENTITY_BOUNCY_SPRING and kind == "BOUNCY_BAR":
			source_entity.variant = 2
		elif entity_type == ENTITY_TYPES.ENTITY_NOTE_BLOCK or entity_type == ENTITY_TYPES.ENTITY_NOTE_SPHERE:
			var note_fields: Array = row.get("fields", [])
			source_entity.note_kind = clampi(_to_int_field(note_fields[5]) if note_fields.size() > 5 else 0, 0, 7)
			source_entity.note_health = 3
		elif entity_type == ENTITY_TYPES.ENTITY_SPRING:
			source_entity.variant = _source_spring_variant(kind)
			source_entity.flying_spring = kind == "FLYING_SPRING"
			source_entity.floating_spring = kind == "FLOATING_SPRING"
			source_entity.origin_y = source_entity.world_y
			source_entity.origin_x = source_entity.world_x
			if source_entity.floating_spring:
				var floating_fields: Array = row.get("fields", [])
				if floating_fields.size() > 8:
					var floating_scale := _source_runtime_scale(source_width, source_height, level)
					var floating_x_amplitude := absf(float(_to_int_field(floating_fields[7])) * 8.0 * floating_scale)
					var floating_y_amplitude := absf(float(_to_int_field(floating_fields[8])) * 8.0 * floating_scale)
					source_entity.floating_spring_amplitude_x = floating_x_amplitude
					source_entity.floating_spring_amplitude_y = floating_y_amplitude
					var floating_direction := _to_int_field(floating_fields[5]) if floating_x_amplitude > floating_y_amplitude else _to_int_field(floating_fields[6])
					source_entity.floating_spring_phase = PI if floating_direction < 0 else 0.0
		elif entity_type == ENTITY_TYPES.ENTITY_FAN:
			source_entity.width = 96.0
			source_entity.height = 96.0
			source_entity.variant = 1 if kind.find("PERIODIC") >= 0 else 0
			source_entity.velocity_x = -1.0 if kind.find("LEFT") >= 0 else 1.0
			source_entity.fan_speed = 1.0
		elif entity_type == ENTITY_TYPES.ENTITY_WHIRLWIND:
			source_entity.width = 128.0
			source_entity.height = 128.0
			source_entity.whirlwind_active = false
			source_entity.whirlwind_timer = 0.0
			var whirlwind_fields: Array = row.get("fields", [])
			if whirlwind_fields.size() > 8:
				source_entity.width = _source_entity_extent(whirlwind_fields[7], source_width, source_height, level)
				source_entity.height = _source_entity_extent(whirlwind_fields[8], source_width, source_height, level)
		elif entity_type == ENTITY_TYPES.ENTITY_PROPELLER:
			source_entity.width = 148.0
			source_entity.height = 128.0
		elif entity_type == ENTITY_TYPES.ENTITY_DASH_RING:
			source_entity.width = 28.0
			source_entity.height = 28.0
			var dash_fields: Array = row.get("fields", [])
			source_entity.variant = clampi(_to_int_field(dash_fields[5]), DASH_RING_UP, DASH_RING_UP_LEFT) if dash_fields.size() > 5 else DASH_RING_RIGHT
		elif entity_type == ENTITY_TYPES.ENTITY_GRAVITY_TOGGLE:
			source_entity.width = 128.0
			source_entity.height = 128.0
			source_entity.gravity_kind = _source_gravity_kind(kind)
			var gravity_fields: Array = row.get("fields", [])
			if gravity_fields.size() > 8:
				source_entity.width = _source_entity_extent(gravity_fields[7], source_width, source_height, level)
				source_entity.height = _source_entity_extent(gravity_fields[8], source_width, source_height, level)
		elif entity_type == ENTITY_TYPES.ENTITY_GRIND_RAIL:
			source_entity.rail_direction = -1.0 if kind.find("LEFT") >= 0 else 1.0
			source_entity.rail_end_mode = 1 if kind.find("END_AIR") >= 0 or kind.find("FORCED_JUMP") >= 0 or kind.find("ALTERNATE") >= 0 else 0
			source_entity.rail_is_start = kind.find("START") >= 0
			source_entity.rail_air_start = kind.find("START_AIR") >= 0
	_apply_source_terrain(level, source_width, source_height)

func _add_source_launcher(entity: EntityState, row: Dictionary, kind: String, source_width: float, source_height: float, level: LevelState) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var left := float(_to_int_field(fields[5])) * 8.0
	var top := float(_to_int_field(fields[6])) * 8.0
	var right := left + float(_to_int_field(fields[7])) * 8.0
	var bottom := top + float(_to_int_field(fields[8])) * 8.0
	var goes_left := kind.ends_with("LEFT")
	var gravity_up := kind.find("__UP_") >= 0
	var start_x := right if goes_left else left
	var end_x := left if goes_left else right
	var vertical_offset := top if gravity_up else bottom
	var start := _source_runtime_position(level, base_x + start_x, base_y + vertical_offset, source_width, source_height)
	var end := _source_runtime_position(level, base_x + end_x, base_y + vertical_offset, source_width, source_height)
	entity.world_x = start.x
	entity.world_y = start.y
	entity.launcher_cart_x = start.x
	entity.launcher_cart_y = start.y
	entity.launcher_base_x = start.x
	entity.launcher_target_x = end.x
	entity.launcher_direction = -1.0 if goes_left else 1.0
	entity.launcher_gravity_up = gravity_up
	entity.launcher_scale = scale

func _add_source_platform_a(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var source_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	var horizontal := _to_int_field(fields[7]) > _to_int_field(fields[8])
	var amplitude_source := _to_int_field(fields[7]) if horizontal else _to_int_field(fields[8])
	var direction_field := _to_int_field(fields[5]) if horizontal else _to_int_field(fields[6])
	var phase := PI if direction_field < 0 else 0.0
	var amplitude := absf(float(amplitude_source)) * 8.0 * scale
	PLATFORM_BUILDER.add_moving_platform(level, source_position.x - 24.0, source_position.y + 12.0, 48.0, 12.0, 0 if horizontal else 1, amplitude, 4.0 * TAU / 256.0 * 60.0, phase)

func _add_source_platform_b(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var source_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	PLATFORM_BUILDER.add_platform(level, source_position.x - 24.0, source_position.y + 12.0, 48.0, 12.0)

func _add_source_speeding_platform(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var start := _source_runtime_position(level, base_x + 32.0, base_y + 18.0, source_width, source_height)
	var first_target := _source_runtime_position(level, base_x + 590.0, base_y + 576.0, source_width, source_height)
	var final_target := _source_runtime_position(level, base_x + 814.0, base_y + 576.0, source_width, source_height)
	PLATFORM_BUILDER.add_platform(level, start.x - 27.0, start.y, 54.0, 12.0)
	var platform: PlatformState = level.platforms.back()
	platform.speeding_mode = true
	platform.speeding_base_x = start.x - 27.0
	platform.speeding_base_y = start.y
	platform.speeding_target_x = first_target.x
	platform.speeding_target_y = first_target.y
	platform.speeding_first_x = first_target.x
	platform.speeding_first_y = first_target.y
	platform.speeding_final_x = final_target.x
	platform.speeding_final_y = final_target.y

func _add_source_entity(level: LevelState, entity_type: int, row: Dictionary, source_width: float, source_height: float) -> EntityState:
	var runtime_position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	var runtime_x: float = runtime_position.x
	var runtime_y: float = runtime_position.y
	return ENTITY_FACTORY.add_entity(level, entity_type, runtime_x, runtime_y)

func _configure_source_lap_trigger(entity: EntityState, row: Dictionary, source_width: float, source_height: float, level: LevelState) -> void:
	var fields: Array = row.get("fields", [])
	var scale := _source_runtime_scale(source_width, source_height, level)
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var left := float(_to_int_field(fields[5])) * 8.0 if fields.size() > 5 else 0.0
	var top := float(_to_int_field(fields[6])) * 8.0 if fields.size() > 6 else 0.0
	var width := maxf(8.0, float(_to_int_field(fields[7])) * 8.0 if fields.size() > 7 else 8.0)
	var height := maxf(8.0, float(_to_int_field(fields[8])) * 8.0 if fields.size() > 8 else 8.0)
	var position := _source_runtime_position(level, base_x, base_y, source_width, source_height)
	entity.world_x = position.x
	entity.world_y = position.y
	entity.width = width * scale
	entity.height = height * scale
	entity.lap_previous_player_x = _player_state.world_x
	entity.lap_previous_checkpoint_time = _checkpoint_time


func _add_source_crumbling_platform(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var source_x := float(row.get("world_x", 0)) + float(_to_int_field(fields[5])) * 8.0
	var source_y := float(row.get("world_y", 0)) + float(_to_int_field(fields[6])) * 8.0
	var position := _source_runtime_position(level, source_x, source_y, source_width, source_height)
	var width := maxf(32.0, float(_to_int_field(fields[7])) * 8.0 * scale)
	var thickness := maxf(8.0, float(_to_int_field(fields[8])) * 8.0 * scale)
	# platform_crumbling.c transitions after its counter passes 30 frames.
	PLATFORM_BUILDER.add_crumbling_platform(level, position.x, position.y + thickness, width, thickness, 31.0 / 60.0)

func _add_source_square_platform(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var source_x := float(row.get("world_x", 0)) + float(_to_int_field(fields[5])) * 8.0
	var source_y := float(row.get("world_y", 0)) + float(_to_int_field(fields[6])) * 8.0
	var position := _source_runtime_position(level, source_x, source_y, source_width, source_height)
	var horizontal_extent := maxi(0, _to_int_field(fields[7]))
	var vertical_extent := maxi(0, _to_int_field(fields[8]))
	var axis := 0 if horizontal_extent > vertical_extent else 1
	var amplitude := maxf(16.0, float(maxi(horizontal_extent, vertical_extent)) * 8.0 * scale)
	var phase := PI if _to_int_field(fields[5]) < 0 or _to_int_field(fields[6]) < 0 else 0.0
	PLATFORM_BUILDER.add_moving_platform(level, position.x, position.y + 16.0, 32.0, 16.0, axis, amplitude, 3.75, phase)

func _add_source_thin_platform(level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var position := _source_runtime_position(level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	PLATFORM_BUILDER.add_platform(level, position.x, position.y + 8.0, 32.0, 8.0)

func _add_source_arrow_platform(level: LevelState, row: Dictionary, kind: String, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _source_runtime_scale(source_width, source_height, level)
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var source_width_offset := float(_to_int_field(fields[5])) * 8.0 + 24.0
	var source_height_offset := float(_to_int_field(fields[6])) * 8.0 + 24.0
	var source_target_x := float(_to_int_field(fields[7])) * 8.0 + source_width_offset - 24.0
	var source_target_y := float(_to_int_field(fields[8])) * 8.0 + source_height_offset - 24.0
	var current_offset := Vector2(source_width_offset, source_height_offset)
	var target_offset := Vector2(source_target_x, source_target_y)
	if kind.ends_with("RIGHT"):
		current_offset.x = source_width_offset
		target_offset.x = source_target_x
	elif kind.ends_with("LEFT"):
		current_offset.x = source_target_x
		target_offset.x = source_width_offset
	else:
		current_offset.y = source_target_y
		target_offset.y = source_height_offset
	var position := _source_runtime_position(level, base_x + current_offset.x, base_y + current_offset.y, source_width, source_height)
	var target := _source_runtime_position(level, base_x + target_offset.x, base_y + target_offset.y, source_width, source_height)
	PLATFORM_BUILDER.add_platform(level, position.x, position.y + 12.0, 32.0, 12.0)
	var platform: PlatformState = level.platforms.back()
	platform.arrow_mode = true
	platform.arrow_target_x = target.x
	platform.arrow_target_y = target.y
	platform.arrow_speed = 7.5 * 60.0 * scale

func _source_runtime_position(level: LevelState, source_x: float, source_y: float, source_width: float, source_height: float) -> Vector2:
	var terrain: Dictionary = _source_manifest.get("terrain", {})
	var source_spawn_x := float(terrain.get("spawn_x", 96))
	var source_spawn_y := float(terrain.get("spawn_y", 655))
	var scale := _source_runtime_scale(source_width, source_height, level)
	return Vector2(
		clampf(180.0 + (source_x - source_spawn_x) * scale, 120.0, level.max_x - 120.0),
		clampf(level.spawn_y + (source_y - source_spawn_y) * scale, 48.0, level.max_y - 24.0)
	)

func _source_runtime_scale(source_width: float, source_height: float, level: LevelState) -> float:
	return clampf(minf((level.max_x - 360.0) / source_width, (level.max_y - 120.0) / source_height), 0.06, 0.14)

func _source_entity_extent(value: Variant, source_width: float, source_height: float, level: LevelState) -> float:
	return maxf(32.0, float(_to_int_field(value)) * 8.0 * _source_runtime_scale(source_width, source_height, level))

func _to_int_field(value: Variant) -> int:
	return int(str(value).strip_edges())

func _apply_source_terrain(level: LevelState, source_width: float, source_height: float) -> void:
	SOURCE_TERRAIN_LOADER.apply(level, _source_manifest.get("terrain", {}), source_width, source_height)

static func _source_surface_at(terrain: Dictionary, source_x: int, source_height: int, collision_layer: int) -> int:
	return SOURCE_TERRAIN_LOADER.sample_surface(terrain, source_x, source_height, collision_layer)

func _source_interactable_type(kind: String) -> int:
	return SOURCE_ENTITY_CATALOG._source_interactable_type(kind)

func _source_gravity_kind(kind: String) -> int:
	return SOURCE_ENTITY_CATALOG._source_gravity_kind(kind)

func _source_spring_variant(kind: String) -> int:
	return SOURCE_ENTITY_CATALOG._source_spring_variant(kind)

func _source_enemy_type(kind: String) -> int:
	return SOURCE_ENTITY_CATALOG._source_enemy_type(kind)

func _source_item_kind(kind: String) -> int:
	return SOURCE_ENTITY_CATALOG._source_item_kind(kind)

func _configure_source_enemy(entity: EntityState, kind: String, row: Dictionary) -> void:
	SOURCE_ENEMY_CONFIGURATOR.configure(entity, kind, row)
func music_entry_duration(is_pipe: bool, kind: int) -> float:
	var frames: Array = [69, 69, 77, 77, 63, 74, 74, 80, 80] if is_pipe else [77, 86, 74]
	var index := clampi(kind, 0, frames.size() - 1)
	return float(frames[index]) / 60.0
