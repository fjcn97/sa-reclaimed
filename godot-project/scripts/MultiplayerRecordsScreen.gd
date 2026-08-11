# MultiplayerRecordsScreen.gd
# Presents an original-inspired dedicated multiplayer records screen.
extends ScreenBase

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _panel: ColorRect = null
var _header_plate: ColorRect = null
var _accent: ColorRect = null
var _header_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _records_stage: ColorRect = null
var _table_card: ColorRect = null
var _prompt_band: ColorRect = null
var _summary_label: Label = null
var _player_name_label: Label = null
var _player_wins_label: Label = null
var _player_losses_label: Label = null
var _player_draws_label: Label = null
var _column_label: Label = null
var _scroll_hint_label: Label = null
var _badge_label: Label = null
var _row_cards: Array[ColorRect] = []
var _name_labels: Array[Label] = []
var _wins_labels: Array[Label] = []
var _losses_labels: Array[Label] = []
var _draws_labels: Array[Label] = []
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
	_ensure_rows()
	_set_screen_visible(_bridge != null and _bridge.is_multiplayer_records_screen())

func _process(_delta: float) -> void:
	if _bridge == null:
		_bridge = resolve_state_bridge()
	var active: bool = _bridge != null and _bridge.is_multiplayer_records_screen()
	_set_screen_visible(active)
	if not active:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 210.0) * 0.5)
	if title_label:
		title_label.text = _bridge.get_multiplayer_records_title_text()
		title_label.position = Vector2(246.0, 116.0)
		title_label.size = Vector2(612.0, 56.0)
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = _bridge.get_multiplayer_records_prompt_text()
		prompt_label.position = Vector2(176.0, 552.0)
		prompt_label.size = Vector2(928.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.52, 0.74 + (pulse * 0.26))
	if detail_label:
		detail_label.text = "%s   |   %s" % [_bridge.get_multiplayer_records_summary_text().replace("\n", "   "), _bridge.get_multiplayer_records_detail_text()]
		detail_label.position = Vector2(170.0, 668.0)
		detail_label.size = Vector2(940.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.80, 0.90, 1.0, 0.92)
	_update_chrome()
	_update_summary()
	_update_rows()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.03, 0.04, 0.08, 0.68))
	_hero_glow = ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.44, 0.24, 0.12, 0.18))
	_header_plate = ensure_rect("HeaderPlate", Rect2(146.0, 96.0, 988.0, 124.0), Color(0.12, 0.08, 0.08, 0.94))
	_panel = ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.08, 0.08, 0.12, 0.96))
	_accent = ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.92, 0.48, 0.20, 1.0))
	_header_band = ensure_rect("HeaderBand", Rect2(204.0, 246.0, 316.0, 238.0), Color(0.24, 0.14, 0.10, 0.92))
	_badge_ring = ensure_rect("BadgeRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(0.92, 0.78, 0.24, 0.22))
	_badge_core = ensure_rect("BadgeCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.24, 0.14, 0.10, 0.96))
	_records_stage = ensure_rect("RecordsStage", Rect2(540.0, 246.0, 532.0, 238.0), Color(0.09, 0.08, 0.12, 0.94))
	_table_card = ensure_rect("TableCard", Rect2(540.0, 246.0, 532.0, 238.0), Color(0.09, 0.08, 0.12, 0.94))
	_prompt_band = ensure_rect("PromptBand", Rect2(176.0, 534.0, 928.0, 96.0), Color(0.04, 0.08, 0.16, 0.92))
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_badge_ring.z_index = -3
	_badge_core.z_index = -2
	_records_stage.z_index = -2
	_table_card.z_index = -1
	_prompt_band.z_index = -1

func _ensure_rows() -> void:
	if _summary_label == null:
		_summary_label = ensure_label("SummaryLabel", Vector2(228.0, 282.0), Vector2(248.0, 82.0), 15)
		_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if _player_name_label == null:
		_player_name_label = ensure_label("PlayerNameLabel", Vector2(228.0, 414.0), Vector2(146.0, 24.0), 18)
		_player_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if _player_wins_label == null:
		_player_wins_label = ensure_label("PlayerWinsLabel", Vector2(384.0, 414.0), Vector2(42.0, 24.0), 18)
		_player_wins_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if _player_losses_label == null:
		_player_losses_label = ensure_label("PlayerLossesLabel", Vector2(438.0, 414.0), Vector2(42.0, 24.0), 18)
		_player_losses_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if _player_draws_label == null:
		_player_draws_label = ensure_label("PlayerDrawsLabel", Vector2(492.0, 414.0), Vector2(42.0, 24.0), 18)
		_player_draws_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if _column_label == null:
		_column_label = ensure_label("ColumnLabel", Vector2(566.0, 280.0), Vector2(420.0, 24.0), 16)
		_column_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if _scroll_hint_label == null:
		_scroll_hint_label = ensure_label("ScrollHintLabel", Vector2(958.0, 280.0), Vector2(82.0, 24.0), 14)
		_scroll_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	if _name_labels.size() > 0:
		return
	for i in range(4):
		var top := 326.0 + float(i) * 36.0
		var card := ensure_rect("RowCard%d" % i, Rect2(566.0, top, 474.0, 28.0), Color(0.10, 0.16, 0.29, 0.96))
		var name := ensure_label("NameLabel%d" % i, Vector2(588.0, top), Vector2(176.0, 26.0), 16)
		var wins := ensure_label("WinsLabel%d" % i, Vector2(804.0, top), Vector2(40.0, 26.0), 16)
		var losses := ensure_label("LossesLabel%d" % i, Vector2(872.0, top), Vector2(40.0, 26.0), 16)
		var draws := ensure_label("DrawsLabel%d" % i, Vector2(940.0, top), Vector2(40.0, 26.0), 16)
		name.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		wins.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		losses.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		draws.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_row_cards.append(card)
		_name_labels.append(name)
		_wins_labels.append(wins)
		_losses_labels.append(losses)
		_draws_labels.append(draws)
	if _badge_label == null:
		_badge_label = ensure_label("BadgeLabel", Vector2(886.0, 160.0), Vector2(108.0, 38.0), 18)
		_badge_label.text = _bridge.get_menu_badge_text("VERSUS")
		_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = _bridge.get_multiplayer_records_summary_text().replace("\n", "   ")
		_summary_label.modulate = Color(0.90, 0.96, 1.0, 0.98)
	var player_row: Dictionary = _bridge.get_multiplayer_records_player_row()
	if _player_name_label:
		_player_name_label.text = str(player_row.get("name", ""))
		_player_name_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if _player_wins_label:
		_player_wins_label.text = "%02d" % int(player_row.get("wins", 0))
		_player_wins_label.modulate = Color(0.78, 0.94, 0.82, 1.0)
	if _player_losses_label:
		_player_losses_label.text = "%02d" % int(player_row.get("losses", 0))
		_player_losses_label.modulate = Color(1.0, 0.74, 0.74, 1.0)
	if _player_draws_label:
		_player_draws_label.text = "%02d" % int(player_row.get("draws", 0))
		_player_draws_label.modulate = Color(0.96, 0.90, 0.60, 1.0)
	if _column_label:
		var columns: Array = _bridge.get_multiplayer_records_column_header_text()
		_column_label.text = "%s              %s    %s    %s" % [_bridge.get_menu_badge_text("PROFILE"), columns[0], columns[1], columns[2]]
		_column_label.modulate = Color(0.72, 0.84, 1.0, 0.96)
	if _scroll_hint_label:
		_scroll_hint_label.text = _bridge.get_multiplayer_records_scroll_hint_text()
		_scroll_hint_label.modulate = Color(1.0, 0.88, 0.52, 0.92)

func _update_chrome() -> void:
	var colors: Dictionary = _bridge.get_multiplayer_records_chrome_colors()
	if _accent:
		_accent.color = colors.get("accent", Color(0.92, 0.48, 0.20, 1.0))
	if _hero_glow:
		var accent := Color(colors.get("accent", Color(0.92, 0.48, 0.20, 1.0)))
		_hero_glow.color = Color(accent.r * 0.42, accent.g * 0.32, accent.b * 0.20, 0.18)
	if _header_plate:
		var plate := Color(colors.get("accent", Color(0.92, 0.48, 0.20, 1.0)))
		_header_plate.color = Color(plate.r * 0.18, plate.g * 0.14, plate.b * 0.12, 0.92)
	if _header_band:
		var header := Color(colors.get("accent", Color(0.92, 0.48, 0.20, 1.0)))
		_header_band.color = Color(header.r * 0.28, header.g * 0.18, header.b * 0.12, 0.92)
	if _badge_core:
		var badge := Color(colors.get("accent", Color(0.92, 0.48, 0.20, 1.0)))
		_badge_core.color = Color(badge.r * 0.28, badge.g * 0.18, badge.b * 0.12, 0.96)
	if _records_stage:
		_records_stage.color = Color(0.09, 0.08, 0.12, 0.94)
	if _table_card:
		_table_card.color = Color(0.09, 0.08, 0.12, 0.94)

func _update_rows() -> void:
	var rows: Array = _bridge.get_multiplayer_records_visible_rows()
	for i in range(_name_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_name_labels[i].visible = visible
		_wins_labels[i].visible = visible
		_losses_labels[i].visible = visible
		_draws_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		_name_labels[i].text = str(row.get("name", ""))
		_wins_labels[i].text = "%02d" % int(row.get("wins", 0))
		_losses_labels[i].text = "%02d" % int(row.get("losses", 0))
		_draws_labels[i].text = "%02d" % int(row.get("draws", 0))
		_row_cards[i].color = Color(0.10, 0.16, 0.29, 0.96)
		_name_labels[i].modulate = Color(0.88, 0.94, 1.0, 0.96)
		_wins_labels[i].modulate = Color(0.78, 0.94, 0.82, 1.0)
		_losses_labels[i].modulate = Color(1.0, 0.74, 0.74, 1.0)
		_draws_labels[i].modulate = Color(0.96, 0.90, 0.60, 1.0)

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
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _records_stage:
		_records_stage.visible = screen_visible
	if _table_card:
		_table_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _player_name_label:
		_player_name_label.visible = screen_visible
	if _player_wins_label:
		_player_wins_label.visible = screen_visible
	if _player_losses_label:
		_player_losses_label.visible = screen_visible
	if _player_draws_label:
		_player_draws_label.visible = screen_visible
	if _column_label:
		_column_label.visible = screen_visible
	if _scroll_hint_label:
		_scroll_hint_label.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	for card in _row_cards:
		card.visible = screen_visible
	for label in _name_labels:
		label.visible = screen_visible
	for label in _wins_labels:
		label.visible = screen_visible
	for label in _losses_labels:
		label.visible = screen_visible
	for label in _draws_labels:
		label.visible = screen_visible
