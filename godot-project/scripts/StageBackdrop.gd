# StageBackdrop.gd
# Draws a simple Sonic-style prototype backdrop and ground plane.
extends Node2D
class_name StageBackdrop

var _time: float = 0.0
var _source_bg_texture: Texture2D = null
var _source_bg_level_id := -1
const BACKGROUND_PROFILE := preload("res://scripts/SourceBackgroundProfile.gd")

func _ready() -> void:
	set_process(true)
	queue_redraw()

func _process(delta: float) -> void:
	_time += delta
	var manifest: Dictionary = CoreBridge.get_source_map_manifest()
	var level_id := int(manifest.get("level_id", -1)) if not manifest.is_empty() else -1
	if level_id != _source_bg_level_id:
		_source_bg_level_id = level_id
		_source_bg_texture = _build_source_background(manifest)
	queue_redraw()

func _draw() -> void:
	var profile := CoreBridge.get_stage_backdrop_profile()
	var sky: Color = profile.get("sky", Color(0.06, 0.11, 0.22))
	var sky_mid: Color = profile.get("sky_mid", Color(0.10, 0.21, 0.39))
	var sky_high: Color = profile.get("sky_high", Color(0.16, 0.36, 0.62))
	var sun: Color = profile.get("sun", Color(0.98, 0.86, 0.45, 0.35))
	var ground: Color = profile.get("ground", Color(0.16, 0.12, 0.08))
	var grass: Color = profile.get("grass", Color(0.18, 0.48, 0.18))
	var hills: Array = profile.get("hills", [])

	draw_rect(Rect2(-2000.0, -2000.0, 6000.0, 2600.0), sky)
	draw_circle(Vector2(980.0 + sin(_time * 0.18) * 18.0, 160.0 + sin(_time * 0.12) * 6.0), 140.0, sun)
	draw_rect(Rect2(-2000.0, 0.0, 6000.0, 260.0), sky_mid)
	draw_rect(Rect2(-2000.0, 180.0, 6000.0, 140.0), sky_high)
	_draw_source_background()
	_draw_zone4_spotlights()

	_draw_drifting_cloud(Vector2(280.0, 140.0), 1.0, 7.0, 0.0)
	_draw_drifting_cloud(Vector2(840.0, 110.0), 1.4, 11.0, 0.8)
	_draw_drifting_cloud(Vector2(1480.0, 130.0), 1.1, 9.0, 1.7)
	_draw_drifting_cloud(Vector2(2080.0, 100.0), 1.5, 13.0, 2.6)
	_draw_drifting_cloud(Vector2(2480.0, 150.0), 0.85, 6.0, 1.2)

	draw_rect(Rect2(-2000.0, 460.0, 6000.0, 80.0), ground)
	draw_rect(Rect2(-2000.0, 452.0, 6000.0, 12.0), grass)
	draw_rect(Rect2(-2000.0, 540.0, 6000.0, 1200.0), Color(0.08, 0.07, 0.08))

	for platform in CoreBridge.get_platforms():
		if not platform.active:
			continue
		var platform_width: float = platform.x2 - platform.x1
		var platform_color := Color(0.62, 0.28, 0.16) if platform.crumble_timer >= 0.0 else Color(0.34, 0.22, 0.14)
		var platform_top_color := Color(0.92, 0.52, 0.24) if platform.crumble_timer >= 0.0 else Color(0.20, 0.55, 0.20)
		if platform.sloped:
			var top_left := Vector2(platform.x1, platform.slope_start_y)
			var top_right := Vector2(platform.x2, platform.slope_end_y)
			draw_colored_polygon(PackedVector2Array([
				top_left,
				top_right,
				Vector2(platform.x2, platform.slope_end_y + platform.thickness),
				Vector2(platform.x1, platform.slope_start_y + platform.thickness),
			]), platform_color)
			draw_polyline(PackedVector2Array([top_left, top_right]), platform_top_color, 4.0)
		elif platform.crumble_phase == 2:
			var break_progress: float = 1.0 - platform.crumble_break_timer / (32.0 / 60.0)
			var segment_width: float = platform_width / 8.0
			for segment in range(8):
				var segment_fall := break_progress * break_progress * 42.0 * (1.0 + float(segment % 3) * 0.12)
				draw_rect(Rect2(platform.x1 + segment * segment_width, platform.top_y + segment_fall, segment_width - 1.0, platform.thickness), platform_color)
				draw_rect(Rect2(platform.x1 + segment * segment_width, platform.top_y + segment_fall, segment_width - 1.0, 4.0), platform_top_color)
		else:
			draw_rect(Rect2(platform.x1, platform.top_y, platform_width, platform.thickness), platform_color)
			draw_rect(Rect2(platform.x1, platform.top_y, platform_width, 4.0), platform_top_color)

	for hill_data in hills:
		var hill := hill_data as Dictionary
		_draw_hill(
			hill.get("origin", Vector2.ZERO),
			hill.get("size", Vector2(240.0, 120.0)),
			hill.get("color", Color(0.12, 0.22, 0.12))
		)

func _draw_drifting_cloud(origin: Vector2, scale: float, speed: float, phase: float) -> void:
	var drift := fposmod(_time * speed + phase * 120.0, 260.0) - 130.0
	_draw_cloud(origin + Vector2(drift, sin(_time * 0.6 + phase) * 4.0), scale)

func _draw_cloud(origin: Vector2, scale: float) -> void:
	var c := Color(0.98, 0.98, 1.0, 0.88)
	draw_circle(origin + Vector2(-26.0, 4.0) * scale, 26.0 * scale, c)
	draw_circle(origin + Vector2(0.0, -12.0) * scale, 34.0 * scale, c)
	draw_circle(origin + Vector2(32.0, 6.0) * scale, 24.0 * scale, c)
	draw_rect(Rect2(origin + Vector2(-50.0, -2.0) * scale, Vector2(102.0, 24.0) * scale), c)

func _draw_hill(origin: Vector2, size: Vector2, color: Color) -> void:
	draw_circle(origin, size.x * 0.5, color)
	draw_rect(Rect2(origin.x - size.x * 0.5, origin.y, size.x, size.y * 0.7), color)

func _draw_source_background() -> void:
	if _source_bg_texture == null:
		return
	var profile := get_source_background_profile(_source_bg_level_id)
	var strips := int(profile.get("strips", 15))
	var strip_height := 480.0 / float(maxi(1, strips))
	var phase_speed := float(profile.get("phase_speed", 0.0))
	var amplitude_x := float(profile.get("amplitude_x", 0.0))
	var amplitude_y := float(profile.get("amplitude_y", 0.0))
	var opacity := float(profile.get("opacity", 0.28))
	# The original Zone2/3/6/7 background tasks write per-scanline offsets to
	# HBlank registers. Draw equivalent horizontal strips so the extracted
	# source background keeps that motion in Godot instead of being a static
	# backdrop.
	for x in range(-600, 3000, 512):
		for strip in range(strips):
			var y := 44.0 + float(strip) * strip_height
			var wave := float(strip) / float(maxi(1, strips - 1)) * TAU
			var offset_x := sin(_time * phase_speed + wave) * amplitude_x
			var offset_y := cos(_time * phase_speed * 0.73 + wave * 1.4) * amplitude_y
			var source_rect := Rect2(x + offset_x, y + offset_y, 512.0, strip_height + 2.0)
			draw_texture_rect_region(_source_bg_texture, source_rect, Rect2(0.0, float(strip) * 240.0 / float(maxi(1, strips)), 256.0, 240.0 / float(maxi(1, strips))), Color(1.0, 1.0, 1.0, opacity))

func _draw_zone4_spotlights() -> void:
	var profile := get_source_background_profile(_source_bg_level_id)
	if not bool(profile.get("spotlights", false)):
		return
	# zone_4.inc.c creates two moving spotlight windows over the snow layer.
	# The polygon cones preserve the readable light shafts without relying on
	# GBA WIN registers, which do not exist in Godot's renderer.
	for i in range(2):
		var phase := _time * (0.42 + float(i) * 0.10) + float(i) * PI
		var center_x := 420.0 + float(i) * 720.0 + sin(phase) * 130.0
		var top_x := center_x + sin(phase * 0.7) * 32.0
		var beam := PackedVector2Array([
			Vector2(top_x - 18.0, 40.0),
			Vector2(top_x + 18.0, 40.0),
			Vector2(center_x + 148.0, 540.0),
			Vector2(center_x - 148.0, 540.0),
		])
		draw_colored_polygon(beam, Color(0.84, 0.92, 1.0, 0.055))
		draw_line(Vector2(top_x, 40.0), Vector2(center_x, 540.0), Color(0.92, 0.97, 1.0, 0.20), 2.0)

func get_source_background_profile(level_id: int) -> Dictionary:
	return BACKGROUND_PROFILE.for_level(level_id)

func _build_source_background(manifest: Dictionary) -> Texture2D:
	if manifest.is_empty() or not bool(manifest.get("valid", false)):
		return null
	var atlas_path := ProjectSettings.globalize_path("res://../data/sa2/maps/%s/%s/tilemaps/bg/tiles.png" % [manifest.zone, manifest.act])
	var map_path := ProjectSettings.globalize_path("res://../data/sa2/maps/%s/%s/tilemaps/bg/tilemap.tilemap2" % [manifest.zone, manifest.act])
	var atlas := Image.load_from_file(atlas_path)
	if atlas == null or atlas.is_empty() or not FileAccess.file_exists(map_path):
		return null
	var file := FileAccess.open(map_path, FileAccess.READ)
	if file == null:
		return null
	var map_bytes := file.get_buffer(file.get_length())
	var image := Image.create(256, 240, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for tile_y in range(30):
		for tile_x in range(32):
			var tile_value := _read_u16(map_bytes, (tile_y * 32 + tile_x) * 2)
			var tile_index := tile_value & 0x03ff
			var atlas_y := tile_index * 8
			if atlas_y + 8 > atlas.get_height():
				continue
			var tile_image := atlas.get_region(Rect2i(0, atlas_y, 8, 8))
			tile_image.convert(Image.FORMAT_RGBA8)
			if tile_value & 0x0400:
				tile_image.flip_x()
			if tile_value & 0x0800:
				tile_image.flip_y()
			image.blit_rect(tile_image, Rect2i(0, 0, 8, 8), Vector2i(tile_x * 8, tile_y * 8))
	return ImageTexture.create_from_image(image)

func _read_u16(bytes: PackedByteArray, offset: int) -> int:
	if offset < 0 or offset + 1 >= bytes.size():
		return 0
	return int(bytes[offset]) | (int(bytes[offset + 1]) << 8)
