extends ScreenBase

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _accent: ColorRect = null
var _header_band: ColorRect = null
var _left_stage: ColorRect = null
var _right_stage: ColorRect = null
var _decision_card: ColorRect = null
var _player_card: ColorRect = null
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _badge_label: Label = null
var _summary_label: Label = null
var _section_label: Label = null
var _option_cards: Array[ColorRect] = []
var _option_labels: Array[Label] = []
var _option_status_labels: Array[Label] = []
var _player_cards: Array[ColorRect] = []
var _player_labels: Array[Label] = []
var _pulse: float = 0.0

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_options()
	_ensure_players()
	_set_screen_visible(CoreBridge.is_multiplayer_lobby_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_multiplayer_lobby_screen()
	_set_screen_visible(active)
	if not active:
		return
	_pulse += delta * 3.0
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 220.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_multiplayer_lobby_title()
		title_label.position = Vector2(352.0, 116.0)
		title_label.size = Vector2(576.0, 54.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_multiplayer_lobby_prompt()
		prompt_label.position = Vector2(216.0, 548.0)
		prompt_label.size = Vector2(848.0, 30.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.88, 0.52, 0.72 + (pulse * 0.24))
	if detail_label:
		detail_label.text = "%s\n%s" % [CoreBridge.get_multiplayer_lobby_info_text(), CoreBridge.get_multiplayer_lobby_detail()]
		detail_label.position = Vector2(164.0, 644.0)
		detail_label.size = Vector2(952.0, 56.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.72, 0.86, 1.0, 0.92)
	_update_players()
	_update_options()
	_update_summary()
	_update_chrome()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.05, 0.10, 0.72))
	_hero_glow = ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.52, 0.28, 0.12, 0.16))
	_header_plate = ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.10, 0.08, 0.08, 0.94))
	_panel = ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.10, 0.09, 0.10, 0.96))
	_accent = ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.95, 0.54, 0.24, 1.0))
	_header_band = ensure_rect("HeaderBand", Rect2(212.0, 246.0, 264.0, 248.0), Color(0.28, 0.16, 0.10, 0.92))
	_left_stage = ensure_rect("LeftStage", Rect2(204.0, 246.0, 278.0, 248.0), Color(0.16, 0.12, 0.11, 0.94))
	_right_stage = ensure_rect("RightStage", Rect2(794.0, 246.0, 278.0, 248.0), Color(0.18, 0.14, 0.12, 0.94))
	_decision_card = ensure_rect("DecisionCard", Rect2(476.0, 274.0, 328.0, 194.0), Color(0.18, 0.14, 0.12, 0.94))
	_player_card = ensure_rect("PlayerCard", Rect2(226.0, 280.0, 234.0, 186.0), Color(0.15, 0.13, 0.11, 0.94))
	_summary_card = ensure_rect("SummaryCard", Rect2(818.0, 280.0, 230.0, 186.0), Color(0.18, 0.14, 0.12, 0.94))
	_prompt_band = ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.05, 0.08, 0.14, 0.92))
	_badge_ring = ensure_rect("BadgeRing", Rect2(566.0, 214.0, 148.0, 60.0), Color(0.98, 0.84, 0.44, 0.24))
	_badge_core = ensure_rect("BadgeCore", Rect2(580.0, 222.0, 120.0, 44.0), Color(0.22, 0.16, 0.10, 0.96))
	_badge_label = ensure_label("BadgeLabel", Vector2(582.0, 224.0), Vector2(116.0, 40.0), 18)
	_summary_label = ensure_label("SummaryLabel", Vector2(840.0, 316.0), Vector2(186.0, 112.0), 16)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_section_label = ensure_label("SectionLabel", Vector2(850.0, 430.0), Vector2(166.0, 24.0), 13)
	_section_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_panel.z_index = -7
	_accent.z_index = -6
	_header_band.z_index = -5
	_left_stage.z_index = -5
	_right_stage.z_index = -5
	_decision_card.z_index = -4
	_player_card.z_index = -4
	_summary_card.z_index = -4
	_prompt_band.z_index = -3
	_badge_ring.z_index = -2
	_badge_core.z_index = -1

func _ensure_options() -> void:
	if _option_cards.size() > 0:
		return
	for i in range(2):
		var left := 504.0 + float(i) * 152.0
		var card := ensure_rect("OptionCard%d" % i, Rect2(left, 320.0, 124.0, 88.0), Color(0.94, 0.91, 0.84, 0.98))
		var label := ensure_label("OptionLabel%d" % i, Vector2(left, 332.0), Vector2(124.0, 28.0), 28)
		var status := ensure_label("OptionStatus%d" % i, Vector2(left, 366.0), Vector2(124.0, 18.0), 11)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_option_cards.append(card)
		_option_labels.append(label)
		_option_status_labels.append(status)

func _ensure_players() -> void:
	if _player_labels.size() > 0:
		return
	for i in range(4):
		var top := 300.0 + float(i) * 38.0
		var card := ensure_rect("PlayerRowCard%d" % i, Rect2(242.0, top, 202.0, 30.0), Color(0.18, 0.16, 0.14, 0.94))
		var label := ensure_label("PlayerLabel%d" % i, Vector2(254.0, top - 2.0), Vector2(178.0, 34.0), 13)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		_player_cards.append(card)
		_player_labels.append(label)

func _update_players() -> void:
	var rows: Array = CoreBridge.get_multiplayer_lobby_player_rows()
	for i in range(_player_labels.size()):
		var visible := i < rows.size()
		_player_cards[i].visible = visible
		_player_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var connected := bool(row.get("connected", false))
		var host := bool(row.get("host", false))
		_player_labels[i].text = "%s\n%s" % [str(row.get("name", "")), str(row.get("status", ""))]
		_player_labels[i].modulate = Color(1.0, 0.92, 0.76, 1.0) if host else (Color(0.84, 0.94, 0.86, 1.0) if connected else Color(0.96, 0.80, 0.64, 1.0))
		_player_cards[i].color = Color(0.34, 0.20, 0.14, 0.98) if host else (Color(0.18, 0.26, 0.18, 0.96) if connected else Color(0.28, 0.18, 0.14, 0.94))

func _update_options() -> void:
	var rows: Array = CoreBridge.get_multiplayer_lobby_option_rows()
	for i in range(_option_labels.size()):
		var visible := i < rows.size()
		_option_cards[i].visible = visible
		_option_labels[i].visible = visible
		_option_status_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var lift := 0.0
		_option_cards[i].position.y = 320.0 + lift
		_option_labels[i].position.y = 332.0 + lift
		_option_status_labels[i].position.y = 366.0 + lift
		_option_cards[i].color = Color(0.96, 0.66, 0.26, 0.98) if is_selected else Color(0.94, 0.91, 0.84, 0.98)
		_option_labels[i].text = str(row.get("label", ""))
		_option_labels[i].modulate = Color(0.16, 0.14, 0.12, 1.0) if is_selected else Color(0.28, 0.24, 0.20, 0.94)
		_option_status_labels[i].text = str(row.get("status", ""))
		_option_status_labels[i].modulate = Color(0.40, 0.24, 0.16, 0.96) if is_selected else Color(0.46, 0.34, 0.24, 0.92)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_multiplayer_lobby_summary_text()
		_summary_label.modulate = Color(0.96, 0.94, 0.90, 0.96)
	if _badge_label:
		_badge_label.text = CoreBridge.get_multiplayer_lobby_badge_text()
		_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.96)
	if _section_label:
		_section_label.text = CoreBridge.get_multiplayer_lobby_section_text()
		_section_label.modulate = Color(0.86, 0.82, 0.74, 0.92)

func _update_chrome() -> void:
	var chrome := CoreBridge.get_multiplayer_lobby_chrome_colors()
	var bounce := sin(_pulse) * 4.0
	if _accent:
		_accent.color = Color(chrome.get("accent", _accent.color))
	if _hero_glow:
		var accent := Color(chrome.get("accent", _accent.color))
		_hero_glow.color = Color(accent.r * 0.46, accent.g * 0.28, accent.b * 0.16, 0.18)
	if _header_plate:
		var accent_plate := Color(chrome.get("accent", _accent.color))
		_header_plate.color = Color(accent_plate.r * 0.18, accent_plate.g * 0.12, accent_plate.b * 0.10, 0.92)
	if _panel:
		var accent_panel := Color(chrome.get("accent", _accent.color))
		_panel.color = Color(accent_panel.r * 0.16, accent_panel.g * 0.14, accent_panel.b * 0.16, 0.96)
	if _header_band:
		var accent2 := Color(chrome.get("accent", _accent.color))
		_header_band.color = Color(accent2.r * 0.28, accent2.g * 0.18, accent2.b * 0.12, 0.92)
	if _left_stage:
		_left_stage.color = Color(0.16, 0.12, 0.11, 0.94)
	if _right_stage:
		_right_stage.color = Color(chrome.get("summary", _right_stage.color))
	if _decision_card:
		_decision_card.color = Color(0.18, 0.14, 0.12, 0.94)
	if _player_card:
		_player_card.color = Color(0.15, 0.13, 0.11, 0.94)
	if _summary_card:
		_summary_card.color = Color(chrome.get("summary", _summary_card.color))
	if _prompt_band:
		_prompt_band.color = Color(0.05, 0.08, 0.14, 0.92)
	if _badge_ring:
		_badge_ring.color = Color(chrome.get("badge", _badge_ring.color))
		_badge_ring.position.y = 214.0 + bounce
	if _badge_core:
		_badge_core.color = Color(0.22, 0.16, 0.10, 0.96)
		_badge_core.position.y = 222.0 + bounce
	if _badge_label:
		_badge_label.position.y = 224.0 + bounce

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
	if _left_stage:
		_left_stage.visible = screen_visible
	if _right_stage:
		_right_stage.visible = screen_visible
	if _decision_card:
		_decision_card.visible = screen_visible
	if _player_card:
		_player_card.visible = screen_visible
	if _summary_card:
		_summary_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _section_label:
		_section_label.visible = screen_visible
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
	for label in _option_status_labels:
		label.visible = screen_visible
	for card in _player_cards:
		card.visible = screen_visible
	for label in _player_labels:
		label.visible = screen_visible
