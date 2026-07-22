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
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge: ColorRect = null
var _summary_label: Label = null
var _badge_label: Label = null
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
	_ensure_option_rows()
	_set_screen_visible(CoreBridge.is_play_mode_screen())

func _process(delta: float) -> void:
	var screen_visible := CoreBridge.is_play_mode_screen()
	_set_screen_visible(screen_visible)
	if not screen_visible:
		return

	_pulse_time += delta * 2.4
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 220.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_play_mode_title_text()
		title_label.position = Vector2(338.0, 76.0)
		title_label.size = Vector2(604.0, 52.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.14, 0.24, 0.44, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_play_mode_prompt_text()
		prompt_label.position = Vector2(164.0, 558.0)
		prompt_label.size = Vector2(952.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(0.18, 0.50, 0.88, 0.76 + (pulse * 0.18)) if CoreBridge.get_title_menu_index() == 0 else Color(0.90, 0.40, 0.16, 0.76 + (pulse * 0.18))
	if detail_label:
		detail_label.text = "%s\n%s" % [CoreBridge.get_play_mode_info_text(), CoreBridge.get_play_mode_detail_text()]
		detail_label.position = Vector2(148.0, 606.0)
		detail_label.size = Vector2(984.0, 64.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.16, 0.28, 0.48, 0.96)
	_update_chrome()
	_update_option_rows()
	_update_summary()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.98, 0.99, 1.0, 1.0))
	_hero_glow = _ensure_rect("PlayModeHeroGlow", Rect2(104.0, 96.0, 1072.0, 504.0), Color(0.24, 0.54, 0.96, 0.10))
	_header_plate = _ensure_rect("PlayModeHeaderPlate", Rect2(150.0, 68.0, 980.0, 82.0), Color(1.0, 1.0, 1.0, 0.98))
	_header_band = _ensure_rect("PlayModeHeaderBand", Rect2(160.0, 214.0, 412.0, 258.0), Color(0.90, 0.95, 1.0, 0.98))
	_panel = _ensure_rect("PlayModePanel", Rect2(118.0, 170.0, 1044.0, 352.0), Color(0.98, 0.99, 1.0, 0.99))
	_accent = _ensure_rect("PlayModeAccent", Rect2(118.0, 150.0, 1044.0, 10.0), Color(0.18, 0.54, 0.94, 0.96))
	_header_glow = _ensure_rect("PlayModeHeaderGlow", Rect2(150.0, 62.0, 980.0, 6.0), Color(0.16, 0.26, 0.46, 0.16))
	_left_stage = _ensure_rect("PlayModeLeftStage", Rect2(160.0, 214.0, 412.0, 258.0), Color(0.90, 0.95, 1.0, 0.98))
	_right_stage = _ensure_rect("PlayModeRightStage", Rect2(610.0, 214.0, 236.0, 258.0), Color(0.20, 0.54, 0.96, 0.94))
	_option_stage = _ensure_rect("PlayModeOptionStage", Rect2(184.0, 236.0, 364.0, 214.0), Color(0.94, 0.97, 1.0, 0.99))
	_badge_ring = _ensure_rect("PlayModeBadgeRing", Rect2(890.0, 224.0, 224.0, 224.0), Color(0.24, 0.54, 0.96, 0.24))
	_badge = _ensure_rect("PlayModeBadge", Rect2(952.0, 286.0, 100.0, 100.0), Color(1.0, 1.0, 1.0, 0.96))
	_summary_card = _ensure_rect("PlayModeSummaryCard", Rect2(638.0, 236.0, 180.0, 214.0), Color(0.96, 0.98, 1.0, 0.98))
	_prompt_band = _ensure_rect("PlayModePromptBand", Rect2(118.0, 534.0, 1044.0, 148.0), Color(0.96, 0.98, 1.0, 0.99))
	_badge_label = _ensure_label("PlayModeBadgeLabel", Vector2(902.0, 316.0), Vector2(200.0, 34.0), 24)
	_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_summary_label = _ensure_label("PlayModeSummaryLabel", Vector2(884.0, 464.0), Vector2(228.0, 116.0), 16)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
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
	_summary_card.z_index = -3
	_prompt_band.z_index = -2
	_badge_ring.z_index = -1
	_badge.z_index = 0

func _ensure_option_rows() -> void:
	if _option_cards.size() > 0:
		return
	for i in range(2):
		var top := 270.0 + float(i) * 92.0
		var card := _ensure_rect("PlayModeCard%d" % i, Rect2(206.0, top, 320.0, 72.0), Color(0.88, 0.93, 1.0, 1.0))
		var option := _ensure_label("PlayModeOption%d" % i, Vector2(228.0, top + 10.0), Vector2(176.0, 28.0), 24)
		var meta := _ensure_label("PlayModeMeta%d" % i, Vector2(230.0, top + 42.0), Vector2(184.0, 16.0), 10)
		var status := _ensure_label("PlayModeStatus%d" % i, Vector2(404.0, top + 24.0), Vector2(96.0, 18.0), 12)
		option.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_option_cards.append(card)
		_option_labels.append(option)
		_meta_labels.append(meta)
		_status_labels.append(status)

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

func _update_option_rows() -> void:
	var rows: Array = CoreBridge.get_play_mode_rows()
	for i in range(_option_cards.size()):
		var visible := i < rows.size()
		_option_cards[i].visible = visible
		_option_labels[i].visible = visible
		_meta_labels[i].visible = visible
		_status_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var selected := bool(row.get("selected", false))
		var top := 270.0 + float(i) * 92.0
		var lift := -6.0 if selected else 0.0
		_option_cards[i].position = Vector2(206.0, top + lift)
		_option_cards[i].size = Vector2(332.0, 76.0) if selected else Vector2(320.0, 72.0)
		_option_labels[i].position = Vector2(228.0, top + 10.0 + lift)
		_meta_labels[i].position = Vector2(230.0, top + 42.0 + lift)
		_status_labels[i].position = Vector2(404.0, top + 24.0 + lift)
		_option_cards[i].color = _get_card_color(str(row.get("status", "")), selected)
		_option_labels[i].text = str(row.get("name", ""))
		_option_labels[i].modulate = Color(1.0, 1.0, 1.0, 1.0) if selected else Color(0.12, 0.22, 0.44, 1.0)
		_meta_labels[i].text = str(row.get("description", ""))
		_meta_labels[i].modulate = Color(0.96, 0.98, 1.0, 0.96) if selected else Color(0.28, 0.40, 0.60, 0.96)
		var status_text := str(row.get("status", ""))
		_status_labels[i].text = status_text
		_status_labels[i].modulate = _get_status_color(status_text)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_play_mode_summary_text()
		_summary_label.modulate = Color(0.14, 0.22, 0.38, 0.98)
	if _badge_label:
		_badge_label.text = CoreBridge.get_play_mode_badge_text()
		_badge_label.modulate = Color(0.12, 0.22, 0.44, 0.98)

func _update_chrome() -> void:
	var chrome := CoreBridge.get_play_mode_chrome_colors()
	var accent: Color = Color(chrome.get("accent", _accent.color))
	var panel_color: Color = Color(chrome.get("panel", _panel.color))
	var summary_color: Color = Color(chrome.get("summary", _summary_card.color))
	var badge_color: Color = Color(chrome.get("badge", _badge.color))
	var glow_alpha := 0.20 + absf(sin(_pulse_time * 0.6)) * 0.08
	if _accent:
		_accent.color = accent
	if _hero_glow:
		_hero_glow.color = Color(accent.r, accent.g, accent.b, glow_alpha * 0.6)
	if _header_plate:
		_header_plate.color = Color(1.0, 1.0, 1.0, 0.98)
	if _header_band:
		_header_band.color = Color(0.90, 0.95, 1.0, 0.98)
	if _panel:
		_panel.color = Color(0.98, 0.99, 1.0, 0.99)
	if _left_stage:
		_left_stage.color = Color(0.90, 0.95, 1.0, 0.98)
	if _right_stage:
		_right_stage.color = Color(accent.r, accent.g, accent.b, 0.94)
	if _option_stage:
		_option_stage.color = Color(0.94, 0.97, 1.0, 0.99)
	if _summary_card:
		_summary_card.color = Color(0.96, 0.98, 1.0, 0.98)
	if _prompt_band:
		_prompt_band.color = Color(0.96, 0.98, 1.0, 0.99)
	if _badge_ring:
		_badge_ring.color = Color(accent.r, accent.g, accent.b, 0.16 + absf(sin(_pulse_time)) * 0.10)
	if _badge:
		_badge.color = Color(1.0, 1.0, 1.0, 0.96)
	if _header_glow:
		_header_glow.color = Color(0.16, 0.26, 0.46, 0.12 + absf(sin(_pulse_time * 0.9)) * 0.06)

func _get_card_color(status_text: String, selected: bool) -> Color:
	if selected:
		if status_text == "READY":
			return Color(0.18, 0.50, 0.88, 0.98)
		return Color(0.90, 0.40, 0.16, 0.98)
	return Color(0.88, 0.93, 1.0, 1.0)

func _get_status_color(status_text: String) -> Color:
	if status_text == "READY":
		return Color(0.18, 0.52, 0.84, 1.0)
	return Color(0.84, 0.38, 0.18, 1.0)

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
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge:
		_badge.visible = screen_visible
	if _summary_card:
		_summary_card.visible = screen_visible
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
	for card in _option_cards:
		card.visible = screen_visible
	for label in _option_labels:
		label.visible = screen_visible
	for label in _meta_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = screen_visible
