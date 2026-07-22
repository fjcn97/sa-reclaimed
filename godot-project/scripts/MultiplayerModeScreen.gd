extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _header_band: ColorRect = null
var _accent: ColorRect = null
var _header_glow: ColorRect = null
var _left_stage: ColorRect = null
var _right_stage: ColorRect = null
var _option_stage: ColorRect = null
var _vs_ring: ColorRect = null
var _vs_core: ColorRect = null
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _focus_plate: ColorRect = null
var _focus_header: Label = null
var _focus_body: Label = null
var _badge_label: Label = null
var _summary_label: Label = null
var _option_cards: Array[ColorRect] = []
var _option_labels: Array[Label] = []
var _meta_labels: Array[Label] = []
var _status_labels: Array[Label] = []
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
	_ensure_option_labels()
	_set_screen_visible(CoreBridge.is_multiplayer_mode_screen())

func _process(delta: float) -> void:
	var active: bool = CoreBridge.is_multiplayer_mode_screen()
	_set_screen_visible(active)
	if not active:
		return
	_pulse_time += delta * 2.6
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 220.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_multiplayer_mode_title_text()
		title_label.position = Vector2(330.0, 72.0)
		title_label.size = Vector2(620.0, 54.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.10, 0.21, 0.43, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_multiplayer_mode_prompt_text()
		prompt_label.position = Vector2(170.0, 564.0)
		prompt_label.size = Vector2(940.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(0.92, 0.43, 0.14, 0.76 + (pulse * 0.18))
	if detail_label:
		detail_label.text = "%s\n%s" % [CoreBridge.get_multiplayer_mode_info_text(), CoreBridge.get_multiplayer_mode_detail_text()]
		detail_label.position = Vector2(154.0, 618.0)
		detail_label.size = Vector2(972.0, 54.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.17, 0.28, 0.46, 0.95)
	_update_chrome()
	_update_option_labels()
	_update_summary()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.98, 0.98, 0.97, 1.0))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(102.0, 98.0, 1076.0, 506.0), Color(0.99, 0.71, 0.31, 0.14))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(150.0, 68.0, 980.0, 82.0), Color(1.0, 1.0, 1.0, 0.98))
	_header_band = _ensure_rect("HeaderBand", Rect2(150.0, 150.0, 980.0, 10.0), Color(0.95, 0.46, 0.13, 1.0))
	_panel = _ensure_rect("Panel", Rect2(118.0, 170.0, 1044.0, 348.0), Color(1.0, 1.0, 1.0, 0.98))
	_accent = _ensure_rect("AccentBar", Rect2(796.0, 170.0, 366.0, 348.0), Color(0.95, 0.47, 0.12, 0.96))
	_header_glow = _ensure_rect("HeaderGlow", Rect2(150.0, 62.0, 980.0, 6.0), Color(0.11, 0.26, 0.56, 0.20))
	_left_stage = _ensure_rect("LeftStage", Rect2(160.0, 214.0, 438.0, 258.0), Color(0.94, 0.96, 1.0, 0.96))
	_right_stage = _ensure_rect("RightStage", Rect2(640.0, 214.0, 466.0, 258.0), Color(0.97, 0.55, 0.18, 0.96))
	_option_stage = _ensure_rect("OptionStage", Rect2(184.0, 236.0, 392.0, 214.0), Color(0.90, 0.94, 1.0, 0.96))
	_vs_ring = _ensure_rect("VsRing", Rect2(720.0, 238.0, 142.0, 142.0), Color(1.0, 1.0, 1.0, 0.20))
	_vs_core = _ensure_rect("VsCore", Rect2(756.0, 274.0, 70.0, 70.0), Color(1.0, 1.0, 1.0, 0.92))
	_summary_card = _ensure_rect("SummaryCard", Rect2(884.0, 236.0, 222.0, 214.0), Color(1.0, 0.86, 0.70, 0.94))
	_prompt_band = _ensure_rect("PromptBand", Rect2(118.0, 534.0, 1044.0, 148.0), Color(1.0, 0.97, 0.93, 0.98))
	_focus_plate = _ensure_rect("FocusPlate", Rect2(650.0, 236.0, 214.0, 214.0), Color(1.0, 0.64, 0.21, 0.92))
	_badge_label = _ensure_label("BadgeLabel", Vector2(752.0, 288.0), Vector2(112.0, 34.0), 24)
	_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_summary_label = _ensure_label("SummaryLabel", Vector2(904.0, 262.0), Vector2(184.0, 178.0), 15)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_focus_header = _ensure_label("FocusHeader", Vector2(672.0, 246.0), Vector2(170.0, 44.0), 28)
	_focus_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_focus_body = _ensure_label("FocusBody", Vector2(674.0, 314.0), Vector2(166.0, 112.0), 16)
	_focus_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_focus_body.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_focus_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_header_band.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_glow.z_index = -4
	_left_stage.z_index = -4
	_right_stage.z_index = -4
	_option_stage.z_index = -3
	_focus_plate.z_index = -3
	_summary_card.z_index = -3
	_prompt_band.z_index = -2
	_vs_ring.z_index = -1
	_vs_core.z_index = 0

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
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label

func _ensure_option_labels() -> void:
	if _option_labels.size() > 0:
		return
	for i in range(2):
		var top := 262.0 + float(i) * 102.0
		var card := _ensure_rect("OptionCard%d" % i, Rect2(202.0, top, 356.0, 78.0), Color(0.88, 0.92, 1.0, 1.0))
		var option := _ensure_label("OptionLabel%d" % i, Vector2(226.0, top + 10.0), Vector2(182.0, 28.0), 26)
		var meta := _ensure_label("MetaLabel%d" % i, Vector2(228.0, top + 42.0), Vector2(226.0, 18.0), 11)
		var status := _ensure_label("StatusLabel%d" % i, Vector2(428.0, top + 24.0), Vector2(108.0, 20.0), 13)
		option.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_option_cards.append(card)
		_option_labels.append(option)
		_meta_labels.append(meta)
		_status_labels.append(status)

func _update_option_labels() -> void:
	var rows: Array = CoreBridge.get_multiplayer_mode_rows()
	for i in range(_option_labels.size()):
		var visible := i < rows.size()
		_option_cards[i].visible = visible
		_option_labels[i].visible = visible
		_meta_labels[i].visible = visible
		_status_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var top := 262.0 + float(i) * 102.0
		var lift := -6.0 if is_selected else 0.0
		_option_cards[i].position = Vector2(202.0, top + lift)
		_option_cards[i].size = Vector2(372.0, 82.0) if is_selected else Vector2(356.0, 78.0)
		_option_labels[i].position = Vector2(226.0, top + 10.0 + lift)
		_meta_labels[i].position = Vector2(228.0, top + 44.0 + lift)
		_status_labels[i].position = Vector2(430.0, top + 24.0 + lift)
		_option_cards[i].color = _get_card_color(is_selected)
		_option_labels[i].text = str(row.get("name", ""))
		_option_labels[i].modulate = Color(1.0, 1.0, 1.0, 1.0) if is_selected else Color(0.10, 0.21, 0.43, 1.0)
		_meta_labels[i].text = str(row.get("description", ""))
		_meta_labels[i].modulate = Color(1.0, 0.94, 0.86, 0.96) if is_selected else Color(0.25, 0.39, 0.60, 0.96)
		var status_text := str(row.get("status", ""))
		_status_labels[i].text = status_text
		_status_labels[i].modulate = Color(1.0, 0.98, 0.88, 1.0) if is_selected else Color(0.92, 0.36, 0.12, 1.0)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_multiplayer_mode_summary_text()
		_summary_label.modulate = Color(0.34, 0.23, 0.12, 0.96)
	if _badge_label:
		_badge_label.text = CoreBridge.get_multiplayer_mode_badge_text()
		_badge_label.modulate = Color(1.0, 1.0, 1.0, 0.98)
	if _focus_header:
		_focus_header.text = CoreBridge.get_multiplayer_mode_badge_text()
		_focus_header.modulate = Color(1.0, 1.0, 1.0, 0.98)
	if _focus_body:
		_focus_body.text = CoreBridge.get_multiplayer_mode_info_text()
		_focus_body.modulate = Color(1.0, 0.97, 0.90, 0.98)

func _update_chrome() -> void:
	var chrome := CoreBridge.get_multiplayer_mode_chrome_colors()
	if _accent:
		_accent.color = Color(chrome.get("accent", _accent.color))
	if _hero_glow:
		var accent_glow: Color = Color(chrome.get("accent", _hero_glow.color))
		_hero_glow.color = Color(accent_glow.r, accent_glow.g, accent_glow.b, 0.10 + absf(sin(_pulse_time * 0.6)) * 0.05)
	if _header_plate:
		_header_plate.color = Color(1.0, 1.0, 1.0, 0.98)
	if _header_band:
		_header_band.color = Color(chrome.get("accent", _header_band.color))
	if _panel:
		_panel.color = Color(1.0, 1.0, 1.0, 0.98)
	if _left_stage:
		_left_stage.color = Color(0.94, 0.96, 1.0, 0.96)
	if _right_stage:
		var right_color: Color = Color(chrome.get("accent", _right_stage.color))
		_right_stage.color = Color(right_color.r, min(right_color.g + 0.05, 1.0), min(right_color.b + 0.04, 1.0), 0.96)
	if _option_stage:
		_option_stage.color = Color(0.90, 0.94, 1.0, 0.96)
	if _focus_plate:
		var focus_color: Color = Color(chrome.get("accent", _focus_plate.color))
		_focus_plate.color = Color(focus_color.r, focus_color.g, focus_color.b, 0.92)
	if _vs_ring:
		var badge: Color = Color(chrome.get("badge", _vs_ring.color))
		_vs_ring.color = Color(1.0, 1.0, 1.0, 0.14 + absf(sin(_pulse_time)) * 0.08)
	if _vs_core:
		_vs_core.color = Color(1.0, 1.0, 1.0, 0.92)
	if _summary_card:
		_summary_card.color = Color(1.0, 0.86, 0.70, 0.94)
	if _prompt_band:
		_prompt_band.color = Color(1.0, 0.97, 0.93, 0.98)
	if _header_glow:
		_header_glow.color = Color(0.10, 0.21, 0.43, 0.12 + absf(sin(_pulse_time * 0.9)) * 0.06)

func _get_card_color(selected: bool) -> Color:
	if selected:
		return Color(0.14, 0.30, 0.58, 0.98) if CoreBridge.get_multiplayer_mode_badge_text() == "LINK" else Color(0.94, 0.46, 0.14, 0.98)
	return Color(0.88, 0.92, 1.0, 1.0)

func _set_screen_visible(screen_visible: bool) -> void:
	if _backdrop:
		_backdrop.visible = screen_visible
	if _hero_glow:
		_hero_glow.visible = screen_visible
	if _header_plate:
		_header_plate.visible = screen_visible
	if _header_band:
		_header_band.visible = screen_visible
	if _panel:
		_panel.visible = screen_visible
	if _accent:
		_accent.visible = screen_visible
	if _header_glow:
		_header_glow.visible = screen_visible
	if _left_stage:
		_left_stage.visible = screen_visible
	if _right_stage:
		_right_stage.visible = screen_visible
	if _option_stage:
		_option_stage.visible = screen_visible
	if _vs_ring:
		_vs_ring.visible = screen_visible
	if _vs_core:
		_vs_core.visible = screen_visible
	if _summary_card:
		_summary_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _focus_plate:
		_focus_plate.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _focus_header:
		_focus_header.visible = screen_visible
	if _focus_body:
		_focus_body.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	for card in _option_cards:
		card.visible = screen_visible
	for label in _option_labels:
		label.visible = screen_visible
	for label in _meta_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = screen_visible
