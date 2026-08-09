extends SceneTree

var checks: int = 0
var failed: bool = false

const SOURCE_DATA_PATHS := preload("res://scripts/core/SourceDataPaths.gd")

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var configured := str(ProjectSettings.get_setting(SOURCE_DATA_PATHS.ROOT_SETTING, ""))
	_check(SOURCE_DATA_PATHS.root() == configured, "project setting controls the source-data root")
	_check(SOURCE_DATA_PATHS.map_root("zone_1", "act_1").ends_with("sa2/maps/zone_1/act_1"), "map paths use the centralized root")
	_check(SOURCE_DATA_PATHS.entity_file("zone_1", "act_1", "rings").ends_with("entities/rings.csv"), "entity paths use the centralized map path")
	_check(SOURCE_DATA_PATHS.foreground_root("zone_1", "act_1").ends_with("tilemaps/fg"), "foreground paths are centralized")
	_check(SOURCE_DATA_PATHS.background_root("zone_1", "act_1").ends_with("tilemaps/bg"), "background paths are centralized")
	_check(SOURCE_DATA_PATHS.tilemap_root("menu").ends_with("sa2/tilemaps/menu"), "standalone tilemap paths are centralized")
	ProjectSettings.set_setting(SOURCE_DATA_PATHS.ROOT_SETTING, "res://custom-source-data")
	_check(SOURCE_DATA_PATHS.root() == "res://custom-source-data", "source-data root can be overridden")
	_check(SOURCE_DATA_PATHS.map_root("zone_x", "act_y") == "res://custom-source-data/sa2/maps/zone_x/act_y", "overridden roots propagate to map paths")
	ProjectSettings.set_setting(SOURCE_DATA_PATHS.ROOT_SETTING, configured)
	print("SOURCE_DATA_PATHS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SOURCE_DATA_PATHS_FAIL: " + label)
