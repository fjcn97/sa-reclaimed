# TinyChaoGardenScreen.gd
# Presents the original-inspired Tiny Chao Garden branch and transfer setup.
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
var _menu_stage: ColorRect = null
var _status_stage: ColorRect = null
var _menu_card: ColorRect = null
var _status_card: ColorRect = null
var _prompt_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _summary_label: Label = null
var _status_title_label: Label = null
var _badge_label: Label = null
var _row_cards: Array[ColorRect] = []
var _option_labels: Array[Label] = []
var _meta_labels: Array[Label] = []
var _status_labels: Array[Label] = []
var _info_labels: Array[Label] = []
var _garden_stage: ColorRect = null
var _garden_shadow: ColorRect = null
var _garden_avatar: ColorRect = null
var _garden_face: Label = null

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
	_ensure_info_labels()
	_set_screen_visible(CoreBridge.is_tiny_chao_screen())

func _process(_delta: float) -> void:
	var active: bool = CoreBridge.is_tiny_chao_screen()
	_set_screen_visible(active)
	if not active:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 220.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_tiny_chao_title_text()
		title_label.position = Vector2(316.0, 76.0)
		title_label.size = Vector2(648.0, 52.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.14, 0.28, 0.12, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_tiny_chao_prompt_text()
		prompt_label.position = Vector2(164.0, 558.0)
		prompt_label.size = Vector2(952.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(0.34, 0.62, 0.20, 0.78 + (pulse * 0.18))
	if detail_label:
		detail_label.text = "%s\n%s" % [CoreBridge.get_tiny_chao_summary_text(), CoreBridge.get_tiny_chao_detail_text()]
		detail_label.position = Vector2(148.0, 606.0)
		detail_label.size = Vector2(984.0, 64.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.18, 0.34, 0.16, 0.96)
	_update_option_labels()
	_update_info_labels()
	_update_summary()
	_update_chrome()
	_update_garden_avatar()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.98, 1.0, 0.96, 1.0))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(106.0, 96.0, 1068.0, 504.0), Color(0.56, 0.86, 0.28, 0.10))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(150.0, 68.0, 980.0, 82.0), Color(1.0, 1.0, 1.0, 0.98))
	_panel = _ensure_rect("Panel", Rect2(118.0, 170.0, 1044.0, 352.0), Color(0.98, 1.0, 0.97, 0.99))
	_accent = _ensure_rect("AccentBar", Rect2(118.0, 150.0, 1044.0, 10.0), Color(0.40, 0.84, 0.28, 1.0))
	_header_band = _ensure_rect("HeaderBand", Rect2(160.0, 214.0, 386.0, 258.0), Color(0.90, 0.97, 0.84, 0.98))
	_badge_ring = _ensure_rect("BadgeRing", Rect2(886.0, 224.0, 220.0, 220.0), Color(0.96, 0.86, 0.30, 0.24))
	_badge_core = _ensure_rect("BadgeCore", Rect2(948.0, 286.0, 96.0, 96.0), Color(1.0, 1.0, 1.0, 0.96))
	_menu_stage = _ensure_rect("MenuStage", Rect2(160.0, 214.0, 386.0, 258.0), Color(0.90, 0.97, 0.84, 0.98))
	_status_stage = _ensure_rect("StatusStage", Rect2(582.0, 214.0, 262.0, 258.0), Color(0.56, 0.86, 0.28, 0.94))
	_menu_card = _ensure_rect("MenuCard", Rect2(182.0, 236.0, 342.0, 214.0), Color(0.95, 0.99, 0.90, 0.98))
	_status_card = _ensure_rect("StatusCard", Rect2(610.0, 236.0, 206.0, 214.0), Color(0.99, 0.96, 0.82, 0.98))
	_prompt_band = _ensure_rect("PromptBand", Rect2(118.0, 534.0, 1044.0, 148.0), Color(0.98, 1.0, 0.94, 0.99))
	_garden_stage = _ensure_rect("GardenStage", Rect2(160.0, 214.0, 684.0, 258.0), Color(0.72, 0.90, 0.58, 0.98))
	_garden_shadow = _ensure_rect("GardenShadow", Rect2(454.0, 418.0, 96.0, 16.0), Color(0.18, 0.32, 0.12, 0.28))
	_garden_avatar = _ensure_rect("GardenAvatar", Rect2(476.0, 354.0, 52.0, 68.0), Color(0.30, 0.74, 0.92, 1.0))
	_garden_face = _ensure_label("GardenFace", Vector2(480.0, 372.0), Vector2(44.0, 26.0), 22)
	_garden_face.text = "^_^"
	_garden_face.modulate = Color(1.0, 1.0, 1.0, 0.96)
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_badge_ring.z_index = -3
	_badge_core.z_index = -2
	_menu_stage.z_index = -2
	_status_stage.z_index = -2
	_menu_card.z_index = -1
	_status_card.z_index = -1
	_prompt_band.z_index = -1
	_garden_stage.z_index = -1
	_garden_shadow.z_index = 0
	_garden_avatar.z_index = 1
	_garden_face.z_index = 2
	_garden_stage.visible = false
	_garden_shadow.visible = false
	_garden_avatar.visible = false
	_garden_face.visible = false

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

func _ensure_option_labels() -> void:
	if _summary_label == null:
		_summary_label = _ensure_label("SummaryLabel", Vector2(884.0, 466.0), Vector2(226.0, 112.0), 16)
		_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	if _status_title_label == null:
		_status_title_label = _ensure_label("StatusTitleLabel", Vector2(624.0, 452.0), Vector2(176.0, 24.0), 16)
		_status_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if _badge_label == null:
		_badge_label = _ensure_label("BadgeLabel", Vector2(898.0, 314.0), Vector2(196.0, 34.0), 24)
	if _option_labels.size() > 0:
		return
	for i in range(3):
		var top := 252.0 + float(i) * 66.0
		var card := _ensure_rect("RowCard%d" % i, Rect2(198.0, top, 312.0, 54.0), Color(0.88, 0.95, 0.82, 1.0))
		var option := _ensure_label("OptionLabel%d" % i, Vector2(220.0, top + 6.0), Vector2(160.0, 24.0), 22)
		var meta := _ensure_label("MetaLabel%d" % i, Vector2(222.0, top + 30.0), Vector2(176.0, 18.0), 10)
		var status := _ensure_label("StatusLabel%d" % i, Vector2(384.0, top + 16.0), Vector2(104.0, 18.0), 12)
		option.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_option_labels.append(option)
		_meta_labels.append(meta)
		_status_labels.append(status)

func _ensure_info_labels() -> void:
	if _info_labels.size() > 0:
		return
	for i in range(4):
		var label := _ensure_label("InfoLabel%d" % i, Vector2(632.0, 258.0 + float(i) * 42.0), Vector2(160.0, 34.0), 14)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		_info_labels.append(label)

func _update_option_labels() -> void:
	var rows: Array = CoreBridge.get_tiny_chao_rows()
	for i in range(_option_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_option_labels[i].visible = visible
		_meta_labels[i].visible = visible
		_status_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var name_text := str(row.get("name", ""))
		var status_text := str(row.get("status", ""))
		var lift := -6.0 if is_selected else 0.0
		var top := 252.0 + float(i) * 66.0
		_row_cards[i].position.y = top + lift
		_row_cards[i].size = Vector2(324.0, 58.0) if is_selected else Vector2(312.0, 54.0)
		_option_labels[i].position.y = top + 6.0 + lift
		_meta_labels[i].position.y = top + 30.0 + lift
		_status_labels[i].position.y = top + 16.0 + lift
		_row_cards[i].color = Color(0.36, 0.72, 0.24, 0.98) if is_selected else Color(0.88, 0.95, 0.82, 1.0)
		_option_labels[i].text = name_text
		_meta_labels[i].text = str(row.get("description", ""))
		_status_labels[i].text = status_text
		_option_labels[i].modulate = Color(1.0, 1.0, 1.0, 1.0) if is_selected else Color(0.16, 0.28, 0.12, 0.98)
		_meta_labels[i].modulate = Color(0.96, 1.0, 0.90, 0.96) if is_selected else Color(0.32, 0.46, 0.20, 0.94)
		if status_text == "READY":
			_status_labels[i].modulate = Color(0.14, 0.54, 0.12, 1.0) if not is_selected else Color(0.98, 1.0, 0.90, 1.0)
		elif name_text == "BACK":
			_status_labels[i].modulate = Color(0.72, 0.40, 0.18, 0.96)
		else:
			_status_labels[i].modulate = Color(0.28, 0.44, 0.18, 0.96) if not is_selected else Color(0.98, 1.0, 0.90, 1.0)

func _update_info_labels() -> void:
	var rows: Array = CoreBridge.get_tiny_chao_info_rows()
	for i in range(_info_labels.size()):
		_info_labels[i].text = str(rows[i]) if i < rows.size() else ""
		_info_labels[i].modulate = Color(0.36, 0.26, 0.10, 0.98)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_tiny_chao_summary_text()
		_summary_label.modulate = Color(0.32, 0.24, 0.10, 0.98)
	if _status_title_label:
		_status_title_label.text = "GARDEN STATUS"
		_status_title_label.modulate = Color(0.32, 0.24, 0.10, 0.98)
	if _badge_label:
		_badge_label.text = "CHAO"
		_badge_label.modulate = Color(0.22, 0.44, 0.14, 0.98)

func _update_garden_avatar() -> void:
	var active := CoreBridge.get_title_phase() == CoreBridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY
	if _garden_stage:
		_garden_stage.visible = active
	if _garden_shadow:
		_garden_shadow.visible = active
	if _garden_avatar:
		_garden_avatar.visible = active
		var position := CoreBridge.get_tiny_chao_play_position()
		_garden_avatar.position = Vector2(472.0 + float(position.x) * 300.0, 354.0 + float(position.y) * 82.0)
		var mood := CoreBridge.get_tiny_chao_mood()
		_garden_avatar.color = Color(0.30, 0.74, 0.92, 1.0) if mood >= 50 else Color(0.42, 0.58, 0.82, 1.0)
	if _garden_face:
		_garden_face.visible = active
		var mood := CoreBridge.get_tiny_chao_mood()
		_garden_face.position = _garden_avatar.position + Vector2(4.0, 18.0) if _garden_avatar else Vector2.ZERO
		_garden_face.text = "^_^" if mood >= 60 else ("-_-" if mood >= 30 else "T_T")

func _update_chrome() -> void:
	if _accent == null or _hero_glow == null or _header_band == null or _badge_core == null or _status_card == null:
		return
	var setup_phase := CoreBridge.get_title_phase() == CoreBridge.TITLE_PHASE_TINY_CHAO_SETUP
	var accent := Color(0.30, 0.76, 0.40, 1.0) if setup_phase else Color(0.40, 0.86, 0.46, 1.0)
	var status_color := Color(1.0, 0.94, 0.80, 0.98) if setup_phase else Color(0.99, 0.96, 0.82, 0.98)
	_accent.color = accent
	_hero_glow.color = Color(accent.r, accent.g, accent.b, 0.10)
	if _header_plate:
		_header_plate.color = Color(1.0, 1.0, 1.0, 0.98)
	_header_band.color = Color(0.90, 0.97, 0.84, 0.98)
	if _menu_stage:
		_menu_stage.color = Color(0.90, 0.97, 0.84, 0.98)
	if _status_stage:
		_status_stage.color = Color(accent.r, accent.g, accent.b, 0.94)
	_badge_core.color = Color(1.0, 1.0, 1.0, 0.96)
	_status_card.color = status_color
	if _menu_card:
		_menu_card.color = Color(0.95, 0.99, 0.90, 0.98)

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
	if _menu_stage:
		_menu_stage.visible = screen_visible
	if _status_stage:
		_status_stage.visible = screen_visible
	if _menu_card:
		_menu_card.visible = screen_visible
	if _status_card:
		_status_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _garden_stage:
		_garden_stage.visible = screen_visible and CoreBridge.get_title_phase() == CoreBridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY
	if _garden_shadow:
		_garden_shadow.visible = screen_visible and CoreBridge.get_title_phase() == CoreBridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY
	if _garden_avatar:
		_garden_avatar.visible = screen_visible and CoreBridge.get_title_phase() == CoreBridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY
	if _garden_face:
		_garden_face.visible = screen_visible and CoreBridge.get_title_phase() == CoreBridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _status_title_label:
		_status_title_label.visible = screen_visible
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
	for label in _option_labels:
		label.visible = screen_visible
	for label in _meta_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = screen_visible
	for label in _info_labels:
		label.visible = screen_visible
