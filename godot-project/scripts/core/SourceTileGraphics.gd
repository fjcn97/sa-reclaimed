class_name SourceTileGraphics

extends RefCounted

const TILE_SIZE := 8

static func read_u16(bytes: PackedByteArray, offset: int) -> int:
	if offset < 0 or offset + 1 >= bytes.size():
		return 0
	return int(bytes[offset]) | (int(bytes[offset + 1]) << 8)

static func read_atlas_tile(atlas: Image, tile_index: int, flip_x: bool = false, flip_y: bool = false) -> Image:
	if atlas == null or atlas.is_empty():
		return null
	var tile_y := tile_index * TILE_SIZE
	if tile_index < 0 or tile_y + TILE_SIZE > atlas.get_height():
		return null
	var tile := atlas.get_region(Rect2i(0, tile_y, TILE_SIZE, TILE_SIZE))
	tile.convert(Image.FORMAT_RGBA8)
	if flip_x:
		tile.flip_x()
	if flip_y:
		tile.flip_y()
	return tile

static func blit_atlas_tile(target: Image, atlas: Image, tile_index: int, destination: Vector2i, flip_x: bool = false, flip_y: bool = false) -> bool:
	var tile := read_atlas_tile(atlas, tile_index, flip_x, flip_y)
	if tile == null:
		return false
	target.blit_rect(tile, Rect2i(0, 0, TILE_SIZE, TILE_SIZE), destination)
	return true
