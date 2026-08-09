# Source-inspired completion card shown between credits and copyright.
extends ScreenBase

const SourceTilemapTextureImpl = preload("res://scripts/SourceTilemapTexture.gd")

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _panel: ColorRect = null
var _shine: ColorRect = null
var _rule: ColorRect = null
var _source_card: TextureRect = null
var _source_cache: Dictionary = {}
var _source_name := ""
var _time: float = 0.0

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_set_screen_visible(CoreBridge.is_credits_end_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_credits_end_screen()
	_set_screen_visible(active)
	if not active:
		return
	_time += delta
	var pulse := 0.5 + sin(_time * 2.2) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_credits_end_title_text()
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_credits_end_prompt_text()
		prompt_label.modulate = Color(1.0, 0.86, 0.34, 0.86 + pulse * 0.14)
	if detail_label:
		detail_label.text = CoreBridge.get_credits_end_detail_text()
		detail_label.modulate = Color(0.74, 0.88, 1.0, 0.92)
	if _shine:
		_shine.color = Color(0.22, 0.60, 1.0, 0.12 + pulse * 0.10)
	if _rule:
		_rule.color = Color(1.0, 0.72, 0.20, 0.46 + pulse * 0.28)
	_update_source_card()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.06, 0.98))
	_panel = ensure_rect("CompletionPanel", Rect2(174.0, 142.0, 932.0, 430.0), Color(0.05, 0.11, 0.23, 0.98))
	_shine = ensure_rect("CompletionShine", Rect2(206.0, 178.0, 868.0, 138.0), Color(0.22, 0.60, 1.0, 0.16))
	_rule = ensure_rect("CompletionRule", Rect2(246.0, 360.0, 788.0, 6.0), Color(1.0, 0.72, 0.20, 0.66))
	_source_card = TextureRect.new()
	_source_card.name = "OriginalCreditsEndCard"
	_source_card.position = Vector2(400.0, 240.0)
	_source_card.size = Vector2(480.0, 320.0)
	_source_card.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_source_card.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_source_card.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_source_card.z_index = -1
	add_child(_source_card)
	_backdrop.z_index = -4
	_panel.z_index = -3
	_shine.z_index = -2
	_rule.z_index = -1

func _update_source_card() -> void:
	if _source_card == null:
		return
	var source := CoreBridge.get_credits_end_source_tilemap()
	if source == _source_name:
		return
	_source_name = source
	if not _source_cache.has(source):
		_source_cache[source] = SourceTilemapTextureImpl.compose(source)
	_source_card.texture = _source_cache[source] as Texture2D

func _set_screen_visible(screen_visible: bool) -> void:
	for node in [_backdrop, _panel, _shine, _rule, title_label, prompt_label, detail_label]:
		if node:
			node.visible = screen_visible
	if _source_card:
		_source_card.visible = screen_visible
