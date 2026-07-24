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
var _left_stage: ColorRect = null
var _right_stage: ColorRect = null
var _summary_stage: ColorRect = null
var _emblem_ring: ColorRect = null
var _emblem_core: ColorRect = null
var _character_card: ColorRect = null
var _course_card: ColorRect = null
var _focus_card: ColorRect = null
var _option_stage: ColorRect = null
var _prompt_band: ColorRect = null
var _emblem_label: Label = null
var _character_label: Label = null
var _course_label: Label = null
var _mode_label: Label = null
var _record_label: Label = null
var _option_cards: Array[ColorRect] = []
var _option_labels: Array[Label] = []
var _meta_labels: Array[Label] = []
var _status_labels: Array[Label] = []
var _focus_slide: float = 0.0

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
	_set_screen_visible(false)

func _process(_delta: float) -> void:
	var screen_visible := CoreBridge.is_time_attack_lobby_screen()
	_set_screen_visible(screen_visible)
	if not screen_visible:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 220.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_time_attack_lobby_title()
		title_label.position = Vector2(248.0, 116.0)
		title_label.size = Vector2(604.0, 54.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_time_attack_lobby_prompt()
		prompt_label.position = Vector2(186.0, 548.0)
		prompt_label.size = Vector2(908.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.52, 0.72 + (pulse * 0.24))
	if detail_label:
		detail_label.text = CoreBridge.get_time_attack_lobby_detail()
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.72, 0.86, 1.0, 0.92)
	_update_chrome()
	_update_summary()
	_update_rows()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.05, 0.10, 0.74))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.12, 0.24, 0.42, 0.18))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.06, 0.10, 0.18, 0.94))
	_header_band = _ensure_rect("HeaderBand", Rect2(214.0, 246.0, 324.0, 256.0), Color(0.06, 0.10, 0.18, 0.94))
	_panel = _ensure_rect("LobbyPanel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.05, 0.08, 0.16, 0.97))
	_accent = _ensure_rect("LobbyAccent", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.34, 0.68, 1.0, 0.74))
	_left_stage = _ensure_rect("LeftStage", Rect2(204.0, 246.0, 346.0, 256.0), Color(0.09, 0.15, 0.28, 0.94))
	_right_stage = _ensure_rect("RightStage", Rect2(576.0, 246.0, 498.0, 256.0), Color(0.10, 0.16, 0.28, 0.92))
	_summary_stage = _ensure_rect("SummaryStage", Rect2(216.0, 272.0, 306.0, 216.0), Color(0.09, 0.15, 0.28, 0.94))
	_emblem_ring = _ensure_rect("EmblemRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(0.16, 0.26, 0.40, 0.22))
	_emblem_core = _ensure_rect("EmblemCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.06, 0.10, 0.18, 0.98))
	_character_card = _ensure_rect("CharacterCard", Rect2(236.0, 292.0, 268.0, 62.0), Color(0.09, 0.15, 0.28, 0.96))
	_course_card = _ensure_rect("CourseCard", Rect2(236.0, 362.0, 268.0, 82.0), Color(0.09, 0.15, 0.28, 0.96))
	_focus_card = _ensure_rect("FocusCard", Rect2(236.0, 452.0, 268.0, 44.0), Color(0.12, 0.18, 0.30, 0.94))
	_option_stage = _ensure_rect("OptionStage", Rect2(600.0, 276.0, 430.0, 196.0), Color(0.10, 0.16, 0.28, 0.92))
	_prompt_band = _ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.05, 0.09, 0.17, 0.94))
	_emblem_label = _ensure_label("EmblemLabel", Vector2(914.0, 158.0), Vector2(68.0, 40.0), 24)
	_character_label = _ensure_label("CharacterSummaryLabel", Vector2(252.0, 308.0), Vector2(236.0, 26.0), 20)
	_course_label = _ensure_label("CourseSummaryLabel", Vector2(250.0, 378.0), Vector2(240.0, 50.0), 16)
	_mode_label = _ensure_label("ModeSummaryLabel", Vector2(252.0, 432.0), Vector2(236.0, 22.0), 13)
	_record_label = _ensure_label("RecordSummaryLabel", Vector2(250.0, 456.0), Vector2(240.0, 32.0), 16)
	_course_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_emblem_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_header_band.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_left_stage.z_index = -4
	_right_stage.z_index = -4
	_summary_stage.z_index = -3
	_option_stage.z_index = -3
	_character_card.z_index = -2
	_course_card.z_index = -2
	_focus_card.z_index = -2
	_prompt_band.z_index = -2
	_emblem_ring.z_index = -1
	_emblem_core.z_index = 0

func _ensure_rows() -> void:
	if _option_cards.size() > 0:
		return
	for i in range(4):
		var top := 292.0 + float(i) * 44.0
		var card := _ensure_rect("LobbyOptionCard%d" % i, Rect2(624.0, top, 382.0, 34.0), Color(0.09, 0.15, 0.28, 0.96))
		var option := _ensure_label("LobbyOptionLabel%d" % i, Vector2(642.0, top - 1.0), Vector2(152.0, 16.0), 16)
		var meta := _ensure_label("LobbyMetaLabel%d" % i, Vector2(642.0, top + 13.0), Vector2(170.0, 14.0), 10)
		var status := _ensure_label("LobbyStatusLabel%d" % i, Vector2(834.0, top + 7.0), Vector2(150.0, 16.0), 11)
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

func _update_summary() -> void:
	var colors := CoreBridge.get_time_attack_lobby_chrome_colors()
	var accent := CoreBridge.get_time_attack_lobby_character_accent_color()
	_focus_slide = lerpf(_focus_slide, float(CoreBridge.get_time_attack_lobby_cursor()) * 6.0, clampf(get_process_delta_time() * 8.0, 0.0, 1.0))
	if _emblem_label:
		_emblem_label.text = CoreBridge.get_time_attack_lobby_emblem_text()
		_emblem_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if _character_label:
		_character_label.text = CoreBridge.get_time_attack_lobby_character_text()
		_character_label.modulate = Color(0.96, 0.98, 1.0, 1.0)
	if _course_label:
		_course_label.text = CoreBridge.get_time_attack_lobby_course_text()
		_course_label.modulate = Color(0.72, 0.84, 0.98, 0.94)
	if _mode_label:
		_mode_label.text = CoreBridge.get_time_attack_lobby_mode_text()
		_mode_label.modulate = Color(1.0, 0.88, 0.40, 1.0)
	if _record_label:
		_record_label.text = CoreBridge.get_time_attack_lobby_record_label_text()
		_record_label.modulate = Color(1.0, 0.96, 0.88, 1.0)
	if _character_card:
		_character_card.color = colors.get("card", Color(0.09, 0.15, 0.28, 0.96))
	if _course_card:
		_course_card.color = colors.get("card", Color(0.09, 0.15, 0.28, 0.96))
	if _focus_card:
		_focus_card.color = Color(accent.r * 0.48, accent.g * 0.48, accent.b * 0.48, 0.94)
		_focus_card.position.x = 236.0 + _focus_slide
	if _emblem_ring:
		_emblem_ring.color = Color(accent.r * 0.82, accent.g * 0.82, accent.b * 0.82, 0.22)
	if _emblem_core:
		_emblem_core.color = Color(accent.r * 0.34, accent.g * 0.34, accent.b * 0.34, 0.98)

func _update_chrome() -> void:
	var colors := CoreBridge.get_time_attack_lobby_chrome_colors()
	if _accent:
		_accent.color = colors.get("accent", Color(0.34, 0.68, 1.0, 0.74))
	if _hero_glow:
		var accent := Color(colors.get("accent", Color(0.34, 0.68, 1.0, 0.74)))
		_hero_glow.color = Color(accent.r * 0.34, accent.g * 0.40, accent.b * 0.52, 0.18)
	if _header_plate:
		var plate := Color(colors.get("card", Color(0.09, 0.15, 0.28, 0.96)))
		_header_plate.color = Color(plate.r * 0.70, plate.g * 0.76, plate.b * 1.02, 0.92)
	if _header_band:
		var panel_color := Color(colors.get("card", Color(0.09, 0.15, 0.28, 0.96)))
		_header_band.color = Color(panel_color.r * 0.72, panel_color.g * 0.78, panel_color.b * 1.04, 0.92)
	if _panel:
		_panel.color = Color(colors.get("card", Color(0.09, 0.15, 0.28, 0.96)))
	if _left_stage:
		_left_stage.color = Color(colors.get("card", Color(0.09, 0.15, 0.28, 0.94)))
	if _right_stage:
		var selected_stage := Color(colors.get("selected", Color(0.18, 0.30, 0.48, 0.98)))
		_right_stage.color = Color(selected_stage.r * 0.56, selected_stage.g * 0.58, selected_stage.b * 0.70, 0.88)
	if _summary_stage:
		_summary_stage.color = Color(colors.get("card", Color(0.09, 0.15, 0.28, 0.94)))
	if _option_stage:
		var selected := Color(colors.get("selected", Color(0.18, 0.30, 0.48, 0.98)))
		_option_stage.color = Color(selected.r * 0.56, selected.g * 0.58, selected.b * 0.70, 0.88)
	if _prompt_band:
		var card := Color(colors.get("card", Color(0.09, 0.15, 0.28, 0.96)))
		_prompt_band.color = Color(card.r * 0.56, card.g * 0.62, card.b * 0.78, 0.90)

func _update_rows() -> void:
	var rows: Array = CoreBridge.get_time_attack_lobby_rows()
	var colors := CoreBridge.get_time_attack_lobby_chrome_colors()
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
		_option_cards[i].color = colors.get("selected", Color(0.18, 0.30, 0.48, 0.98)) if selected else colors.get("card", Color(0.09, 0.15, 0.28, 0.96))
		var top := 292.0 + float(i) * 44.0
		var lift := -3.0 if selected else 0.0
		_option_cards[i].position = Vector2(624.0, top + lift)
		_option_labels[i].text = str(row.get("name", ""))
		_meta_labels[i].text = str(row.get("description", ""))
		_status_labels[i].text = str(row.get("status", ""))
		_option_labels[i].position = Vector2(642.0, top - 1.0 + lift)
		_meta_labels[i].position = Vector2(642.0, top + 13.0 + lift)
		_status_labels[i].position = Vector2(834.0, top + 7.0 + lift)
		_option_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0) if selected else Color(0.96, 0.98, 1.0, 1.0)
		_meta_labels[i].modulate = Color(0.72, 0.84, 0.98, 0.94)
		_status_labels[i].modulate = Color(1.0, 0.88, 0.40, 1.0) if i == 0 else Color(0.78, 0.84, 0.94, 0.92)

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
	if _left_stage:
		_left_stage.visible = screen_visible
	if _right_stage:
		_right_stage.visible = screen_visible
	if _summary_stage:
		_summary_stage.visible = screen_visible
	if _emblem_ring:
		_emblem_ring.visible = screen_visible
	if _emblem_core:
		_emblem_core.visible = screen_visible
	if _character_card:
		_character_card.visible = screen_visible
	if _course_card:
		_course_card.visible = screen_visible
	if _focus_card:
		_focus_card.visible = screen_visible
	if _option_stage:
		_option_stage.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _emblem_label:
		_emblem_label.visible = screen_visible
	if _character_label:
		_character_label.visible = screen_visible
	if _course_label:
		_course_label.visible = screen_visible
	if _mode_label:
		_mode_label.visible = screen_visible
	if _record_label:
		_record_label.visible = screen_visible
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
