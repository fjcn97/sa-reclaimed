# Course-selection map construction and animated marker view.
extends RefCounted
class_name CourseMapView

var _avatar_marker: ColorRect = null
var _marker_glow: ColorRect = null
var _map_nodes: Array[ColorRect] = []
var _map_node_labels: Array[Label] = []
var _map_links: Array[ColorRect] = []
var _marker_visual_pos: Vector2 = Vector2.ZERO
var _marker_target_pos: Vector2 = Vector2.ZERO
var _marker_from_pos: Vector2 = Vector2.ZERO
var _selected_map_index: int = -1
var _map_ready: bool = false

func setup(screen: Object) -> Dictionary:
	_marker_glow = _rect(screen, "CourseMarkerGlow", Rect2(0.0, 0.0, 28.0, 28.0), Color(1.0, 0.90, 0.34, 0.24))
	_marker_glow.z_index = 1
	_avatar_marker = _rect(screen, "CourseAvatarMarker", Rect2(0.0, 0.0, 16.0, 16.0), Color(1.0, 0.88, 0.32, 1.0))
	_avatar_marker.z_index = 2
	for i in range(16):
		var link := _rect(screen, "CourseMapLink%d" % i, Rect2(0.0, 0.0, 8.0, 8.0), Color(0.16, 0.28, 0.44, 0.86))
		link.z_index = 0
		_map_links.append(link)
		var node := _rect(screen, "CourseMapNode%d" % i, Rect2(0.0, 0.0, 22.0, 22.0), Color(0.20, 0.28, 0.38, 0.96))
		node.z_index = 1
		var label := _label(screen, "CourseMapNodeLabel%d" % i, Vector2.ZERO, Vector2(54.0, 16.0), 11)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_map_nodes.append(node)
		_map_node_labels.append(label)

	return {
		"avatar_marker": _avatar_marker,
		"marker_glow": _marker_glow,
		"map_nodes": _map_nodes,
		"map_node_labels": _map_node_labels,
		"map_links": _map_links,
	}

func reset() -> void:
	_marker_visual_pos = Vector2.ZERO
	_marker_target_pos = Vector2.ZERO
	_marker_from_pos = Vector2.ZERO
	_selected_map_index = -1
	_map_ready = false

## The screen supplies a presentation snapshot; this view has no autoload
## dependency and can therefore be reused in isolated scene tests.
func update(map_state: Dictionary, delta: float, pulse_time: float) -> void:
	var nodes: Array = map_state.get("nodes", [])
	var marker_pulse := 0.5 + 0.5 * sin(pulse_time * 6.0)
	var unlocking: bool = bool(map_state.get("unlocking", false))
	var unlock_path_reveal: bool = bool(map_state.get("unlock_path_reveal", false))
	var unlock_progress: float = float(map_state.get("unlock_progress", 1.0))
	var course_positions: Dictionary = {}
	for node_data in nodes:
		course_positions[int(node_data.get("index", -1))] = Vector2(node_data.get("position", Vector2.ZERO))
	for i in range(_map_links.size()):
		_map_links[i].visible = i < nodes.size() - 1
		if not _map_links[i].visible:
			continue
		var from_node: Dictionary = nodes[i]
		var to_node: Dictionary = nodes[i + 1]
		var from_pos: Vector2 = Vector2(from_node.get("position", Vector2.ZERO))
		var to_pos: Vector2 = Vector2(to_node.get("position", Vector2.ZERO))
		var segment_delta: Vector2 = to_pos - from_pos
		var width: float = max(absf(segment_delta.x), 8.0)
		var height: float = max(absf(segment_delta.y), 8.0)
		_map_links[i].position = Vector2(254.0 + minf(from_pos.x, to_pos.x), 310.0 + minf(from_pos.y, to_pos.y))
		_map_links[i].size = Vector2(width, height)
		var active_path := bool(from_node.get("unlocked", false)) and bool(to_node.get("unlocked", false))
		var path_color := Color(0.30, 0.64, 0.94, 0.92) if active_path else Color(0.18, 0.34, 0.54, 0.56)
		if unlocking and i == nodes.size() - 2:
			var reveal_alpha := 0.18 + (unlock_progress * 0.82) if unlock_path_reveal else 1.0
			path_color = Color(1.0, 0.78, 0.28, reveal_alpha)
		_map_links[i].color = path_color
	for i in range(_map_nodes.size()):
		var visible := i < nodes.size()
		_map_nodes[i].visible = visible
		_map_node_labels[i].visible = visible
		if not visible:
			continue
		var node: Dictionary = nodes[i]
		var pos: Vector2 = Vector2(node.get("position", Vector2.ZERO))
		var selected := bool(node.get("selected", false))
		var unlocked := bool(node.get("unlocked", false))
		var cleared := bool(node.get("cleared", false))
		var bob := sin(pulse_time * 2.4 + float(i) * 0.8) * 2.0
		_map_nodes[i].position = Vector2(244.0 + pos.x, 298.0 + pos.y + bob)
		_map_node_labels[i].position = Vector2(231.0 + pos.x, 320.0 + pos.y + bob)
		_map_node_labels[i].size = Vector2(44.0, 14.0)
		_map_nodes[i].size = Vector2(26.0, 26.0) if selected else Vector2(22.0, 22.0)
		_map_nodes[i].color = Color(1.0, 0.84, 0.28, 0.84 + marker_pulse * 0.16) if selected else (Color(0.30, 0.76, 0.48, 0.98) if cleared else (Color(0.30, 0.54, 0.90, 0.96) if unlocked else Color(0.22, 0.26, 0.32, 0.92)))
		_map_node_labels[i].text = str(int(node.get("index", 0)) + 1)
		_map_node_labels[i].modulate = Color(1.0, 0.96, 0.84, 1.0) if selected else Color(0.96, 0.98, 1.0, 1.0)
		if selected:
			_marker_target_pos = Vector2(250.0 + pos.x + 3.0, 276.0 + pos.y + bob)
			if _selected_map_index != i:
				_selected_map_index = i
				if not _map_ready:
					_marker_visual_pos = _marker_target_pos
					_marker_from_pos = _marker_target_pos
					_map_ready = true
	if _avatar_marker and nodes.size() > 0:
		if bool(map_state.get("traveling", false)):
			var from_index: int = int(map_state.get("travel_from_index", -1))
			var to_index: int = int(map_state.get("travel_to_index", -1))
			if course_positions.has(from_index):
				var from_pos: Vector2 = course_positions[from_index]
				_marker_from_pos = Vector2(250.0 + from_pos.x + 3.0, 276.0 + from_pos.y)
			if course_positions.has(to_index):
				var to_pos: Vector2 = course_positions[to_index]
				_marker_target_pos = Vector2(250.0 + to_pos.x + 3.0, 276.0 + to_pos.y)
			var travel_progress := ease(float(map_state.get("travel_progress", 1.0)), -2.0)
			_marker_visual_pos = _marker_from_pos.lerp(_marker_target_pos, travel_progress)
		else:
			var marker_speed := clampf(delta * 8.0, 0.0, 1.0)
			_marker_visual_pos = _marker_visual_pos.lerp(_marker_target_pos, marker_speed)
			_marker_from_pos = _marker_visual_pos
		_avatar_marker.position = _marker_visual_pos
		if _marker_glow:
			_marker_glow.position = _marker_visual_pos - Vector2(6.0, 6.0)
			_marker_glow.size = Vector2(28.0, 28.0)
			_marker_glow.color = Color(1.0, 0.90, 0.34, 0.20 + marker_pulse * 0.12)
		var settle_bonus := 0.0
		var settling: bool = bool(map_state.get("settling", false))
		if settling:
			settle_bonus = 4.0 * (1.0 - float(map_state.get("settle_progress", 1.0)))
		_avatar_marker.size = Vector2(16.0 + sin(pulse_time * 6.0) * 2.0 + settle_bonus, 16.0 + sin(pulse_time * 6.0) * 2.0 + settle_bonus)
		_avatar_marker.color = Color(1.0, 0.94, 0.46, 1.0) if settling else Color(1.0, 0.88, 0.32, 0.90 + marker_pulse * 0.10)
		_avatar_marker.visible = true
		if _marker_glow:
			_marker_glow.visible = true
	elif _avatar_marker:
		_avatar_marker.visible = false
		if _marker_glow:
			_marker_glow.visible = false

static func _rect(screen: ScreenBase, node_name: String, rect: Rect2, color: Color) -> ColorRect:
	return screen.ensure_rect(node_name, rect, color)

static func _label(screen: ScreenBase, node_name: String, position: Vector2, size: Vector2, font_size: int) -> Label:
	return screen.ensure_label(node_name, position, size, font_size)
