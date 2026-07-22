extends SceneTree

const LOADER = preload("res://scripts/SourceMapLoader.gd")
const BRIDGE = preload("res://scripts/CoreBridge.gd")
const SPECIAL_INTERACTABLES := [
	"PLATFORM_CRUMBLING", "PLATFORM_SQUARE", "COMMON_THIN_PLATFORM",
	"PLATFORM_A", "PLATFORM_B", "SPEEDING_PLATFORM"
]

func _init() -> void:
	var bridge: Node = BRIDGE.new()
	var unsupported: Dictionary = {}
	var checked := 0
	for boss_mode in [false, true]:
		var limit := 16 if not boss_mode else 7
		for index in range(limit):
			var level_id := index if not boss_mode else index * 2
			var manifest: Dictionary = LOADER.load_level(level_id, boss_mode)
			var location := "%s/%s" % [manifest.zone, manifest.act]
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
	if unsupported.is_empty():
		print("COVERAGE_UNSUPPORTED=0")
		quit(0)
	for key in unsupported.keys():
		print("UNSUPPORTED %s locations=%s" % [key, ",".join(unsupported[key])])
	print("COVERAGE_UNSUPPORTED=%d" % unsupported.size())
	quit(1)

func _register(unsupported: Dictionary, key: String, location: String) -> void:
	if not unsupported.has(key):
		unsupported[key] = []
	if location not in unsupported[key]:
		unsupported[key].append(location)
