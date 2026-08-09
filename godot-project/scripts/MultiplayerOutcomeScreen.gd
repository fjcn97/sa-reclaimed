extends ScreenBase

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
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _badge_label: Label = null
var _summary_label: Label = null
var _player_cards: Array[ColorRect] = []
var _player_labels: Array[Label] = []
var _pulse_time: float = 0.0

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_player_rows()
	_set_screen_visible(CoreBridge.is_multiplayer_outcome_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_multiplayer_outcome_screen()
	_set_screen_visible(active)
	if not active:
		return
	_pulse_time += delta * 2.6
	var pulse := 0.5 + sin(_pulse_time) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_multiplayer_outcome_title()
		title_label.position = Vector2(212.0, 126.0)
		title_label.size = Vector2(856.0, 52.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_multiplayer_outcome_prompt()
		prompt_label.position = Vector2(180.0, 548.0)
		prompt_label.size = Vector2(920.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.46, 0.74 + pulse * 0.18)
	if detail_label:
		detail_label.text = CoreBridge.get_multiplayer_outcome_detail()
		detail_label.position = Vector2(164.0, 642.0)
		detail_label.size = Vector2(952.0, 56.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.84, 0.92, 1.0, 0.96)
	_update_players()
	_update_summary()
	_update_chrome()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.03, 0.03, 0.06, 0.78))
	_hero_glow = ensure_rect("HeroGlow", Rect2(148.0, 108.0, 984.0, 152.0), Color(0.18, 0.26, 0.36, 0.18))
	_header_plate = ensure_rect("HeaderPlate", Rect2(176.0, 122.0, 928.0, 86.0), Color(0.10, 0.14, 0.22, 0.96))
	_panel = ensure_rect("Panel", Rect2(196.0, 230.0, 888.0, 284.0), Color(0.10, 0.14, 0.22, 0.96))
	_accent = ensure_rect("AccentBar", Rect2(196.0, 214.0, 888.0, 10.0), Color(0.96, 0.72, 0.24, 1.0))
	_left_stage = ensure_rect("LeftStage", Rect2(230.0, 264.0, 474.0, 208.0), Color(0.12, 0.18, 0.30, 0.96))
	_right_stage = ensure_rect("RightStage", Rect2(728.0, 264.0, 320.0, 208.0), Color(0.16, 0.22, 0.18, 0.98))
	_summary_card = ensure_rect("SummaryCard", Rect2(754.0, 290.0, 268.0, 156.0), Color(0.16, 0.22, 0.18, 0.98))
	_prompt_band = ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.05, 0.08, 0.14, 0.92))
	_badge_ring = ensure_rect("BadgeRing", Rect2(914.0, 110.0, 126.0, 126.0), Color(0.96, 0.72, 0.24, 0.18))
	_badge_core = ensure_rect("BadgeCore", Rect2(950.0, 146.0, 54.0, 54.0), Color(0.98, 0.98, 1.0, 1.0))
	_badge_label = ensure_label("BadgeLabel", Vector2(920.0, 160.0), Vector2(114.0, 28.0), 18)
	_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_summary_label = ensure_label("SummaryLabel", Vector2(782.0, 314.0), Vector2(212.0, 112.0), 16)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_accent.z_index = -7
	_panel.z_index = -6
	_left_stage.z_index = -5
	_right_stage.z_index = -5
	_summary_card.z_index = -4
	_prompt_band.z_index = -3
	_badge_ring.z_index = -2
	_badge_core.z_index = -1

func _ensure_player_rows() -> void:
	if _player_labels.size() > 0:
		return
	for i in range(4):
		var top := 292.0 + float(i) * 42.0
		var card := ensure_rect("PlayerCard%d" % i, Rect2(254.0, top, 426.0, 32.0), Color(0.12, 0.18, 0.30, 0.96))
		var label := ensure_label("PlayerLabel%d" % i, Vector2(270.0, top - 2.0), Vector2(394.0, 34.0), 14)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		_player_cards.append(card)
		_player_labels.append(label)

func _update_players() -> void:
	var rows: Array = CoreBridge.get_multiplayer_outcome_player_rows()
	for i in range(_player_labels.size()):
		var visible := i < rows.size()
		_player_cards[i].visible = visible
		_player_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var connected := bool(row.get("connected", false))
		_player_labels[i].text = "%s   |   %s" % [str(row.get("name", "")), str(row.get("status", ""))]
		_player_labels[i].modulate = Color(0.98, 0.94, 0.78, 1.0) if i == 0 else (Color(0.84, 0.94, 0.86, 1.0) if connected else Color(0.96, 0.74, 0.62, 1.0))
		_player_cards[i].color = Color(0.34, 0.22, 0.14, 0.98) if i == 0 else (Color(0.18, 0.28, 0.20, 0.96) if connected else Color(0.28, 0.16, 0.16, 0.94))

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_multiplayer_outcome_summary_text()
		_summary_label.modulate = Color(0.92, 0.96, 1.0, 0.96)
	if _badge_label:
		_badge_label.text = CoreBridge.get_multiplayer_outcome_badge_text()
		_badge_label.modulate = Color(0.18, 0.18, 0.24, 0.98)

func _update_chrome() -> void:
	var chrome := CoreBridge.get_multiplayer_outcome_chrome_colors()
	var accent: Color = Color(chrome.get("accent", Color(0.96, 0.72, 0.24, 1.0)))
	if _accent:
		_accent.color = accent
	if _hero_glow:
		_hero_glow.color = Color(accent.r * 0.30, accent.g * 0.36, accent.b * 0.44, 0.18 + absf(sin(_pulse_time)) * 0.06)
	if _header_plate:
		_header_plate.color = Color(chrome.get("panel", _header_plate.color))
	if _panel:
		var panel_color: Color = Color(chrome.get("panel", _panel.color))
		_panel.color = Color(panel_color.r * 0.94, panel_color.g * 0.98, panel_color.b * 1.04, 0.96)
	if _left_stage:
		_left_stage.color = Color(chrome.get("panel", _left_stage.color))
	if _right_stage:
		_right_stage.color = Color(chrome.get("summary", _right_stage.color))
	if _summary_card:
		_summary_card.color = Color(chrome.get("summary", _summary_card.color))
	if _prompt_band:
		var summary_color: Color = Color(chrome.get("summary", _prompt_band.color))
		_prompt_band.color = Color(summary_color.r * 0.80, summary_color.g * 0.88, summary_color.b * 0.98, 0.92)
	if _badge_ring:
		_badge_ring.color = Color(accent.r, accent.g, accent.b, 0.14 + absf(sin(_pulse_time * 1.4)) * 0.08)

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
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	for card in _player_cards:
		card.visible = screen_visible
	for label in _player_labels:
		label.visible = screen_visible
