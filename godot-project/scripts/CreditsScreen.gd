# CreditsScreen.gd
# Source-aligned timed credits pages with manual advance and skip input.
extends ScreenBase

const SourceTilemapTextureImpl = preload("res://scripts/SourceTilemapTexture.gd")

@export var title_label: Label = null
@export var page_label: Label = null
@export var prompt_label: Label = null

var _backdrop: ColorRect = null
var _glow: ColorRect = null
var _panel: ColorRect = null
var _rule: ColorRect = null
var _page_index_label: Label = null
var _slide_texture: TextureRect = null
var _slide_cache: Dictionary = {}
var _active_slide_source := ""
var _time: float = 0.0

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if page_label == null:
		page_label = get_node_or_null("PageLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	_ensure_chrome()
	_set_screen_visible(CoreBridge.is_credits_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_credits_screen()
	_set_screen_visible(active)
	if not active:
		return
	_time += delta
	var pulse := 0.5 + sin(_time * 2.0) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_credits_title_text()
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if page_label:
		page_label.text = "%s  |  %s" % [CoreBridge.get_credits_page_text(), CoreBridge.get_credits_source_group_text()]
		page_label.modulate = Color(0.76, 0.90, 1.0, 0.82 + pulse * 0.16)
	if prompt_label:
		prompt_label.text = CoreBridge.get_credits_detail_text()
		prompt_label.modulate = Color(1.0, 0.88, 0.42, 0.76 + pulse * 0.20)
	if _page_index_label:
		_page_index_label.text = CoreBridge.get_credits_page_index_text()
	_update_chrome(pulse)
	_update_slide()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.06, 0.98))
	_glow = ensure_rect("CenterGlow", Rect2(130.0, 120.0, 1020.0, 470.0), Color(0.10, 0.28, 0.54, 0.18))
	_panel = ensure_rect("CreditsPanel", Rect2(196.0, 166.0, 888.0, 376.0), Color(0.05, 0.10, 0.20, 0.96))
	_rule = ensure_rect("CreditsRule", Rect2(270.0, 286.0, 740.0, 5.0), Color(0.28, 0.72, 1.0, 0.72))
	_page_index_label = ensure_label("PageIndexLabel", Vector2(510.0, 478.0), Vector2(260.0, 30.0), 14)
	_page_index_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_slide_texture = get_node_or_null("OriginalCreditsSlide") as TextureRect
	if _slide_texture == null:
		_slide_texture = TextureRect.new()
		_slide_texture.name = "OriginalCreditsSlide"
		add_child(_slide_texture)
	_slide_texture.position = Vector2(400.0, 240.0)
	_slide_texture.size = Vector2(480.0, 320.0)
	_slide_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_slide_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_slide_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_slide_texture.z_index = 0
	_backdrop.z_index = -4
	_glow.z_index = -3
	_panel.z_index = -2
	_rule.z_index = -1

func _update_chrome(pulse: float) -> void:
	if _glow:
		_glow.color = Color(0.10, 0.28 + pulse * 0.06, 0.54, 0.15 + pulse * 0.08)
	if _rule:
		_rule.color = Color(0.28, 0.72, 1.0, 0.52 + pulse * 0.30)

func _update_slide() -> void:
	if _slide_texture == null:
		return
	var source := CoreBridge.get_credits_source_tilemap()
	if source == _active_slide_source:
		return
	_active_slide_source = source
	if not _slide_cache.has(source):
		_slide_cache[source] = SourceTilemapTextureImpl.compose(source)
	_slide_texture.texture = _slide_cache[source] as Texture2D

func _set_screen_visible(screen_visible: bool) -> void:
	if _backdrop:
		_backdrop.visible = screen_visible
	if _glow:
		_glow.visible = screen_visible
	if _panel:
		_panel.visible = screen_visible
	if _rule:
		_rule.visible = screen_visible
	if _page_index_label:
		_page_index_label.visible = screen_visible
	if _slide_texture:
		_slide_texture.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if page_label:
		page_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
