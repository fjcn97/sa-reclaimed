# Rebuilds a GBA 30-column tilemap from the extracted source graphics.
class_name SourceTilemapTexture
extends RefCounted

const SOURCE_DATA_PATHS := preload("res://scripts/core/SourceDataPaths.gd")
const SOURCE_TILE_GRAPHICS := preload("res://scripts/core/SourceTileGraphics.gd")

static func compose(source: String, map_width: int = 30, map_entry_bytes: int = 2) -> Texture2D:
	var base := SOURCE_DATA_PATHS.globalize(SOURCE_DATA_PATHS.tilemap_root(source))
	var tiles := Image.new()
	if tiles.load(base.path_join("tiles.png")) != OK:
		return null
	var map_file := FileAccess.open(base.path_join("tilemap.tilemap2"), FileAccess.READ)
	if map_file == null:
		return null
	var tilemap := map_file.get_buffer(map_file.get_length())
	map_width = maxi(map_width, 1)
	map_entry_bytes = 1 if map_entry_bytes == 1 else 2
	var map_height := int(tilemap.size() / map_entry_bytes / map_width)
	var image := Image.create(map_width * 8, map_height * 8, false, Image.FORMAT_RGBA8)
	for map_y in range(map_height):
		for map_x in range(map_width):
			var offset := (map_y * map_width + map_x) * map_entry_bytes
			var entry := int(tilemap[offset])
			if map_entry_bytes == 2:
				entry |= int(tilemap[offset + 1]) << 8
			var tile_index := entry & 0x03ff
			SOURCE_TILE_GRAPHICS.blit_atlas_tile(
				image,
				tiles,
				tile_index,
				Vector2i(map_x * 8, map_y * 8),
				bool(entry & 0x0400),
				bool(entry & 0x0800)
			)
	return ImageTexture.create_from_image(image)
