# Source-inspired character unlock cutscene shown after a qualifying course clear.
extends ScreenBase

const SourceTilemapTextureImpl = preload("res://scripts/SourceTilemapTexture.gd")

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _panel: ColorRect = null
var _portrait: ColorRect = null
var _shine: ColorRect = null
var _rule: ColorRect = null
var _slide_texture: TextureRect = null
var _dialogue_texture: TextureRect = null
var _source_cache: Dictionary = {}
var _dialogue_cache: Dictionary = {}
var _slide_name := ""
var _dialogue_name := ""
var _time: float = 0.0
var _bridge: Node = null

func _ready() -> void:
	_bridge = resolve_state_bridge()
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_set_screen_visible(_bridge != null and _bridge.is_character_unlock_screen())

func _process(delta: float) -> void:
	if _bridge == null:
		_bridge = resolve_state_bridge()
	var active: bool = _bridge != null and _bridge.is_character_unlock_screen()
	_set_screen_visible(active)
	if not active:
		return
	_time += delta
	var pulse := 0.5 + sin(_time * 2.4) * 0.5
	if title_label:
		title_label.text = _bridge.get_character_unlock_title_text()
		title_label.modulate = Color(0.96, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = _bridge.get_character_unlock_prompt_text()
		prompt_label.modulate = Color(1.0, 0.82, 0.28, 0.86 + pulse * 0.14)
	if detail_label:
		detail_label.text = _bridge.get_character_unlock_detail_text()
		detail_label.modulate = Color(0.74, 0.88, 1.0, 0.92)
	if _portrait:
		_portrait.color = Color(0.24, 0.66, 1.0, 0.20 + pulse * 0.16)
	if _shine:
		_shine.color = Color(0.22, 0.60, 1.0, 0.10 + pulse * 0.10)
	if _rule:
		_rule.color = Color(1.0, 0.70, 0.18, 0.48 + pulse * 0.24)
	_update_source_cards()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.06, 0.98))
	_panel = ensure_rect("UnlockPanel", Rect2(168.0, 108.0, 944.0, 500.0), Color(0.05, 0.11, 0.23, 0.98))
	_portrait = ensure_rect("PortraitCard", Rect2(244.0, 246.0, 220.0, 190.0), Color(0.24, 0.66, 1.0, 0.28))
	_shine = ensure_rect("UnlockShine", Rect2(512.0, 178.0, 536.0, 164.0), Color(0.22, 0.60, 1.0, 0.14))
	_rule = ensure_rect("UnlockRule", Rect2(226.0, 470.0, 828.0, 6.0), Color(1.0, 0.70, 0.18, 0.66))
	_slide_texture = _create_source_texture("OriginalUnlockSlide", Vector2(204.0, 226.0), Vector2(270.0, 180.0), -2)
	_dialogue_texture = _create_source_texture("OriginalUnlockDialogue", Vector2(486.0, 504.0), Vector2(574.0, 80.0), -1)
	_backdrop.z_index = -5
	_panel.z_index = -4
	_portrait.z_index = -3
	_shine.z_index = -2
	_rule.z_index = -1

func _create_source_texture(node_name: String, position: Vector2, size: Vector2, layer_index: int) -> TextureRect:
	var node := TextureRect.new()
	node.name = node_name
	node.position = position
	node.size = size
	node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	node.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	node.z_index = layer_index
	add_child(node)
	return node

func _update_source_cards() -> void:
	if _slide_texture == null or _dialogue_texture == null:
		return
	var slide_name: String = _bridge.get_character_unlock_source_slide_tilemap()
	var dialogue_name: String = _bridge.get_character_unlock_source_dialogue_tilemap()
	if slide_name != _slide_name:
		_slide_name = slide_name
		if not _source_cache.has(slide_name) and not slide_name.is_empty():
			_source_cache[slide_name] = SourceTilemapTextureImpl.compose(slide_name)
		_slide_texture.texture = _source_cache[slide_name] as Texture2D if not slide_name.is_empty() else null
	if dialogue_name != _dialogue_name:
		_dialogue_name = dialogue_name
		if not _dialogue_cache.has(dialogue_name) and not dialogue_name.is_empty():
			_dialogue_cache[dialogue_name] = SourceTilemapTextureImpl.compose(dialogue_name)
		_dialogue_texture.texture = _dialogue_cache[dialogue_name] as Texture2D if not dialogue_name.is_empty() else null

func _set_screen_visible(screen_visible: bool) -> void:
	for node in [_backdrop, _panel, _portrait, _shine, _rule, title_label, prompt_label, detail_label]:
		if node:
			node.visible = screen_visible
	if _slide_texture:
		_slide_texture.visible = screen_visible
	if _dialogue_texture:
		_dialogue_texture.visible = screen_visible
