# PauseScreen.gd
# Presents an original-inspired dedicated pause panel with compact stage actions.
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
var _menu_stage: ColorRect = null
var _summary_stage: ColorRect = null
var _menu_card: ColorRect = null
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _summary_label: Label = null
var _badge_label: Label = null
var _row_cards: Array[ColorRect] = []
var _row_labels: Array[Label] = []
var _value_labels: Array[Label] = []
var _bridge: Node = null

func _ready() -> void:
	set_process(true)
	_bridge = resolve_state_bridge()
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_rows()
	_set_screen_visible(_bridge != null and _bridge.is_paused())

func _process(_delta: float) -> void:
	if _bridge == null:
		_bridge = resolve_state_bridge()
		if _bridge == null:
			_set_screen_visible(false)
			return
	var paused: bool = _bridge.is_paused()
	_set_screen_visible(paused)
	if not paused:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 180.0) * 0.5)
	if title_label:
		title_label.text = _bridge.get_pause_title_text()
		title_label.position = Vector2(352.0, 116.0)
		title_label.size = Vector2(576.0, 54.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = _bridge.get_pause_prompt_text()
		prompt_label.position = Vector2(216.0, 548.0)
		prompt_label.size = Vector2(848.0, 30.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.52, 0.74 + (pulse * 0.24))
	if detail_label:
		detail_label.text = _bridge.get_pause_detail_text()
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.72, 0.86, 1.0, 0.92)
	_update_chrome()
	_update_rows()
	_update_summary()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.05, 0.10, 0.74))
	_hero_glow = ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.36, 0.28, 0.10, 0.16))
	_header_plate = ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.09, 0.08, 0.08, 0.94))
	_panel = ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.06, 0.08, 0.15, 0.96))
	_accent = ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.98, 0.76, 0.20, 0.98))
	_header_band = ensure_rect("HeaderBand", Rect2(318.0, 246.0, 644.0, 82.0), Color(0.24, 0.18, 0.08, 0.92))
	_badge_ring = ensure_rect("BadgeRing", Rect2(556.0, 214.0, 168.0, 60.0), Color(0.96, 0.82, 0.30, 0.20))
	_badge_core = ensure_rect("BadgeCore", Rect2(570.0, 222.0, 140.0, 44.0), Color(0.24, 0.18, 0.08, 0.96))
	_menu_stage = ensure_rect("MenuStage", Rect2(286.0, 330.0, 356.0, 122.0), Color(0.08, 0.12, 0.22, 0.94))
	_summary_stage = ensure_rect("SummaryStage", Rect2(668.0, 330.0, 326.0, 122.0), Color(0.08, 0.10, 0.18, 0.94))
	_menu_card = ensure_rect("MenuCard", Rect2(302.0, 346.0, 324.0, 90.0), Color(0.10, 0.13, 0.22, 0.98))
	_summary_card = ensure_rect("SummaryCard", Rect2(686.0, 346.0, 290.0, 90.0), Color(0.08, 0.10, 0.18, 0.96))
	_prompt_band = ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.04, 0.08, 0.16, 0.92))
	_summary_label = ensure_label("SummaryLabel", Vector2(710.0, 364.0), Vector2(242.0, 52.0), 15)
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_badge_label = ensure_label("BadgeLabel", Vector2(582.0, 228.0), Vector2(116.0, 32.0), 16)
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_panel.z_index = -7
	_accent.z_index = -6
	_header_band.z_index = -5
	_badge_ring.z_index = -4
	_badge_core.z_index = -3
	_menu_stage.z_index = -3
	_summary_stage.z_index = -3
	_menu_card.z_index = -2
	_summary_card.z_index = -2
	_prompt_band.z_index = -1

func _ensure_rows() -> void:
	if _row_labels.size() > 0:
		return
	for i in range(2):
		var top := 364.0 + float(i) * 34.0
		var card := ensure_rect("RowCard%d" % i, Rect2(322.0, top, 284.0, 28.0), Color(0.10, 0.16, 0.29, 0.96))
		var row := ensure_label("RowLabel%d" % i, Vector2(340.0, top - 1.0), Vector2(124.0, 26.0), 16)
		var value := ensure_label("ValueLabel%d" % i, Vector2(450.0, top - 1.0), Vector2(136.0, 26.0), 12)
		value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(row)
		_value_labels.append(value)

func _update_rows() -> void:
	var rows: Array = _bridge.get_pause_menu_rows()
	var selected: int = _bridge.get_pause_menu_index()
	for i in range(_row_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_row_labels[i].visible = visible
		_value_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := i == selected
		var top := 364.0 + float(i) * 34.0
		var lift := 0.0
		_row_cards[i].position = Vector2(322.0, top + lift)
		_row_labels[i].position = Vector2(340.0, top - 1.0 + lift)
		_value_labels[i].position = Vector2(450.0, top - 1.0 + lift)
		_row_cards[i].color = Color(0.34, 0.24, 0.10, 0.98) if is_selected else Color(0.10, 0.16, 0.29, 0.96)
		_row_labels[i].text = str(row.get("label", ""))
		_value_labels[i].text = str(row.get("value", ""))
		_row_labels[i].modulate = Color(1.0, 0.90, 0.52, 1.0) if is_selected else Color(0.90, 0.96, 1.0, 0.94)
		_value_labels[i].modulate = Color(1.0, 0.96, 0.84, 1.0) if is_selected else Color(0.76, 0.86, 1.0, 0.92)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = _bridge.get_pause_summary_text()
		_summary_label.modulate = Color(0.90, 0.96, 1.0, 0.96)
	if _badge_label:
		_badge_label.text = _bridge.get_pause_badge_text()
		_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

func _update_chrome() -> void:
	var colors: Dictionary = _bridge.get_pause_chrome_colors() if _bridge else {}
	var accent := Color(colors.get("accent", Color(0.98, 0.76, 0.20, 0.98)))
	var card := Color(colors.get("card", Color(0.10, 0.13, 0.22, 0.98)))
	if _accent:
		_accent.color = accent
	if _hero_glow:
		_hero_glow.color = Color(accent.r * 0.40, accent.g * 0.34, accent.b * 0.16, 0.18)
	if _header_plate:
		_header_plate.color = Color(accent.r * 0.18, accent.g * 0.14, accent.b * 0.10, 0.92)
	if _panel:
		_panel.color = Color(accent.r * 0.12, accent.g * 0.14, accent.b * 0.20, 0.96)
	if _header_band:
		_header_band.color = Color(accent.r * 0.26, accent.g * 0.20, accent.b * 0.10, 0.92)
	if _badge_core:
		_badge_core.color = Color(accent.r * 0.26, accent.g * 0.20, accent.b * 0.10, 0.96)
	if _menu_stage:
		_menu_stage.color = Color(card.r * 0.88, card.g * 0.94, card.b * 1.04, 0.94)
	if _summary_stage:
		_summary_stage.color = Color(card.r * 0.72, card.g * 0.78, card.b * 0.90, 0.94)
	if _menu_card:
		_menu_card.color = card
	if _summary_card:
		_summary_card.color = Color(card.r * 0.78, card.g * 0.84, card.b * 0.96, 0.96)

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
	if _summary_stage:
		_summary_stage.visible = screen_visible
	if _menu_card:
		_menu_card.visible = screen_visible
	if _summary_card:
		_summary_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
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
	for label in _value_labels:
		label.visible = screen_visible
