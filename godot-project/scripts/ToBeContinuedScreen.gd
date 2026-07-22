extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _glow: ColorRect = null
var _stripe: ColorRect = null
var _shadow: ColorRect = null
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
	_set_screen_visible(CoreBridge.is_to_be_continued_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_to_be_continued_screen()
	_set_screen_visible(active)
	if not active:
		return
	_pulse_time += delta * 2.0
	var sway := sin(_pulse_time) * 24.0
	if title_label:
		title_label.text = CoreBridge.get_to_be_continued_title_text()
		title_label.position = Vector2(170.0 + sway, 280.0)
		title_label.size = Vector2(940.0, 80.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_to_be_continued_prompt_text()
		prompt_label.position = Vector2(238.0, 400.0)
		prompt_label.size = Vector2(804.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.92, 0.64, 0.78 + absf(sin(_pulse_time * 1.2)) * 0.18)
	if detail_label:
		detail_label.text = CoreBridge.get_to_be_continued_detail_text()
		detail_label.position = Vector2(220.0, 612.0)
		detail_label.size = Vector2(840.0, 30.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.82, 0.90, 1.0, 0.92)
	_update_chrome()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.04, 0.92))
	_glow = _ensure_rect("CenterGlow", Rect2(148.0, 236.0, 984.0, 180.0), Color(0.12, 0.22, 0.38, 0.18))
	_stripe = _ensure_rect("CenterStripe", Rect2(184.0, 306.0, 912.0, 46.0), Color(0.10, 0.16, 0.28, 0.96))
	_shadow = _ensure_rect("ShadowStripe", Rect2(184.0, 360.0, 912.0, 18.0), Color(0.00, 0.00, 0.00, 0.34))
	_backdrop.z_index = -4
	_glow.z_index = -3
	_stripe.z_index = -2
	_shadow.z_index = -1

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
		_glow.color = Color(0.10, 0.22 + absf(sin(_pulse_time * 0.8)) * 0.06, 0.40, 0.18)
	if _stripe:
		_stripe.color = Color(0.10, 0.16, 0.28 + absf(sin(_pulse_time * 0.6)) * 0.04, 0.96)

func _set_screen_visible(screen_visible: bool) -> void:
	if _backdrop:
		_backdrop.visible = screen_visible
	if _glow:
		_glow.visible = screen_visible
	if _stripe:
		_stripe.visible = screen_visible
	if _shadow:
		_shadow.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
