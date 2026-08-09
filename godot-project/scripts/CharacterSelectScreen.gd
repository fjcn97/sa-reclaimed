extends ScreenBase

const CHARACTER_WHEEL_VIEW := preload("res://scripts/ui/CharacterWheelView.gd")

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _accent: ColorRect = null
var _left_stage: ColorRect = null
var _right_stage: ColorRect = null
var _prompt_band: ColorRect = null
var _header_band: ColorRect = null
var _wheel_shadow: ColorRect = null
var _wheel_ring: ColorRect = null
var _wheel_core: ColorRect = null
var _portrait_ring: ColorRect = null
var _portrait_card: ColorRect = null
var _portrait_glow: ColorRect = null
var _roster_card: ColorRect = null
var _summary_card: ColorRect = null
var _context_chip: ColorRect = null
var _title_rule: ColorRect = null
var _context_label: Label = null
var _selected_name_label: Label = null
var _selected_desc_label: Label = null
var _summary_label: Label = null
var _emblem_label: Label = null
var _row_cards: Array[ColorRect] = []
var _row_labels: Array[Label] = []
var _desc_labels: Array[Label] = []
var _status_labels: Array[Label] = []
var _wheel_nodes: Array[ColorRect] = []
var _wheel_node_labels: Array[Label] = []
var _selected_node_ring: ColorRect = null
var _wheel_time: float = 0.0
var _wheel_view := CHARACTER_WHEEL_VIEW.new()

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
	var wheel_nodes := _wheel_view.setup(self)
	_wheel_nodes.assign(wheel_nodes["wheel_nodes"])
	_wheel_node_labels.assign(wheel_nodes["wheel_node_labels"])
	_selected_node_ring = wheel_nodes["selected_node_ring"] as ColorRect
	_set_screen_visible(CoreBridge.is_character_select())

func _process(delta: float) -> void:
	var active: bool = CoreBridge.is_character_select()
	_set_screen_visible(active)
	if not active:
		return
	_wheel_time += delta * 2.6
	var intro_progress := CoreBridge.get_character_select_intro_progress()
	var intro_amount := 1.0 - intro_progress
	var side_shift := 82.0 * intro_amount
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 220.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_character_select_title_text()
		title_label.position = Vector2(248.0, 116.0 - 34.0 * intro_amount)
		title_label.size = Vector2(612.0, 56.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 0.30 + intro_progress * 0.70)
	if prompt_label:
		prompt_label.text = CoreBridge.get_character_select_prompt_text()
		prompt_label.position = Vector2(188.0, 548.0)
		prompt_label.size = Vector2(904.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.54, (0.30 + intro_progress * 0.44) + (pulse * 0.24))
	if detail_label:
		detail_label.text = CoreBridge.get_character_select_detail_text()
		detail_label.position = Vector2(170.0, 664.0)
		detail_label.size = Vector2(940.0, 32.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.74, 0.86, 1.0, 0.92)
	_update_selected_character()
	_update_rows()
	_update_wheel()
	_update_chrome()
	if _left_stage:
		_left_stage.position.x = 204.0 - side_shift
	if _header_band:
		_header_band.position.x = 210.0 - side_shift
	if _right_stage:
		_right_stage.position.x = 576.0 + side_shift
	if _roster_card:
		_roster_card.position.x = 602.0 + side_shift
	if _context_chip:
		_context_chip.position.x = 602.0 + side_shift

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.05, 0.10, 0.68))
	_hero_glow = ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.12, 0.24, 0.56, 0.18))
	_header_plate = ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.08, 0.10, 0.18, 0.94))
	_panel = ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.05, 0.09, 0.17, 0.96))
	_accent = ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.18, 0.48, 0.86, 0.72))
	_header_band = ensure_rect("HeaderBand", Rect2(210.0, 246.0, 326.0, 254.0), Color(0.08, 0.15, 0.30, 0.92))
	_left_stage = ensure_rect("LeftStage", Rect2(204.0, 246.0, 346.0, 254.0), Color(0.08, 0.12, 0.24, 0.94))
	_right_stage = ensure_rect("RightStage", Rect2(576.0, 246.0, 498.0, 254.0), Color(0.10, 0.16, 0.28, 0.94))
	_prompt_band = ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.04, 0.08, 0.16, 0.92))
	_title_rule = ensure_rect("TitleRule", Rect2(238.0, 202.0, 804.0, 5.0), Color(0.86, 0.90, 1.0, 0.34))
	_wheel_shadow = ensure_rect("WheelShadow", Rect2(184.0, 258.0, 238.0, 210.0), Color(0.00, 0.04, 0.10, 0.26))
	_wheel_ring = ensure_rect("WheelRing", Rect2(214.0, 274.0, 152.0, 152.0), Color(0.16, 0.28, 0.52, 0.94))
	_wheel_core = ensure_rect("WheelCore", Rect2(246.0, 306.0, 88.0, 88.0), Color(0.09, 0.14, 0.24, 1.0))
	_portrait_ring = ensure_rect("PortraitRing", Rect2(392.0, 270.0, 122.0, 122.0), Color(0.92, 0.76, 0.24, 0.20))
	_portrait_card = ensure_rect("PortraitCard", Rect2(362.0, 304.0, 174.0, 166.0), Color(0.08, 0.14, 0.24, 0.98))
	_portrait_glow = ensure_rect("PortraitGlow", Rect2(382.0, 320.0, 134.0, 102.0), Color(0.30, 0.78, 0.98, 0.28))
	_summary_card = ensure_rect("SummaryCard", Rect2(230.0, 450.0, 296.0, 58.0), Color(0.07, 0.13, 0.23, 0.95))
	_roster_card = ensure_rect("RosterCard", Rect2(602.0, 274.0, 446.0, 194.0), Color(0.07, 0.13, 0.23, 0.95))
	_context_chip = ensure_rect("ContextChip", Rect2(602.0, 252.0, 164.0, 30.0), Color(0.18, 0.38, 0.86, 0.96))
	_backdrop.z_index = -11
	_hero_glow.z_index = -10
	_header_plate.z_index = -9
	_panel.z_index = -8
	_accent.z_index = -7
	_header_band.z_index = -6
	_left_stage.z_index = -5
	_right_stage.z_index = -5
	_prompt_band.z_index = -5
	_title_rule.z_index = -4
	_wheel_shadow.z_index = -3
	_wheel_ring.z_index = -2
	_wheel_core.z_index = -1
	_portrait_ring.z_index = -1
	_portrait_card.z_index = 0
	_portrait_glow.z_index = 1
	_summary_card.z_index = 0
	_roster_card.z_index = 0
	_context_chip.z_index = 1

func _ensure_header_labels() -> void:
	_context_label = ensure_label("ContextLabel", Vector2(614.0, 252.0), Vector2(140.0, 26.0), 14)
	_context_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_selected_name_label = ensure_label("SelectedNameLabel", Vector2(226.0, 252.0), Vector2(300.0, 38.0), 28)
	_selected_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_selected_desc_label = ensure_label("SelectedDescLabel", Vector2(230.0, 290.0), Vector2(292.0, 48.0), 15)
	_selected_desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_selected_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label = ensure_label("SummaryLabel", Vector2(248.0, 458.0), Vector2(260.0, 44.0), 14)
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_emblem_label = ensure_label("EmblemLabel", Vector2(416.0, 312.0), Vector2(74.0, 38.0), 26)
	_emblem_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _ensure_rows() -> void:
	if _row_labels.size() > 0:
		return
	for i in range(5):
		var top := 290.0 + float(i) * 36.0
		var card := ensure_rect("RowCard%d" % i, Rect2(624.0, top, 398.0, 30.0), Color(0.10, 0.16, 0.29, 0.96))
		var row := ensure_label("RowLabel%d" % i, Vector2(642.0, top - 1.0), Vector2(132.0, 16.0), 17)
		var desc := ensure_label("DescLabel%d" % i, Vector2(642.0, top + 14.0), Vector2(176.0, 14.0), 10)
		var status := ensure_label("StatusLabel%d" % i, Vector2(826.0, top + 5.0), Vector2(176.0, 18.0), 12)
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(row)
		_desc_labels.append(desc)
		_status_labels.append(status)

func _update_selected_character() -> void:
	var selected_name := CoreBridge.get_selected_character_name()
	var selected_desc := CoreBridge.get_selected_character_description()
	if _context_label:
		_context_label.text = CoreBridge.get_character_select_context_label()
		_context_label.modulate = Color(0.95, 0.98, 1.0, 1.0)
	if _selected_name_label:
		_selected_name_label.text = selected_name
		_selected_name_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if _selected_desc_label:
		_selected_desc_label.text = selected_desc
		_selected_desc_label.modulate = Color(0.76, 0.88, 1.0, 0.94)
	if _summary_label:
		_summary_label.text = CoreBridge.get_character_select_summary_text()
		_summary_label.modulate = Color(0.88, 0.94, 1.0, 0.96)
	if _emblem_label:
		var compact := selected_name.replace(" ", "")
		_emblem_label.text = compact.left(2) if compact.length() >= 2 else compact
		_emblem_label.modulate = Color(1.0, 0.95, 0.74, 0.98)

func _update_rows() -> void:
	var rows: Array = CoreBridge.get_character_select_rows()
	for i in range(_row_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_row_labels[i].visible = visible
		_desc_labels[i].visible = visible
		_status_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var is_available := bool(row.get("available", false))
		var status_text := str(row.get("status", ""))
		var top := 290.0 + float(i) * 36.0
		var lift := 0.0
		_row_cards[i].position = Vector2(624.0, top + lift)
		_row_labels[i].position = Vector2(642.0, top - 1.0 + lift)
		_desc_labels[i].position = Vector2(642.0, top + 14.0 + lift)
		_status_labels[i].position = Vector2(826.0, top + 5.0 + lift)
		_row_cards[i].color = Color(0.22, 0.38, 0.62, 0.98) if is_selected else Color(0.10, 0.16, 0.29, 0.96)
		_row_labels[i].text = str(row.get("name", ""))
		_desc_labels[i].text = str(row.get("description", ""))
		_status_labels[i].text = status_text
		_row_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0) if is_selected else Color(0.98, 0.98, 1.0, 1.0)
		_desc_labels[i].modulate = Color(0.70, 0.84, 1.0, 0.94)
		_status_labels[i].modulate = Color(0.32, 1.0, 0.56, 1.0) if is_available else Color(0.62, 0.66, 0.76, 0.96)

func _update_wheel() -> void:
	_wheel_view.update(get_process_delta_time(), _wheel_time)

func _update_chrome() -> void:
	var unlocked := CoreBridge.is_character_unlocked(CoreBridge.get_character_menu_index())
	var chrome := CoreBridge.get_character_select_chrome_colors()
	var chip_color := Color(chrome.get("chip", Color(0.22, 0.42, 0.86, 0.96)))
	var glow_ready := Color(chrome.get("glow_ready", Color(0.32, 0.78, 0.98, 0.28)))
	var glow_locked := Color(chrome.get("glow_locked", Color(0.22, 0.24, 0.30, 0.24)))
	if _hero_glow:
		_hero_glow.color = Color(chip_color.r * 0.62, chip_color.g * 0.72, chip_color.b * 0.98, 0.18)
	if _header_plate:
		_header_plate.color = Color(chip_color.r * 0.22, chip_color.g * 0.28, chip_color.b * 0.42, 0.92)
	if _panel:
		_panel.color = Color(chip_color.r * 0.20, chip_color.g * 0.24, chip_color.b * 0.40, 0.96)
	if _header_band:
		_header_band.color = Color(chip_color.r * 0.36, chip_color.g * 0.42, chip_color.b * 0.64, 0.92)
	if _left_stage:
		_left_stage.color = Color(chip_color.r * 0.30, chip_color.g * 0.34, chip_color.b * 0.58, 0.94)
	if _right_stage:
		_right_stage.color = Color(0.10, 0.16, 0.28, 0.94)
	if _accent:
		_accent.color = chip_color
	if _prompt_band:
		_prompt_band.color = Color(0.04, 0.08, 0.16, 0.92)
	if _portrait_glow:
		_portrait_glow.color = glow_ready if unlocked else glow_locked
	if _context_chip:
		_context_chip.color = chip_color
	if _wheel_ring:
		_wheel_ring.color = Color(chip_color.r * 0.78, chip_color.g * 0.78, chip_color.b * 0.92, 0.94)
	if _portrait_ring:
		_portrait_ring.color = Color(chip_color.r + 0.54, chip_color.g + 0.42, chip_color.b * 0.42, 0.22)
	if _wheel_core:
		_wheel_core.color = Color(chip_color.r * 0.24, chip_color.g * 0.30, chip_color.b * 0.44, 1.0)
	if _portrait_card:
		_portrait_card.color = Color(chip_color.r * 0.24, chip_color.g * 0.30, chip_color.b * 0.44, 0.98)
	if _summary_card:
		_summary_card.color = Color(0.07, 0.13, 0.23, 0.95)
	if _roster_card:
		_roster_card.color = Color(0.07, 0.13, 0.23, 0.95)
	if _title_rule:
		_title_rule.color = Color(chip_color.r, chip_color.g, chip_color.b, 0.34)

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
	if _left_stage:
		_left_stage.visible = screen_visible
	if _right_stage:
		_right_stage.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _header_band:
		_header_band.visible = screen_visible
	if _title_rule:
		_title_rule.visible = screen_visible
	if _wheel_shadow:
		_wheel_shadow.visible = screen_visible
	if _wheel_ring:
		_wheel_ring.visible = screen_visible
	if _wheel_core:
		_wheel_core.visible = screen_visible
	if _portrait_ring:
		_portrait_ring.visible = screen_visible
	if _portrait_card:
		_portrait_card.visible = screen_visible
	if _portrait_glow:
		_portrait_glow.visible = screen_visible
	if _summary_card:
		_summary_card.visible = screen_visible
	if _roster_card:
		_roster_card.visible = screen_visible
	if _context_chip:
		_context_chip.visible = screen_visible
	if _selected_node_ring:
		_selected_node_ring.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	if _context_label:
		_context_label.visible = screen_visible
	if _selected_name_label:
		_selected_name_label.visible = screen_visible
	if _selected_desc_label:
		_selected_desc_label.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _emblem_label:
		_emblem_label.visible = screen_visible
	for card in _row_cards:
		card.visible = screen_visible
	for label in _row_labels:
		label.visible = screen_visible
	for label in _desc_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = screen_visible
	for node in _wheel_nodes:
		node.visible = screen_visible
	for label in _wheel_node_labels:
		label.visible = screen_visible
