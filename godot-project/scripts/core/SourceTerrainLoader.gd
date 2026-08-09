extends RefCounted
class_name SourceTerrainLoader

const SOURCE_MAP_LOADER := preload("res://scripts/SourceMapLoader.gd")
const PLATFORM_BUILDER := preload("res://scripts/core/PlatformBuilder.gd")

static func apply(level: LevelState, terrain: Dictionary, source_width: float, source_height: float) -> void:
	if not bool(terrain.get("valid", false)):
		return
	_apply_layer(level, terrain, source_width, source_height, 0)
	_apply_layer(level, terrain, source_width, source_height, 1)

static func _apply_layer(level: LevelState, terrain: Dictionary, source_width: float, source_height: float, collision_layer: int) -> void:
	var sample_step := 16
	var segment_start := -1
	var segment_last_x := 0
	var segment_start_y := 0
	var segment_end_y := 0
	for source_x in range(0, int(source_width), sample_step):
		var surface := sample_surface(terrain, source_x, int(source_height), collision_layer)
		if surface < 0:
			if segment_start >= 0:
				_add_platform(level, terrain, segment_start, segment_last_x, segment_start_y, segment_end_y, source_width, source_height, collision_layer)
				segment_start = -1
			continue
		var runtime_position := _runtime_position(level, terrain, source_x, surface, source_width, source_height)
		if segment_start < 0 or absf(runtime_position.y - _runtime_position(level, terrain, segment_start, segment_start_y, source_width, source_height).y) > 22.0:
			if segment_start >= 0:
				_add_platform(level, terrain, segment_start, segment_last_x, segment_start_y, segment_end_y, source_width, source_height, collision_layer)
			segment_start = source_x
			segment_start_y = surface
			segment_last_x = source_x
		segment_end_y = surface
		segment_last_x = source_x
	if segment_start >= 0:
		_add_platform(level, terrain, segment_start, segment_last_x, segment_start_y, segment_end_y, source_width, source_height, collision_layer)

static func sample_surface(terrain: Dictionary, source_x: int, source_height: int, collision_layer: int) -> int:
	var best_surface := -1
	for source_y in range(source_height - 8, -1, -8):
		var sample: Dictionary = SOURCE_MAP_LOADER.sample_floor(terrain, source_x, source_y, collision_layer)
		if bool(sample.get("solid", false)):
			best_surface = maxi(best_surface, int(sample.get("surface_y", source_y)))
		if best_surface >= 0 and source_y + 16 <= best_surface:
			break
	return best_surface

static func _add_platform(level: LevelState, terrain: Dictionary, source_start_x: int, source_end_x: int, source_start_y: float, source_end_y: float, source_width: float, source_height: float, collision_layer: int) -> void:
	var start_position := _runtime_position(level, terrain, source_start_x, source_start_y, source_width, source_height)
	var end_position := _runtime_position(level, terrain, source_end_x + 16, source_end_y, source_width, source_height)
	if end_position.x - start_position.x >= 18.0:
		PLATFORM_BUILDER.add_sloped_platform(level, start_position.x, start_position.y + 12.0, end_position.x, end_position.y + 12.0, 12.0, collision_layer)

static func _runtime_position(level: LevelState, terrain: Dictionary, source_x: float, source_y: float, source_width: float, source_height: float) -> Vector2:
	var source_spawn_x := float(terrain.get("spawn_x", 96))
	var source_spawn_y := float(terrain.get("spawn_y", 655))
	var scale := clampf(minf((level.max_x - 360.0) / source_width, (level.max_y - 120.0) / source_height), 0.06, 0.14)
	return Vector2(clampf(180.0 + (source_x - source_spawn_x) * scale, 120.0, level.max_x - 120.0), clampf(level.spawn_y + (source_y - source_spawn_y) * scale, 48.0, level.max_y - 24.0))
