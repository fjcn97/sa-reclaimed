# Source-inspired character unlock cutscene shown after a qualifying course clear.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _panel: ColorRect = null
var _portrait: ColorRect = null
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
	_set_screen_visible(CoreBridge.is_character_unlock_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_character_unlock_screen()
	_set_screen_visible(active)
	if not active:
		return
	_time += delta
	var pulse := 0.5 + sin(_time * 2.4) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_character_unlock_title_text()
		title_label.modulate = Color(0.96, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_character_unlock_prompt_text()
		prompt_label.modulate = Color(1.0, 0.82, 0.28, 0.86 + pulse * 0.14)
	if detail_label:
		detail_label.text = CoreBridge.get_character_unlock_detail_text()
		detail_label.modulate = Color(0.74, 0.88, 1.0, 0.92)
	if _portrait:
		_portrait.color = Color(0.24, 0.66, 1.0, 0.20 + pulse * 0.16)
	if _shine:
		_shine.color = Color(0.22, 0.60, 1.0, 0.10 + pulse * 0.10)
	if _rule:
		_rule.color = Color(1.0, 0.70, 0.18, 0.48 + pulse * 0.24)

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.06, 0.98))
	_panel = _ensure_rect("UnlockPanel", Rect2(168.0, 108.0, 944.0, 500.0), Color(0.05, 0.11, 0.23, 0.98))
	_portrait = _ensure_rect("PortraitCard", Rect2(244.0, 246.0, 220.0, 190.0), Color(0.24, 0.66, 1.0, 0.28))
	_shine = _ensure_rect("UnlockShine", Rect2(512.0, 178.0, 536.0, 164.0), Color(0.22, 0.60, 1.0, 0.14))
	_rule = _ensure_rect("UnlockRule", Rect2(226.0, 470.0, 828.0, 6.0), Color(1.0, 0.70, 0.18, 0.66))
	_backdrop.z_index = -5
	_panel.z_index = -4
	_portrait.z_index = -3
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
	for node in [_backdrop, _panel, _portrait, _shine, _rule, title_label, prompt_label, detail_label]:
		if node:
			node.visible = screen_visible
