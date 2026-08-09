extends SceneTree

const LOADER = preload("res://scripts/SourceMapLoader.gd")
const BRIDGE = preload("res://scripts/CoreBridge.gd")
const SPECIAL_INTERACTABLES := [
	"PLATFORM_CRUMBLING", "PLATFORM_SQUARE", "COMMON_THIN_PLATFORM",
	"PLATFORM_A", "PLATFORM_B", "SPEEDING_PLATFORM"
]

func _init() -> void:
	var bridge: Node = BRIDGE.new()
	get_root().add_child(bridge)
	var unsupported: Dictionary = {}
	var checked := 0
	var terrains_checked := 0
	for boss_mode in [false, true]:
		var limit := 16 if not boss_mode else 7
		for index in range(limit):
			var level_id := index if not boss_mode else index * 2
			var manifest: Dictionary = LOADER.load_level(level_id, boss_mode)
			var location := "%s/%s" % [manifest.zone, manifest.act]
			terrains_checked += 1
			if not bool(manifest.terrain.get("valid", false)):
				_register(unsupported, "terrain:%s" % location, location)
			for row in manifest.entities.get("interactables", []):
				checked += 1
				var kind := str(row.get("kind", ""))
				if kind in SPECIAL_INTERACTABLES or kind.begins_with("ARROW_PLATFORM") or bridge._source_interactable_type(kind) >= 0:
					continue
				_register(unsupported, "interactable:%s" % kind, location)
			for row in manifest.entities.get("enemies", []):
				checked += 1
				var enemy_kind := str(row.get("kind", ""))
				if bridge._source_enemy_type(enemy_kind) >= 0:
					continue
				_register(unsupported, "enemy:%s" % enemy_kind, location)
			for row in manifest.entities.get("itemboxes", []):
				checked += 1
				var item_kind := str(row.get("kind", ""))
				if bridge._source_item_kind(item_kind) >= 0:
					continue
				_register(unsupported, "itembox:%s" % item_kind, location)
	print("COVERAGE_ROWS=%d" % checked)
	print("COVERAGE_TERRAINS=%d" % terrains_checked)
	if unsupported.is_empty():
		print("COVERAGE_UNSUPPORTED=0")
		_finish(bridge, 0)
		return
	for key in unsupported.keys():
		print("UNSUPPORTED %s locations=%s" % [key, ",".join(unsupported[key])])
	print("COVERAGE_UNSUPPORTED=%d" % unsupported.size())
	_finish(bridge, 1)

func _finish(bridge: Node, exit_code: int) -> void:
	bridge.queue_free()
	call_deferred("_quit_after_cleanup", exit_code)

func _quit_after_cleanup(exit_code: int) -> void:
	quit(exit_code)

func _register(unsupported: Dictionary, key: String, location: String) -> void:
	if not unsupported.has(key):
		unsupported[key] = []
	if location not in unsupported[key]:
		unsupported[key].append(location)
