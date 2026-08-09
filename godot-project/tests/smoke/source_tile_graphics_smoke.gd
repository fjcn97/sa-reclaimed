extends SceneTree

const TILE_GRAPHICS := preload("res://scripts/core/SourceTileGraphics.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bytes := PackedByteArray([0x34, 0x12, 0xFF])
	_check(TILE_GRAPHICS.read_u16(bytes, 0) == 0x1234, "Tile graphics reads little-endian words")
	_check(TILE_GRAPHICS.read_u16(bytes, 2) == 0, "Tile graphics rejects incomplete words")

	var atlas := Image.create(8, 16, false, Image.FORMAT_RGBA8)
	atlas.fill(Color.BLACK)
	atlas.set_pixel(0, 0, Color.RED)
	atlas.set_pixel(7, 7, Color.GREEN)
	atlas.set_pixel(0, 8, Color.BLUE)
	var tile := TILE_GRAPHICS.read_atlas_tile(atlas, 0)
	_check(tile != null and tile.get_pixel(0, 0).is_equal_approx(Color.RED), "Tile graphics reads an atlas tile")
	_check(tile != null and tile.get_pixel(7, 7).is_equal_approx(Color.GREEN), "Tile graphics preserves tile pixels")
	var flipped := TILE_GRAPHICS.read_atlas_tile(atlas, 0, true, true)
	_check(flipped != null and flipped.get_pixel(0, 0).is_equal_approx(Color.GREEN), "Tile graphics applies both flips")
	_check(TILE_GRAPHICS.read_atlas_tile(atlas, 2) == null, "Tile graphics rejects missing atlas tiles")

	var target := Image.create(16, 8, false, Image.FORMAT_RGBA8)
	target.fill(Color.BLACK)
	_check(TILE_GRAPHICS.blit_atlas_tile(target, atlas, 1, Vector2i(8, 0)), "Tile graphics blits a valid tile")
	_check(target.get_pixel(8, 0).is_equal_approx(Color.BLUE), "Tile graphics blit writes to the requested destination")
	_check(not TILE_GRAPHICS.blit_atlas_tile(target, atlas, 2, Vector2i.ZERO), "Tile graphics reports an invalid blit")

	print("SOURCE_TILE_GRAPHICS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SOURCE_TILE_GRAPHICS_FAIL: " + label)
