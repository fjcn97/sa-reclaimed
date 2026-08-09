extends RefCounted
class_name SourceMetatileCache

const SOURCE_DATA_PATHS := preload("res://scripts/core/SourceDataPaths.gd")
const SOURCE_TILE_GRAPHICS := preload("res://scripts/core/SourceTileGraphics.gd")

var textures: Dictionary = {}
var atlas: Image = null

func clear() -> void:
	textures.clear()
	atlas = null

func build(manifest: Dictionary, terrain: Dictionary) -> void:
	clear()
	if not bool(terrain.get("valid", false)):
		return
	var atlas_path := SOURCE_DATA_PATHS.globalize(SOURCE_DATA_PATHS.foreground_root(manifest.get("zone", 0), manifest.get("act", 0)).path_join("tileset.png"))
	atlas = Image.load_from_file(atlas_path)
	if atlas == null or atlas.is_empty():
		return
	var map_width := int(terrain.get("map_width", 0))
	var map_height := int(terrain.get("map_height", 0))
	var needed: Dictionary = {}
	for map_bytes in [terrain.get("map_front", PackedByteArray()), terrain.get("map_back", PackedByteArray())]:
		for map_index in range(map_width * map_height):
			var metatile_index := SOURCE_TILE_GRAPHICS.read_u16(map_bytes, map_index * 2) & 0x03ff
			if metatile_index != 0:
				needed[metatile_index] = true
	for metatile_index in needed.keys():
		var image := Image.create(96, 96, false, Image.FORMAT_RGBA8)
		image.fill(Color(0.0, 0.0, 0.0, 0.0))
		for local_y in range(12):
			for local_x in range(12):
				var tile_value := SOURCE_TILE_GRAPHICS.read_u16(terrain.get("metatiles", PackedByteArray()), (int(metatile_index) * 144 + local_y * 12 + local_x) * 2)
				var tile_index := tile_value & 0x03ff
				SOURCE_TILE_GRAPHICS.blit_atlas_tile(
					image,
					atlas,
					tile_index,
					Vector2i(local_x * 8, local_y * 8),
					bool(tile_value & 0x0400),
					bool(tile_value & 0x0800)
				)
		textures[metatile_index] = ImageTexture.create_from_image(image)

func get_cached_count() -> int:
	return textures.size()
