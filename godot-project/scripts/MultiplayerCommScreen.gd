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
var _command_stage: ColorRect = null
var _roster_stage: ColorRect = null
var _command_card: ColorRect = null
var _roster_card: ColorRect = null
var _prompt_band: ColorRect = null
var _signal_ring: ColorRect = null
var _signal_core: ColorRect = null
var _signal_label: Label = null
var _summary_label: Label = null
var _section_label: Label = null
var _option_cards: Array[ColorRect] = []
var _option_labels: Array[Label] = []
var _meta_labels: Array[Label] = []
var _status_labels: Array[Label] = []
var _player_cards: Array[ColorRect] = []
var _player_labels: Array[Label] = []
var _pulse_time: float = 0.0
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
	_ensure_player_labels()
	_set_screen_visible(_bridge != null and _bridge.is_multiplayer_comm_screen())

func _process(delta: float) -> void:
	if _bridge == null:
		_bridge = resolve_state_bridge()
	var active: bool = _bridge != null and _bridge.is_multiplayer_comm_screen()
	_set_screen_visible(active)
	if not active:
		return
	_pulse_time += delta * 2.8
	if title_label:
		title_label.text = _bridge.get_multiplayer_comm_title()
		title_label.position = Vector2(334.0, 78.0)
		title_label.size = Vector2(612.0, 48.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.11, 0.21, 0.43, 1.0)
	if prompt_label:
		prompt_label.text = _bridge.get_multiplayer_comm_prompt()
		prompt_label.position = Vector2(164.0, 558.0)
		prompt_label.size = Vector2(952.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = _bridge.get_multiplayer_comm_prompt_color()
	if detail_label:
		detail_label.text = "%s\n%s" % [_bridge.get_multiplayer_comm_info_text(), _bridge.get_multiplayer_comm_detail_text()]
		detail_label.position = Vector2(144.0, 608.0)
		detail_label.size = Vector2(992.0, 64.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.17, 0.28, 0.46, 0.96)
	_update_option_labels()
	_update_player_labels()
	_update_summary()
	_update_chrome()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.99, 0.98, 0.96, 1.0))
	_hero_glow = ensure_rect("HeroGlow", Rect2(108.0, 96.0, 1064.0, 510.0), Color(0.96, 0.62, 0.24, 0.10))
	_header_plate = ensure_rect("HeaderPlate", Rect2(150.0, 68.0, 980.0, 82.0), Color(1.0, 1.0, 1.0, 0.98))
	_panel = ensure_rect("Panel", Rect2(118.0, 170.0, 1044.0, 352.0), Color(1.0, 1.0, 1.0, 0.98))
	_accent = ensure_rect("AccentBar", Rect2(118.0, 150.0, 1044.0, 10.0), Color(0.93, 0.48, 0.17, 1.0))
	_header_band = ensure_rect("HeaderBand", Rect2(160.0, 214.0, 430.0, 258.0), Color(0.89, 0.94, 1.0, 0.98))
	_command_stage = ensure_rect("CommandStage", Rect2(160.0, 214.0, 430.0, 258.0), Color(0.89, 0.94, 1.0, 0.98))
	_roster_stage = ensure_rect("RosterStage", Rect2(624.0, 214.0, 236.0, 258.0), Color(0.95, 0.56, 0.18, 0.96))
	_command_card = ensure_rect("CommandCard", Rect2(182.0, 234.0, 386.0, 218.0), Color(0.93, 0.96, 1.0, 0.98))
	_roster_card = ensure_rect("RosterCard", Rect2(652.0, 234.0, 180.0, 218.0), Color(0.99, 0.89, 0.75, 0.98))
	_prompt_band = ensure_rect("PromptBand", Rect2(118.0, 534.0, 1044.0, 148.0), Color(1.0, 0.97, 0.93, 0.98))
	_signal_ring = ensure_rect("SignalRing", Rect2(892.0, 224.0, 234.0, 234.0), Color(0.97, 0.58, 0.18, 0.22))
	_signal_core = ensure_rect("SignalCore", Rect2(954.0, 286.0, 110.0, 110.0), Color(1.0, 1.0, 1.0, 0.94))
	_signal_label = ensure_label("SignalLabel", Vector2(904.0, 316.0), Vector2(210.0, 40.0), 28)
	_summary_label = ensure_label("SummaryLabel", Vector2(886.0, 474.0), Vector2(232.0, 120.0), 16)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_section_label = ensure_label("SectionLabel", Vector2(660.0, 452.0), Vector2(166.0, 20.0), 16)
	_section_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_command_stage.z_index = -3
	_roster_stage.z_index = -3
	_command_card.z_index = -2
	_roster_card.z_index = -2
	_prompt_band.z_index = -1
	_signal_ring.z_index = -1
	_signal_core.z_index = 0

func _ensure_option_labels() -> void:
	if _option_labels.size() > 0:
		return
	for i in range(3):
		var top := 254.0 + float(i) * 66.0
		var card := ensure_rect("OptionCard%d" % i, Rect2(194.0, top, 362.0, 54.0), Color(0.88, 0.92, 1.0, 1.0))
		var option := ensure_label("OptionLabel%d" % i, Vector2(216.0, top + 6.0), Vector2(172.0, 24.0), 22)
		var meta := ensure_label("MetaLabel%d" % i, Vector2(218.0, top + 30.0), Vector2(208.0, 16.0), 10)
		var status := ensure_label("StatusLabel%d" % i, Vector2(390.0, top + 16.0), Vector2(140.0, 18.0), 12)
		option.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_option_cards.append(card)
		_option_labels.append(option)
		_meta_labels.append(meta)
		_status_labels.append(status)

func _ensure_player_labels() -> void:
	if _player_labels.size() > 0:
		return
	for i in range(4):
		var top := 260.0 + float(i) * 44.0
		var card := ensure_rect("PlayerCard%d" % i, Rect2(654.0, top, 176.0, 30.0), Color(0.99, 0.88, 0.76, 0.96))
		var label := ensure_label("PlayerLabel%d" % i, Vector2(664.0, top + 2.0), Vector2(156.0, 24.0), 11)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		_player_cards.append(card)
		_player_labels.append(label)

func _update_option_labels() -> void:
	var rows: Array = _bridge.get_multiplayer_comm_rows()
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
		var lift := 0.0
		_option_cards[i].position.y = 254.0 + float(i) * 66.0 + lift
		_option_cards[i].size = Vector2(362.0, 54.0)
		_option_labels[i].position.y = 260.0 + float(i) * 66.0 + lift
		_meta_labels[i].position.y = 284.0 + float(i) * 66.0 + lift
		_status_labels[i].position.y = 270.0 + float(i) * 66.0 + lift
		var status_text := str(row.get("status", ""))
		_option_cards[i].color = _get_option_card_color(is_selected, bool(row.get("waiting", false)), bool(row.get("locked", false)))
		_option_labels[i].text = str(row.get("label", ""))
		_option_labels[i].modulate = _get_option_color(is_selected)
		_meta_labels[i].text = str(row.get("value", ""))
		_meta_labels[i].modulate = Color(1.0, 0.94, 0.86, 0.96) if is_selected else Color(0.24, 0.38, 0.60, 0.96)
		_status_labels[i].text = status_text
		_status_labels[i].modulate = _get_status_color(bool(row.get("ready", false)), bool(row.get("waiting", false)), bool(row.get("locked", false)))

func _update_player_labels() -> void:
	var rows: Array = _bridge.get_multiplayer_comm_player_rows()
	for i in range(_player_labels.size()):
		var visible := i < rows.size()
		_player_cards[i].visible = visible
		_player_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var connected := bool(row.get("connected", false))
		_player_labels[i].text = "%s\n%s" % [str(row.get("name", "")), str(row.get("status", ""))]
		_player_labels[i].modulate = Color(0.30, 0.22, 0.12, 1.0) if connected else Color(0.58, 0.34, 0.12, 1.0)
		_player_cards[i].color = Color(1.0, 0.90, 0.78, 0.98) if connected else Color(0.98, 0.82, 0.66, 0.98)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = _bridge.get_multiplayer_comm_summary_text()
		_summary_label.modulate = Color(0.34, 0.22, 0.12, 0.96)
	if _signal_label:
		_signal_label.text = _bridge.get_multiplayer_comm_signal_text()
		_signal_label.modulate = Color(1.0, 1.0, 1.0, 0.98)
	if _section_label:
		_section_label.text = _bridge.get_multiplayer_comm_section_text()
		_section_label.modulate = Color(0.34, 0.22, 0.12, 0.96)

func _get_option_color(selected: bool) -> Color:
	if _bridge.get_title_phase() == _bridge.TITLE_PHASE_MULTI_CONNECT:
		return Color(1.0, 1.0, 1.0, 1.0) if selected else Color(0.10, 0.21, 0.43, 0.98)
	return Color(1.0, 1.0, 1.0, 1.0) if selected else Color(0.10, 0.21, 0.43, 0.98)

func _get_option_card_color(selected: bool, waiting: bool, locked: bool) -> Color:
	if selected:
		if waiting:
			return Color(0.96, 0.56, 0.22, 0.98)
		return Color(0.16, 0.32, 0.60, 0.98)
	if locked:
		return Color(0.86, 0.86, 0.88, 0.94)
	return Color(0.88, 0.92, 1.0, 1.0)

func _get_status_color(ready: bool, waiting: bool, locked: bool) -> Color:
	if ready:
		return Color(0.14, 0.56, 0.22, 1.0)
	if waiting:
		return Color(0.86, 0.42, 0.14, 1.0)
	if locked:
		return Color(0.48, 0.50, 0.56, 1.0)
	return Color(0.34, 0.40, 0.52, 0.92)

func _update_chrome() -> void:
	var chrome: Dictionary = _bridge.get_multiplayer_comm_chrome_colors()
	var accent: Color = Color(chrome.get("accent", Color(0.88, 0.48, 0.22, 1.0)))
	if _header_plate:
		_header_plate.color = Color(1.0, 1.0, 1.0, 0.98)
	if _accent:
		_accent.color = accent
	if _hero_glow:
		_hero_glow.color = Color(accent.r, accent.g, accent.b, 0.10 + absf(sin(_pulse_time * 0.8)) * 0.04)
	if _header_band:
		_header_band.color = Color(0.89, 0.94, 1.0, 0.98)
	if _command_stage:
		_command_stage.color = Color(0.89, 0.94, 1.0, 0.98)
	if _roster_stage:
		_roster_stage.color = Color(accent.r, min(accent.g + 0.08, 1.0), min(accent.b + 0.04, 1.0), 0.96)
	if _command_card:
		_command_card.color = Color(0.93, 0.96, 1.0, 0.98)
	if _roster_card:
		_roster_card.color = Color(1.0, 0.90, 0.76, 0.98)
	if _prompt_band:
		_prompt_band.color = Color(1.0, 0.97, 0.93, 0.98)
	if _signal_ring:
		_signal_ring.color = Color(accent.r, accent.g, accent.b, 0.18 + absf(sin(_pulse_time)) * 0.08)
	if _signal_core:
		_signal_core.color = Color(1.0, 1.0, 1.0, 0.94)

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
	if _command_stage:
		_command_stage.visible = screen_visible
	if _roster_stage:
		_roster_stage.visible = screen_visible
	if _command_card:
		_command_card.visible = screen_visible
	if _roster_card:
		_roster_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _signal_ring:
		_signal_ring.visible = screen_visible
	if _signal_core:
		_signal_core.visible = screen_visible
	if _signal_label:
		_signal_label.visible = screen_visible
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
	for label in _meta_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = screen_visible
	for card in _player_cards:
		card.visible = screen_visible
	for label in _player_labels:
		label.visible = screen_visible
