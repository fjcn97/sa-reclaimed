# ButtonConfigScreen.gd
# Presents an original-inspired dedicated button configuration screen.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _accent: ColorRect = null
var _header_band: ColorRect = null
var _summary_stage: ColorRect = null
var _bindings_stage: ColorRect = null
var _focus_plate: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _controls_card: ColorRect = null
var _prompt_band: ColorRect = null
var _summary_label: Label = null
var _badge_label: Label = null
var _row_cards: Array[ColorRect] = []
var _row_labels: Array[Label] = []
var _value_labels: Array[Label] = []
var _status_labels: Array[Label] = []

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_rows()
	_set_screen_visible(CoreBridge.is_button_config_screen())

func _process(_delta: float) -> void:
	var active: bool = CoreBridge.is_button_config_screen()
	_set_screen_visible(active)
	if not active:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 210.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_button_config_title_text()
		title_label.position = Vector2(312.0, 98.0)
		title_label.size = Vector2(524.0, 52.0)
		title_label.modulate = Color(0.99, 0.97, 0.90, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_button_config_prompt_text()
		prompt_label.position = Vector2(188.0, 518.0)
		prompt_label.size = Vector2(904.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.92, 0.58, 0.72 + (pulse * 0.28))
	if detail_label:
		detail_label.text = CoreBridge.get_button_config_detail_text()
		detail_label.position = Vector2(168.0, 632.0)
		detail_label.size = Vector2(944.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.74, 0.86, 1.0, 0.92)
	_update_chrome()
	_update_summary()
	_update_rows()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.04, 0.09, 0.68))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(190.0, 92.0, 900.0, 160.0), Color(0.38, 0.22, 0.10, 0.18))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(214.0, 94.0, 852.0, 92.0), Color(0.10, 0.08, 0.10, 0.94))
	_panel = _ensure_rect("Panel", Rect2(210.0, 212.0, 860.0, 336.0), Color(0.08, 0.08, 0.12, 0.96))
	_accent = _ensure_rect("AccentBar", Rect2(244.0, 172.0, 792.0, 8.0), Color(0.92, 0.48, 0.20, 0.92))
	_header_band = _ensure_rect("HeaderBand", Rect2(252.0, 234.0, 230.0, 236.0), Color(0.24, 0.14, 0.10, 0.92))
	_summary_stage = _ensure_rect("SummaryStage", Rect2(246.0, 228.0, 230.0, 236.0), Color(0.12, 0.09, 0.10, 0.94))
	_bindings_stage = _ensure_rect("BindingsStage", Rect2(516.0, 236.0, 488.0, 216.0), Color(0.10, 0.10, 0.14, 0.94))
	_focus_plate = _ensure_rect("FocusPlate", Rect2(532.0, 264.0, 456.0, 52.0), Color(0.50, 0.24, 0.10, 0.22))
	_badge_ring = _ensure_rect("BadgeRing", Rect2(908.0, 112.0, 110.0, 110.0), Color(0.92, 0.78, 0.24, 0.22))
	_badge_core = _ensure_rect("BadgeCore", Rect2(936.0, 140.0, 54.0, 54.0), Color(0.24, 0.14, 0.10, 0.96))
	_controls_card = _ensure_rect("ControlsCard", Rect2(518.0, 452.0, 486.0, 70.0), Color(0.09, 0.08, 0.12, 0.92))
	_prompt_band = _ensure_rect("PromptBand", Rect2(210.0, 568.0, 860.0, 82.0), Color(0.04, 0.08, 0.16, 0.92))
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_summary_stage.z_index = -3
	_bindings_stage.z_index = -3
	_focus_plate.z_index = -2
	_badge_ring.z_index = -2
	_badge_core.z_index = -1
	_controls_card.z_index = -1
	_prompt_band.z_index = -1

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

func _ensure_label(node_name: String, pos: Vector2, size: Vector2, font_size: int) -> Label:
	var label := get_node_or_null(node_name) as Label
	if label == null:
		label = Label.new()
		label.name = node_name
		add_child(label)
	label.position = pos
	label.size = size
	label.add_theme_font_size_override("font_size", font_size)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label

func _ensure_rows() -> void:
	if _summary_label == null:
		_summary_label = _ensure_label("SummaryLabel", Vector2(266.0, 266.0), Vector2(182.0, 164.0), 15)
		_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	if _row_labels.size() > 0:
		return
	for i in range(3):
		var top := 270.0 + float(i) * 58.0
		var card := _ensure_rect("RowCard%d" % i, Rect2(532.0, top, 456.0, 52.0), Color(0.10, 0.16, 0.29, 0.96))
		var row := _ensure_label("RowLabel%d" % i, Vector2(550.0, top + 2.0), Vector2(120.0, 46.0), 18)
		var value := _ensure_label("ValueLabel%d" % i, Vector2(682.0, top + 2.0), Vector2(188.0, 46.0), 18)
		var status := _ensure_label("StatusLabel%d" % i, Vector2(866.0, top + 2.0), Vector2(98.0, 46.0), 14)
		row.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		value.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(row)
		_value_labels.append(value)
		_status_labels.append(status)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_button_config_summary_text()
		_summary_label.modulate = Color(0.92, 0.95, 1.0, 0.98)
	if _badge_label == null:
		_badge_label = _ensure_label("BadgeLabel", Vector2(900.0, 152.0), Vector2(126.0, 30.0), 16)
	if _badge_label:
		_badge_label.text = "INPUT"
		_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

func _update_chrome() -> void:
	var colors := CoreBridge.get_button_config_chrome_colors()
	var accent := Color(colors.get("accent", Color(0.92, 0.48, 0.20, 1.0)))
	if _hero_glow:
		_hero_glow.color = Color(accent.r * 0.42, accent.g * 0.34, accent.b * 0.24, 0.18)
	if _accent:
		_accent.color = accent
	if _header_plate:
		_header_plate.color = Color(accent.r * 0.18, accent.g * 0.13, accent.b * 0.12, 0.92)
	if _header_band:
		_header_band.color = Color(accent.r * 0.28, accent.g * 0.20, accent.b * 0.14, 0.92)
	if _summary_stage:
		_summary_stage.color = Color(accent.r * 0.16, accent.g * 0.12, accent.b * 0.10, 0.94)
	if _bindings_stage:
		_bindings_stage.color = Color(accent.r * 0.10, accent.g * 0.11, accent.b * 0.16, 0.94)
	if _badge_core:
		_badge_core.color = Color(accent.r * 0.28, accent.g * 0.20, accent.b * 0.14, 0.96)
	if _controls_card:
		_controls_card.color = Color(0.09, 0.08, 0.12, 0.92)
	if _prompt_band:
		_prompt_band.color = Color(0.04, 0.08, 0.16, 0.92)
	if _focus_plate:
		_focus_plate.color = Color(accent.r * 0.56, accent.g * 0.30, accent.b * 0.14, 0.30)

func _update_rows() -> void:
	var rows: Array = CoreBridge.get_button_config_rows()
	var focus_y := 270.0 + float(CoreBridge.get_save_menu_index()) * 58.0
	if _focus_plate:
		_focus_plate.position.y = focus_y
	for i in range(_row_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_row_labels[i].visible = visible
		_value_labels[i].visible = visible
		_status_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var status_text := str(row.get("status", ""))
		var lift := -2.0 if is_selected else 0.0
		var top := 270.0 + float(i) * 58.0
		_row_cards[i].position.y = top + lift
		_row_labels[i].position.y = top + 2.0 + lift
		_value_labels[i].position.y = top + 2.0 + lift
		_status_labels[i].position.y = top + 2.0 + lift
		_row_cards[i].color = Color(0.58, 0.28, 0.14, 0.98) if is_selected else Color(0.12, 0.16, 0.24, 0.94)
		_row_labels[i].text = str(row.get("label", ""))
		_value_labels[i].text = str(row.get("value", ""))
		_status_labels[i].text = status_text
		_row_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0) if is_selected else Color(0.98, 0.98, 1.0, 0.98)
		_value_labels[i].modulate = Color(0.86, 0.92, 1.0, 0.98)
		_status_labels[i].modulate = Color(1.0, 0.82, 0.52, 1.0) if status_text == "ACTIVE" else Color(0.70, 0.78, 0.90, 0.88)

func _set_screen_visible(screen_visible: bool) -> void:
	if _backdrop:
		_backdrop.visible = screen_visible
	if _hero_glow:
		_hero_glow.visible = screen_visible
	if _header_plate:
		_header_plate.visible = screen_visible
	if _panel:
		_panel.visible = screen_visible
	if _accent:
		_accent.visible = screen_visible
	if _header_band:
		_header_band.visible = screen_visible
	if _summary_stage:
		_summary_stage.visible = screen_visible
	if _bindings_stage:
		_bindings_stage.visible = screen_visible
	if _focus_plate:
		_focus_plate.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _controls_card:
		_controls_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	for card in _row_cards:
		card.visible = screen_visible
	for label in _row_labels:
		label.visible = screen_visible
	for label in _value_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = screen_visible
