# Renders the extracted SA2 foreground metatiles in the runtime stage space.
extends Node2D

var _manifest: Dictionary = {}
var _terrain: Dictionary = {}
var _metatile_textures: Dictionary = {}
var _source_level_id := -1
var _atlas: Image = null
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
		_metatile_textures.clear()
		_atlas = null
		if bool(_terrain.get("valid", false)):
			_build_metatile_cache()
		queue_redraw()

func _draw() -> void:
	if _metatile_textures.is_empty() or not bool(_terrain.get("valid", false)):
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
				var map_value := _read_u16(map_bytes, (map_y * map_width + map_x) * 2)
				var metatile_index := map_value & 0x03ff
				if metatile_index == 0 or not _metatile_textures.has(metatile_index):
					continue
				var source_pos := Vector2(map_x * 96.0, map_y * 96.0)
				var runtime_pos := Vector2(
					180.0 + (source_pos.x - source_spawn.x) * _scale,
					460.0 + (source_pos.y - source_spawn.y) * _scale
				)
				var texture: Texture2D = _metatile_textures[metatile_index]
				draw_texture_rect(texture, Rect2(runtime_pos, Vector2(96.0, 96.0) * _scale), false, Color(1.0, 1.0, 1.0, 0.82))

func _build_metatile_cache() -> void:
	var atlas_path := ProjectSettings.globalize_path("res://../data/sa2/maps/%s/%s/tilemaps/fg/tileset.png" % [_manifest.zone, _manifest.act])
	_atlas = Image.load_from_file(atlas_path)
	if _atlas == null or _atlas.is_empty():
		return
	var map_bytes: PackedByteArray = _terrain.get("map_front", PackedByteArray())
	var back_bytes: PackedByteArray = _terrain.get("map_back", PackedByteArray())
	var map_width := int(_terrain.get("map_width", 0))
	var map_height := int(_terrain.get("map_height", 0))
	var needed := {}
	for map_bytes_for_scan in [map_bytes, back_bytes]:
		for map_index in range(map_width * map_height):
			var metatile_index := _read_u16(map_bytes_for_scan, map_index * 2) & 0x03ff
			if metatile_index != 0:
				needed[metatile_index] = true
	for metatile_index in needed.keys():
		var image := Image.create(96, 96, false, Image.FORMAT_RGBA8)
		image.fill(Color(0.0, 0.0, 0.0, 0.0))
		for local_y in range(12):
			for local_x in range(12):
				var tile_value := _read_u16(_terrain.metatiles, (int(metatile_index) * 144 + local_y * 12 + local_x) * 2)
				var tile_index := tile_value & 0x03ff
				var tile_y := tile_index * 8
				if tile_y + 8 > _atlas.get_height():
					continue
				var tile_image := _atlas.get_region(Rect2i(0, tile_y, 8, 8))
				tile_image.convert(Image.FORMAT_RGBA8)
				if tile_value & 0x0400:
					tile_image.flip_x()
				if tile_value & 0x0800:
					tile_image.flip_y()
				image.blit_rect(tile_image, Rect2i(0, 0, 8, 8), Vector2i(local_x * 8, local_y * 8))
		_metatile_textures[metatile_index] = ImageTexture.create_from_image(image)

func _read_u16(bytes: PackedByteArray, offset: int) -> int:
	if offset < 0 or offset + 1 >= bytes.size():
		return 0
	return int(bytes[offset]) | (int(bytes[offset + 1]) << 8)

func get_cached_metatile_count() -> int:
	return _metatile_textures.size()
