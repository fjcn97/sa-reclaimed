# TimeRecordsScreen.gd
# Presents an original-inspired dedicated time records screen.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _panel: ColorRect = null
var _header_plate: ColorRect = null
var _accent: ColorRect = null
var _header_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _records_stage: ColorRect = null
var _header_card: ColorRect = null
var _prompt_band: ColorRect = null
var _summary_label: Label = null
var _character_label: Label = null
var _heading_label: Label = null
var _subtitle_label: Label = null
var _badge_label: Label = null
var _character_card: ColorRect = null
var _character_glow: ColorRect = null
var _character_nameplate: ColorRect = null
var _character_caption: Label = null
var _row_cards: Array[ColorRect] = []
var _row_labels: Array[Label] = []
var _time_labels: Array[Label] = []

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
	_set_screen_visible(CoreBridge.is_time_records_screen())

func _process(_delta: float) -> void:
	var active: bool = CoreBridge.is_time_records_screen()
	_set_screen_visible(active)
	if not active:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 210.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_time_records_title_text()
		title_label.position = Vector2(254.0, 116.0)
		title_label.size = Vector2(612.0, 56.0)
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_time_records_prompt_text()
		prompt_label.position = Vector2(176.0, 552.0)
		prompt_label.size = Vector2(928.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.52, 0.74 + (pulse * 0.26))
	if detail_label:
		detail_label.text = "%s   |   %s" % [CoreBridge.get_time_records_summary_text().replace("\n", "   "), CoreBridge.get_time_records_detail_text()]
		detail_label.position = Vector2(170.0, 668.0)
		detail_label.size = Vector2(940.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.80, 0.90, 1.0, 0.92)
	_update_chrome()
	_update_summary()
	_update_rows()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.03, 0.04, 0.08, 0.68))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.16, 0.28, 0.62, 0.18))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(146.0, 96.0, 988.0, 124.0), Color(0.08, 0.10, 0.18, 0.94))
	_panel = _ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.08, 0.08, 0.14, 0.96))
	_accent = _ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.26, 0.52, 0.96, 1.0))
	_header_band = _ensure_rect("HeaderBand", Rect2(210.0, 246.0, 288.0, 238.0), Color(0.12, 0.18, 0.34, 0.92))
	_badge_ring = _ensure_rect("BadgeRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(0.92, 0.78, 0.24, 0.22))
	_badge_core = _ensure_rect("BadgeCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.12, 0.18, 0.34, 0.96))
	_records_stage = _ensure_rect("RecordsStage", Rect2(522.0, 246.0, 550.0, 238.0), Color(0.08, 0.12, 0.22, 0.94))
	_header_card = _ensure_rect("HeaderCard", Rect2(204.0, 246.0, 292.0, 238.0), Color(0.08, 0.12, 0.22, 0.94))
	_character_card = _ensure_rect("CharacterCard", Rect2(224.0, 300.0, 244.0, 102.0), Color(0.08, 0.12, 0.22, 0.94))
	_character_glow = _ensure_rect("CharacterGlow", Rect2(236.0, 312.0, 220.0, 52.0), Color(0.26, 0.52, 0.96, 0.18))
	_character_nameplate = _ensure_rect("CharacterNameplate", Rect2(236.0, 372.0, 220.0, 24.0), Color(0.12, 0.18, 0.34, 0.94))
	_character_caption = _ensure_label("CharacterCaption", Vector2(244.0, 320.0), Vector2(204.0, 42.0), 24)
	_character_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt_band = _ensure_rect("PromptBand", Rect2(176.0, 534.0, 928.0, 96.0), Color(0.04, 0.08, 0.16, 0.92))
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_badge_ring.z_index = -3
	_badge_core.z_index = -2
	_records_stage.z_index = -2
	_header_card.z_index = -2
	_character_card.z_index = -1
	_character_glow.z_index = 0
	_character_nameplate.z_index = 1
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
		_summary_label = _ensure_label("SummaryLabel", Vector2(228.0, 282.0), Vector2(224.0, 82.0), 15)
		_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if _character_label == null:
		_character_label = _ensure_label("CharacterLabel", Vector2(228.0, 434.0), Vector2(224.0, 28.0), 20)
		_character_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if _heading_label == null:
		_heading_label = _ensure_label("HeadingLabel", Vector2(556.0, 278.0), Vector2(462.0, 28.0), 22)
	if _subtitle_label == null:
		_subtitle_label = _ensure_label("SubtitleLabel", Vector2(556.0, 308.0), Vector2(462.0, 22.0), 14)
	if _row_labels.size() > 0:
		return
	for i in range(5):
		var top := 346.0 + float(i) * 30.0
		var card := _ensure_rect("RowCard%d" % i, Rect2(548.0, top, 494.0, 24.0), Color(0.10, 0.16, 0.29, 0.96))
		var row := _ensure_label("RowLabel%d" % i, Vector2(572.0, top - 1.0), Vector2(176.0, 26.0), 16)
		var time := _ensure_label("TimeLabel%d" % i, Vector2(766.0, top - 1.0), Vector2(248.0, 26.0), 16)
		row.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		time.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(row)
		_time_labels.append(time)
	if _badge_label == null:
		_badge_label = _ensure_label("BadgeLabel", Vector2(888.0, 160.0), Vector2(106.0, 40.0), 18)
		_badge_label.text = "RECORD"
		_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

func _update_summary() -> void:
	var time_attack_context := CoreBridge.is_time_attack_level_select_screen()
	if _summary_label:
		_summary_label.text = CoreBridge.get_time_records_summary_text().replace("\n", "\n\n") if time_attack_context else CoreBridge.get_time_records_summary_text().replace("\n", "   ")
		_summary_label.modulate = Color(0.90, 0.96, 1.0, 0.98)
	if _character_label:
		_character_label.text = CoreBridge.get_time_records_character_text()
		_character_label.modulate = Color(0.78, 0.88, 1.0, 1.0)
	if _heading_label:
		_heading_label.text = CoreBridge.get_time_records_course_heading_text()
		_heading_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if _subtitle_label:
		_subtitle_label.text = CoreBridge.get_time_records_course_subtitle_text()
		_subtitle_label.modulate = Color(0.72, 0.84, 1.0, 0.96)
	if _character_caption:
		_character_caption.text = CoreBridge.get_time_records_character_text()
		_character_caption.modulate = Color(1.0, 0.97, 0.84, 0.98) if time_attack_context else Color(0.80, 0.90, 1.0, 0.0)
	if _badge_label:
		_badge_label.text = "TA" if time_attack_context else "RECORD"
		_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

func _update_chrome() -> void:
	var colors := CoreBridge.get_time_records_chrome_colors()
	var time_attack_context := CoreBridge.is_time_attack_level_select_screen()
	if _accent:
		_accent.color = colors.get("accent", Color(0.26, 0.52, 0.96, 1.0))
	if _hero_glow:
		var accent := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_hero_glow.color = Color(accent.r * 0.45, accent.g * 0.45, accent.b * 0.62, 0.18)
	if _header_plate:
		var panel_color := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_header_plate.color = Color(panel_color.r * 0.24, panel_color.g * 0.26, panel_color.b * 0.34, 0.92)
	if _header_band:
		var header := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_header_band.color = Color(header.r * 0.28, header.g * 0.24, header.b * 0.34, 0.92)
	if _badge_core:
		var badge := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_badge_core.color = Color(badge.r * 0.28, badge.g * 0.24, badge.b * 0.34, 0.96)
	if _header_card:
		_header_card.color = colors.get("stage", Color(0.08, 0.12, 0.22, 0.94))
	if _records_stage:
		_records_stage.color = colors.get("stage", Color(0.08, 0.12, 0.22, 0.94))
	if _character_card:
		_character_card.color = colors.get("stage", Color(0.08, 0.12, 0.22, 0.94))
	if _character_glow:
		var accent := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_character_glow.color = Color(accent.r * 0.56, accent.g * 0.48, accent.b * 0.30, 0.26) if time_attack_context else Color(accent.r * 0.45, accent.g * 0.45, accent.b * 0.62, 0.18)
	if _character_nameplate:
		var accent := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_character_nameplate.color = Color(accent.r * 0.38, accent.g * 0.28, accent.b * 0.20, 0.92) if time_attack_context else Color(accent.r * 0.28, accent.g * 0.24, accent.b * 0.34, 0.92)

func _update_rows() -> void:
	var rows: Array = CoreBridge.get_time_record_rows()
	var mode_choice_view := rows.size() == 2
	var time_attack_context := CoreBridge.is_time_attack_level_select_screen()
	if _character_label:
		_character_label.visible = not mode_choice_view and not time_attack_context
	if _heading_label:
		_heading_label.visible = true
	if _subtitle_label:
		_subtitle_label.visible = true
	if _summary_label:
		_summary_label.position = Vector2(228.0, 420.0) if time_attack_context else Vector2(228.0, 282.0)
		_summary_label.size = Vector2(224.0, 72.0) if time_attack_context else Vector2(224.0, 82.0)
		_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if time_attack_context else HORIZONTAL_ALIGNMENT_LEFT
	if _heading_label:
		_heading_label.position = Vector2(556.0, 270.0) if time_attack_context else Vector2(556.0, 278.0)
	if _subtitle_label:
		_subtitle_label.position = Vector2(556.0, 304.0) if time_attack_context else Vector2(556.0, 308.0)
	if _character_card:
		_character_card.visible = time_attack_context
	if _character_glow:
		_character_glow.visible = time_attack_context
	if _character_nameplate:
		_character_nameplate.visible = time_attack_context
	if _character_caption:
		_character_caption.visible = time_attack_context
	for i in range(_row_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_row_labels[i].visible = visible
		_time_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var top := (354.0 + float(i) * 46.0) if mode_choice_view else (344.0 + float(i) * 42.0 if time_attack_context else 346.0 + float(i) * 30.0)
		_row_cards[i].position.y = top
		_row_labels[i].position.y = top - 1.0
		_time_labels[i].position.y = top - 1.0
		_row_cards[i].size.y = 34.0 if time_attack_context and not mode_choice_view else 24.0
		var is_selected := bool(row.get("selected", false))
		var is_record_row := bool(row.get("recorded", false))
		_row_labels[i].text = ("BEST %d" % [i + 1]) if time_attack_context and not mode_choice_view else str(row.get("name", ""))
		_time_labels[i].text = str(row.get("time", ""))
		_row_labels[i].size.x = 188.0 if time_attack_context and not mode_choice_view else 176.0
		_time_labels[i].size.x = 216.0 if time_attack_context and not mode_choice_view else 248.0
		if is_selected:
			_row_cards[i].color = Color(0.22, 0.38, 0.62, 0.98)
			_row_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0)
			_time_labels[i].modulate = Color(0.96, 0.88, 0.52, 1.0)
		elif is_record_row:
			_row_cards[i].color = Color(0.28, 0.20, 0.08, 0.96)
			_row_labels[i].modulate = Color(0.98, 0.88, 0.64, 1.0)
			_time_labels[i].modulate = Color(0.98, 0.82, 0.48, 1.0)
		else:
			_row_cards[i].color = Color(0.10, 0.16, 0.29, 0.96)
			_row_labels[i].modulate = Color(0.88, 0.94, 1.0, 0.94)
			_time_labels[i].modulate = Color(0.72, 0.84, 1.0, 0.96)

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
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _records_stage:
		_records_stage.visible = screen_visible
	if _header_card:
		_header_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _character_label:
		_character_label.visible = screen_visible
	if _heading_label:
		_heading_label.visible = screen_visible
	if _subtitle_label:
		_subtitle_label.visible = screen_visible
	if _character_card:
		_character_card.visible = screen_visible
	if _character_glow:
		_character_glow.visible = screen_visible
	if _character_nameplate:
		_character_nameplate.visible = screen_visible
	if _character_caption:
		_character_caption.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	for card in _row_cards:
		card.visible = screen_visible
	for label in _row_labels:
		label.visible = screen_visible
	for label in _time_labels:
		label.visible = screen_visible
