# Source-inspired copyright card shown after the credits sequence.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _panel: ColorRect = null
var _rule: ColorRect = null
var _seal: ColorRect = null
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
	_set_screen_visible(CoreBridge.is_copyright_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_copyright_screen()
	_set_screen_visible(active)
	if not active:
		return
	_time += delta
	var pulse := 0.5 + sin(_time * 2.0) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_copyright_title_text()
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_copyright_prompt_text()
		prompt_label.modulate = Color(1.0, 0.88, 0.40, 0.86 + pulse * 0.14)
	if detail_label:
		detail_label.text = CoreBridge.get_copyright_detail_text()
		detail_label.modulate = Color(0.74, 0.86, 1.0, 0.88)
	if _rule:
		_rule.color = Color(0.28, 0.72, 1.0, 0.48 + pulse * 0.28)
	if _seal:
		_seal.color = Color(0.20, 0.52, 0.86, 0.20 + pulse * 0.12)

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.05, 0.98))
	_panel = _ensure_rect("CopyrightPanel", Rect2(188.0, 150.0, 904.0, 404.0), Color(0.05, 0.10, 0.20, 0.97))
	_rule = _ensure_rect("CopyrightRule", Rect2(286.0, 286.0, 708.0, 5.0), Color(0.28, 0.72, 1.0, 0.72))
	_seal = _ensure_rect("CopyrightSeal", Rect2(550.0, 352.0, 180.0, 94.0), Color(0.20, 0.52, 0.86, 0.28))
	_backdrop.z_index = -4
	_panel.z_index = -3
	_rule.z_index = -2
	_seal.z_index = -1

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
	for node in [_backdrop, _panel, _rule, _seal, title_label, prompt_label, detail_label]:
		if node:
			node.visible = screen_visible
