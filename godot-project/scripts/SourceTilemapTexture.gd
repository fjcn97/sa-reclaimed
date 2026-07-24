# Rebuilds a GBA 30-column tilemap from the extracted source graphics.
class_name SourceTilemapTexture
extends RefCounted

static func compose(source: String) -> Texture2D:
	var base := ProjectSettings.globalize_path("res://../data/sa2/tilemaps/%s" % source)
	var tiles := Image.new()
	if tiles.load(base.path_join("tiles.png")) != OK:
		return null
	var map_file := FileAccess.open(base.path_join("tilemap.tilemap2"), FileAccess.READ)
	if map_file == null:
		return null
	var tilemap := map_file.get_buffer(map_file.get_length())
	var map_width := 30
	var map_height := int(tilemap.size() / 2 / map_width)
	var image := Image.create(map_width * 8, map_height * 8, false, Image.FORMAT_RGBA8)
	for map_y in range(map_height):
		for map_x in range(map_width):
			var offset := (map_y * map_width + map_x) * 2
			var entry := int(tilemap[offset]) | (int(tilemap[offset + 1]) << 8)
			var tile_index := entry & 0x03ff
			var flip_x := (entry & 0x0400) != 0
			var flip_y := (entry & 0x0800) != 0
			for tile_y in range(8):
				for tile_x in range(8):
					var source_x := 7 - tile_x if flip_x else tile_x
					var source_y := 7 - tile_y if flip_y else tile_y
					var source_y_atlas := tile_index * 8 + source_y
					if source_y_atlas < tiles.get_height():
						image.set_pixel(map_x * 8 + tile_x, map_y * 8 + tile_y, tiles.get_pixel(source_x, source_y_atlas))
	return ImageTexture.create_from_image(image)
