class_name SourceDataPaths
extends RefCounted

const ROOT_SETTING := "sa_reclaimed/source_data_root"
const DEFAULT_ROOT := "res://../data"

static func root() -> String:
	var configured := str(ProjectSettings.get_setting(ROOT_SETTING, DEFAULT_ROOT)).strip_edges()
	return configured if not configured.is_empty() else DEFAULT_ROOT

static func map_root(zone: String, act: String) -> String:
	return root().path_join("sa2/maps").path_join(zone).path_join(act)

static func entity_file(zone: String, act: String, file_stem: String) -> String:
	return map_root(zone, act).path_join("entities").path_join("%s.csv" % file_stem)

static func foreground_root(zone: String, act: String) -> String:
	return map_root(zone, act).path_join("tilemaps/fg")

static func background_root(zone: String, act: String) -> String:
	return map_root(zone, act).path_join("tilemaps/bg")

static func tilemap_root(source: String) -> String:
	return root().path_join("sa2/tilemaps").path_join(source)

static func globalize(path: String) -> String:
	return ProjectSettings.globalize_path(path)
