extends SceneTree

const LOADER = preload("res://scripts/SourceMapLoader.gd")

func _init() -> void:
	var manifest: Dictionary = LOADER.load_level(0)
	for key in manifest.entities.keys():
		var kinds := {}
		for row in manifest.entities[key]:
			var kind := str(row.kind)
			kinds[kind] = int(kinds.get(kind, 0)) + 1
		print(key, ": ", kinds)
	quit()
