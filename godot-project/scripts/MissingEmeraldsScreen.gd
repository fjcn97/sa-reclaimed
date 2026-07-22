# MissingEmeraldsScreen.gd
# Ports the original notification shown when the story ends before all emeralds.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _panel: ColorRect = null
var _accent: ColorRect = null
var _slots: Array[ColorRect] = []
var _slot_labels: Array[Label] = []
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
	_set_screen_visible(CoreBridge.is_missing_emeralds_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_missing_emeralds_screen()
	_set_screen_visible(active)
	if not active:
		return
	_time += delta
	var pulse := 0.5 + sin(_time * 2.4) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_missing_emeralds_title_text()
		title_label.modulate = Color(1.0, 0.90, 0.46, 0.92 + pulse * 0.08)
	if prompt_label:
		prompt_label.text = CoreBridge.get_missing_emeralds_prompt_text()
		prompt_label.modulate = Color(0.72, 0.88, 1.0, 0.94)
	if detail_label:
		detail_label.text = CoreBridge.get_missing_emeralds_detail_text()
		detail_label.modulate = Color(1.0, 0.92, 0.66, 0.76 + pulse * 0.20)
	_update_slots()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.03, 0.08, 0.98))
	_panel = _ensure_rect("NotificationPanel", Rect2(164.0, 132.0, 952.0, 430.0), Color(0.06, 0.12, 0.24, 0.96))
	_accent = _ensure_rect("AccentBar", Rect2(232.0, 244.0, 816.0, 6.0), Color(0.28, 0.72, 1.0, 0.78))
	_backdrop.z_index = -4
	_panel.z_index = -3
	_accent.z_index = -2
	for i in range(7):
		var x := 370.0 + float(i) * 80.0
		var slot := _ensure_rect("EmeraldSlot%d" % i, Rect2(x, 332.0, 48.0, 48.0), Color(0.12, 0.18, 0.30, 1.0))
		var label := _ensure_label("EmeraldLabel%d" % i, Vector2(x, 382.0), Vector2(48.0, 24.0), 11)
		label.text = "?"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_slots.append(slot)
		_slot_labels.append(label)

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

func _ensure_label(node_name: String, pos: Vector2, size: Vector2, font_size: int) -> Label:
	var node := get_node_or_null(node_name) as Label
	if node == null:
		node = Label.new()
		node.name = node_name
		add_child(node)
	node.position = pos
	node.size = size
	node.add_theme_font_size_override("font_size", font_size)
	node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return node

func _update_slots() -> void:
	var collected := CoreBridge.get_missing_emeralds_count()
	for i in range(_slots.size()):
		var found := i < collected
		_slots[i].color = Color(0.20, 0.72, 0.48, 0.98) if found else Color(0.16, 0.20, 0.30, 0.98)
		_slot_labels[i].text = "OK" if found else "?"
		_slot_labels[i].modulate = Color(0.76, 1.0, 0.84, 1.0) if found else Color(0.52, 0.60, 0.74, 0.94)

func _set_screen_visible(screen_visible: bool) -> void:
	if _backdrop:
		_backdrop.visible = screen_visible
	if _panel:
		_panel.visible = screen_visible
	if _accent:
		_accent.visible = screen_visible
	for node in _slots:
		node.visible = screen_visible
	for node in _slot_labels:
		node.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
