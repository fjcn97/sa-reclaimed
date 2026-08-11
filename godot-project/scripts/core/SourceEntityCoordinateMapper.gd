class_name SourceEntityCoordinateMapper
extends RefCounted

## Converts source-map coordinates and field extents into runtime geometry.
static func runtime_position(source_manifest: Dictionary, level: LevelState, source_x: float, source_y: float, source_width: float, source_height: float) -> Vector2:
	var terrain: Dictionary = source_manifest.get("terrain", {})
	var source_spawn_x := float(terrain.get("spawn_x", 96))
	var source_spawn_y := float(terrain.get("spawn_y", 655))
	var scale := runtime_scale(source_width, source_height, level)
	return Vector2(
		clampf(180.0 + (source_x - source_spawn_x) * scale, 120.0, level.max_x - 120.0),
		clampf(level.spawn_y + (source_y - source_spawn_y) * scale, 48.0, level.max_y - 24.0)
	)

static func runtime_scale(source_width: float, source_height: float, level: LevelState) -> float:
	return clampf(minf((level.max_x - 360.0) / source_width, (level.max_y - 120.0) / source_height), 0.06, 0.14)

static func entity_extent(value: Variant, source_width: float, source_height: float, level: LevelState) -> float:
	return maxf(32.0, float(to_int_field(value)) * 8.0 * runtime_scale(source_width, source_height, level))

static func to_int_field(value: Variant) -> int:
	return int(str(value).strip_edges())
