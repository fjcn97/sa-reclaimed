extends SimpleListMenuScreen

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
var _bridge: Node = null

func _ready() -> void:
	set_process(true)
	_bridge = resolve_state_bridge()
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_option_rows()
	_set_screen_visible(_bridge != null and _bridge.is_play_mode_screen())

func _process(delta: float) -> void:
	if _bridge == null:
		_bridge = resolve_state_bridge()
		if _bridge == null:
			_set_screen_visible(false)
			return
	var screen_visible: bool = _bridge.is_play_mode_screen()
	_set_screen_visible(screen_visible)
	if not screen_visible:
		return

	_pulse_time += delta * 2.4
	if title_label:
		title_label.text = _bridge.get_play_mode_title_text()
		title_label.position = Vector2(338.0, 76.0)
		title_label.size = Vector2(604.0, 52.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.14, 0.24, 0.44, 1.0)
	if prompt_label:
		prompt_label.visible = false
	if detail_label:
		detail_label.text = _bridge.get_play_mode_detail_text()
		detail_label.position = Vector2(148.0, 636.0)
		detail_label.size = Vector2(984.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.16, 0.28, 0.48, 0.96)
	_update_chrome()
	_update_option_rows()
	_update_summary()

func _ensure_chrome() -> void:
	var chrome := ensure_simple_list_chrome({"glow": Color(0.24, 0.54, 0.96, 0.10), "panel": Color(0.98, 0.99, 1.0, 0.99), "accent": Color(0.18, 0.54, 0.94, 0.96), "footer": Color(0.96, 0.98, 1.0, 0.99)})
	_backdrop = chrome["backdrop"]
	_hero_glow = chrome["hero_glow"]
	_header_plate = chrome["header_plate"]
	_panel = chrome["panel"]
	_accent = chrome["accent"]
	_prompt_band = chrome["prompt_band"]
	_header_band = ensure_rect("PlayModeHeaderBand", LIST_STAGE_RECT, Color(0.90, 0.95, 1.0, 0.98))
	_header_glow = ensure_rect("PlayModeHeaderGlow", Rect2(150.0, 62.0, 980.0, 6.0), Color(0.16, 0.26, 0.46, 0.16))
	_left_stage = ensure_rect("PlayModeLeftStage", LIST_STAGE_RECT, Color(0.90, 0.95, 1.0, 0.98))
	_right_stage = ensure_rect("PlayModeRightStage", Rect2(610.0, 214.0, 236.0, 258.0), Color(0.20, 0.54, 0.96, 0.94))
	_option_stage = ensure_rect("PlayModeOptionStage", LIST_STAGE_RECT, Color(0.94, 0.97, 1.0, 0.99))
	_badge_ring = ensure_rect("PlayModeBadgeRing", Rect2(890.0, 224.0, 224.0, 224.0), Color(0.24, 0.54, 0.96, 0.24))
	_badge = ensure_rect("PlayModeBadge", Rect2(952.0, 286.0, 100.0, 100.0), Color(1.0, 1.0, 1.0, 0.96))
	_summary_card = ensure_rect("PlayModeSummaryCard", Rect2(638.0, 236.0, 180.0, 214.0), Color(0.96, 0.98, 1.0, 0.98))
	_badge_label = ensure_label("PlayModeBadgeLabel", Vector2(902.0, 316.0), Vector2(200.0, 34.0), 24)
	_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_summary_label = ensure_label("PlayModeSummaryLabel", Vector2(280.0, 414.0), Vector2(720.0, 104.0), 17)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_header_band.z_index = -7
	_header_glow.z_index = -4
	_left_stage.z_index = -4
	_right_stage.z_index = -4
	_option_stage.z_index = -3
	_summary_card.z_index = -3
	_badge_ring.z_index = -1
	_badge.z_index = 0

func _ensure_option_rows() -> void:
	if _option_cards.size() > 0:
		return
	for i in range(2):
		var top := 250.0 + float(i) * 58.0
		var card := ensure_rect("PlayModeCard%d" % i, Rect2(LIST_ROW_X, top, LIST_ROW_WIDTH, 52.0), Color(0.88, 0.93, 1.0, 1.0))
		var option := ensure_label("PlayModeOption%d" % i, Vector2(LIST_LABEL_X, top + 2.0), Vector2(276.0, 48.0), 22)
		var meta := ensure_label("PlayModeMeta%d" % i, Vector2(LIST_VALUE_X, top + 2.0), Vector2(LIST_VALUE_WIDTH, 48.0), 14)
		var status := ensure_label("PlayModeStatus%d" % i, Vector2.ZERO, Vector2.ZERO, 1)
		option.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_option_cards.append(card)
		_option_labels.append(option)
		_meta_labels.append(meta)
		_status_labels.append(status)

func _update_option_rows() -> void:
	var rows: Array = _bridge.get_play_mode_rows()
	for i in range(_option_cards.size()):
		var visible := i < rows.size()
		_option_cards[i].visible = visible
		_option_labels[i].visible = visible
		_meta_labels[i].visible = visible
		_status_labels[i].visible = false
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var selected := bool(row.get("selected", false))
		var available := bool(row.get("available", true))
		var top := 250.0 + float(i) * 58.0
		var lift := 0.0
		_option_cards[i].position = Vector2(LIST_ROW_X, top + lift)
		_option_cards[i].size = Vector2(LIST_ROW_WIDTH, 52.0)
		_option_labels[i].position = Vector2(LIST_LABEL_X, top + 2.0 + lift)
		_meta_labels[i].position = Vector2(LIST_VALUE_X, top + 2.0 + lift)
		_status_labels[i].visible = false
		_option_cards[i].color = _get_card_color(available, selected)
		_option_labels[i].text = str(row.get("name", ""))
		_option_labels[i].modulate = Color(1.0, 1.0, 1.0, 1.0) if selected else Color(0.12, 0.22, 0.44, 1.0)
		_meta_labels[i].text = str(row.get("description", ""))
		_meta_labels[i].modulate = Color(0.96, 0.98, 1.0, 0.96) if selected else Color(0.28, 0.40, 0.60, 0.96)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = _bridge.get_play_mode_summary_text()
		_summary_label.modulate = Color(0.14, 0.22, 0.38, 0.98)
	if _badge_label:
		_badge_label.visible = false

func _update_chrome() -> void:
	var chrome: Dictionary = _bridge.get_play_mode_chrome_colors() if _bridge else {}
	var accent: Color = Color(chrome.get("accent", _accent.color))
	var panel_color: Color = Color(chrome.get("panel", _panel.color))
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
		_right_stage.visible = false
	if _option_stage:
		_option_stage.color = Color(0.94, 0.97, 1.0, 0.99)
	if _summary_card:
		_summary_card.visible = false
	if _prompt_band:
		_prompt_band.color = Color(0.96, 0.98, 1.0, 0.99)
	if _badge_ring:
		_badge_ring.visible = false
	if _badge:
		_badge.visible = false
	if _header_glow:
		_header_glow.color = Color(0.16, 0.26, 0.46, 0.12 + absf(sin(_pulse_time * 0.9)) * 0.06)

func _get_card_color(available: bool, selected: bool) -> Color:
	if selected:
		if available:
			return Color(0.18, 0.50, 0.88, 0.98)
		return Color(0.90, 0.40, 0.16, 0.98)
	return Color(0.88, 0.93, 1.0, 1.0)

func _get_status_color(available: bool) -> Color:
	if available:
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
		_right_stage.visible = false
	if _option_stage:
		_option_stage.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = false
	if _badge:
		_badge.visible = false
	if _summary_card:
		_summary_card.visible = false
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _badge_label:
		_badge_label.visible = false
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
		label.visible = false
