# ClearScreen.gd
# Presents an original-inspired stage results screen.
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
var _results_stage: ColorRect = null
var _header_card: ColorRect = null
var _score_card: ColorRect = null
var _rank_badge: ColorRect = null
var _prompt_band: ColorRect = null
var _stage_label: Label = null
var _rank_label: Label = null
var _record_label: Label = null
var _row_labels: Array[Label] = []
var _value_labels: Array[Label] = []

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_header_labels()
	_ensure_rows()
	_set_screen_visible(CoreBridge.is_clear_screen())

func _process(_delta: float) -> void:
	var clear_mode: bool = CoreBridge.is_clear_screen()
	_set_screen_visible(clear_mode)
	if not clear_mode:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 220.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_clear_title_text()
		title_label.position = Vector2(248.0, 116.0)
		title_label.size = Vector2(604.0, 54.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(1.0, 0.95, 0.62, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_clear_prompt_text()
		prompt_label.position = Vector2(186.0, 548.0)
		prompt_label.size = Vector2(908.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(0.98, 0.98, 1.0, 0.72 + (pulse * 0.24))
	if detail_label:
		detail_label.text = CoreBridge.get_clear_footer_text()
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.86, 0.92, 1.0, 0.96)
	_update_chrome()
	_update_header()
	_update_rows()
	_update_rank_style()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.04, 0.68))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.36, 0.24, 0.10, 0.18))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.10, 0.08, 0.03, 0.94))
	_header_band = _ensure_rect("HeaderBand", Rect2(214.0, 246.0, 332.0, 256.0), Color(0.10, 0.08, 0.03, 0.94))
	_panel = _ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.10, 0.08, 0.03, 0.96))
	_accent = _ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.96, 0.76, 0.20, 0.98))
	_left_stage = _ensure_rect("LeftStage", Rect2(204.0, 246.0, 346.0, 256.0), Color(0.16, 0.10, 0.04, 0.92))
	_right_stage = _ensure_rect("RightStage", Rect2(576.0, 246.0, 498.0, 256.0), Color(0.18, 0.12, 0.04, 0.98))
	_results_stage = _ensure_rect("ResultsStage", Rect2(222.0, 272.0, 310.0, 218.0), Color(0.16, 0.10, 0.04, 0.92))
	_header_card = _ensure_rect("HeaderCard", Rect2(236.0, 286.0, 282.0, 48.0), Color(0.28, 0.18, 0.06, 0.98))
	_score_card = _ensure_rect("ScoreCard", Rect2(236.0, 346.0, 282.0, 126.0), Color(0.18, 0.12, 0.04, 0.98))
	_rank_badge = _ensure_rect("RankBadge", Rect2(818.0, 280.0, 230.0, 176.0), Color(0.72, 0.50, 0.14, 0.98))
	_prompt_band = _ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.08, 0.07, 0.05, 0.92))
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_header_band.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_left_stage.z_index = -4
	_right_stage.z_index = -4
	_results_stage.z_index = -3
	_header_card.z_index = -2
	_score_card.z_index = -2
	_prompt_band.z_index = -2
	_rank_badge.z_index = -1

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

func _ensure_header_labels() -> void:
	_stage_label = _ensure_label("StageLabel", Vector2(252.0, 294.0), Vector2(250.0, 28.0), 20)
	_stage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_rank_label = _ensure_label("RankLabel", Vector2(848.0, 304.0), Vector2(170.0, 88.0), 56)
	_rank_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_rank_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_record_label = _ensure_label("RecordLabel", Vector2(836.0, 408.0), Vector2(194.0, 36.0), 16)
	_record_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_record_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _ensure_rows() -> void:
	if _row_labels.size() > 0:
		return
	for i in range(4):
		var top := 354.0 + float(i) * 28.0
		var row := _ensure_label("RowLabel%d" % i, Vector2(252.0, top), Vector2(112.0, 22.0), 14)
		var value := _ensure_label("ValueLabel%d" % i, Vector2(372.0, top), Vector2(124.0, 22.0), 16)
		value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_labels.append(row)
		_value_labels.append(value)

func _update_header() -> void:
	if _stage_label:
		_stage_label.text = CoreBridge.get_clear_stage_label()
		_stage_label.modulate = Color(1.0, 0.95, 0.68, 1.0)
	if _rank_label:
		_rank_label.text = CoreBridge.get_clear_result_badge_text()
		_rank_label.add_theme_font_size_override("font_size", 36 if CoreBridge.get_clear_title_text() == "TIME ATTACK" else 56)
		_rank_label.modulate = Color(0.16, 0.10, 0.02, 1.0)
	if _record_label:
		_record_label.text = CoreBridge.get_clear_time_attack_record_status_text() if CoreBridge.get_clear_title_text() == "TIME ATTACK" else ("COUNTING" if not CoreBridge.is_clear_input_ready() else CoreBridge.get_clear_rank_text_value())
		_record_label.modulate = Color(0.10, 0.20, 0.34, 1.0) if CoreBridge.get_clear_title_text() == "TIME ATTACK" else Color(0.22, 0.12, 0.03, 1.0)
		_record_label.visible = true

func _update_rows() -> void:
	var rows: Array = CoreBridge.get_clear_rows()
	for i in range(_row_labels.size()):
		var row: Dictionary = rows[i]
		_row_labels[i].text = str(row.get("label", ""))
		_value_labels[i].text = str(row.get("value", ""))
		_row_labels[i].modulate = Color(0.74, 0.90, 1.0, 1.0) if CoreBridge.get_clear_title_text() == "TIME ATTACK" else Color(0.98, 0.88, 0.44, 1.0)
		_value_labels[i].modulate = Color(1.0, 0.96, 0.84, 1.0) if CoreBridge.get_clear_title_text() == "TIME ATTACK" else Color(0.98, 0.98, 1.0, 1.0)

func _update_chrome() -> void:
	var colors := CoreBridge.get_clear_chrome_colors()
	if _accent:
		_accent.color = colors.get("accent", Color(0.96, 0.76, 0.20, 0.98))
	if _hero_glow:
		var accent := Color(colors.get("accent", Color(0.96, 0.76, 0.20, 0.98)))
		_hero_glow.color = Color(accent.r * 0.36, accent.g * 0.30, accent.b * 0.16, 0.18)
	if _header_plate:
		var header_plate := Color(colors.get("header", Color(0.28, 0.18, 0.06, 0.98)))
		_header_plate.color = Color(header_plate.r * 0.54, header_plate.g * 0.54, header_plate.b * 0.54, 0.92)
	if _header_band:
		var header := Color(colors.get("header", Color(0.28, 0.18, 0.06, 0.98)))
		_header_band.color = Color(header.r * 0.54, header.g * 0.54, header.b * 0.54, 0.92)
	if _left_stage:
		var score_left := Color(colors.get("score", Color(0.18, 0.12, 0.04, 0.98)))
		_left_stage.color = Color(score_left.r * 0.88, score_left.g * 0.92, score_left.b * 0.96, 0.90)
	if _right_stage:
		_right_stage.color = Color(colors.get("badge", Color(0.72, 0.50, 0.14, 0.98)))
	if _results_stage:
		var score := Color(colors.get("score", Color(0.18, 0.12, 0.04, 0.98)))
		_results_stage.color = Color(score.r * 0.88, score.g * 0.92, score.b * 0.96, 0.90)
	if _header_card:
		_header_card.color = colors.get("header", Color(0.28, 0.18, 0.06, 0.98))
	if _score_card:
		_score_card.color = colors.get("score", Color(0.18, 0.12, 0.04, 0.98))
	if _rank_badge:
		_rank_badge.color = colors.get("badge", Color(0.72, 0.50, 0.14, 0.98))
	if _prompt_band:
		var score2 := Color(colors.get("score", Color(0.18, 0.12, 0.04, 0.98)))
		_prompt_band.color = Color(score2.r * 0.58, score2.g * 0.62, score2.b * 0.70, 0.90)

func _update_rank_style() -> void:
	if _rank_badge == null or _rank_label == null:
		return
	if CoreBridge.get_clear_title_text() == "TIME ATTACK":
		match _rank_label.text:
			"GOLD":
				_rank_badge.color = Color(0.92, 0.84, 0.28, 0.98)
			"SILVER":
				_rank_badge.color = Color(0.78, 0.84, 0.94, 0.98)
			"BRONZE":
				_rank_badge.color = Color(0.74, 0.52, 0.24, 0.98)
			"COPPER":
				_rank_badge.color = Color(0.66, 0.44, 0.22, 0.98)
			_:
				_rank_badge.color = Color(0.44, 0.58, 0.76, 0.98)
		return
	match _rank_label.text:
		"S":
			_rank_badge.color = Color(0.92, 0.86, 0.34, 0.98) if CoreBridge.get_clear_title_text() == "TIME ATTACK" else Color(0.96, 0.82, 0.24, 0.98)
		"A":
			_rank_badge.color = Color(0.64, 0.84, 1.0, 0.98) if CoreBridge.get_clear_title_text() == "TIME ATTACK" else Color(0.86, 0.76, 0.34, 0.98)
		"B":
			_rank_badge.color = Color(0.54, 0.72, 0.92, 0.98) if CoreBridge.get_clear_title_text() == "TIME ATTACK" else Color(0.72, 0.74, 0.78, 0.98)
		"C":
			_rank_badge.color = Color(0.38, 0.58, 0.80, 0.98) if CoreBridge.get_clear_title_text() == "TIME ATTACK" else Color(0.66, 0.46, 0.22, 0.98)
		_:
			_rank_badge.color = Color(0.26, 0.40, 0.64, 0.98) if CoreBridge.get_clear_title_text() == "TIME ATTACK" else Color(0.56, 0.28, 0.16, 0.98)

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
	if _results_stage:
		_results_stage.visible = screen_visible
	if _header_card:
		_header_card.visible = screen_visible
	if _score_card:
		_score_card.visible = screen_visible
	if _rank_badge:
		_rank_badge.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	if _stage_label:
		_stage_label.visible = screen_visible
	if _rank_label:
		_rank_label.visible = screen_visible
	if _record_label:
		_record_label.visible = screen_visible
	for label in _row_labels:
		label.visible = screen_visible
	for label in _value_labels:
		label.visible = screen_visible
