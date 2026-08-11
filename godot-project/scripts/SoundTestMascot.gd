extends Control

var _time: float = 0.0
@export var state_bridge_path: NodePath = NodePath("/root/CoreBridge")
var _bridge: Node = null

func _ready() -> void:
	_bridge = get_node_or_null(state_bridge_path)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(true)
	queue_redraw()

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func _draw() -> void:
	if _bridge == null:
		_bridge = get_node_or_null(state_bridge_path)
	var playing: bool = _bridge != null and _bridge.is_sound_test_playing()
	var tempo: float = _bridge.get_sound_test_tempo() if _bridge != null else 0.0
	var beat := sin(_time * (tempo * 0.46 if playing else 2.6))
	var bob := beat * (5.0 if playing else 1.5)
	var dance := beat * (12.0 if playing else 2.0)
	var center := Vector2(size.x * 0.5, size.y * 0.54 + bob)
	var outline := Color(0.05, 0.08, 0.15, 1.0)
	var cream := Color(1.0, 0.84, 0.62, 1.0)
	var dress := Color(0.96, 0.48, 0.66, 1.0)
	var blue := Color(0.24, 0.62, 0.94, 1.0)
	var white := Color(0.98, 0.99, 1.0, 1.0)

	# Cream's long ears and bow remain readable at the small sound-test scale.
	_draw_ellipse(center + Vector2(-42.0, -42.0), Vector2(16.0, 38.0), cream, outline)
	_draw_ellipse(center + Vector2(42.0, -42.0), Vector2(16.0, 38.0), cream, outline)
	draw_circle(center, 34.0, cream)
	draw_circle(center + Vector2(-12.0, -2.0), 4.0, outline)
	draw_circle(center + Vector2(12.0, -2.0), 4.0, outline)
	draw_circle(center + Vector2(-12.0, -1.0), 1.5, white)
	draw_circle(center + Vector2(12.0, -1.0), 1.5, white)
	draw_line(center + Vector2(-7.0, 12.0), center + Vector2(7.0, 12.0), dress, 3.0)
	draw_circle(center + Vector2(-29.0, -26.0), 9.0, dress)
	draw_circle(center + Vector2(-20.0, -34.0), 5.0, blue)

	var torso := center + Vector2(0.0, 42.0)
	draw_colored_polygon(PackedVector2Array([
		torso + Vector2(-30.0, -8.0), torso + Vector2(30.0, -8.0),
		torso + Vector2(42.0, 48.0), torso + Vector2(-42.0, 48.0),
	]), dress)
	draw_line(torso + Vector2(-28.0, 4.0), torso + Vector2(-48.0 + dance, 34.0), outline, 7.0)
	draw_line(torso + Vector2(28.0, 4.0), torso + Vector2(48.0 - dance, 34.0), outline, 7.0)
	draw_line(torso + Vector2(-18.0, 46.0), torso + Vector2(-26.0 - dance * 0.3, 72.0), blue, 8.0)
	draw_line(torso + Vector2(18.0, 46.0), torso + Vector2(26.0 + dance * 0.3, 72.0), blue, 8.0)
	if playing:
		var ring := 44.0 + absf(beat) * 10.0
		draw_arc(center, ring, 0.0, TAU, 32, Color(0.32, 0.88, 0.98, 0.34), 3.0)

func _draw_ellipse(center: Vector2, radius: Vector2, fill: Color, border: Color) -> void:
	var points := PackedVector2Array()
	for i in range(25):
		var angle := TAU * float(i) / 24.0
		points.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
	draw_colored_polygon(points, border)
	var inner := PackedVector2Array()
	for i in range(25):
		var angle := TAU * float(i) / 24.0
		inner.append(center + Vector2(cos(angle) * maxf(radius.x - 3.0, 1.0), sin(angle) * maxf(radius.y - 3.0, 1.0)))
	draw_colored_polygon(inner, fill)
