# EntitySprite.gd
# Reusable sprite-based stage entity presentation for the Godot remake.
extends Node2D
class_name EntitySprite

var entity_state = null
var _body: Sprite2D = null
var _overlay: Sprite2D = null
var _fallback: StageEntity = null
var _pulse_time: float = 0.0

func _ready() -> void:
	_body = get_node_or_null("Body")
	_overlay = get_node_or_null("Overlay")
	if _body == null:
		_body = Sprite2D.new()
		_body.name = "Body"
		add_child(_body)
	if _overlay == null:
		_overlay = Sprite2D.new()
		_overlay.name = "Overlay"
		add_child(_overlay)
	_fallback = StageEntity.new()
	_fallback.name = "FallbackEntity"
	_fallback.visible = false
	add_child(_fallback)
	_apply_visuals()

func bind_state(state) -> void:
	entity_state = state
	_apply_visuals()

func _process(delta: float) -> void:
	if entity_state == null:
		visible = false
		return
	if entity_state.type == CoreBridge.ENTITY_LAP_TRIGGER:
		visible = false
		return

	visible = entity_state.active
	if not visible:
		return

	global_position = Vector2(entity_state.world_x, entity_state.world_y)
	_pulse_time += delta
	_animate(delta)

func _apply_visuals() -> void:
	if entity_state == null or _body == null or _overlay == null:
		return

	var profile := CoreBridge.get_entity_visual_profile(entity_state.type, bool(entity_state.activated))
	var use_fallback := false
	if _fallback:
		_fallback.visible = false
	_body.centered = true
	_overlay.centered = true
	_body.position = Vector2.ZERO
	_overlay.position = Vector2.ZERO
	_body.rotation = 0.0
	_overlay.rotation = 0.0
	_body.modulate = Color.WHITE
	_overlay.modulate = Color.WHITE

	match entity_state.type:
		CoreBridge.ENTITY_RING, CoreBridge.ENTITY_SCATTER_RING:
			_body.texture = _make_ring_texture()
			_overlay.texture = _make_ring_glint_texture()
		CoreBridge.ENTITY_SPECIAL_RING:
			_body.texture = _make_ring_texture()
			_overlay.texture = _make_ring_glint_texture()
			_body.modulate = Color(0.30, 0.86, 1.0, 1.0)
			_overlay.modulate = Color(0.78, 1.0, 1.0, 1.0)
		CoreBridge.ENTITY_RING_EFFECT:
			_body.texture = _make_ring_effect_texture()
			_overlay.texture = _make_ring_effect_overlay_texture()
		CoreBridge.ENTITY_HEART_EFFECT:
			_body.texture = _make_heart_texture()
			_overlay.texture = null
		CoreBridge.ENTITY_DUST_EFFECT:
			_body.texture = _make_dust_texture()
			_overlay.texture = null
		CoreBridge.ENTITY_GRIND_EFFECT:
			_body.texture = _make_grind_effect_texture()
			_overlay.texture = null
		CoreBridge.ENTITY_CHEESE:
			_body.texture = _make_cheese_texture()
			_overlay.texture = null
		CoreBridge.ENTITY_TAIL_SWIPE:
			_body.texture = _make_tail_swipe_texture()
			_overlay.texture = null
		CoreBridge.ENTITY_KNUCKLES_FIRE:
			_body.texture = _make_knuckles_fire_texture()
			_overlay.texture = null
		CoreBridge.ENTITY_SONIC_SKID:
			_body.texture = _make_sonic_skid_texture()
			_overlay.texture = null
		CoreBridge.ENTITY_WHIRLWIND:
			_body.texture = _make_whirlwind_texture()
			_overlay.texture = _make_whirlwind_overlay_texture()
		CoreBridge.ENTITY_FAN:
			_body.texture = _make_fan_texture()
			_overlay.texture = _make_fan_overlay_texture(entity_state.velocity_x)
		CoreBridge.ENTITY_SPIKES:
			_body.texture = _make_spikes_texture()
			_overlay.texture = null
		CoreBridge.ENTITY_ITEM_BOX:
			_body.texture = _make_item_box_texture()
			_overlay.texture = _make_shield_icon_texture() if entity_state.item_kind == CoreBridge.ITEM_BOX_KIND_SHIELD else (_make_invincibility_icon_texture() if entity_state.item_kind == CoreBridge.ITEM_BOX_KIND_INVINCIBILITY else _make_item_box_icon_texture())
		CoreBridge.ENTITY_PROPELLER:
			_body.texture = _make_propeller_texture()
			_overlay.texture = _make_propeller_overlay_texture()
		CoreBridge.ENTITY_SPRING:
			_body.texture = _make_spring_base_texture()
			_overlay.texture = _make_spring_top_texture()
		CoreBridge.ENTITY_BOUNCY_SPRING:
			_body.texture = _make_bouncy_bar_texture() if entity_state.variant == 2 else _make_spring_base_texture()
			_overlay.texture = _make_bouncy_bar_overlay_texture() if entity_state.variant == 2 else _make_spring_top_texture()
		CoreBridge.ENTITY_LAYER_TOGGLE:
			_body.texture = _make_layer_toggle_texture()
			_overlay.texture = _make_layer_toggle_overlay_texture(entity_state.variant == 1)
		CoreBridge.ENTITY_RAMP:
			_body.texture = _make_ramp_texture(entity_state.variant == 1)
			_overlay.texture = null
		CoreBridge.ENTITY_ROTATING_HANDLE:
			_body.texture = _make_handle_texture()
			_overlay.texture = _make_handle_overlay_texture()
		CoreBridge.ENTITY_CORK_SCREW:
			_body.texture = _make_corkscrew_texture(entity_state.variant == 1)
			_overlay.texture = null
		CoreBridge.ENTITY_ENEMY:
			_body.texture = _make_enemy_body_texture()
			_overlay.texture = _make_enemy_face_texture()
		CoreBridge.ENTITY_CHECKPOINT:
			_body.texture = _make_checkpoint_pole_texture()
			_overlay.texture = _make_flag_texture(entity_state.activated)
		CoreBridge.ENTITY_GOAL:
			_body.texture = _make_goal_pole_texture()
			_overlay.texture = _make_goal_flag_texture()
		CoreBridge.ENTITY_GOAL_LEVER:
			_body.texture = _make_goal_pole_texture()
			_overlay.texture = _make_goal_flag_texture()
		_:
			use_fallback = true
			_body.texture = null
			_overlay.texture = null

	if use_fallback and _fallback:
		_body.visible = false
		_overlay.visible = false
		_fallback.visible = true
		_fallback.bind_state(entity_state)
	else:
		_body.visible = true
		_overlay.visible = true

	_body.scale = profile.get("body_scale", Vector2.ONE)
	_overlay.scale = profile.get("overlay_scale", Vector2.ONE)
	_body.position = profile.get("body_offset", Vector2.ZERO)
	_overlay.position = profile.get("overlay_offset", Vector2.ZERO)
	_overlay.modulate = profile.get("overlay_color", Color.WHITE)

func _animate(delta: float) -> void:
	match entity_state.type:
		CoreBridge.ENTITY_RING, CoreBridge.ENTITY_SCATTER_RING:
			rotation += delta * 3.0
			var pulse := 1.0 + sin(_pulse_time * 5.0) * 0.08
			scale = Vector2.ONE * pulse
			_overlay.rotation = -rotation
		CoreBridge.ENTITY_SPECIAL_RING:
			rotation += delta * 2.2
			var special_pulse := 1.0 + sin(_pulse_time * 4.0) * 0.10
			scale = Vector2.ONE * special_pulse
			_overlay.rotation = -rotation
		CoreBridge.ENTITY_RING_EFFECT:
			var effect_progress := clampf(entity_state.state_timer / 0.34, 0.0, 1.0)
			scale = Vector2.ONE * (0.55 + effect_progress * 0.9)
			modulate = Color(1.0, 0.94, 0.62, 1.0 - effect_progress)
			_overlay.rotation += delta * 8.0
		CoreBridge.ENTITY_HEART_EFFECT:
			var heart_progress := clampf(entity_state.state_timer / 0.72, 0.0, 1.0)
			scale = Vector2.ONE * (0.72 + sin(heart_progress * PI) * 0.18)
			modulate = Color(1.0, 0.40, 0.60, 1.0 - heart_progress)
			rotation = sin(_pulse_time * 8.0) * 0.12
		CoreBridge.ENTITY_DUST_EFFECT:
			var dust_progress := clampf(entity_state.state_timer / 0.48, 0.0, 1.0)
			scale = Vector2.ONE * (0.72 + dust_progress * 0.58)
			modulate = Color(0.78, 0.82, 0.86, 0.78 * (1.0 - dust_progress))
		CoreBridge.ENTITY_GRIND_EFFECT:
			scale = Vector2.ONE * (0.72 + sin(_pulse_time * 14.0) * 0.16)
			modulate = Color(1.0, 0.82, 0.30, 0.92)
			rotation = _pulse_time * 7.0
		CoreBridge.ENTITY_CHEESE:
			scale = Vector2.ONE * (0.82 + sin(_pulse_time * 5.0) * 0.08)
			modulate = Color(0.98, 0.72, 0.42, 1.0)
			rotation = sin(_pulse_time * 3.0) * 0.10
		CoreBridge.ENTITY_TAIL_SWIPE:
			var swipe_progress := clampf(entity_state.state_timer / 0.28, 0.0, 1.0)
			scale = Vector2.ONE * (0.65 + swipe_progress * 0.55)
			modulate = Color(0.70, 0.92, 1.0, 1.0 - swipe_progress)
			rotation = (-0.8 if entity_state.variant == 1 else 0.8) + swipe_progress * 1.8
		CoreBridge.ENTITY_KNUCKLES_FIRE:
			var fire_progress := clampf(entity_state.state_timer / 0.36, 0.0, 1.0)
			scale = Vector2.ONE * (0.68 + sin(fire_progress * PI) * 0.28)
			modulate = Color(1.0, 0.34 + fire_progress * 0.35, 0.12, 1.0 - fire_progress)
			rotation = _pulse_time * 10.0
		CoreBridge.ENTITY_SONIC_SKID:
			var skid_progress := clampf(entity_state.state_timer / 0.32, 0.0, 1.0)
			scale = Vector2.ONE * (0.70 + skid_progress * 0.45)
			modulate = Color(0.42, 0.78, 1.0, 1.0 - skid_progress)
			rotation = (-0.55 if entity_state.variant == 1 else 0.55) + skid_progress * 1.4
		CoreBridge.ENTITY_WHIRLWIND:
			rotation = sin(_pulse_time * 1.5) * 0.08
			_overlay.rotation += delta * 1.8
		CoreBridge.ENTITY_FAN:
			_overlay.position.x = sin(_pulse_time * 5.0) * 5.0
		CoreBridge.ENTITY_SPIKES:
			_body.position.y = sin(_pulse_time * 2.0) * 0.5
		CoreBridge.ENTITY_ITEM_BOX:
			rotation = sin(_pulse_time * 2.0) * 0.03
			_overlay.modulate.a = 0.82 + sin(_pulse_time * 4.0) * 0.12
		CoreBridge.ENTITY_PROPELLER:
			_overlay.rotation += delta * 5.0
			var propeller_scale := 1.0 + sin(_pulse_time * 4.0) * 0.06
			_overlay.scale = Vector2.ONE * propeller_scale
		CoreBridge.ENTITY_SPRING:
			scale = Vector2(1.0, 1.0 + sin(_pulse_time * 8.0) * 0.05)
			_overlay.position = Vector2(0.0, -6.0 + sin(_pulse_time * 9.0) * 1.5)
			_body.position = Vector2(0.0, 4.0 + sin(_pulse_time * 7.0) * 0.6)
		CoreBridge.ENTITY_BOUNCY_SPRING:
			var bar_pulse := 1.0 if not entity_state.activated else 0.82
			_body.scale.y = bar_pulse
			_overlay.scale.y = bar_pulse
		CoreBridge.ENTITY_LAYER_TOGGLE:
			_overlay.modulate.a = 0.62 + sin(_pulse_time * 5.0) * 0.22
		CoreBridge.ENTITY_RAMP:
			_body.modulate.a = 0.82 + sin(_pulse_time * 3.0) * 0.12
		CoreBridge.ENTITY_ROTATING_HANDLE:
			rotation = _pulse_time * (3.2 if not entity_state.activated else 7.0)
		CoreBridge.ENTITY_CORK_SCREW:
			rotation = sin(_pulse_time * 3.0) * 0.08
		CoreBridge.ENTITY_ENEMY:
			position.y = sin(_pulse_time * 4.0) * 3.0
			_overlay.rotation = sin(_pulse_time * 7.0) * 0.05
			_body.rotation = sin(_pulse_time * 2.0) * 0.03
		CoreBridge.ENTITY_CHECKPOINT:
			_overlay.rotation = sin(_pulse_time * 6.0) * 0.08
			var profile := CoreBridge.get_entity_visual_profile(entity_state.type, bool(entity_state.activated))
			var offset: Vector2 = profile.get("overlay_offset", Vector2(16.0, -20.0))
			_overlay.position.x = offset.x + sin(_pulse_time * 6.0) * 2.0
			_overlay.position.y = offset.y
			_overlay.modulate = profile.get("overlay_color", Color.WHITE)
		CoreBridge.ENTITY_GOAL:
			_overlay.rotation = sin(_pulse_time * 6.0) * 0.12
			var profile := CoreBridge.get_entity_visual_profile(entity_state.type, false)
			var offset: Vector2 = profile.get("overlay_offset", Vector2(18.0, -28.0))
			_overlay.position.x = offset.x + sin(_pulse_time * 5.5) * 2.5
			_overlay.position.y = offset.y
			_body.rotation = sin(_pulse_time * 2.8) * 0.04
		CoreBridge.ENTITY_GOAL_LEVER:
			_overlay.rotation = sin(_pulse_time * 6.0) * 0.12
			var lever_profile := CoreBridge.get_entity_visual_profile(entity_state.type, bool(entity_state.activated))
			var lever_offset: Vector2 = lever_profile.get("overlay_offset", Vector2(18.0, -28.0))
			_overlay.position = lever_offset
			_body.rotation = sin(_pulse_time * 2.8) * 0.04
		_:
			pass

func _make_ring_texture() -> Texture2D:
	var image := Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for y in range(32):
		for x in range(32):
			var dx := x - 16
			var dy := y - 16
			var dist := sqrt(float(dx * dx + dy * dy))
			if dist >= 10.0 and dist <= 14.0:
				image.set_pixel(x, y, Color(1.0, 0.82, 0.18, 1.0))
			elif dist >= 7.5 and dist <= 9.5:
				image.set_pixel(x, y, Color(0.98, 0.92, 0.48, 1.0))
	return ImageTexture.create_from_image(image)

func _make_ring_glint_texture() -> Texture2D:
	var image := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for y in range(16):
		for x in range(16):
			var dx := x - 5
			var dy := y - 5
			if dx * dx + dy * dy <= 6:
				image.set_pixel(x, y, Color(1.0, 1.0, 1.0, 0.55))
	return ImageTexture.create_from_image(image)

func _make_ring_effect_texture() -> Texture2D:
	var image := Image.create(40, 40, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for i in range(8):
		var angle: float = float(i) * TAU / 8.0
		var x := int(20.0 + cos(angle) * 16.0)
		var y := int(20.0 + sin(angle) * 16.0)
		for dx in range(-2, 3):
			for dy in range(-2, 3):
				if x + dx >= 0 and x + dx < 40 and y + dy >= 0 and y + dy < 40:
					image.set_pixel(x + dx, y + dy, Color(1.0, 0.86, 0.26, 0.95))
	return ImageTexture.create_from_image(image)

func _make_ring_effect_overlay_texture() -> Texture2D:
	var image := Image.create(40, 40, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for i in range(4):
		var angle: float = float(i) * PI / 2.0
		for step in range(12):
			var point := Vector2(20, 20) + Vector2(cos(angle), sin(angle)) * float(step)
			image.set_pixel(int(point.x), int(point.y), Color(1.0, 1.0, 0.82, 0.8))
	return ImageTexture.create_from_image(image)

func _make_heart_texture() -> Texture2D:
	var image := Image.create(28, 28, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for y in range(28):
		for x in range(28):
			var px := float(x - 14) / 10.0
			var py := float(y - 11) / 10.0
			var left_lobe := (px + 0.43) * (px + 0.43) + (py + 0.18) * (py + 0.18) <= 0.24
			var right_lobe := (px - 0.43) * (px - 0.43) + (py + 0.18) * (py + 0.18) <= 0.24
			var lower_point := py >= -0.15 and py <= 1.25 and absf(px) <= (1.25 - py) * 0.58
			if left_lobe or right_lobe or lower_point:
				image.set_pixel(x, y, Color(1.0, 0.28, 0.52, 0.95))
	return ImageTexture.create_from_image(image)

func _make_dust_texture() -> Texture2D:
	var image := Image.create(48, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for y in range(32):
		for x in range(48):
			var left := Vector2(x - 14, y - 18).length_squared() <= 105.0
			var center := Vector2(x - 24, y - 14).length_squared() <= 128.0
			var right := Vector2(x - 35, y - 18).length_squared() <= 92.0
			if left or center or right:
				image.set_pixel(x, y, Color(0.72, 0.76, 0.82, 0.82))
	return ImageTexture.create_from_image(image)

func _make_grind_effect_texture() -> Texture2D:
	var image := Image.create(28, 28, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for i in range(6):
		var point := Vector2(14, 14) + Vector2(cos(float(i) * PI / 3.0), sin(float(i) * PI / 3.0)) * 11.0
		for dx in range(-1, 2):
			for dy in range(-1, 2):
				var px := int(point.x) + dx
				var py := int(point.y) + dy
				if px >= 0 and px < 28 and py >= 0 and py < 28:
					image.set_pixel(px, py, Color(1.0, 0.88, 0.34, 0.95))
	return ImageTexture.create_from_image(image)

func _make_cheese_texture() -> Texture2D:
	var image := Image.create(34, 34, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for y in range(34):
		for x in range(34):
			var dx := x - 17
			var dy := y - 17
			if dx * dx + dy * dy <= 105:
				image.set_pixel(x, y, Color(1.0, 0.72, 0.22, 1.0))
	for i in range(5):
		image.set_pixel(10 + i, 7 + i, Color(0.34, 0.18, 0.08, 1.0))
		image.set_pixel(24 - i, 7 + i, Color(0.34, 0.18, 0.08, 1.0))
	return ImageTexture.create_from_image(image)

func _make_tail_swipe_texture() -> Texture2D:
	var image := Image.create(54, 42, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for i in range(30):
		var angle: float = -1.15 + float(i) * 2.3 / 29.0
		var point := Vector2(25, 30) + Vector2(cos(angle), sin(angle)) * (10.0 + float(i) * 0.55)
		image.set_pixel(int(point.x), int(point.y), Color(0.34, 0.78, 1.0, 0.88))
	return ImageTexture.create_from_image(image)

func _make_knuckles_fire_texture() -> Texture2D:
	var image := Image.create(38, 38, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for y in range(38):
		for x in range(38):
			var dx := float(x - 19)
			var dy := float(y - 19)
			var dist := sqrt(dx * dx + dy * dy)
			if dist <= 15.0:
				image.set_pixel(x, y, Color(1.0, 0.38, 0.08, 0.92))
			elif dist <= 9.0:
				image.set_pixel(x, y, Color(1.0, 0.88, 0.24, 1.0))
	return ImageTexture.create_from_image(image)

func _make_sonic_skid_texture() -> Texture2D:
	var image := Image.create(48, 38, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for i in range(28):
		var angle: float = -1.0 + float(i) * 2.0 / 27.0
		var radius := 8.0 + float(i) * 0.65
		var point := Vector2(23, 26) + Vector2(cos(angle), sin(angle)) * radius
		image.set_pixel(int(point.x), int(point.y), Color(0.36, 0.80, 1.0, 0.92))
	return ImageTexture.create_from_image(image)

func _make_spring_base_texture() -> Texture2D:
	var image := Image.create(32, 24, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(24):
		for x in range(32):
			if y >= 12:
				image.set_pixel(x, y, Color(0.12, 0.64, 1.0, 1.0))
			elif x >= 5 and x <= 26 and y >= 2:
				image.set_pixel(x, y, Color(0.22, 0.22, 0.28, 1.0))
	return ImageTexture.create_from_image(image)

func _make_spring_top_texture() -> Texture2D:
	var image := Image.create(32, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(16):
		for x in range(32):
			if y >= 4 and y <= 11 and x >= 4 and x <= 27:
				image.set_pixel(x, y, Color(0.93, 0.2, 0.3, 1.0))
			elif y >= 6 and y <= 9 and x >= 2 and x <= 29:
				image.set_pixel(x, y, Color(0.96, 0.96, 1.0, 1.0))
	return ImageTexture.create_from_image(image)

func _make_bouncy_bar_texture() -> Texture2D:
	var image := Image.create(56, 28, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(8, 23):
		for x in range(4, 52):
			if y <= 12 or y >= 18 or x <= 8 or x >= 47:
				image.set_pixel(x, y, Color(0.18, 0.64, 0.92, 1.0))
	return ImageTexture.create_from_image(image)

func _make_bouncy_bar_overlay_texture() -> Texture2D:
	var image := Image.create(56, 28, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for x in range(8, 48):
		image.set_pixel(x, 14, Color(1.0, 0.84, 0.24, 0.95))
		image.set_pixel(x, 15, Color(0.98, 0.44, 0.18, 0.90))
	return ImageTexture.create_from_image(image)

func _make_layer_toggle_texture() -> Texture2D:
	return _make_solid_texture(30, 48, Color(0.18, 0.28, 0.54, 0.86))

func _make_layer_toggle_overlay_texture(back_layer: bool) -> Texture2D:
	var image := Image.create(42, 42, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	var color := Color(0.38, 0.92, 1.0, 0.96) if not back_layer else Color(0.86, 0.56, 1.0, 0.96)
	for y in range(8, 34):
		var width := 7 if y < 22 else 7 - int((y - 22) * 0.3)
		for x in range(21 - width, 22 + width):
			image.set_pixel(x, y, color)
	return ImageTexture.create_from_image(image)

func _make_ramp_texture(reverse: bool) -> Texture2D:
	var image := Image.create(96, 64, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(8, 58):
		var edge := int((y - 8) * 1.65) if not reverse else 95 - int((y - 8) * 1.65)
		for x in range(96):
			if (not reverse and x >= edge) or (reverse and x <= edge):
				image.set_pixel(x, y, Color(0.22, 0.62, 0.34, 0.9))
	return ImageTexture.create_from_image(image)

func _make_handle_texture() -> Texture2D:
	return _make_solid_texture(18, 78, Color(0.68, 0.74, 0.82, 0.92))

func _make_handle_overlay_texture() -> Texture2D:
	var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for angle_step in range(24):
		var angle: float = float(angle_step) * TAU / 24.0
		var point := Vector2(32.0, 32.0) + Vector2(cos(angle), sin(angle)) * 25.0
		image.set_pixel(int(point.x), int(point.y), Color(0.96, 0.74, 0.26, 0.98))
	return ImageTexture.create_from_image(image)

func _make_corkscrew_texture(stop: bool) -> Texture2D:
	var image := Image.create(54, 54, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for i in range(28):
		var angle: float = float(i) * TAU / 18.0
		var radius := 5.0 + float(i) * 0.75
		var point := Vector2(27.0, 27.0) + Vector2(cos(angle), sin(angle)) * radius
		image.set_pixel(int(point.x), int(point.y), Color(0.94, 0.48, 0.20, 0.98) if not stop else Color(0.42, 0.80, 1.0, 0.98))
	return ImageTexture.create_from_image(image)

func _make_enemy_body_texture() -> Texture2D:
	var image := Image.create(32, 24, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(24):
		for x in range(32):
			var dx := x - 16
			var dy := y - 11
			if dx * dx + dy * dy <= 95:
				image.set_pixel(x, y, Color(0.95, 0.24, 0.26, 1.0))
			elif y >= 15 and x >= 6 and x <= 25:
				image.set_pixel(x, y, Color(0.18, 0.18, 0.2, 1.0))
	return ImageTexture.create_from_image(image)

func _make_enemy_face_texture() -> Texture2D:
	var image := Image.create(32, 24, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(24):
		for x in range(32):
			if (x - 12) * (x - 12) + (y - 10) * (y - 10) <= 4:
				image.set_pixel(x, y, Color.WHITE)
			if (x - 20) * (x - 20) + (y - 10) * (y - 10) <= 4:
				image.set_pixel(x, y, Color.WHITE)
			if y >= 12 and y <= 13 and x >= 12 and x <= 20:
				image.set_pixel(x, y, Color(0.2, 0.2, 0.22, 1.0))
	return ImageTexture.create_from_image(image)

func _make_checkpoint_pole_texture() -> Texture2D:
	var image := Image.create(20, 96, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(96):
		for x in range(20):
			if x >= 8 and x <= 11:
				image.set_pixel(x, y, Color(0.95, 0.95, 0.96, 1.0))
			elif x >= 7 and x <= 12 and y >= 6 and y <= 90:
				image.set_pixel(x, y, Color(0.22, 0.22, 0.28, 1.0))
			elif y >= 88 and x >= 5 and x <= 15:
				image.set_pixel(x, y, Color(0.4, 0.28, 0.16, 1.0))
	return ImageTexture.create_from_image(image)

func _make_goal_pole_texture() -> Texture2D:
	var image := Image.create(20, 96, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(96):
		for x in range(20):
			if x >= 8 and x <= 11:
				image.set_pixel(x, y, Color(0.96, 0.84, 0.18, 1.0))
			elif x >= 7 and x <= 12 and y >= 6 and y <= 90:
				image.set_pixel(x, y, Color(0.30, 0.24, 0.12, 1.0))
			elif y >= 88 and x >= 5 and x <= 15:
				image.set_pixel(x, y, Color(0.40, 0.28, 0.16, 1.0))
	return ImageTexture.create_from_image(image)

func _make_flag_texture(activated: bool) -> Texture2D:
	var image := Image.create(32, 20, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	var color := Color(0.16, 0.76, 0.34, 1.0) if not activated else Color(0.95, 0.38, 0.16, 1.0)
	for y in range(20):
		for x in range(32):
			if x >= 2 and x <= 23 and y >= 3 and y <= 13:
				image.set_pixel(x, y, color)
	return ImageTexture.create_from_image(image)

func _make_goal_flag_texture() -> Texture2D:
	var image := Image.create(36, 28, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(28):
		for x in range(36):
			if x >= 2 and x <= 25 and y >= 2 and y <= 8:
				image.set_pixel(x, y, Color(0.95, 0.84, 0.18, 1.0))
			elif x >= 2 and x <= 21 and y >= 9 and y <= 16:
				image.set_pixel(x, y, Color(0.16, 0.76, 0.34, 1.0))
			elif x >= 2 and x <= 17 and y >= 17 and y <= 23:
				image.set_pixel(x, y, Color(0.95, 0.38, 0.16, 1.0))
	return ImageTexture.create_from_image(image)

func _make_whirlwind_texture() -> Texture2D:
	return _make_solid_texture(112, 240, Color(0.20, 0.70, 0.96, 0.10))

func _make_whirlwind_overlay_texture() -> Texture2D:
	var image := Image.create(112, 240, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(240):
		var center := 56.0 + sin(float(y) * 0.08) * 18.0
		var half_width := 8.0 + float(y) * 0.08
		for x in range(112):
			if absf(float(x) - center) <= half_width:
				var alpha := 0.18 + (1.0 - absf(float(x) - center) / half_width) * 0.30
				image.set_pixel(x, y, Color(0.55, 0.90, 1.0, alpha))
	return ImageTexture.create_from_image(image)

func _make_fan_texture() -> Texture2D:
	return _make_solid_texture(88, 72, Color(0.18, 0.58, 0.92, 0.10))

func _make_fan_overlay_texture(direction: float) -> Texture2D:
	var image := Image.create(88, 72, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	var sign_direction := 1.0 if direction >= 0.0 else -1.0
	for row in range(3):
		var y := 14 + row * 22
		for x in range(12, 76):
			var local_x := float(x - 44) * sign_direction
			if local_x >= -22.0 and local_x <= 24.0 and absf(float(y - (14 + row * 22))) <= 3.0:
				image.set_pixel(x, y, Color(0.60, 0.92, 1.0, 0.72))
		var arrow_x := 68 if sign_direction > 0.0 else 20
		for x in range(8):
			image.set_pixel(arrow_x - int(sign_direction) * x, int(y - x / 2.0), Color(0.78, 0.98, 1.0, 0.75))
	return ImageTexture.create_from_image(image)

func _make_spikes_texture() -> Texture2D:
	var image := Image.create(64, 28, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for spike in range(4):
		var center := 8 + spike * 16
		for y in range(18):
			var half_width := int((18 - y) * 0.42)
			for x in range(center - half_width, center + half_width + 1):
				if x >= 0 and x < 64:
					image.set_pixel(x, y, Color(0.86, 0.90, 0.96, 1.0))
	for x in range(64):
		for y in range(18, 24):
			image.set_pixel(x, y, Color(0.26, 0.30, 0.40, 1.0))
	return ImageTexture.create_from_image(image)

func _make_item_box_texture() -> Texture2D:
	var image := Image.create(40, 40, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.96, 0.72, 0.16, 1.0))
	for y in range(4, 36):
		for x in range(4, 36):
			if x < 7 or x > 32 or y < 7 or y > 32:
				image.set_pixel(x, y, Color(0.18, 0.32, 0.58, 1.0))
	return ImageTexture.create_from_image(image)

func _make_item_box_icon_texture() -> Texture2D:
	var image := Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(6, 26):
		for x in range(6, 26):
			var dx := x - 16
			var dy := y - 16
			if dx * dx + dy * dy <= 52:
				image.set_pixel(x, y, Color(0.78, 0.94, 1.0, 0.92))
	return ImageTexture.create_from_image(image)

func _make_shield_icon_texture() -> Texture2D:
	var image := Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(5, 28):
		var width := int(4.0 + float(y - 5) * 0.45) if y < 17 else int(9.0 - float(y - 17) * 0.35)
		for x in range(16 - width, 17 + width):
			if x >= 0 and x < 32:
				image.set_pixel(x, y, Color(0.55, 0.92, 1.0, 0.95))
	return ImageTexture.create_from_image(image)

func _make_invincibility_icon_texture() -> Texture2D:
	var image := Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(4, 28):
		for x in range(4, 28):
			var dx := float(x - 16)
			var dy := float(y - 16)
			var angle: float = atan2(float(dy), float(dx))
			var radius := sqrt(dx * dx + dy * dy)
			var star_radius := 11.0 if int(floor((angle + PI) / (PI / 5.0))) % 2 == 0 else 5.0
			if radius <= star_radius:
				image.set_pixel(x, y, Color(1.0, 0.94, 0.34, 0.98))
	return ImageTexture.create_from_image(image)

func _make_propeller_texture() -> Texture2D:
	var image := Image.create(144, 144, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for y in range(144):
		for x in range(144):
			var dx := float(x - 72)
			var dy := float(y - 72)
			var radius := sqrt(dx * dx + dy * dy)
			if radius >= 62.0 and radius <= 65.0:
				image.set_pixel(x, y, Color(0.36, 0.72, 1.0, 0.34))
	return ImageTexture.create_from_image(image)

func _make_propeller_overlay_texture() -> Texture2D:
	var image := Image.create(128, 128, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))
	for blade in range(4):
		var angle: float = float(blade) * PI * 0.5
		var direction := Vector2(cos(angle), sin(angle))
		var side := Vector2(-direction.y, direction.x)
		for length in range(12, 58):
			var center := Vector2(64.0, 64.0) + direction * float(length)
			var width := 7.0 - float(length - 12) * 0.08
			for offset in range(-int(width), int(width) + 1):
				var pixel := center + side * float(offset)
				var px := int(pixel.x)
				var py := int(pixel.y)
				if px >= 0 and px < 128 and py >= 0 and py < 128:
					image.set_pixel(px, py, Color(0.66, 0.92, 1.0, 0.78))
		for y in range(56, 73):
			for x in range(56, 73):
				var dx := x - 64
				var dy := y - 64
				if dx * dx + dy * dy <= 72:
					image.set_pixel(x, y, Color(0.14, 0.30, 0.52, 1.0))
	return ImageTexture.create_from_image(image)

func _make_solid_texture(width: int, height: int, color: Color) -> Texture2D:
	var image := Image.create(width, height, false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
