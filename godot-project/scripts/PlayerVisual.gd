# PlayerVisual.gd
# Simple sprite-based player avatar for the Godot remake prototype.
extends CharacterBody2D

var _body: Sprite2D = null
var _shadow: Sprite2D = null
var _boost_trails: Array[Sprite2D] = []
var _time: float = 0.0

func _ready() -> void:
	set_process(true)
	_body = get_node_or_null("Body")
	_shadow = get_node_or_null("Shadow")
	if _body == null:
		_body = Sprite2D.new()
		_body.name = "Body"
		add_child(_body)
	if _shadow == null:
		_shadow = Sprite2D.new()
		_shadow.name = "Shadow"
		add_child(_shadow)
	_body.texture = _make_player_texture()
	_shadow.texture = _make_shadow_texture()
	for i in range(3):
		var trail := Sprite2D.new()
		trail.name = "BoostTrail%d" % i
		trail.texture = _body.texture
		trail.z_index = -1
		trail.modulate = Color(0.36, 0.82, 1.0, 0.0)
		add_child(trail)
		_boost_trails.append(trail)
	visible = CoreBridge.should_show_player_visual()

func _process(delta: float) -> void:
	_time += delta
	var state = CoreBridge.get_player_state()
	if _body == null or _shadow == null:
		return

	visible = state.is_alive and CoreBridge.should_show_player_visual()
	if not visible:
		_hide_boost_trails()
		return

	_body.modulate = CoreBridge.get_player_visual_color(state.variant, false)
	if state.is_grounded:
		_body.position = Vector2(0.0, sin(_time * 8.0) * 1.5)
		_body.rotation = 0.0
		_body.scale = Vector2(1.0 + sin(_time * 10.0) * 0.03, 1.0 - sin(_time * 10.0) * 0.02)
	else:
		_body.position = Vector2(0.0, -4.0)
		_body.rotation = state.rotation * 0.08
		_body.scale = Vector2(1.0, 1.0)

	if state.has_cleared_level:
		_body.modulate = CoreBridge.get_player_visual_color(state.variant, true)

	_shadow.position = Vector2(0.0, 22.0 + sin(_time * 8.0) * 0.5)
	_shadow.scale = Vector2(1.0 + sin(_time * 8.0) * 0.04, 0.55)
	_update_boost_trails()
	queue_redraw()

func _draw() -> void:
	if not visible:
		return
	var center := Vector2(0.0, -2.0)
	if CoreBridge.is_player_magnetic_shielded():
		draw_arc(center, 31.0 + sin(_time * 5.0) * 1.5, 0.0, TAU, 40, Color(0.72, 0.48, 1.0, 0.88), 3.0)
		draw_arc(center, 36.0, _time * 1.8, _time * 1.8 + PI * 0.9, 20, Color(0.86, 0.70, 1.0, 0.56), 2.0)
	elif CoreBridge.is_hud_shield_active():
		draw_arc(center, 30.0 + sin(_time * 4.0) * 1.0, 0.0, TAU, 40, Color(0.42, 0.84, 1.0, 0.82), 3.0)
		draw_arc(center, 34.0, -_time * 1.2, -_time * 1.2 + PI * 0.75, 18, Color(0.72, 0.96, 1.0, 0.50), 2.0)
	if CoreBridge.is_player_invincible():
		for i in range(8):
			var angle := _time * 2.4 + float(i) * TAU / 8.0
			var inner := center + Vector2(cos(angle), sin(angle)) * 32.0
			var outer := center + Vector2(cos(angle), sin(angle)) * 41.0
			draw_line(inner, outer, Color(1.0, 0.90, 0.28, 0.90), 3.0)
	if CoreBridge.is_player_speed_up_active():
		for i in range(3):
			var line_y := -14.0 + float(i) * 12.0
			var line_length := 22.0 + sin(_time * 8.0 + float(i)) * 5.0
			draw_line(Vector2(-18.0 - line_length, line_y), Vector2(-18.0, line_y), Color(1.0, 0.52, 0.20, 0.72), 3.0)

func _update_boost_trails() -> void:
	if not CoreBridge.is_player_boosting():
		_hide_boost_trails()
		return
	var positions: Array = CoreBridge.get_boost_trail_positions()
	for i in range(_boost_trails.size()):
		var trail := _boost_trails[i]
		if i >= positions.size():
			trail.visible = false
			continue
		trail.visible = true
		trail.global_position = positions[i]
		trail.rotation = _body.rotation
		trail.scale = _body.scale * (1.0 - float(i) * 0.05)
		trail.modulate = Color(0.36, 0.82, 1.0, 0.38 - float(i) * 0.09)

func _hide_boost_trails() -> void:
	for trail in _boost_trails:
		trail.visible = false

func _make_player_texture() -> Texture2D:
	var image := Image.create(48, 48, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(48):
		for x in range(48):
			var dx := x - 24
			var dy := y - 24
			var dist := dx * dx + dy * dy
			if dist <= 170:
				image.set_pixel(x, y, Color(0.20, 0.72, 1.0, 1.0))
			elif dist <= 200 and y <= 28:
				image.set_pixel(x, y, Color(0.86, 0.96, 1.0, 1.0))
			elif dist <= 210 and y >= 30:
				image.set_pixel(x, y, Color(0.12, 0.22, 0.35, 1.0))
	for i in range(6):
		image.set_pixel(30 + i, 14 + i, Color(0.20, 0.72, 1.0, 1.0))
		image.set_pixel(13 - i, 14 + i, Color(0.20, 0.72, 1.0, 1.0))
	return ImageTexture.create_from_image(image)

func _make_shadow_texture() -> Texture2D:
	var image := Image.create(40, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(16):
		for x in range(40):
			var dx := x - 20
			var dy := y - 8
			if (dx * dx) / 260.0 + (dy * dy) / 30.0 <= 1.0:
				image.set_pixel(x, y, Color(0.0, 0.0, 0.0, 0.25))
	return ImageTexture.create_from_image(image)
