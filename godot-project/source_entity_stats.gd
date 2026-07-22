extends SceneTree

const LOADER = preload("res://scripts/SourceMapLoader.gd")

func _init() -> void:
	var failed := false
	# Cover every SourceMapLoader level route, including the final and extra maps.
	for level_id in range(16):
		var manifest: Dictionary = LOADER.load_level(level_id)
		failed = failed or not bool(manifest.valid)
		print("level=%d %s/%s regions=%dx%d objects=%d valid=%s" % [level_id, manifest.zone, manifest.act, manifest.region_width, manifest.region_height, manifest.entity_count, manifest.valid])
		for key in manifest.entities.keys():
			var rows: Array = manifest.entities[key]
			if rows.is_empty():
				continue
			var max_x := 0
			var max_y := 0
			for row in rows:
				max_x = maxi(max_x, int(row.world_x))
				max_y = maxi(max_y, int(row.world_y))
			print("  %s=%d max=(%d,%d)" % [key, rows.size(), max_x, max_y])
	for zone_index in range(1, 8):
		var boss_level_id := (zone_index - 1) * 2
		var boss_manifest: Dictionary = LOADER.load_level(boss_level_id, true)
		failed = failed or not bool(boss_manifest.valid)
		print("boss=zone_%d/act_boss regions=%dx%d objects=%d valid=%s" % [zone_index, boss_manifest.region_width, boss_manifest.region_height, boss_manifest.entity_count, boss_manifest.valid])
	quit(1 if failed else 0)
