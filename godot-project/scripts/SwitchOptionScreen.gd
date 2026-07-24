# SwitchOptionScreen.gd
# Presents an original-inspired two-choice submenu used by options toggles.
extends CanvasLayer

@export var screen_id: String = ""
@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _accent: ColorRect = null
var _header_band: ColorRect = null
var _choice_stage: ColorRect = null
var _summary_stage: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _choice_card: ColorRect = null
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _summary_label: Label = null
var _badge_label: Label = null
var _row_cards: Array[ColorRect] = []
var _row_labels: Array[Label] = []
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
	_set_screen_visible(_is_active())

func _process(_delta: float) -> void:
	var active := _is_active()
	_set_screen_visible(active)
	if not active:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 210.0) * 0.5)
	if title_label:
		title_label.text = _get_title_text()
		title_label.position = Vector2(248.0, 116.0)
		title_label.size = Vector2(628.0, 56.0)
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = _get_prompt_text()
		prompt_label.position = Vector2(180.0, 550.0)
		prompt_label.size = Vector2(920.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = _get_prompt_color(pulse)
	if detail_label:
		detail_label.text = "%s   |   %s" % [_get_summary_text().replace("\n", "   "), _get_detail_text()]
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = _get_footer_color()
	_update_chrome()
	_update_summary()
	_update_rows()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.04, 0.09, 0.68))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.20, 0.28, 0.40, 0.18))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.10, 0.10, 0.12, 0.94))
	_panel = _ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.05, 0.09, 0.17, 0.96))
	_accent = _ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), _get_accent_color())
	_header_band = _ensure_rect("HeaderBand", Rect2(210.0, 246.0, 288.0, 238.0), Color(0.20, 0.18, 0.14, 0.92))
	_choice_stage = _ensure_rect("ChoiceStage", Rect2(204.0, 246.0, 562.0, 238.0), Color(0.05, 0.10, 0.18, 0.92))
	_summary_stage = _ensure_rect("SummaryStage", Rect2(792.0, 246.0, 280.0, 238.0), Color(0.10, 0.16, 0.28, 0.94))
	_badge_ring = _ensure_rect("BadgeRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(0.92, 0.78, 0.24, 0.22))
	_badge_core = _ensure_rect("BadgeCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.20, 0.18, 0.14, 0.96))
	_choice_card = _ensure_rect("ChoiceCard", Rect2(226.0, 302.0, 518.0, 126.0), Color(0.05, 0.10, 0.18, 0.92))
	_summary_card = _ensure_rect("SummaryCard", Rect2(818.0, 278.0, 228.0, 196.0), Color(0.07, 0.14, 0.25, 0.95))
	_prompt_band = _ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.04, 0.08, 0.16, 0.92))
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_choice_stage.z_index = -3
	_summary_stage.z_index = -3
	_badge_ring.z_index = -2
	_badge_core.z_index = -1
	_choice_card.z_index = -1
	_summary_card.z_index = -1
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
		_summary_label = _ensure_label("SummaryLabel", Vector2(838.0, 304.0), Vector2(188.0, 148.0), 16)
		_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if _row_labels.size() > 0:
		return
	for i in range(2):
		var top := 328.0 + float(i) * 42.0
		var card := _ensure_rect("RowCard%d" % i, Rect2(252.0, top, 466.0, 30.0), Color(0.10, 0.16, 0.29, 0.96))
		var row := _ensure_label("RowLabel%d" % i, Vector2(276.0, top), Vector2(130.0, 28.0), 20)
		var status := _ensure_label("StatusLabel%d" % i, Vector2(420.0, top), Vector2(274.0, 28.0), 12)
		row.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(row)
		_status_labels.append(status)

func _update_chrome() -> void:
	var accent_color := _get_accent_color()
	if _hero_glow:
		_hero_glow.color = Color(accent_color.r * 0.45, accent_color.g * 0.42, accent_color.b * 0.38, 0.18)
	if _header_plate:
		_header_plate.color = Color(accent_color.r * 0.20, accent_color.g * 0.18, accent_color.b * 0.16, 0.92)
	if _accent:
		_accent.color = accent_color
	if _header_band:
		_header_band.color = Color(accent_color.r * 0.32, accent_color.g * 0.28, accent_color.b * 0.24, 0.92)
	if _choice_stage:
		_choice_stage.color = _get_body_card_color()
	if _summary_stage:
		_summary_stage.color = _get_summary_stage_color()
	if _badge_core:
		_badge_core.color = Color(accent_color.r * 0.32, accent_color.g * 0.28, accent_color.b * 0.24, 0.96)
	if _choice_card:
		_choice_card.color = _get_body_card_color()
	if _summary_card:
		_summary_card.color = _get_summary_stage_color()
	if _prompt_band:
		_prompt_band.color = _get_prompt_band_color()

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = _get_summary_text().replace("\n", "\n")
		_summary_label.modulate = _get_summary_color()
	if _badge_label == null:
		_badge_label = _ensure_label("BadgeLabel", Vector2(886.0, 160.0), Vector2(124.0, 38.0), 18)
	if _badge_label:
		_badge_label.text = _get_badge_text()
		_badge_label.modulate = _get_badge_text_color()

func _update_rows() -> void:
	var rows := _get_rows()
	for i in range(_row_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_row_labels[i].visible = visible
		_status_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var top := 328.0 + float(i) * 42.0
		var lift := -4.0 if is_selected else 0.0
		_row_cards[i].position.y = top + lift
		_row_labels[i].position.y = top + lift
		_status_labels[i].position.y = top + lift
		_row_cards[i].color = _get_row_card_color(is_selected, i)
		_row_labels[i].text = str(row.get("label", ""))
		_status_labels[i].text = str(row.get("status", ""))
		_row_labels[i].modulate = _get_row_text_color(is_selected, i)
		_status_labels[i].modulate = _get_row_status_color(is_selected, i)

func _is_active() -> bool:
	if screen_id == "difficulty":
		return CoreBridge.is_difficulty_screen()
	if screen_id == "time_limit":
		return CoreBridge.is_time_limit_screen()
	if screen_id == "delete_confirm":
		return CoreBridge.is_delete_confirm_screen()
	if screen_id == "delete_final":
		return CoreBridge.is_delete_final_confirm_screen()
	return false

func _get_title_text() -> String:
	if screen_id == "difficulty":
		return CoreBridge.get_difficulty_title_text()
	if screen_id == "time_limit":
		return CoreBridge.get_time_limit_title_text()
	if screen_id == "delete_confirm" or screen_id == "delete_final":
		return CoreBridge.get_delete_confirm_title_text()
	return ""

func _get_prompt_text() -> String:
	if screen_id == "difficulty":
		return CoreBridge.get_difficulty_prompt_text()
	if screen_id == "time_limit":
		return CoreBridge.get_time_limit_prompt_text()
	if screen_id == "delete_confirm" or screen_id == "delete_final":
		return CoreBridge.get_delete_confirm_prompt_text()
	return ""

func _get_summary_text() -> String:
	if screen_id == "difficulty":
		return CoreBridge.get_difficulty_summary_text()
	if screen_id == "time_limit":
		return CoreBridge.get_time_limit_summary_text()
	if screen_id == "delete_confirm" or screen_id == "delete_final":
		return CoreBridge.get_delete_confirm_summary_text()
	return ""

func _get_detail_text() -> String:
	if screen_id == "difficulty":
		return CoreBridge.get_difficulty_detail_text()
	if screen_id == "time_limit":
		return CoreBridge.get_time_limit_detail_text()
	if screen_id == "delete_confirm" or screen_id == "delete_final":
		return CoreBridge.get_delete_confirm_detail_text()
	return ""

func _get_rows() -> Array:
	if screen_id == "difficulty":
		return CoreBridge.get_difficulty_rows()
	if screen_id == "time_limit":
		return CoreBridge.get_time_limit_rows()
	if screen_id == "delete_confirm" or screen_id == "delete_final":
		return CoreBridge.get_delete_confirm_rows()
	return []

func _get_chrome_colors() -> Dictionary:
	if screen_id == "difficulty":
		return CoreBridge.get_difficulty_chrome_colors()
	if screen_id == "time_limit":
		return CoreBridge.get_time_limit_chrome_colors()
	if screen_id == "delete_confirm" or screen_id == "delete_final":
		return CoreBridge.get_delete_confirm_chrome_colors()
	return {}

func _get_accent_color() -> Color:
	return _get_chrome_colors().get("accent", Color(0.24, 0.78, 0.96, 1.0))

func _get_card_color() -> Color:
	return _get_chrome_colors().get("card", Color(0.86, 0.94, 1.0, 0.98))

func _get_text_color() -> Color:
	return _get_chrome_colors().get("text", Color(0.10, 0.12, 0.18, 1.0))

func _get_detail_color() -> Color:
	var base: Color = _get_text_color()
	return Color(base.r, base.g, base.b, 0.96)

func _get_status_color() -> Color:
	var base: Color = _get_text_color()
	return Color(base.r, base.g, base.b, 0.86)

func _is_delete_screen() -> bool:
	return screen_id == "delete_confirm" or screen_id == "delete_final"

func _is_delete_final_screen() -> bool:
	return screen_id == "delete_final"

func _get_badge_text() -> String:
	return CoreBridge.get_switch_option_badge_text(screen_id)

func _get_badge_text_color() -> Color:
	if _is_delete_screen():
		return Color(1.0, 0.90, 0.90, 0.96)
	return Color(1.0, 0.95, 0.74, 0.95)

func _get_prompt_color(pulse: float) -> Color:
	if _is_delete_final_screen():
		return Color(1.0, 0.58, 0.58, 0.74 + (pulse * 0.26))
	if _is_delete_screen():
		return Color(1.0, 0.74, 0.52, 0.74 + (pulse * 0.26))
	return Color(1.0, 0.90, 0.52, 0.74 + (pulse * 0.26))

func _get_footer_color() -> Color:
	if _is_delete_screen():
		return Color(0.96, 0.84, 0.84, 0.92)
	return Color(0.72, 0.86, 1.0, 0.92)

func _get_summary_color() -> Color:
	if _is_delete_screen():
		return Color(0.98, 0.90, 0.90, 0.98)
	return Color(0.90, 0.96, 1.0, 0.98)

func _get_body_card_color() -> Color:
	if _is_delete_final_screen():
		return Color(0.16, 0.05, 0.07, 0.94)
	if _is_delete_screen():
		return Color(0.18, 0.08, 0.07, 0.92)
	return Color(0.05, 0.10, 0.18, 0.92)

func _get_summary_stage_color() -> Color:
	if _is_delete_final_screen():
		return Color(0.22, 0.08, 0.10, 0.94)
	if _is_delete_screen():
		return Color(0.24, 0.10, 0.10, 0.94)
	return Color(0.07, 0.14, 0.25, 0.95)

func _get_prompt_band_color() -> Color:
	if _is_delete_screen():
		return Color(0.14, 0.05, 0.06, 0.94)
	return Color(0.04, 0.08, 0.16, 0.92)

func _get_row_card_color(is_selected: bool, index: int) -> Color:
	if not _is_delete_screen():
		return Color(0.22, 0.38, 0.62, 0.98) if is_selected else Color(0.10, 0.16, 0.29, 0.96)
	if is_selected and index == 0:
		return Color(0.62, 0.18, 0.18, 0.98)
	if is_selected:
		return Color(0.20, 0.36, 0.24, 0.98)
	return Color(0.20, 0.10, 0.12, 0.96)

func _get_row_text_color(is_selected: bool, index: int) -> Color:
	if not _is_delete_screen():
		return Color(1.0, 0.98, 0.84, 1.0) if is_selected else Color(0.98, 0.98, 1.0, 1.0)
	if is_selected and index == 0:
		return Color(1.0, 0.94, 0.94, 1.0)
	if is_selected:
		return Color(0.92, 1.0, 0.94, 1.0)
	return Color(0.98, 0.94, 0.94, 1.0)

func _get_row_status_color(is_selected: bool, index: int) -> Color:
	if not _is_delete_screen():
		return Color(0.84, 0.90, 0.98, 0.92)
	if index == 0:
		return Color(1.0, 0.72, 0.72, 0.96)
	if is_selected:
		return Color(0.78, 0.94, 0.82, 0.96)
	return Color(0.92, 0.96, 0.94, 0.92)

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
	if _choice_stage:
		_choice_stage.visible = screen_visible
	if _summary_stage:
		_summary_stage.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _choice_card:
		_choice_card.visible = screen_visible
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
	for card in _row_cards:
		card.visible = screen_visible
	for label in _row_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = screen_visible
