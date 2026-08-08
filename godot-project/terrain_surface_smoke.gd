extends SceneTree

const BRIDGE := preload("res://scripts/CoreBridge.gd")
const LOADER := preload("res://scripts/SourceMapLoader.gd")

var checks := 0
var failed := false

func _init() -> void:
	var bridge: Node = BRIDGE.new()
	get_root().add_child(bridge)
	for boss_mode in [false, true]:
		for level_id in range(16 if not boss_mode else 7):
			var manifest: Dictionary = LOADER.load_level(level_id, boss_mode)
			var terrain: Dictionary = manifest.get("terrain", {})
			var source_width := int(terrain.get("map_width", 0)) * 96
			var source_height := int(terrain.get("map_height", 0)) * 96
			if not bool(terrain.get("valid", false)):
				_check(false, "terrain is valid for %s course %d" % ["boss" if boss_mode else "zone", level_id])
				continue
			var sample_xs := [0, source_width / 4, source_width / 2, maxi(0, source_width - 16)]
			for sample_x in sample_xs:
				for layer in [0, 1]:
					var expected: int = _naive_surface(terrain, int(sample_x), source_height, layer)
					var actual: int = bridge._source_surface_at(terrain, int(sample_x), source_height, layer)
					_check(actual == expected, "surface equivalence at %s/%d x%d layer%d expected=%d actual=%d" % ["boss" if boss_mode else "zone", level_id, sample_x, layer, expected, actual])
	print("TERRAIN_SURFACE_CHECKS=%d" % checks)
	bridge.queue_free()
	quit(1 if failed else 0)

func _naive_surface(terrain: Dictionary, source_x: int, source_height: int, layer: int) -> int:
	var best_surface := -1
	for source_y in range(0, source_height, 8):
		var sample: Dictionary = LOADER.sample_floor(terrain, source_x, source_y, layer)
		if bool(sample.get("solid", false)):
			best_surface = maxi(best_surface, int(sample.get("surface_y", source_y)))
	return best_surface

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TERRAIN_SURFACE_FAIL: " + label)
