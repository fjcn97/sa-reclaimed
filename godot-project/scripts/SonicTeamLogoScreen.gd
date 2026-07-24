extends CanvasLayer

const SourceTilemapTextureImpl = preload("res://scripts/SourceTilemapTexture.gd")

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _panel: ColorRect = null
var _accent: ColorRect = null
var _source_logo: TextureRect = null
var _source_texture: Texture2D = null
var _pulse_time: float = 0.0

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_set_screen_visible(CoreBridge.is_sonic_team_logo_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_sonic_team_logo_screen()
	_set_screen_visible(active)
	if not active:
		return
	_pulse_time += delta * 1.2
	var pulse := 0.5 + sin(_pulse_time) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_sonic_team_logo_title_text()
		title_label.position = Vector2(180.0, 248.0)
		title_label.size = Vector2(920.0, 96.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_sonic_team_logo_prompt_text()
		prompt_label.position = Vector2(250.0, 370.0)
		prompt_label.size = Vector2(780.0, 36.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(0.80, 0.90, 1.0, 0.76 + pulse * 0.18)
	if detail_label:
		detail_label.text = CoreBridge.get_sonic_team_logo_detail_text()
		detail_label.position = Vector2(260.0, 544.0)
		detail_label.size = Vector2(760.0, 28.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.76, 0.86, 1.0, 0.86)
	_update_chrome()
	_update_source_logo()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.04, 0.11, 0.96))
	_panel = _ensure_rect("Panel", Rect2(180.0, 210.0, 920.0, 230.0), Color(0.08, 0.16, 0.30, 0.90))
	_accent = _ensure_rect("Accent", Rect2(220.0, 462.0, 840.0, 6.0), Color(0.30, 0.76, 1.0, 0.44))
	_source_logo = TextureRect.new()
	_source_logo.name = "OriginalCreatedBySonicTeam"
	_source_logo.position = Vector2(400.0, 200.0)
	_source_logo.size = Vector2(480.0, 320.0)
	_source_logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_source_logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_source_logo.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_source_logo.z_index = -1
	add_child(_source_logo)
	_backdrop.z_index = -3
	_panel.z_index = -2
	_accent.z_index = -1

func _ensure_rect(node_name: String, rect: Rect2, color: Color) -> ColorRect:
	var rect_node := get_node_or_null(node_name) as ColorRect
	if rect_node == null:
		rect_node = ColorRect.new()
		rect_node.name = node_name
		add_child(rect_node)
	rect_node.position = rect.position
	rect_node.size = rect.size
	rect_node.color = color
	return rect_node

func _update_chrome() -> void:
	if _accent:
		_accent.color = Color(0.30, 0.76, 1.0, 0.30 + absf(sin(_pulse_time * 1.1)) * 0.22)

func _update_source_logo() -> void:
	if _source_logo == null:
		return
	if _source_texture == null:
		_source_texture = SourceTilemapTextureImpl.compose(CoreBridge.get_sonic_team_logo_source_tilemap())
	_source_logo.texture = _source_texture

func _set_screen_visible(screen_visible: bool) -> void:
	if _backdrop:
		_backdrop.visible = screen_visible
	if _panel:
		_panel.visible = screen_visible
	if _accent:
		_accent.visible = screen_visible
	if _source_logo:
		_source_logo.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
