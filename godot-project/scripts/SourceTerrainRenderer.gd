# Renders the extracted SA2 foreground metatiles in the runtime stage space.
extends Node2D

const SOURCE_TILE_GRAPHICS := preload("res://scripts/core/SourceTileGraphics.gd")

var _manifest: Dictionary = {}
var _terrain: Dictionary = {}
var _metatile_cache := SourceMetatileCache.new()
var _source_level_id := -1
var _scale := 0.1

func _ready() -> void:
	set_process(true)
	set_process_internal(true)

func _process(_delta: float) -> void:
	var core := get_node_or_null("/root/CoreBridge")
	if core == null:
		return
	var manifest: Dictionary = core.get_source_map_manifest()
	var level_id := int(manifest.get("level_id", -1)) if not manifest.is_empty() else -1
	if level_id != _source_level_id:
		_source_level_id = level_id
		_manifest = manifest
		_terrain = manifest.get("terrain", {}) if not manifest.is_empty() else {}
		_metatile_cache.clear()
		if bool(_terrain.get("valid", false)):
			_build_metatile_cache()
		queue_redraw()

func _draw() -> void:
	if _metatile_cache.textures.is_empty() or not bool(_terrain.get("valid", false)):
		return
	var map_width := int(_terrain.get("map_width", 0))
	var map_height := int(_terrain.get("map_height", 0))
	var source_spawn := Vector2(float(_terrain.get("spawn_x", 96)), float(_terrain.get("spawn_y", 655)))
	var source_width := maxf(1.0, float(map_width) * 96.0)
	var source_height := maxf(1.0, float(map_height) * 96.0)
	_scale = clampf(minf(2100.0 / source_width, 600.0 / source_height), 0.06, 0.14)
	for layer_name in ["map_back", "map_front"]:
		var map_bytes: PackedByteArray = _terrain.get(layer_name, PackedByteArray())
		for map_y in range(map_height):
			for map_x in range(map_width):
				var map_value := SOURCE_TILE_GRAPHICS.read_u16(map_bytes, (map_y * map_width + map_x) * 2)
				var metatile_index := map_value & 0x03ff
				if metatile_index == 0 or not _metatile_cache.textures.has(metatile_index):
					continue
				var source_pos := Vector2(map_x * 96.0, map_y * 96.0)
				var runtime_pos := Vector2(
					180.0 + (source_pos.x - source_spawn.x) * _scale,
					460.0 + (source_pos.y - source_spawn.y) * _scale
				)
				var texture: Texture2D = _metatile_cache.textures[metatile_index]
				draw_texture_rect(texture, Rect2(runtime_pos, Vector2(96.0, 96.0) * _scale), false, Color(1.0, 1.0, 1.0, 0.82))

func _build_metatile_cache() -> void:
	_metatile_cache.build(_manifest, _terrain)

func get_cached_metatile_count() -> int:
	return _metatile_cache.get_cached_count()
