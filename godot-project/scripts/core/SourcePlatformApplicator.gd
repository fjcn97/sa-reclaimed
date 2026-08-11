class_name SourcePlatformApplicator
extends RefCounted

## Routes source interactable records that materialize as platforms instead of entities.
const PLATFORM_BUILDER := preload("res://scripts/core/PlatformBuilder.gd")
const COORDINATE_MAPPER := preload("res://scripts/core/SourceEntityCoordinateMapper.gd")

static func apply(source_manifest: Dictionary, level: LevelState, row: Dictionary, kind: String, source_width: float, source_height: float) -> bool:
	match kind:
		"PLATFORM_CRUMBLING":
			_add_crumbling(source_manifest, level, row, source_width, source_height)
		"PLATFORM_SQUARE":
			_add_square(source_manifest, level, row, source_width, source_height)
		"COMMON_THIN_PLATFORM":
			_add_thin(source_manifest, level, row, source_width, source_height)
		"PLATFORM_A":
			_add_platform_a(source_manifest, level, row, source_width, source_height)
		"PLATFORM_B":
			_add_platform_b(source_manifest, level, row, source_width, source_height)
		"SPEEDING_PLATFORM":
			_add_speeding(source_manifest, level, row, source_width, source_height)
		_:
			if kind.begins_with("ARROW_PLATFORM"):
				_add_arrow(source_manifest, level, row, kind, source_width, source_height)
			else:
				return false
	return true

static func _add_platform_a(manifest: Dictionary, level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _scale(source_width, source_height, level)
	var position := _position(manifest, level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	var horizontal := _field(fields[7]) > _field(fields[8])
	var amplitude_source := _field(fields[7]) if horizontal else _field(fields[8])
	var direction_field := _field(fields[5]) if horizontal else _field(fields[6])
	PLATFORM_BUILDER.add_moving_platform(level, position.x - 24.0, position.y + 12.0, 48.0, 12.0, 0 if horizontal else 1, absf(float(amplitude_source)) * 8.0 * scale, 4.0 * TAU / 256.0 * 60.0, PI if direction_field < 0 else 0.0)

static func _add_platform_b(manifest: Dictionary, level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var position := _position(manifest, level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	PLATFORM_BUILDER.add_platform(level, position.x - 24.0, position.y + 12.0, 48.0, 12.0)

static func _add_speeding(manifest: Dictionary, level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var start := _position(manifest, level, base_x + 32.0, base_y + 18.0, source_width, source_height)
	var first_target := _position(manifest, level, base_x + 590.0, base_y + 576.0, source_width, source_height)
	var final_target := _position(manifest, level, base_x + 814.0, base_y + 576.0, source_width, source_height)
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

static func _add_crumbling(manifest: Dictionary, level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _scale(source_width, source_height, level)
	var position := _position(manifest, level, float(row.get("world_x", 0)) + float(_field(fields[5])) * 8.0, float(row.get("world_y", 0)) + float(_field(fields[6])) * 8.0, source_width, source_height)
	var width := maxf(32.0, float(_field(fields[7])) * 8.0 * scale)
	var thickness := maxf(8.0, float(_field(fields[8])) * 8.0 * scale)
	PLATFORM_BUILDER.add_crumbling_platform(level, position.x, position.y + thickness, width, thickness, 31.0 / 60.0)

static func _add_square(manifest: Dictionary, level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _scale(source_width, source_height, level)
	var position := _position(manifest, level, float(row.get("world_x", 0)) + float(_field(fields[5])) * 8.0, float(row.get("world_y", 0)) + float(_field(fields[6])) * 8.0, source_width, source_height)
	var horizontal_extent := maxi(0, _field(fields[7]))
	var vertical_extent := maxi(0, _field(fields[8]))
	PLATFORM_BUILDER.add_moving_platform(level, position.x, position.y + 16.0, 32.0, 16.0, 0 if horizontal_extent > vertical_extent else 1, maxf(16.0, float(maxi(horizontal_extent, vertical_extent)) * 8.0 * scale), 3.75, PI if _field(fields[5]) < 0 or _field(fields[6]) < 0 else 0.0)

static func _add_thin(manifest: Dictionary, level: LevelState, row: Dictionary, source_width: float, source_height: float) -> void:
	var position := _position(manifest, level, float(row.get("world_x", 0)), float(row.get("world_y", 0)), source_width, source_height)
	PLATFORM_BUILDER.add_platform(level, position.x, position.y + 8.0, 32.0, 8.0)

static func _add_arrow(manifest: Dictionary, level: LevelState, row: Dictionary, kind: String, source_width: float, source_height: float) -> void:
	var fields: Array = row.get("fields", [])
	if fields.size() <= 8:
		return
	var scale := _scale(source_width, source_height, level)
	var base_x := float(row.get("world_x", 0))
	var base_y := float(row.get("world_y", 0))
	var width_offset := float(_field(fields[5])) * 8.0 + 24.0
	var height_offset := float(_field(fields[6])) * 8.0 + 24.0
	var target_x := float(_field(fields[7])) * 8.0 + width_offset - 24.0
	var target_y := float(_field(fields[8])) * 8.0 + height_offset - 24.0
	var current_offset := Vector2(width_offset, height_offset)
	var target_offset := Vector2(target_x, target_y)
	if kind.ends_with("LEFT"):
		current_offset.x = target_x
		target_offset.x = width_offset
	elif not kind.ends_with("RIGHT"):
		current_offset.y = target_y
		target_offset.y = height_offset
	var position := _position(manifest, level, base_x + current_offset.x, base_y + current_offset.y, source_width, source_height)
	var target := _position(manifest, level, base_x + target_offset.x, base_y + target_offset.y, source_width, source_height)
	PLATFORM_BUILDER.add_platform(level, position.x, position.y + 12.0, 32.0, 12.0)
	var platform: PlatformState = level.platforms.back()
	platform.arrow_mode = true
	platform.arrow_target_x = target.x
	platform.arrow_target_y = target.y
	platform.arrow_speed = 7.5 * 60.0 * scale

static func _position(manifest: Dictionary, level: LevelState, source_x: float, source_y: float, source_width: float, source_height: float) -> Vector2:
	return COORDINATE_MAPPER.runtime_position(manifest, level, source_x, source_y, source_width, source_height)

static func _scale(source_width: float, source_height: float, level: LevelState) -> float:
	return COORDINATE_MAPPER.runtime_scale(source_width, source_height, level)

static func _field(value: Variant) -> int:
	return COORDINATE_MAPPER.to_int_field(value)
