# EntitySprite.gd
# Reusable sprite-based stage entity presentation for the Godot remake.
extends Node2D
class_name EntitySprite

const ENTITY_TYPES := preload("res://scripts/core/EntityTypes.gd")
const TEXTURE_FACTORY := preload("res://scripts/ui/EntitySpriteTextureFactory.gd")
var _texture_factory := TEXTURE_FACTORY.new()

@export var state_bridge_path: NodePath = NodePath("/root/CoreBridge")

var entity_state = null
var _body: Sprite2D = null
var _overlay: Sprite2D = null
var _fallback: StageEntity = null
var _pulse_time: float = 0.0
var _bridge: Node = null

func _ready() -> void:
	_bridge = get_node_or_null(state_bridge_path)
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
	if _bridge == null:
		_bridge = get_node_or_null(state_bridge_path)
	if entity_state == null:
		visible = false
		return
	if entity_state.type == ENTITY_TYPES.ENTITY_LAP_TRIGGER:
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

	if _bridge == null:
		_bridge = get_node_or_null(state_bridge_path)
		if _bridge == null:
			return
	var profile: Dictionary = _bridge.get_entity_visual_profile(entity_state.type, bool(entity_state.activated))
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
		ENTITY_TYPES.ENTITY_RING, ENTITY_TYPES.ENTITY_SCATTER_RING:
			_body.texture = _texture_factory.make_ring_texture()
			_overlay.texture = _texture_factory.make_ring_glint_texture()
		ENTITY_TYPES.ENTITY_SPECIAL_RING:
			_body.texture = _texture_factory.make_ring_texture()
			_overlay.texture = _texture_factory.make_ring_glint_texture()
			_body.modulate = Color(0.30, 0.86, 1.0, 1.0)
			_overlay.modulate = Color(0.78, 1.0, 1.0, 1.0)
		ENTITY_TYPES.ENTITY_RING_EFFECT:
			_body.texture = _texture_factory.make_ring_effect_texture()
			_overlay.texture = _texture_factory.make_ring_effect_overlay_texture()
		ENTITY_TYPES.ENTITY_HEART_EFFECT:
			_body.texture = _texture_factory.make_heart_texture()
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_DUST_EFFECT:
			_body.texture = _texture_factory.make_dust_texture()
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_GRIND_EFFECT:
			_body.texture = _texture_factory.make_grind_effect_texture()
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_CHEESE:
			_body.texture = _texture_factory.make_cheese_texture()
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_TAIL_SWIPE:
			_body.texture = _texture_factory.make_tail_swipe_texture()
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_KNUCKLES_FIRE:
			_body.texture = _texture_factory.make_knuckles_fire_texture()
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_SONIC_SKID:
			_body.texture = _texture_factory.make_sonic_skid_texture()
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_WHIRLWIND:
			_body.texture = _texture_factory.make_whirlwind_texture()
			_overlay.texture = _texture_factory.make_whirlwind_overlay_texture()
		ENTITY_TYPES.ENTITY_FAN:
			_body.texture = _texture_factory.make_fan_texture()
			_overlay.texture = _texture_factory.make_fan_overlay_texture(entity_state.velocity_x)
		ENTITY_TYPES.ENTITY_SPIKES:
			_body.texture = _texture_factory.make_spikes_texture()
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_ITEM_BOX:
			_body.texture = _texture_factory.make_item_box_texture()
			_overlay.texture = _texture_factory.item_box_icon_texture(entity_state.item_kind)
			_overlay.modulate = _texture_factory.item_box_icon_color(entity_state.item_kind)
		ENTITY_TYPES.ENTITY_PROPELLER:
			_body.texture = _texture_factory.make_propeller_texture()
			_overlay.texture = _texture_factory.make_propeller_overlay_texture()
		ENTITY_TYPES.ENTITY_SPRING:
			_body.texture = _texture_factory.make_spring_base_texture()
			_overlay.texture = _texture_factory.make_spring_top_texture()
		ENTITY_TYPES.ENTITY_BOUNCY_SPRING:
			_body.texture = _texture_factory.make_bouncy_bar_texture() if entity_state.variant == 2 else _texture_factory.make_spring_base_texture()
			_overlay.texture = _texture_factory.make_bouncy_bar_overlay_texture() if entity_state.variant == 2 else _texture_factory.make_spring_top_texture()
		ENTITY_TYPES.ENTITY_LAYER_TOGGLE:
			_body.texture = _texture_factory.make_layer_toggle_texture()
			_overlay.texture = _texture_factory.make_layer_toggle_overlay_texture(entity_state.variant == 1)
		ENTITY_TYPES.ENTITY_RAMP:
			_body.texture = _texture_factory.make_ramp_texture(entity_state.variant == 1)
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_ROTATING_HANDLE:
			_body.texture = _texture_factory.make_handle_texture()
			_overlay.texture = _texture_factory.make_handle_overlay_texture()
		ENTITY_TYPES.ENTITY_CORK_SCREW:
			_body.texture = _texture_factory.make_corkscrew_texture(entity_state.variant == 1)
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_ENEMY:
			# Source enemies carry a species profile. Let StageEntity render that
			# profile so imported enemies keep their individual silhouettes,
			# projectiles, trails, and attack poses instead of sharing one generic
			# texture.
			use_fallback = true
			_body.texture = null
			_overlay.texture = null
		ENTITY_TYPES.ENTITY_CHECKPOINT:
			_body.texture = _texture_factory.make_checkpoint_pole_texture()
			_overlay.texture = _texture_factory.make_flag_texture(entity_state.activated)
		ENTITY_TYPES.ENTITY_GOAL:
			_body.texture = _texture_factory.make_goal_pole_texture()
			_overlay.texture = _texture_factory.make_goal_flag_texture()
		ENTITY_TYPES.ENTITY_GOAL_LEVER:
			_body.texture = _texture_factory.make_goal_pole_texture()
			_overlay.texture = _texture_factory.make_goal_flag_texture()
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
		ENTITY_TYPES.ENTITY_RING, ENTITY_TYPES.ENTITY_SCATTER_RING:
			rotation += delta * 3.0
			var pulse := 1.0 + sin(_pulse_time * 5.0) * 0.08
			scale = Vector2.ONE * pulse
			_overlay.rotation = -rotation
		ENTITY_TYPES.ENTITY_SPECIAL_RING:
			rotation += delta * 2.2
			var special_pulse := 1.0 + sin(_pulse_time * 4.0) * 0.10
			scale = Vector2.ONE * special_pulse
			_overlay.rotation = -rotation
		ENTITY_TYPES.ENTITY_RING_EFFECT:
			var effect_progress := clampf(entity_state.state_timer / 0.34, 0.0, 1.0)
			scale = Vector2.ONE * (0.55 + effect_progress * 0.9)
			modulate = Color(1.0, 0.94, 0.62, 1.0 - effect_progress)
			_overlay.rotation += delta * 8.0
		ENTITY_TYPES.ENTITY_HEART_EFFECT:
			var heart_progress := clampf(entity_state.state_timer / 0.72, 0.0, 1.0)
			scale = Vector2.ONE * (0.72 + sin(heart_progress * PI) * 0.18)
			modulate = Color(1.0, 0.40, 0.60, 1.0 - heart_progress)
			rotation = sin(_pulse_time * 8.0) * 0.12
		ENTITY_TYPES.ENTITY_DUST_EFFECT:
			var dust_progress := clampf(entity_state.state_timer / 0.48, 0.0, 1.0)
			scale = Vector2.ONE * (0.72 + dust_progress * 0.58)
			modulate = Color(0.78, 0.82, 0.86, 0.78 * (1.0 - dust_progress))
		ENTITY_TYPES.ENTITY_GRIND_EFFECT:
			scale = Vector2.ONE * (0.72 + sin(_pulse_time * 14.0) * 0.16)
			modulate = Color(1.0, 0.82, 0.30, 0.92)
			rotation = _pulse_time * 7.0
		ENTITY_TYPES.ENTITY_CHEESE:
			scale = Vector2.ONE * (0.82 + sin(_pulse_time * 5.0) * 0.08)
			modulate = Color(0.98, 0.72, 0.42, 1.0)
			rotation = sin(_pulse_time * 3.0) * 0.10
		ENTITY_TYPES.ENTITY_TAIL_SWIPE:
			var swipe_progress := clampf(entity_state.state_timer / 0.28, 0.0, 1.0)
			scale = Vector2.ONE * (0.65 + swipe_progress * 0.55)
			modulate = Color(0.70, 0.92, 1.0, 1.0 - swipe_progress)
			rotation = (-0.8 if entity_state.variant == 1 else 0.8) + swipe_progress * 1.8
		ENTITY_TYPES.ENTITY_KNUCKLES_FIRE:
			var fire_progress := clampf(entity_state.state_timer / 0.36, 0.0, 1.0)
			scale = Vector2.ONE * (0.68 + sin(fire_progress * PI) * 0.28)
			modulate = Color(1.0, 0.34 + fire_progress * 0.35, 0.12, 1.0 - fire_progress)
			rotation = _pulse_time * 10.0
		ENTITY_TYPES.ENTITY_SONIC_SKID:
			var skid_progress := clampf(entity_state.state_timer / 0.32, 0.0, 1.0)
			scale = Vector2.ONE * (0.70 + skid_progress * 0.45)
			modulate = Color(0.42, 0.78, 1.0, 1.0 - skid_progress)
			rotation = (-0.55 if entity_state.variant == 1 else 0.55) + skid_progress * 1.4
		ENTITY_TYPES.ENTITY_WHIRLWIND:
			rotation = sin(_pulse_time * 1.5) * 0.08
			_overlay.rotation += delta * 1.8
		ENTITY_TYPES.ENTITY_FAN:
			_overlay.position.x = sin(_pulse_time * 5.0) * 5.0
		ENTITY_TYPES.ENTITY_SPIKES:
			_body.position.y = sin(_pulse_time * 2.0) * 0.5
		ENTITY_TYPES.ENTITY_ITEM_BOX:
			rotation = sin(_pulse_time * 2.0) * 0.03
			_overlay.modulate.a = 0.82 + sin(_pulse_time * 4.0) * 0.12
		ENTITY_TYPES.ENTITY_PROPELLER:
			_overlay.rotation += delta * 5.0
			var propeller_scale := 1.0 + sin(_pulse_time * 4.0) * 0.06
			_overlay.scale = Vector2.ONE * propeller_scale
		ENTITY_TYPES.ENTITY_SPRING:
			scale = Vector2(1.0, 1.0 + sin(_pulse_time * 8.0) * 0.05)
			_overlay.position = Vector2(0.0, -6.0 + sin(_pulse_time * 9.0) * 1.5)
			_body.position = Vector2(0.0, 4.0 + sin(_pulse_time * 7.0) * 0.6)
		ENTITY_TYPES.ENTITY_BOUNCY_SPRING:
			var bar_pulse := 1.0 if not entity_state.activated else 0.82
			_body.scale.y = bar_pulse
			_overlay.scale.y = bar_pulse
		ENTITY_TYPES.ENTITY_LAYER_TOGGLE:
			_overlay.modulate.a = 0.62 + sin(_pulse_time * 5.0) * 0.22
		ENTITY_TYPES.ENTITY_RAMP:
			_body.modulate.a = 0.82 + sin(_pulse_time * 3.0) * 0.12
		ENTITY_TYPES.ENTITY_ROTATING_HANDLE:
			# The original sprite follows the handle's accumulated rot field;
			# effect_offset is kept in sync by CoreBridge for presentation code.
			rotation = entity_state.rotating_handle_angle
		ENTITY_TYPES.ENTITY_CORK_SCREW:
			rotation = sin(_pulse_time * 3.0) * 0.08
		ENTITY_TYPES.ENTITY_ENEMY:
			position.y = sin(_pulse_time * 4.0) * 3.0
			_overlay.rotation = sin(_pulse_time * 7.0) * 0.05
			_body.rotation = sin(_pulse_time * 2.0) * 0.03
		ENTITY_TYPES.ENTITY_CHECKPOINT:
			_overlay.rotation = sin(_pulse_time * 6.0) * 0.08
			var profile: Dictionary = _bridge.get_entity_visual_profile(entity_state.type, bool(entity_state.activated)) if _bridge != null else {}
			var offset: Vector2 = profile.get("overlay_offset", Vector2(16.0, -20.0))
			_overlay.position.x = offset.x + sin(_pulse_time * 6.0) * 2.0
			_overlay.position.y = offset.y
			_overlay.modulate = profile.get("overlay_color", Color.WHITE)
		ENTITY_TYPES.ENTITY_GOAL:
			_overlay.rotation = sin(_pulse_time * 6.0) * 0.12
			var profile: Dictionary = _bridge.get_entity_visual_profile(entity_state.type, false) if _bridge != null else {}
			var offset: Vector2 = profile.get("overlay_offset", Vector2(18.0, -28.0))
			_overlay.position.x = offset.x + sin(_pulse_time * 5.5) * 2.5
			_overlay.position.y = offset.y
			_body.rotation = sin(_pulse_time * 2.8) * 0.04
		ENTITY_TYPES.ENTITY_GOAL_LEVER:
			_overlay.rotation = sin(_pulse_time * 6.0) * 0.12
			var lever_profile: Dictionary = _bridge.get_entity_visual_profile(entity_state.type, bool(entity_state.activated)) if _bridge != null else {}
			var lever_offset: Vector2 = lever_profile.get("overlay_offset", Vector2(18.0, -28.0))
			_overlay.position = lever_offset
			_body.rotation = sin(_pulse_time * 2.8) * 0.04
		_:
			pass
