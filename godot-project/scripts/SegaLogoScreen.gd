extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _band: ColorRect = null
var _glow: ColorRect = null
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
	_set_screen_visible(CoreBridge.is_sega_logo_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_sega_logo_screen()
	_set_screen_visible(active)
	if not active:
		return
	_pulse_time += delta * 1.6
	var pulse := 0.5 + sin(_pulse_time) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_sega_logo_title_text()
		title_label.position = Vector2(200.0, 260.0)
		title_label.size = Vector2(880.0, 120.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.22, 0.58, 0.96, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_sega_logo_prompt_text()
		prompt_label.position = Vector2(240.0, 402.0)
		prompt_label.size = Vector2(800.0, 32.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(0.86, 0.94, 1.0, 0.74 + pulse * 0.20)
	if detail_label:
		detail_label.text = CoreBridge.get_sega_logo_detail_text()
		detail_label.position = Vector2(320.0, 594.0)
		detail_label.size = Vector2(640.0, 28.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.80, 0.88, 1.0, 0.88)
	_update_chrome()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.94, 0.97, 1.0, 1.0))
	_band = _ensure_rect("LogoBand", Rect2(210.0, 286.0, 860.0, 72.0), Color(0.08, 0.20, 0.56, 0.94))
	_glow = _ensure_rect("LogoGlow", Rect2(176.0, 240.0, 928.0, 168.0), Color(0.24, 0.60, 0.98, 0.10))
	_backdrop.z_index = -3
	_glow.z_index = -2
	_band.z_index = -1

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
	if _glow:
		_glow.color = Color(0.24, 0.60, 0.98, 0.08 + absf(sin(_pulse_time * 1.4)) * 0.06)

func _set_screen_visible(screen_visible: bool) -> void:
	if _backdrop:
		_backdrop.visible = screen_visible
	if _band:
		_band.visible = screen_visible
	if _glow:
		_glow.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
