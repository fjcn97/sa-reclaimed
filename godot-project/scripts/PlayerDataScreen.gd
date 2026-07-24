# PlayerDataScreen.gd
# Presents an original-inspired dedicated player data submenu.
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
var _profile_stage: ColorRect = null
var _menu_stage: ColorRect = null
var _summary_stage: ColorRect = null
var _profile_card: ColorRect = null
var _menu_card: ColorRect = null
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _profile_label: Label = null
var _slot_label: Label = null
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
	_ensure_header_labels()
	_ensure_rows()
	_set_screen_visible(CoreBridge.is_player_data_screen())

func _process(_delta: float) -> void:
	var active: bool = CoreBridge.is_player_data_screen()
	_set_screen_visible(active)
	if not active:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 210.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_player_data_title_text()
		title_label.position = Vector2(334.0, 76.0)
		title_label.size = Vector2(604.0, 52.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.18, 0.30, 0.24, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_player_data_prompt_text()
		prompt_label.position = Vector2(164.0, 558.0)
		prompt_label.size = Vector2(952.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(0.18, 0.74, 0.54, 0.76 + (pulse * 0.18))
	if detail_label:
		detail_label.text = "%s\n%s" % [CoreBridge.get_player_data_summary_text(), CoreBridge.get_player_data_detail_text()]
		detail_label.position = Vector2(148.0, 606.0)
		detail_label.size = Vector2(984.0, 64.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.20, 0.34, 0.28, 0.96)
	_update_chrome()
	_update_header()
	_update_rows()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.98, 1.0, 0.98, 1.0))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(104.0, 96.0, 1072.0, 504.0), Color(0.24, 0.80, 0.58, 0.10))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(150.0, 68.0, 980.0, 82.0), Color(1.0, 1.0, 1.0, 0.98))
	_panel = _ensure_rect("Panel", Rect2(118.0, 170.0, 1044.0, 352.0), Color(0.98, 1.0, 0.99, 0.99))
	_accent = _ensure_rect("AccentBar", Rect2(118.0, 150.0, 1044.0, 10.0), Color(0.20, 0.80, 0.56, 0.96))
	_header_band = _ensure_rect("HeaderBand", Rect2(160.0, 214.0, 412.0, 258.0), Color(0.90, 0.98, 0.92, 0.98))
	_profile_stage = _ensure_rect("ProfileStage", Rect2(160.0, 214.0, 412.0, 62.0), Color(0.90, 0.98, 0.92, 0.98))
	_menu_stage = _ensure_rect("MenuStage", Rect2(160.0, 286.0, 412.0, 166.0), Color(0.94, 1.0, 0.96, 0.98))
	_summary_stage = _ensure_rect("SummaryStage", Rect2(610.0, 214.0, 236.0, 258.0), Color(0.20, 0.80, 0.56, 0.94))
	_badge_ring = _ensure_rect("BadgeRing", Rect2(892.0, 224.0, 220.0, 220.0), Color(0.20, 0.80, 0.56, 0.22))
	_badge_core = _ensure_rect("BadgeCore", Rect2(954.0, 286.0, 96.0, 96.0), Color(1.0, 1.0, 1.0, 0.96))
	_profile_card = _ensure_rect("ProfileCard", Rect2(184.0, 228.0, 364.0, 34.0), Color(0.94, 1.0, 0.96, 0.98))
	_menu_card = _ensure_rect("MenuCard", Rect2(184.0, 304.0, 364.0, 132.0), Color(0.98, 1.0, 0.98, 0.98))
	_summary_card = _ensure_rect("SummaryCard", Rect2(638.0, 236.0, 180.0, 214.0), Color(0.94, 1.0, 0.96, 0.98))
	_prompt_band = _ensure_rect("PromptBand", Rect2(118.0, 534.0, 1044.0, 148.0), Color(0.96, 1.0, 0.97, 0.99))
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_profile_stage.z_index = -3
	_menu_stage.z_index = -3
	_summary_stage.z_index = -3
	_badge_ring.z_index = -2
	_badge_core.z_index = -1
	_profile_card.z_index = -1
	_menu_card.z_index = -1
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

func _ensure_header_labels() -> void:
	_profile_label = _ensure_label("ProfileLabel", Vector2(208.0, 234.0), Vector2(214.0, 22.0), 16)
	_profile_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_slot_label = _ensure_label("SlotLabel", Vector2(372.0, 234.0), Vector2(152.0, 22.0), 12)
	_slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_summary_label = _ensure_label("SummaryLabel", Vector2(884.0, 464.0), Vector2(228.0, 116.0), 16)
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _ensure_rows() -> void:
	if _row_labels.size() > 0:
		return
	for i in range(4):
		var top := 320.0 + float(i) * 28.0
		var card := _ensure_rect("RowCard%d" % i, Rect2(198.0, top, 336.0, 24.0), Color(0.90, 0.97, 0.92, 1.0))
		var row := _ensure_label("RowLabel%d" % i, Vector2(218.0, top - 1.0), Vector2(134.0, 24.0), 14)
		var value := _ensure_label("ValueLabel%d" % i, Vector2(352.0, top - 1.0), Vector2(116.0, 24.0), 11)
		var status := _ensure_label("StatusLabel%d" % i, Vector2(468.0, top - 1.0), Vector2(52.0, 24.0), 11)
		row.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		value.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(row)
		_value_labels.append(value)
		_status_labels.append(status)

func _update_header() -> void:
	if _profile_label:
		_profile_label.text = CoreBridge.get_player_data_header_text()
		_profile_label.modulate = Color(0.18, 0.30, 0.24, 1.0)
	if _slot_label:
		_slot_label.text = CoreBridge.get_player_data_slot_text()
		_slot_label.modulate = Color(0.28, 0.48, 0.34, 0.96)
	if _summary_label:
		_summary_label.text = CoreBridge.get_player_data_summary_text().replace("\n", "\n")
		_summary_label.modulate = Color(0.18, 0.30, 0.24, 0.98)
	if _badge_label == null:
		_badge_label = _ensure_label("BadgeLabel", Vector2(902.0, 316.0), Vector2(200.0, 34.0), 22)
	if _badge_label:
		_badge_label.text = CoreBridge.get_menu_badge_text("PROFILE")
		_badge_label.modulate = Color(0.18, 0.30, 0.24, 0.98)

func _update_chrome() -> void:
	var accent := Color(0.20, 0.80, 0.56, 0.92)
	if _accent:
		_accent.color = accent
	if _hero_glow:
		_hero_glow.color = Color(accent.r, accent.g, accent.b, 0.10)
	if _header_plate:
		_header_plate.color = Color(1.0, 1.0, 1.0, 0.98)
	if _header_band:
		_header_band.color = Color(0.90, 0.98, 0.92, 0.98)
	if _profile_stage:
		_profile_stage.color = Color(0.90, 0.98, 0.92, 0.98)
	if _menu_stage:
		_menu_stage.color = Color(0.94, 1.0, 0.96, 0.98)
	if _summary_stage:
		_summary_stage.color = Color(accent.r, accent.g, accent.b, 0.94)
	if _badge_core:
		_badge_core.color = Color(1.0, 1.0, 1.0, 0.96)
	if _summary_card:
		_summary_card.color = Color(0.94, 1.0, 0.96, 0.98)

func _update_rows() -> void:
	var rows: Array = CoreBridge.get_player_data_rows()
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
		var is_profile := bool(row.get("profile", false))
		var status_text := str(row.get("status", ""))
		var top := 320.0 + float(i) * 28.0
		var lift := -2.0 if is_selected else 0.0
		_row_cards[i].position.y = top + lift
		_row_cards[i].size = Vector2(348.0, 26.0) if is_selected else Vector2(336.0, 24.0)
		_row_labels[i].position.y = top - 1.0 + lift
		_value_labels[i].position.y = top - 1.0 + lift
		_status_labels[i].position.y = top - 1.0 + lift
		_row_cards[i].color = Color(0.20, 0.80, 0.56, 0.98) if is_selected else Color(0.90, 0.97, 0.92, 1.0)
		_row_labels[i].text = str(row.get("label", ""))
		_value_labels[i].text = str(row.get("value", ""))
		_status_labels[i].text = status_text
		_row_labels[i].modulate = Color(1.0, 1.0, 1.0, 1.0) if is_selected else Color(0.18, 0.30, 0.24, 1.0)
		_value_labels[i].modulate = Color(0.96, 0.99, 0.98, 0.96) if is_selected else Color(0.30, 0.48, 0.38, 0.94)
		if is_profile:
			_status_labels[i].modulate = Color(0.96, 1.0, 0.98, 1.0) if is_selected else Color(0.18, 0.46, 0.30, 1.0)
		else:
			_status_labels[i].modulate = Color(0.96, 1.0, 0.98, 1.0) if is_selected else Color(0.34, 0.50, 0.40, 0.92)

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
	if _profile_stage:
		_profile_stage.visible = screen_visible
	if _menu_stage:
		_menu_stage.visible = screen_visible
	if _summary_stage:
		_summary_stage.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _profile_card:
		_profile_card.visible = screen_visible
	if _menu_card:
		_menu_card.visible = screen_visible
	if _summary_card:
		_summary_card.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	if _profile_label:
		_profile_label.visible = screen_visible
	if _slot_label:
		_slot_label.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	for card in _row_cards:
		card.visible = screen_visible
	for label in _row_labels:
		label.visible = screen_visible
	for label in _value_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = screen_visible
