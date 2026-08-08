# HUD.gd
# Presents an original-inspired gameplay HUD with dedicated score, ring, life, and timer panels.
extends CanvasLayer

@export var rings_label: Label = null
@export var score_label: Label = null
@export var time_label: Label = null
@export var lives_label: Label = null
@export var status_label: Label = null
var special_ring_label: Label = null
var powerup_label: Label = null
var _race_start_label: Label = null

var _score_card: ColorRect = null
var _rings_card: ColorRect = null
var _special_ring_card: ColorRect = null
var _lives_card: ColorRect = null
var _timer_card: ColorRect = null
var _status_card: ColorRect = null
var _score_glow: ColorRect = null
var _timer_glow: ColorRect = null
var _lives_glow: ColorRect = null
var _score_title: Label = null
var _rings_title: Label = null
var _time_title: Label = null
var _lives_title: Label = null
var _character_label: Label = null
var _boss_panel: ColorRect = null
var _boss_title: Label = null
var _boss_phase: Label = null
var _boss_health_back: ColorRect = null
var _boss_health_fill: ColorRect = null
var _boss_health_pips: Array[ColorRect] = []
var _mp_panel: ColorRect = null
var _mp_track: ColorRect = null
var _mp_start_flag: Label = null
var _mp_finish_flag: Label = null
var _mp_row_cards: Array[ColorRect] = []
var _mp_name_labels: Array[Label] = []
var _mp_place_labels: Array[Label] = []
var _mp_progress_labels: Array[Label] = []
var _mp_markers: Array[ColorRect] = []

func _ready() -> void:
	set_process(true)
	if rings_label == null:
		rings_label = get_node_or_null("RingsLabel")
	if score_label == null:
		score_label = get_node_or_null("ScoreLabel")
	if time_label == null:
		time_label = get_node_or_null("TimerLabel")
	if lives_label == null:
		lives_label = get_node_or_null("LivesLabel")
	if status_label == null:
		status_label = get_node_or_null("StatusLabel")
	special_ring_label = get_node_or_null("SpecialRingLabel")
	powerup_label = get_node_or_null("PowerupLabel")
	_ensure_chrome()
	_ensure_titles()
	_race_start_label = _ensure_label("RaceStartLabel", Vector2(430.0, 174.0), Vector2(420.0, 92.0), 64)
	_race_start_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_race_start_label.text = CoreBridge.get_hud_race_start_text()
	_ensure_boss_panel()
	_ensure_multiplayer_panel()

func _process(_delta: float) -> void:
	var title_mode: bool = CoreBridge.is_title_screen()
	var pause_mode: bool = CoreBridge.is_paused()
	var save_mode: bool = CoreBridge.is_save_options()
	var intro_mode: bool = CoreBridge.is_intro_screen()
	var clear_mode: bool = CoreBridge.is_clear_screen()
	var special_stage_mode: bool = CoreBridge.is_special_stage_screen()
	var presentation_mode: bool = CoreBridge.is_game_over_screen() \
		or CoreBridge.is_final_intro_screen() \
		or CoreBridge.is_chaos_emeralds_screen() \
		or CoreBridge.is_missing_emeralds_screen() \
		or CoreBridge.is_to_be_continued_screen() \
		or CoreBridge.is_sega_logo_screen() \
		or CoreBridge.is_sonic_team_logo_screen() \
		or CoreBridge.is_credits_screen() \
		or CoreBridge.is_copyright_screen() \
		or CoreBridge.is_credits_end_screen() \
		or CoreBridge.is_character_unlock_screen()
	var hud_visible := not title_mode and not pause_mode and not save_mode and not intro_mode and not clear_mode and not special_stage_mode and not presentation_mode
	var state = CoreBridge.get_player_state()
	var elapsed = CoreBridge.get_elapsed_time()

	_set_hud_visible(hud_visible)
	if not hud_visible:
		return
	if _race_start_label:
		var race_start_visible := CoreBridge.is_race_start_message_visible()
		var race_start_progress := CoreBridge.get_race_start_message_progress()
		var remaining_frames := race_start_progress * 60.0
		var race_start_scale := Vector2.ONE
		if remaining_frames < 16.0:
			# countdown.c expands the horizontal halves while collapsing their
			# vertical scale during the final 16 frames of the source animation.
			race_start_scale = Vector2(2.0 - (remaining_frames / 16.0), (remaining_frames + 1.0) / 16.0)
		_race_start_label.visible = race_start_visible
		_race_start_label.modulate = Color(1.0, 0.94, 0.42, race_start_progress)
		_race_start_label.scale = race_start_scale

	var chrome := CoreBridge.get_hud_chrome_colors()
	if score_label:
		score_label.text = "%06d" % min(int(state.score), 999999)
		score_label.position = Vector2(48.0, 28.0)
		score_label.size = Vector2(230.0, 28.0)
		score_label.modulate = chrome.get("text", Color(0.96, 0.98, 1.0, 1.0))
	if rings_label:
		rings_label.text = "%03d" % state.rings
		rings_label.position = Vector2(48.0, 80.0)
		rings_label.size = Vector2(118.0, 28.0)
		var rings_color := Color(chrome.get("rings_value", Color(1.0, 0.92, 0.42, 1.0)))
		if state.rings == 0 and (Time.get_ticks_msec() / 120) % 2 == 0:
			rings_color.a = 0.22
		rings_label.modulate = rings_color
	if special_ring_label:
		special_ring_label.visible = CoreBridge.is_special_ring_hud_visible()
		special_ring_label.text = CoreBridge.get_hud_special_ring_text()
		special_ring_label.position = Vector2(34.0, 126.0)
		special_ring_label.size = Vector2(164.0, 22.0)
		special_ring_label.modulate = chrome.get("rings_value", Color(0.72, 0.96, 1.0, 1.0))
	if powerup_label:
		powerup_label.text = CoreBridge.get_hud_powerup_text()
		powerup_label.visible = powerup_label.text != ""
		if CoreBridge.is_player_magnetic_shielded():
			powerup_label.modulate = Color(0.78, 0.58, 1.0, 1.0)
		elif CoreBridge.is_hud_shield_active():
			powerup_label.modulate = Color(0.52, 0.92, 1.0, 1.0)
		elif CoreBridge.is_player_invincible():
			powerup_label.modulate = Color(1.0, 0.92, 0.30, 1.0)
		elif CoreBridge.is_player_speed_up_active():
			powerup_label.modulate = Color(1.0, 0.56, 0.24, 1.0)
		else:
			powerup_label.modulate = Color(1.0, 0.84, 0.28, 1.0)
	if lives_label:
		lives_label.text = "x %d" % max(0, state.lives - 1)
		lives_label.position = Vector2(104.0, 646.0)
		lives_label.size = Vector2(110.0, 28.0)
		lives_label.modulate = chrome.get("text", Color(0.96, 0.98, 1.0, 1.0))
	if time_label:
		time_label.text = CoreBridge.get_hud_time_text()
		time_label.position = Vector2(1052.0, 28.0)
		time_label.size = Vector2(172.0, 28.0)
		var time_color := Color(chrome.get("text", Color(0.96, 0.98, 1.0, 1.0)))
		if CoreBridge.is_hud_timer_warning():
			time_color = Color(1.0, 0.30, 0.22, 0.52 + absf(sin(Time.get_ticks_msec() / 180.0)) * 0.48)
		time_label.modulate = time_color
	if status_label:
		status_label.text = CoreBridge.get_status_text()
		status_label.visible = CoreBridge.get_status_text() != ""
		status_label.position = Vector2(376.0, 30.0)
		status_label.size = Vector2(528.0, 32.0)
		status_label.modulate = chrome.get("text", Color(0.96, 0.98, 1.0, 1.0))

	_update_titles(state.variant, chrome)
	_update_boss_panel(chrome)
	_update_multiplayer_panel(chrome)
	_update_hud_chrome(chrome)

func _ensure_chrome() -> void:
	_score_glow = _ensure_rect("ScoreGlow", Rect2(10.0, 12.0, 300.0, 56.0), Color(0.14, 0.28, 0.54, 0.18))
	_score_card = _ensure_rect("ScoreCard", Rect2(18.0, 18.0, 278.0, 42.0), Color(0.08, 0.16, 0.38, 0.92))
	_rings_card = _ensure_rect("RingsCard", Rect2(18.0, 70.0, 194.0, 42.0), Color(0.34, 0.18, 0.04, 0.92))
	_special_ring_card = _ensure_rect("SpecialRingCard", Rect2(18.0, 118.0, 194.0, 36.0), Color(0.08, 0.28, 0.40, 0.90))
	_lives_glow = _ensure_rect("LivesGlow", Rect2(10.0, 626.0, 236.0, 58.0), Color(0.10, 0.18, 0.36, 0.14))
	_lives_card = _ensure_rect("LivesCard", Rect2(18.0, 632.0, 214.0, 46.0), Color(0.08, 0.14, 0.28, 0.92))
	_timer_glow = _ensure_rect("TimerGlow", Rect2(972.0, 12.0, 278.0, 56.0), Color(0.16, 0.24, 0.58, 0.18))
	_timer_card = _ensure_rect("TimerCard", Rect2(980.0, 18.0, 262.0, 42.0), Color(0.12, 0.18, 0.42, 0.92))
	_status_card = _ensure_rect("StatusCard", Rect2(350.0, 18.0, 580.0, 46.0), Color(0.08, 0.10, 0.18, 0.86))
	_score_glow.z_index = -6
	_score_card.z_index = -5
	_rings_card.z_index = -5
	_special_ring_card.z_index = -5
	_lives_glow.z_index = -6
	_lives_card.z_index = -5
	_timer_glow.z_index = -6
	_timer_card.z_index = -5
	_status_card.z_index = -5

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
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label

func _ensure_titles() -> void:
	if special_ring_label == null:
		special_ring_label = _ensure_label("SpecialRingLabel", Vector2(34.0, 126.0), Vector2(164.0, 22.0), 12)
	powerup_label = _ensure_label("PowerupLabel", Vector2(222.0, 126.0), Vector2(132.0, 22.0), 12)
	_score_title = _ensure_label("ScoreTitle", Vector2(34.0, 22.0), Vector2(86.0, 20.0), 14)
	_rings_title = _ensure_label("RingsTitle", Vector2(34.0, 74.0), Vector2(86.0, 20.0), 14)
	_time_title = _ensure_label("TimeTitle", Vector2(996.0, 22.0), Vector2(72.0, 20.0), 14)
	_lives_title = _ensure_label("LivesTitle", Vector2(34.0, 636.0), Vector2(60.0, 20.0), 14)
	_character_label = _ensure_label("CharacterLabel", Vector2(34.0, 652.0), Vector2(60.0, 20.0), 16)
	var chrome := CoreBridge.get_hud_chrome_colors()
	_score_title.modulate = chrome.get("score_title", Color(0.68, 0.86, 1.0, 0.94))
	_rings_title.modulate = chrome.get("rings_title", Color(1.0, 0.84, 0.36, 0.96))
	_time_title.modulate = chrome.get("time_title", Color(0.74, 0.88, 1.0, 0.94))
	_lives_title.modulate = chrome.get("lives_title", Color(0.72, 0.84, 1.0, 0.94))
	_character_label.modulate = chrome.get("character", Color(0.98, 0.98, 1.0, 1.0))

func _ensure_boss_panel() -> void:
	_boss_panel = _ensure_rect("BossPanel", Rect2(432.0, 78.0, 416.0, 74.0), Color(0.18, 0.06, 0.10, 0.94))
	_boss_panel.z_index = -4
	_boss_title = _ensure_label("BossTitle", Vector2(448.0, 86.0), Vector2(150.0, 22.0), 14)
	_boss_phase = _ensure_label("BossPhase", Vector2(620.0, 86.0), Vector2(212.0, 22.0), 14)
	_boss_phase.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_boss_health_back = _ensure_rect("BossHealthBack", Rect2(448.0, 118.0, 384.0, 14.0), Color(0.04, 0.03, 0.06, 0.96))
	_boss_health_back.z_index = -3
	_boss_health_fill = _ensure_rect("BossHealthFill", Rect2(450.0, 120.0, 380.0, 10.0), Color(0.94, 0.24, 0.24, 1.0))
	_boss_health_fill.z_index = -2
	for i in range(8):
		var pip := _ensure_rect("BossHealthPip%d" % i, Rect2(450.0 + i * 47.5, 120.0, 42.0, 10.0), Color(1.0, 0.52, 0.34, 1.0))
		pip.z_index = -1
		_boss_health_pips.append(pip)

func _update_boss_panel(chrome: Dictionary) -> void:
	var boss_state: Dictionary = CoreBridge.get_boss_hud_state()
	var boss_visible := bool(boss_state.get("active", false))
	var health := int(boss_state.get("health", 0))
	var max_health := maxi(1, int(boss_state.get("max_health", 1)))
	if _boss_panel:
		_boss_panel.visible = boss_visible
		_boss_panel.color = chrome.get("status_card", Color(0.18, 0.06, 0.10, 0.94))
	if _boss_title:
		_boss_title.visible = boss_visible
		_boss_title.text = CoreBridge.get_hud_boss_title_text(health, max_health)
		_boss_title.modulate = Color(1.0, 0.82, 0.62, 1.0)
	if _boss_phase:
		_boss_phase.visible = boss_visible
		_boss_phase.text = CoreBridge.get_hud_boss_phase_text(str(boss_state.get("phase", "")))
		_boss_phase.modulate = chrome.get("text", Color(0.96, 0.98, 1.0, 1.0))
	if _boss_health_back:
		_boss_health_back.visible = boss_visible
	if _boss_health_fill:
		_boss_health_fill.visible = boss_visible
		_boss_health_fill.size.x = 380.0 * float(health) / float(max_health)
		_boss_health_fill.color = Color(0.94, 0.24, 0.24, 1.0) if health <= 2 else Color(1.0, 0.52, 0.28, 1.0)
	for i in range(_boss_health_pips.size()):
		_boss_health_pips[i].visible = boss_visible and i < health


func _update_titles(character_variant: int, chrome: Dictionary) -> void:
	var titles := CoreBridge.get_hud_titles()
	if _score_title:
		_score_title.text = str(titles.get("score", "SCORE"))
		_score_title.modulate = chrome.get("score_title", Color(0.68, 0.86, 1.0, 0.94))
	if _rings_title:
		_rings_title.text = str(titles.get("rings", "RINGS"))
		_rings_title.modulate = chrome.get("rings_title", Color(1.0, 0.84, 0.36, 0.96))
	if _time_title:
		_time_title.text = str(titles.get("time", "TIME"))
		_time_title.modulate = chrome.get("time_title", Color(0.74, 0.88, 1.0, 0.94))
	if _lives_title:
		_lives_title.text = str(titles.get("lives", "LIFE"))
		_lives_title.modulate = chrome.get("lives_title", Color(0.72, 0.84, 1.0, 0.94))
	if _character_label:
		_character_label.text = CoreBridge.get_hud_character_short_name(character_variant)
		_character_label.modulate = chrome.get("character", Color(0.98, 0.98, 1.0, 1.0))

func _ensure_multiplayer_panel() -> void:
	_mp_panel = _ensure_rect("MultiplayerPanel", Rect2(828.0, 508.0, 420.0, 168.0), Color(0.16, 0.07, 0.12, 0.88))
	_mp_track = _ensure_rect("MultiplayerTrack", Rect2(960.0, 532.0, 236.0, 8.0), Color(0.88, 0.62, 0.18, 0.88))
	_mp_start_flag = _ensure_label("MultiplayerStartFlag", Vector2(922.0, 520.0), Vector2(34.0, 24.0), 14)
	_mp_finish_flag = _ensure_label("MultiplayerFinishFlag", Vector2(1200.0, 520.0), Vector2(40.0, 24.0), 14)
	_mp_panel.z_index = -4
	_mp_track.z_index = -3
	_mp_start_flag.z_index = -2
	_mp_finish_flag.z_index = -2

	if _mp_row_cards.size() > 0:
		return

	for i in range(4):
		var row_card := _ensure_rect("MultiplayerRowCard%d" % i, Rect2(846.0, 548.0 + i * 28.0, 386.0, 24.0), Color(0.10, 0.05, 0.09, 0.82))
		row_card.z_index = -2
		_mp_row_cards.append(row_card)

		var place_label := _ensure_label("MultiplayerPlaceLabel%d" % i, Vector2(858.0, 548.0 + i * 28.0), Vector2(58.0, 24.0), 14)
		place_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_mp_place_labels.append(place_label)

		var name_label := _ensure_label("MultiplayerNameLabel%d" % i, Vector2(924.0, 548.0 + i * 28.0), Vector2(188.0, 24.0), 14)
		_mp_name_labels.append(name_label)

		var progress_label := _ensure_label("MultiplayerProgressLabel%d" % i, Vector2(1136.0, 548.0 + i * 28.0), Vector2(84.0, 24.0), 14)
		progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_mp_progress_labels.append(progress_label)

		var marker := _ensure_rect("MultiplayerMarker%d" % i, Rect2(960.0, 531.0, 10.0, 10.0), Color(1.0, 0.88, 0.48, 1.0))
		marker.z_index = -1
		_mp_markers.append(marker)

func _update_hud_chrome(chrome: Dictionary) -> void:
	if _score_card:
		_score_card.color = chrome.get("score_card", _score_card.color)
	if _rings_card:
		_rings_card.color = chrome.get("rings_card", _rings_card.color)
	if _special_ring_card:
		_special_ring_card.color = Color(chrome.get("rings_card", _special_ring_card.color)).darkened(0.08)
	if _lives_card:
		_lives_card.color = chrome.get("lives_card", _lives_card.color)
	if _timer_card:
		_timer_card.color = chrome.get("timer_card", _timer_card.color)
	if _status_card:
		_status_card.color = chrome.get("status_card", _status_card.color)
	if _score_glow:
		var score_color: Color = Color(chrome.get("score_card", _score_card.color))
		_score_glow.color = Color(score_color.r * 0.52, score_color.g * 0.74, score_color.b * 1.08, 0.16)
	if _timer_glow:
		var timer_color: Color = Color(chrome.get("timer_card", _timer_card.color))
		_timer_glow.color = Color(timer_color.r * 0.72, timer_color.g * 0.86, timer_color.b * 1.10, 0.16)
	if _lives_glow:
		var lives_color: Color = Color(chrome.get("lives_card", _lives_card.color))
		_lives_glow.color = Color(lives_color.r * 0.56, lives_color.g * 0.72, lives_color.b * 1.04, 0.12)

func _update_multiplayer_panel(chrome: Dictionary) -> void:
	var multiplayer_visible := CoreBridge.is_multiplayer_run()
	if _mp_panel:
		_mp_panel.visible = multiplayer_visible
		_mp_panel.color = chrome.get("status_card", Color(0.16, 0.07, 0.12, 0.88))
	if _mp_track:
		_mp_track.visible = multiplayer_visible
		_mp_track.color = chrome.get("rings_title", Color(0.88, 0.62, 0.18, 0.88))
	if _mp_start_flag:
		_mp_start_flag.visible = multiplayer_visible
		_mp_start_flag.text = CoreBridge.get_hud_multiplayer_start_flag_text()
		_mp_start_flag.modulate = chrome.get("score_title", Color(1.0, 0.82, 0.52, 0.94))
	if _mp_finish_flag:
		_mp_finish_flag.visible = multiplayer_visible
		_mp_finish_flag.text = CoreBridge.get_hud_multiplayer_finish_flag_text()
		_mp_finish_flag.modulate = chrome.get("score_title", Color(1.0, 0.82, 0.52, 0.94))

	var rows: Array = CoreBridge.get_multiplayer_hud_rows()
	for i in range(_mp_row_cards.size()):
		var has_row := multiplayer_visible and i < rows.size() and rows[i] is Dictionary
		var row: Dictionary = {}
		if has_row:
			row = rows[i] as Dictionary
		if _mp_row_cards[i]:
			_mp_row_cards[i].visible = has_row
			_mp_row_cards[i].color = Color(0.30, 0.12, 0.18, 0.90) if bool(row.get("is_local", false)) else Color(0.10, 0.05, 0.09, 0.82)
		if _mp_place_labels[i]:
			_mp_place_labels[i].visible = has_row
			_mp_place_labels[i].text = str(row.get("place_text", ""))
			_mp_place_labels[i].modulate = chrome.get("rings_title", Color(1.0, 0.88, 0.44, 0.96))
		if _mp_name_labels[i]:
			_mp_name_labels[i].visible = has_row
			_mp_name_labels[i].text = "%s  %s" % [str(row.get("name", "")), str(row.get("character", ""))]
			_mp_name_labels[i].modulate = chrome.get("text", Color(1.0, 0.96, 0.92, 1.0))
		if _mp_progress_labels[i]:
			_mp_progress_labels[i].visible = has_row
			_mp_progress_labels[i].text = str(row.get("progress_text", ""))
			_mp_progress_labels[i].modulate = chrome.get("score_title", Color(1.0, 0.82, 0.52, 0.94))
		if _mp_markers[i]:
			_mp_markers[i].visible = has_row
			var progress_value: float = clampf(float(row.get("progress", 0.0)), 0.0, 1.0)
			_mp_markers[i].position = Vector2(960.0 + progress_value * 226.0, 531.0 + i * 2.0)
			_mp_markers[i].color = Color(1.0, 0.92, 0.54, 1.0) if bool(row.get("is_local", false)) else Color(0.90, 0.76, 0.42, 0.96)

func _set_hud_visible(hud_visible: bool) -> void:
	if _score_glow:
		_score_glow.visible = hud_visible
	if _score_card:
		_score_card.visible = hud_visible
	if _rings_card:
		_rings_card.visible = hud_visible
	if _special_ring_card:
		_special_ring_card.visible = hud_visible and CoreBridge.is_special_ring_hud_visible()
	if _lives_glow:
		_lives_glow.visible = hud_visible
	if _lives_card:
		_lives_card.visible = hud_visible
	if _timer_glow:
		_timer_glow.visible = hud_visible
	if _timer_card:
		_timer_card.visible = hud_visible
	if _status_card:
		_status_card.visible = hud_visible
	if rings_label:
		rings_label.visible = hud_visible
	if special_ring_label:
		special_ring_label.visible = hud_visible and CoreBridge.is_special_ring_hud_visible()
	if powerup_label:
		powerup_label.visible = hud_visible and powerup_label.text != ""
	if score_label:
		score_label.visible = hud_visible
	if time_label:
		time_label.visible = hud_visible
	if lives_label:
		lives_label.visible = hud_visible
	if status_label:
		status_label.visible = hud_visible and CoreBridge.get_status_text() != ""
	if _race_start_label:
		_race_start_label.visible = hud_visible and CoreBridge.is_race_start_message_visible()
	if _score_title:
		_score_title.visible = hud_visible
	if _rings_title:
		_rings_title.visible = hud_visible
	if _time_title:
		_time_title.visible = hud_visible
	if _lives_title:
		_lives_title.visible = hud_visible
	if _character_label:
		_character_label.visible = hud_visible
	if _boss_panel:
		_boss_panel.visible = hud_visible and CoreBridge.get_boss_hud_state().get("active", false)
	if _boss_title:
		_boss_title.visible = hud_visible and CoreBridge.get_boss_hud_state().get("active", false)
	if _boss_phase:
		_boss_phase.visible = hud_visible and CoreBridge.get_boss_hud_state().get("active", false)
	if _boss_health_back:
		_boss_health_back.visible = hud_visible and CoreBridge.get_boss_hud_state().get("active", false)
	if _boss_health_fill:
		_boss_health_fill.visible = hud_visible and CoreBridge.get_boss_hud_state().get("active", false)
	for pip in _boss_health_pips:
		pip.visible = hud_visible and CoreBridge.get_boss_hud_state().get("active", false)
	if not hud_visible:
		if _mp_panel:
			_mp_panel.visible = false
		if _mp_track:
			_mp_track.visible = false
		if _mp_start_flag:
			_mp_start_flag.visible = false
		if _mp_finish_flag:
			_mp_finish_flag.visible = false
		for row_card in _mp_row_cards:
			row_card.visible = false
		for label in _mp_name_labels:
			label.visible = false
		for label in _mp_place_labels:
			label.visible = false
		for label in _mp_progress_labels:
			label.visible = false
		for marker in _mp_markers:
			marker.visible = false
