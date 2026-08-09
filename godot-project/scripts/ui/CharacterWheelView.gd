# Character-selection wheel geometry and animated selection view.
extends RefCounted
class_name CharacterWheelView

var _wheel_nodes: Array[ColorRect] = []
var _wheel_node_labels: Array[Label] = []
var _selected_node_ring: ColorRect = null
var _node_positions: Array[Vector2] = []
var _selected_wheel_pos: Vector2 = Vector2.ZERO

func setup(screen: Object) -> Dictionary:
	var center := Vector2(290.0, 350.0)
	var radius_x := 86.0
	var radius_y := 72.0
	for i in range(5):
		var angle := -PI * 0.5 + float(i) * TAU / 5.0
		var pos := center + Vector2(cos(angle) * radius_x, sin(angle) * radius_y)
		_node_positions.append(pos)
		var node := _rect(screen, "WheelNode%d" % i, Rect2(pos.x - 16.0, pos.y - 16.0, 32.0, 32.0), Color(0.20, 0.30, 0.44, 0.98))
		var label := _label(screen, "WheelNodeLabel%d" % i, Vector2(pos.x - 16.0, pos.y - 16.0), Vector2(32.0, 32.0), 11)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_wheel_nodes.append(node)
		_wheel_node_labels.append(label)
	_selected_node_ring = _rect(screen, "SelectedNodeRing", Rect2(center.x - 22.0, center.y - 22.0, 44.0, 44.0), Color(0.98, 0.80, 0.22, 0.92))
	_selected_node_ring.z_index = 2
	_selected_wheel_pos = center

	return {
		"wheel_nodes": _wheel_nodes,
		"wheel_node_labels": _wheel_node_labels,
		"selected_node_ring": _selected_node_ring,
	}

func update(delta: float, wheel_time: float) -> void:
	var rows: Array = CoreBridge.get_character_select_rows()
	var selected_index := -1
	for i in range(_wheel_nodes.size()):
		var visible := i < rows.size()
		_wheel_nodes[i].visible = visible
		_wheel_node_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_available := bool(row.get("available", false))
		var is_selected := bool(row.get("selected", false))
		var pos := _node_positions[i]
		var bob := sin(wheel_time + float(i) * 0.8) * 4.0
		_wheel_nodes[i].position = Vector2(pos.x - 16.0, pos.y - 16.0 + bob)
		_wheel_node_labels[i].position = Vector2(pos.x - 16.0, pos.y - 16.0 + bob)
		_wheel_nodes[i].color = Color(0.46, 0.78, 0.98, 0.98) if is_selected else (Color(0.20, 0.30, 0.44, 0.98) if is_available else Color(0.24, 0.24, 0.28, 0.96))
		var name_text := str(row.get("name", ""))
		name_text = name_text.replace(" ", "")
		_wheel_node_labels[i].text = name_text.left(2)
		_wheel_node_labels[i].modulate = Color(0.96, 0.98, 1.0, 1.0) if is_available else Color(0.70, 0.72, 0.76, 0.94)
		if is_selected:
			selected_index = i
	if _selected_node_ring:
		if selected_index >= 0:
			var target := _node_positions[selected_index] + Vector2(0.0, sin(wheel_time + float(selected_index) * 0.8) * 4.0)
			_selected_wheel_pos = _selected_wheel_pos.lerp(target, clampf(delta * 10.0, 0.0, 1.0))
			_selected_node_ring.position = _selected_wheel_pos - Vector2(22.0, 22.0)
			_selected_node_ring.color = Color(0.98, 0.80, 0.22, 0.92 + absf(sin(wheel_time * 1.2)) * 0.06)
			_selected_node_ring.visible = true
		else:
			_selected_node_ring.visible = false

static func _rect(screen: Object, node_name: String, rect: Rect2, color: Color) -> ColorRect:
	return screen.call("ensure_rect", node_name, rect, color) as ColorRect

static func _label(screen: Object, node_name: String, position: Vector2, size: Vector2, font_size: int) -> Label:
	return screen.call("ensure_label", node_name, position, size, font_size) as Label
