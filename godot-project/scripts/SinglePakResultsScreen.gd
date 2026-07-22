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
var _row_stage: ColorRect = null
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _summary_label: Label = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _badge_label: Label = null
var _row_cards: Array[ColorRect] = []
var _row_labels: Array[Label] = []
var _stat_labels: Array[Label] = []
var _option_cards: Array[ColorRect] = []
var _option_labels: Array[Label] = []
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
	_ensure_rows()
	_ensure_options()
	_set_screen_visible(CoreBridge.is_singlepak_results_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_singlepak_results_screen()
	_set_screen_visible(active)
	if not active:
		return
	_pulse_time += delta * 3.0
	var pulse := 0.5 + (sin(_pulse_time * 1.1) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_multiplayer_results_title()
		title_label.position = Vector2(248.0, 116.0)
		title_label.size = Vector2(620.0, 54.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_multiplayer_results_prompt()
		prompt_label.position = Vector2(186.0, 548.0)
		prompt_label.size = Vector2(908.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.86, 0.38, 0.76 + pulse * 0.20)
	if detail_label:
		detail_label.text = CoreBridge.get_multiplayer_results_detail()
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.84, 0.92, 1.0, 0.96)
	_update_chrome()
	_update_rows()
	_update_options()
	_update_summary()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.03, 0.03, 0.06, 0.72))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 188.0), Color(0.11, 0.18, 0.30, 0.22))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.06, 0.10, 0.18, 0.94))
	_header_band = _ensure_rect("HeaderBand", Rect2(214.0, 246.0, 324.0, 256.0), Color(0.06, 0.10, 0.18, 0.94))
	_panel = _ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.10, 0.14, 0.22, 0.96))
	_accent = _ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.92, 0.42, 0.24, 1.0))
	_header_glow = _ensure_rect("HeaderGlow", Rect2(176.0, 168.0, 928.0, 6.0), Color(0.94, 0.76, 0.34, 0.28))
	_left_stage = _ensure_rect("LeftStage", Rect2(204.0, 246.0, 346.0, 256.0), Color(0.12, 0.18, 0.30, 0.92))
	_right_stage = _ensure_rect("RightStage", Rect2(576.0, 246.0, 498.0, 256.0), Color(0.14, 0.18, 0.28, 0.98))
	_row_stage = _ensure_rect("RowStage", Rect2(228.0, 274.0, 300.0, 212.0), Color(0.12, 0.18, 0.30, 0.92))
	_summary_card = _ensure_rect("SummaryCard", Rect2(818.0, 278.0, 230.0, 180.0), Color(0.14, 0.18, 0.28, 0.98))
	_prompt_band = _ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.08, 0.11, 0.18, 0.94))
	_badge_ring = _ensure_rect("BadgeRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(0.92, 0.42, 0.24, 0.22))
	_badge_core = _ensure_rect("BadgeCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.98, 0.98, 1.0, 1.0))
	_badge_label = _ensure_label("BadgeLabel", Vector2(900.0, 160.0), Vector2(96.0, 36.0), 18)
	_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_header_band.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_glow.z_index = -4
	_left_stage.z_index = -4
	_right_stage.z_index = -4
	_row_stage.z_index = -3
	_summary_card.z_index = -3
	_prompt_band.z_index = -2
	_badge_ring.z_index = -1
	_badge_core.z_index = 0

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

func _ensure_rows() -> void:
	if _row_labels.size() > 0:
		return
	for i in range(4):
		var y := 292.0 + float(i) * 44.0
		var card := _ensure_rect("RowCard%d" % i, Rect2(248.0, y, 260.0, 34.0), Color(0.12, 0.18, 0.30, 0.96))
		var row := _ensure_label("RowLabel%d" % i, Vector2(266.0, y - 1.0), Vector2(114.0, 16.0), 15)
		var stat := _ensure_label("StatLabel%d" % i, Vector2(362.0, y + 12.0), Vector2(128.0, 12.0), 9)
		row.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		stat.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(row)
		_stat_labels.append(stat)

func _ensure_options() -> void:
	if _option_labels.size() > 0:
		return
	for i in range(2):
		var left := 290.0 + float(i) * 348.0
		var card := _ensure_rect("OptionCard%d" % i, Rect2(left, 620.0, 252.0, 44.0), Color(0.16, 0.12, 0.16, 0.96))
		var label := _ensure_label("OptionLabel%d" % i, Vector2(left, 620.0), Vector2(252.0, 44.0), 20)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_option_cards.append(card)
		_option_labels.append(label)

func _ensure_summary_label() -> void:
	if _summary_label != null:
		return
	_summary_label = _ensure_label("SummaryLabel", Vector2(840.0, 304.0), Vector2(186.0, 128.0), 16)
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_summary_label.modulate = Color(0.84, 0.92, 1.0, 0.96)

func _update_rows() -> void:
	_ensure_summary_label()
	var rows: Array = CoreBridge.get_singlepak_result_rows()
	var selection_mode := CoreBridge.is_multiplayer_character_selection_results()
	for i in range(_row_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_row_labels[i].visible = visible
		_stat_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_winner := bool(row.get("winner", false)) or (selection_mode and i == 0)
		var top := 292.0 + float(i) * 44.0
		var lift := -3.0 if is_winner else 0.0
		_row_cards[i].position = Vector2(248.0, top + lift)
		_row_labels[i].position = Vector2(266.0, top - 1.0 + lift)
		_stat_labels[i].position = Vector2(362.0, top + 12.0 + lift)
		_row_cards[i].color = Color(0.36, 0.20, 0.18, 0.98) if selection_mode and is_winner else (Color(0.20, 0.32, 0.50, 0.98) if is_winner else Color(0.12, 0.18, 0.30, 0.96))
		_row_labels[i].text = "%s %s" % [str(row.get("rank_text", "P%d" % [int(row.get("rank", i + 1))])), str(row.get("name", ""))]
		_row_labels[i].modulate = Color(1.0, 0.84, 0.40, 1.0) if is_winner else Color(0.96, 0.97, 1.0, 1.0)
		if selection_mode:
			_stat_labels[i].text = "%s   LOCKED   %s" % [str(row.get("character", "SONIC")), str(row.get("rank_text", "P%d" % [i + 1]))]
		else:
			_stat_labels[i].text = str(row.get("stat_text", "%s   RINGS %d   SCORE %d" % [str(row.get("character", "SONIC")), int(row.get("rings", 0)), int(row.get("score", 0))]))
		_stat_labels[i].modulate = Color(1.0, 0.84, 0.40, 1.0) if is_winner else Color(0.82, 0.88, 0.98, 0.96)

func _update_options() -> void:
	var rows: Array = CoreBridge.get_multiplayer_result_option_rows()
	for i in range(_option_labels.size()):
		var visible := i < rows.size()
		_option_cards[i].visible = visible
		_option_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var lift := -6.0 if is_selected else 0.0
		_option_cards[i].position.y = 620.0 + lift
		_option_labels[i].position.y = 620.0 + lift
		_option_cards[i].color = Color(0.42, 0.20, 0.18, 0.98) if is_selected and CoreBridge.is_multiplayer_character_selection_results() else (Color(0.20, 0.30, 0.48, 0.98) if is_selected else Color(0.16, 0.12, 0.16, 0.96))
		_option_labels[i].text = str(row.get("label", ""))
		_option_labels[i].modulate = Color(1.0, 0.88, 0.42, 1.0) if is_selected else Color(0.78, 0.84, 0.94, 0.92)
	if _prompt_band:
		_prompt_band.visible = rows.size() > 0

func _update_summary() -> void:
	_ensure_summary_label()
	if _summary_label:
		_summary_label.text = CoreBridge.get_multiplayer_results_summary_text()
	if _badge_label:
		_badge_label.text = CoreBridge.get_multiplayer_results_badge_text()
		_badge_label.modulate = Color(0.18, 0.18, 0.24, 0.98)

func _update_chrome() -> void:
	var chrome := CoreBridge.get_multiplayer_results_chrome_colors()
	if _accent:
		_accent.color = Color(chrome.get("accent", _accent.color))
	if _hero_glow:
		var glow_accent: Color = Color(chrome.get("accent", _hero_glow.color))
		_hero_glow.color = Color(glow_accent.r * 0.26, glow_accent.g * 0.32, glow_accent.b * 0.42, 0.18 + absf(sin(_pulse_time * 0.5)) * 0.08)
	if _header_plate:
		var plate_color: Color = Color(chrome.get("panel", _header_plate.color))
		_header_plate.color = Color(plate_color.r * 0.78, plate_color.g * 0.84, plate_color.b * 1.10, 0.92)
	if _header_band:
		var band_panel: Color = Color(chrome.get("panel", _header_band.color))
		_header_band.color = Color(band_panel.r * 0.78, band_panel.g * 0.84, band_panel.b * 1.10, 0.90)
	if _panel:
		_panel.color = Color(chrome.get("panel", _panel.color))
	if _left_stage:
		var row_panel: Color = Color(chrome.get("panel", _left_stage.color))
		_left_stage.color = Color(row_panel.r * 0.94, row_panel.g * 1.04, row_panel.b * 1.16, 0.92)
	if _right_stage:
		_right_stage.color = Color(chrome.get("summary", _right_stage.color))
	if _row_stage:
		var row_stage_color: Color = Color(chrome.get("panel", _row_stage.color))
		_row_stage.color = Color(row_stage_color.r * 0.94, row_stage_color.g * 1.04, row_stage_color.b * 1.16, 0.92)
	if _summary_card:
		_summary_card.color = Color(chrome.get("summary", _summary_card.color))
	if _prompt_band:
		var summary_color: Color = Color(chrome.get("summary", _prompt_band.color))
		_prompt_band.color = Color(summary_color.r * 0.84, summary_color.g * 0.90, summary_color.b * 1.02, 0.92)
	if _badge_ring:
		var badge_accent: Color = Color(chrome.get("accent", _badge_ring.color))
		_badge_ring.color = Color(badge_accent.r, badge_accent.g, badge_accent.b, 0.16 + absf(sin(_pulse_time)) * 0.10)
	if _header_glow:
		var accent: Color = Color(chrome.get("accent", _header_glow.color))
		_header_glow.color = Color(accent.r, accent.g, accent.b, 0.28 + absf(sin(_pulse_time)) * 0.08)

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
	if _row_stage:
		_row_stage.visible = screen_visible
	if _summary_card:
		_summary_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
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
	for label in _stat_labels:
		label.visible = screen_visible
	for card in _option_cards:
		card.visible = screen_visible
	for label in _option_labels:
		label.visible = screen_visible
