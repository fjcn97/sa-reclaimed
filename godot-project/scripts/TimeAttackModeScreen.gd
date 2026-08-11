extends ScreenBase

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
var _info_card: ColorRect = null
var _summary_card: ColorRect = null
var _emblem_ring: ColorRect = null
var _emblem_core: ColorRect = null
var _prompt_band: ColorRect = null
var _summary_label: Label = null
var _emblem_label: Label = null
var _option_cards: Array[ColorRect] = []
var _option_labels: Array[Label] = []
var _meta_labels: Array[Label] = []
var _status_labels: Array[Label] = []
var _anim_time: float = 0.0
var _bridge: Node = null

func _ready() -> void:
	_bridge = resolve_state_bridge()
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_option_labels()
	_set_screen_visible(_bridge != null and _bridge.is_time_attack_mode_screen())

func _process(delta: float) -> void:
	if _bridge == null:
		_bridge = resolve_state_bridge()
	var active: bool = _bridge != null and _bridge.is_time_attack_mode_screen()
	_set_screen_visible(active)
	if not active:
		return
	_anim_time += delta * 2.8
	var intro_progress: float = _bridge.get_time_attack_mode_intro_progress()
	var intro_amount := 1.0 - intro_progress
	var title_shift := -44.0 * intro_amount
	var side_shift := 72.0 * intro_amount
	if title_label:
		title_label.text = _bridge.get_time_attack_mode_title_text()
		title_label.position = Vector2(332.0 + title_shift, 76.0)
		title_label.size = Vector2(604.0, 52.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.26, 0.20, 0.10, 0.35 + intro_progress * 0.65)
	if prompt_label:
		prompt_label.text = _bridge.get_time_attack_mode_prompt_text()
		prompt_label.position = Vector2(164.0, 558.0)
		prompt_label.size = Vector2(952.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(0.88, 0.42, 0.16, (0.30 + intro_progress * 0.46) + absf(sin(_anim_time * 0.9)) * 0.18)
	if detail_label:
		detail_label.text = _bridge.get_time_attack_mode_detail_text()
		detail_label.position = Vector2(148.0, 606.0)
		detail_label.size = Vector2(984.0, 64.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.34, 0.24, 0.12, 0.96)
	_update_chrome()
	_update_option_labels()
	_update_summary()
	if _left_stage:
		_left_stage.position.x = 160.0 - side_shift
	if _option_stage:
		_option_stage.position.x = 184.0 - side_shift
	if _info_card:
		_info_card.position.x = 184.0 - side_shift
	if _right_stage:
		_right_stage.position.x = 610.0 + side_shift
	if _summary_card:
		_summary_card.position.x = 638.0 + side_shift

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(1.0, 0.98, 0.94, 1.0))
	_hero_glow = ensure_rect("HeroGlow", Rect2(104.0, 96.0, 1072.0, 504.0), Color(0.96, 0.58, 0.22, 0.10))
	_header_plate = ensure_rect("HeaderPlate", Rect2(150.0, 68.0, 980.0, 82.0), Color(1.0, 1.0, 1.0, 0.98))
	_header_band = ensure_rect("HeaderBand", Rect2(160.0, 214.0, 412.0, 258.0), Color(1.0, 0.95, 0.84, 0.98))
	_panel = ensure_rect("Panel", Rect2(118.0, 170.0, 1044.0, 352.0), Color(1.0, 0.99, 0.96, 0.99))
	_accent = ensure_rect("AccentBar", Rect2(118.0, 150.0, 1044.0, 10.0), Color(0.92, 0.56, 0.20, 0.96))
	_header_glow = ensure_rect("HeaderGlow", Rect2(150.0, 62.0, 980.0, 6.0), Color(0.84, 0.46, 0.18, 0.18))
	_left_stage = ensure_rect("LeftStage", Rect2(160.0, 214.0, 412.0, 258.0), Color(1.0, 0.95, 0.84, 0.98))
	_right_stage = ensure_rect("RightStage", Rect2(610.0, 214.0, 236.0, 258.0), Color(0.94, 0.56, 0.20, 0.94))
	_option_stage = ensure_rect("OptionStage", Rect2(184.0, 236.0, 364.0, 178.0), Color(1.0, 0.97, 0.90, 0.98))
	_info_card = ensure_rect("InfoCard", Rect2(184.0, 422.0, 364.0, 28.0), Color(1.0, 0.90, 0.78, 0.98))
	_summary_card = ensure_rect("SummaryCard", Rect2(638.0, 236.0, 180.0, 214.0), Color(1.0, 0.92, 0.80, 0.98))
	_prompt_band = ensure_rect("PromptBand", Rect2(118.0, 534.0, 1044.0, 148.0), Color(1.0, 0.98, 0.94, 0.99))
	_emblem_ring = ensure_rect("EmblemRing", Rect2(892.0, 224.0, 220.0, 220.0), Color(0.94, 0.56, 0.20, 0.24))
	_emblem_core = ensure_rect("EmblemCore", Rect2(954.0, 286.0, 96.0, 96.0), Color(1.0, 1.0, 1.0, 0.96))
	_summary_label = ensure_label("SummaryLabel", Vector2(884.0, 464.0), Vector2(228.0, 116.0), 16)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_emblem_label = ensure_label("EmblemLabel", Vector2(904.0, 316.0), Vector2(196.0, 32.0), 24)
	_emblem_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
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
	_info_card.z_index = -3
	_summary_card.z_index = -3
	_prompt_band.z_index = -2
	_emblem_ring.z_index = -1
	_emblem_core.z_index = 0

func _ensure_option_labels() -> void:
	if _option_labels.size() > 0:
		return
	for i in range(2):
		var top := 272.0 + float(i) * 92.0
		var card := ensure_rect("OptionCard%d" % i, Rect2(206.0, top, 320.0, 72.0), Color(1.0, 0.95, 0.86, 1.0))
		var option := ensure_label("OptionLabel%d" % i, Vector2(228.0, top + 10.0), Vector2(148.0, 24.0), 24)
		var meta := ensure_label("MetaLabel%d" % i, Vector2(230.0, top + 42.0), Vector2(188.0, 16.0), 10)
		var status := ensure_label("StatusLabel%d" % i, Vector2(394.0, top + 24.0), Vector2(108.0, 18.0), 12)
		option.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_option_cards.append(card)
		_option_labels.append(option)
		_meta_labels.append(meta)
		_status_labels.append(status)

func _update_option_labels() -> void:
	var rows: Array = _bridge.get_time_attack_mode_rows()
	for i in range(_option_labels.size()):
		var visible := i < rows.size()
		_option_cards[i].visible = visible
		_option_labels[i].visible = visible
		_meta_labels[i].visible = visible
		_status_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var status_text := str(row.get("status", ""))
		var is_locked := bool(row.get("locked", false))
		var top := 272.0 + float(i) * 92.0
		var lift := 0.0
		_option_cards[i].position = Vector2(206.0, top + lift)
		_option_cards[i].size = Vector2(320.0, 72.0)
		_option_labels[i].position = Vector2(228.0, top + 10.0 + lift)
		_meta_labels[i].position = Vector2(230.0, top + 42.0 + lift)
		_status_labels[i].position = Vector2(394.0, top + 24.0 + lift)
		_option_cards[i].color = _get_selected_card_color(is_locked) if is_selected else _get_idle_card_color(is_locked)
		_option_labels[i].text = str(row.get("name", ""))
		_option_labels[i].modulate = Color(1.0, 1.0, 1.0, 1.0) if is_selected and not is_locked else (Color(0.72, 0.72, 0.78, 1.0) if is_locked else Color(0.26, 0.20, 0.10, 1.0))
		_meta_labels[i].text = str(row.get("description", ""))
		_meta_labels[i].modulate = Color(1.0, 0.98, 0.92, 0.96) if is_selected and not is_locked else (Color(0.58, 0.62, 0.70, 0.92) if is_locked else Color(0.48, 0.36, 0.20, 0.94))
		_status_labels[i].text = status_text
		_status_labels[i].modulate = _get_status_color(is_locked, is_selected)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = _bridge.get_time_attack_mode_summary_text()
		_summary_label.modulate = Color(0.34, 0.24, 0.12, 0.98)
	if _emblem_label:
		_emblem_label.text = _bridge.get_menu_badge_text("TA")
		_emblem_label.modulate = Color(0.78, 0.32, 0.14, 0.98)
	if _info_card:
		_info_card.color = Color(1.0, 0.90, 0.78, 0.98)

func _update_chrome() -> void:
	var rows: Array = _bridge.get_time_attack_mode_rows()
	var selected_index := 0
	for i in range(rows.size()):
		if bool((rows[i] as Dictionary).get("selected", false)):
			selected_index = i
			break
	var accent := Color(0.28, 0.54, 0.96, 0.94) if selected_index == 0 else Color(0.94, 0.44, 0.24, 0.94)
	var pulse := absf(sin(_anim_time))
	if _hero_glow:
		_hero_glow.color = Color(accent.r, accent.g, accent.b, 0.10 + pulse * 0.04)
	if _header_plate:
		_header_plate.color = Color(1.0, 1.0, 1.0, 0.98)
	if _header_band:
		_header_band.color = Color(1.0, 0.95, 0.84, 0.98)
	if _panel:
		_panel.color = Color(1.0, 0.99, 0.96, 0.99)
	if _accent:
		_accent.color = Color(accent.r, accent.g, accent.b, 0.96)
	if _header_glow:
		_header_glow.color = Color(accent.r, accent.g, accent.b, 0.12 + absf(sin(_anim_time * 0.9)) * 0.06)
	if _left_stage:
		_left_stage.color = Color(1.0, 0.95, 0.84, 0.98)
	if _right_stage:
		_right_stage.color = Color(accent.r, accent.g, accent.b, 0.94)
	if _option_stage:
		_option_stage.color = Color(1.0, 0.97, 0.90, 0.98)
	if _summary_card:
		_summary_card.color = Color(1.0, 0.92, 0.80, 0.98)
	if _prompt_band:
		_prompt_band.color = Color(1.0, 0.98, 0.94, 0.99)
	if _emblem_ring:
		_emblem_ring.color = Color(accent.r, accent.g, accent.b, 0.24)
	if _emblem_core:
		_emblem_core.color = Color(1.0, 1.0, 1.0, 0.96)

func _get_selected_card_color(locked: bool) -> Color:
	if locked:
		return Color(0.56, 0.52, 0.54, 0.98)
	return Color(0.90, 0.40, 0.16, 0.98) if _bridge.get_title_menu_index() == 1 else Color(0.24, 0.54, 0.96, 0.98)

func _get_idle_card_color(locked: bool) -> Color:
	if locked:
		return Color(0.88, 0.86, 0.86, 0.96)
	return Color(1.0, 0.95, 0.86, 1.0)

func _get_status_color(locked: bool, selected: bool) -> Color:
	if locked:
		return Color(0.52, 0.52, 0.58, 1.0)
	return Color(1.0, 0.98, 0.92, 1.0) if selected else Color(0.84, 0.40, 0.16, 0.96)

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
	if _info_card:
		_info_card.visible = screen_visible
	if _summary_card:
		_summary_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _emblem_ring:
		_emblem_ring.visible = screen_visible
	if _emblem_core:
		_emblem_core.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _emblem_label:
		_emblem_label.visible = screen_visible
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
