# Source-inspired completion card shown between credits and copyright.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _panel: ColorRect = null
var _shine: ColorRect = null
var _rule: ColorRect = null
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

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.06, 0.98))
	_panel = _ensure_rect("CompletionPanel", Rect2(174.0, 142.0, 932.0, 430.0), Color(0.05, 0.11, 0.23, 0.98))
	_shine = _ensure_rect("CompletionShine", Rect2(206.0, 178.0, 868.0, 138.0), Color(0.22, 0.60, 1.0, 0.16))
	_rule = _ensure_rect("CompletionRule", Rect2(246.0, 360.0, 788.0, 6.0), Color(1.0, 0.72, 0.20, 0.66))
	_backdrop.z_index = -4
	_panel.z_index = -3
	_shine.z_index = -2
	_rule.z_index = -1

func _ensure_rect(node_name: String, rect: Rect2, color: Color) -> ColorRect:
	var node := get_node_or_null(node_name) as ColorRect
	if node == null:
		node = ColorRect.new()
		node.name = node_name
		add_child(node)
	node.position = rect.position
	node.size = rect.size
	node.color = color
	return node

func _set_screen_visible(screen_visible: bool) -> void:
	for node in [_backdrop, _panel, _shine, _rule, title_label, prompt_label, detail_label]:
		if node:
			node.visible = screen_visible
