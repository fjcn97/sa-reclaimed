# Parses the extracted SA2 map entity CSVs without coupling them to gameplay.
class_name SourceMapLoader
extends RefCounted

const CAMERA_REGION_WIDTH := 256
const TILE_WIDTH := 8
const ENTITY_FILES := ["rings", "interactables", "enemies", "itemboxes"]

static func load_level(level_id: int, boss_mode: bool = false) -> Dictionary:
	var location := _level_location(level_id, boss_mode)
	var manifest := {
		"level_id": level_id,
		"zone": location.zone,
		"act": location.act,
		"source_path": "res://../data/sa2/maps/%s/%s" % [location.zone, location.act],
		"region_width": 0,
		"region_height": 0,
		"entities": {},
		"entity_count": 0,
		"valid": true,
		"errors": [],
	}
	manifest["terrain"] = _read_terrain(location.zone, location.act)
	if not manifest.terrain.valid:
		manifest.valid = false
		manifest.errors.append(manifest.terrain.error)
	for file_stem in ENTITY_FILES:
		var parsed := _read_entity_file(location.zone, location.act, file_stem)
		if not parsed.valid:
			manifest.valid = false
			manifest.errors.append(parsed.error)
			manifest.entities[file_stem] = []
			continue
		manifest.region_width = maxi(manifest.region_width, parsed.region_width)
		manifest.region_height = maxi(manifest.region_height, parsed.region_height)
		manifest.entities[file_stem] = parsed.rows
		manifest.entity_count += parsed.rows.size()
	return manifest

static func sample_floor(terrain: Dictionary, world_x: int, world_y: int, layer: int = 0) -> Dictionary:
	if not bool(terrain.get("valid", false)):
		return {"solid": false, "surface_y": world_y, "height": 0, "tile": -1}
	var x := clampi(world_x, 0, int(terrain.map_width) * 96 - 1)
	var y := clampi(world_y, 0, int(terrain.map_height) * 96 - 1)
	var tile_x := x / 8
	var tile_y := y / 8
	var map_layer: PackedByteArray = terrain.map_front if layer == 0 else terrain.map_back
	var map_offset := ((tile_y / 12) * int(terrain.map_width) + (tile_x / 12)) * 2
	var metatile_index := _read_u16(map_layer, map_offset) & 0x03ff
	var metatile_offset := (metatile_index * 144 + (tile_y % 12) * 12 + (tile_x % 12)) * 2
	var tile := _read_u16(terrain.metatiles, metatile_offset)
	var tile_index := tile & 0x03ff
	var sample_y := y % 8
	if tile & 0x0800:
		sample_y = 7 - sample_y
	var raw_height := int(terrain.height_map[tile_index * 8 + sample_y]) & 0x0f
	var height := raw_height - 16 if raw_height & 0x08 else raw_height
	if height == -8:
		height = 8
	if tile & 0x0400 and height != 0 and height != 8:
		height = height - 8 if height > 0 else height + 8
	return {
		"solid": height != 0,
		"surface_y": tile_y * 8 + (8 - height) if height != 0 else y,
		"height": height,
		"tile": tile_index,
	}

static func _level_location(level_id: int, boss_mode: bool = false) -> Dictionary:
	if boss_mode and level_id < 14:
		var boss_zone_index := clampi(int(level_id / 2) + 1, 1, 7)
		return {"zone": "zone_%d" % boss_zone_index, "act": "act_boss"}
	if level_id >= 14:
		return {"zone": "zone_final", "act": "act_xx" if level_id == 14 else "act_ta53"}
	var zone_index := clampi(int(level_id / 2) + 1, 1, 7)
	var act_index := 1 if level_id % 2 == 0 else 2
	return {"zone": "zone_%d" % zone_index, "act": "act_%d" % act_index}

static func _read_entity_file(zone: String, act: String, file_stem: String) -> Dictionary:
	var path := ProjectSettings.globalize_path("res://../data/sa2/maps/%s/%s/entities/%s.csv" % [zone, act, file_stem])
	if not FileAccess.file_exists(path):
		return {"valid": false, "error": "Missing source map file: %s" % path}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"valid": false, "error": "Unable to open source map file: %s" % path}
	var lines := file.get_as_text().split("\n", false)
	if lines.is_empty():
		return {"valid": false, "error": "Empty source map file: %s" % path}
	var header: PackedStringArray = lines[0].strip_edges().split(",")
	if header.size() < 4 or header[0] != "Adv2":
		return {"valid": false, "error": "Invalid source map header: %s" % path}
	var rows: Array = []
	for line in lines.slice(1):
		var fields: PackedStringArray = line.strip_edges().split(",")
		if fields.size() < 4 or fields[0].is_empty():
			continue
		var region_x := _to_int(fields[0])
		var region_y := _to_int(fields[1])
		var local_x := _to_int(fields[2])
		var local_y := _to_int(fields[3])
		var row := {
			"region_x": region_x,
			"region_y": region_y,
			"local_x": local_x,
			"local_y": local_y,
			"world_x": region_x * CAMERA_REGION_WIDTH + local_x * TILE_WIDTH,
			"world_y": region_y * CAMERA_REGION_WIDTH + local_y * TILE_WIDTH,
			"kind": fields[4] if fields.size() > 4 else "",
			"fields": Array(fields),
		}
		rows.append(row)
	return {
		"valid": true,
		"region_width": _to_int(header[2]),
		"region_height": _to_int(header[3]),
		"rows": rows,
	}

static func _read_terrain(zone: String, act: String) -> Dictionary:
	var base := ProjectSettings.globalize_path("res://../data/sa2/maps/%s/%s/tilemaps/fg" % [zone, act])
	var metadata_path := base.path_join("metadata.txt")
	var metadata := ""
	if FileAccess.file_exists(metadata_path):
		var metadata_file := FileAccess.open(metadata_path, FileAccess.READ)
		metadata = metadata_file.get_as_text() if metadata_file else ""
	var map_dim := _metadata_pair(metadata, "map_dim")
	var map_front := _read_binary(base.path_join("map_front.bin"))
	var map_back := _read_binary(base.path_join("map_back.bin"))
	var metatiles := _read_binary(base.path_join("metatiles.tilemap2"))
	var height_map := _read_binary(base.path_join("height_map.coll"))
	var flags := _read_binary(base.path_join("flags.coll"))
	var tile_rotation := _read_binary(base.path_join("tile_rot.coll"))
	var valid := map_dim.size() == 2 and not map_front.is_empty() and not map_back.is_empty() and not metatiles.is_empty() and not height_map.is_empty()
	return {
		"valid": valid,
		"error": "Missing source terrain data: %s" % base if not valid else "",
		"map_width": map_dim[0] if map_dim.size() == 2 else 0,
		"map_height": map_dim[1] if map_dim.size() == 2 else 0,
		"spawn_x": _metadata_pair(metadata, "spawn_pos")[0] if _metadata_pair(metadata, "spawn_pos").size() == 2 else 96,
		"spawn_y": _metadata_pair(metadata, "spawn_pos")[1] if _metadata_pair(metadata, "spawn_pos").size() == 2 else 655,
		"map_front": map_front,
		"map_back": map_back,
		"metatiles": metatiles,
		"height_map": height_map,
		"flags": flags,
		"tile_rotation": tile_rotation,
	}

static func _metadata_pair(metadata: String, key: String) -> Array:
	for line in metadata.split("\n"):
		if not line.strip_edges().begins_with(key):
			continue
		var values := line.get_slice("=", 1).strip_edges().trim_prefix("{").trim_suffix("}").split(",")
		if values.size() >= 2:
			return [_to_int(values[0]), _to_int(values[1])]
	return []

static func _read_binary(path: String) -> PackedByteArray:
	if not FileAccess.file_exists(path):
		return PackedByteArray()
	var file := FileAccess.open(path, FileAccess.READ)
	return file.get_buffer(file.get_length()) if file else PackedByteArray()

static func _read_u16(bytes: PackedByteArray, offset: int) -> int:
	if offset < 0 or offset + 1 >= bytes.size():
		return 0
	return int(bytes[offset]) | (int(bytes[offset + 1]) << 8)

static func _to_int(value: String) -> int:
	return int(value.strip_edges())
