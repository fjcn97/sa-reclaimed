# SoundTestScreen.gd
# Presents an original-inspired dedicated sound test screen.
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
var _speaker_stage: ColorRect = null
var _status_stage: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _speaker_frame: ColorRect = null
var _speaker_core: ColorRect = null
var _speaker_glow: ColorRect = null
var _number_plate: ColorRect = null
var _status_plate: ColorRect = null
var _prompt_band: ColorRect = null
var _track_number_label: Label = null
var _track_name_label: Label = null
var _status_label: Label = null
var _summary_label: Label = null
var _ticker_label: Label = null
var _badge_label: Label = null
var _cream_mascot: Control = null
var _row_cards: Array[ColorRect] = []
var _row_labels: Array[Label] = []
var _value_labels: Array[Label] = []
var _gradient_bands: Array[ColorRect] = []
var _gradient_time: float = 0.0
var _track_audio_player: AudioStreamPlayer = null
var _track_audio_key := ""
var _bridge: Node = null

const SOURCE_BG_PALETTE: Array[Color] = [
	Color(0.02, 0.03, 0.08, 0.96),
	Color(1.0, 1.0, 0.55, 0.90),
	Color(0.80, 0.87, 0.61, 0.86),
	Color(0.70, 0.67, 0.08, 0.82),
	Color(0.02, 0.61, 0.45, 0.80),
	Color(0.45, 0.38, 0.67, 0.78),
	Color(0.98, 0.98, 0.98, 0.78),
	Color(0.02, 0.03, 0.08, 0.96),
]

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
	_ensure_labels()
	_ensure_rows()
	_ensure_mascot()
	_track_audio_player = AudioStreamPlayer.new()
	_track_audio_player.name = "SoundTestPreviewPlayer"
	add_child(_track_audio_player)
	_set_screen_visible(_bridge != null and _bridge.is_sound_test_screen())

func _process(_delta: float) -> void:
	var active: bool = _bridge != null and _bridge.is_sound_test_screen()
	_set_screen_visible(active)
	if not active:
		_stop_track_preview()
		return
	_sync_track_preview()
	_gradient_time += _delta
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 210.0) * 0.5)
	if title_label:
		title_label.text = _bridge.get_sound_test_title_text()
		title_label.position = Vector2(248.0, 116.0)
		title_label.size = Vector2(628.0, 56.0)
		title_label.modulate = Color(0.92, 0.97, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = _bridge.get_sound_test_prompt_text()
		prompt_label.position = Vector2(182.0, 550.0)
		prompt_label.size = Vector2(916.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.52, 0.74 + (pulse * 0.26))
	if detail_label:
		detail_label.text = "%s   |   %s" % [_bridge.get_sound_test_status_text(), _bridge.get_sound_test_detail_text()]
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.80, 0.90, 1.0, 0.92)
	_update_chrome()
	_update_header()
	_update_rows()
	_update_name_ticker()
	_update_speaker_animation()
	_update_gradient_bands()

func _sync_track_preview() -> void:
	var playing: bool = _bridge.is_sound_test_playing()
	if not playing:
		_stop_track_preview()
		return
	var track_key := "%d:%s" % [_bridge.get_sound_test_track_number(), _bridge.get_sound_test_track_name()]
	if _track_audio_player == null:
		return
	if track_key != _track_audio_key or _track_audio_player.stream == null:
		_track_audio_key = track_key
		_track_audio_player.stream = SoundTestPreviewGenerator.make_preview(_bridge.get_sound_test_track_number(), _bridge.get_sound_test_tempo())
		_track_audio_player.play()
	elif not _track_audio_player.playing:
		_track_audio_player.play()

func _stop_track_preview() -> void:
	if _track_audio_player and _track_audio_player.playing:
		_track_audio_player.stop()

func _ensure_chrome() -> void:
	_ensure_gradient_bands()
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.05, 0.70))
	_hero_glow = ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.12, 0.34, 0.56, 0.18))
	_header_plate = ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.08, 0.12, 0.18, 0.94))
	_panel = ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.07, 0.11, 0.20, 0.98))
	_accent = ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.18, 0.78, 0.98, 1.0))
	_header_band = ensure_rect("HeaderBand", Rect2(210.0, 246.0, 288.0, 238.0), Color(0.08, 0.16, 0.30, 0.92))
	_speaker_stage = ensure_rect("SpeakerStage", Rect2(204.0, 246.0, 292.0, 238.0), Color(0.08, 0.14, 0.22, 0.94))
	_status_stage = ensure_rect("StatusStage", Rect2(522.0, 246.0, 550.0, 238.0), Color(0.08, 0.14, 0.24, 0.94))
	_badge_ring = ensure_rect("BadgeRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(0.92, 0.78, 0.24, 0.22))
	_badge_core = ensure_rect("BadgeCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.10, 0.20, 0.34, 0.96))
	_speaker_frame = ensure_rect("SpeakerFrame", Rect2(224.0, 278.0, 252.0, 196.0), Color(0.13, 0.18, 0.28, 1.0))
	_speaker_core = ensure_rect("SpeakerCore", Rect2(254.0, 312.0, 192.0, 128.0), Color(0.03, 0.05, 0.10, 1.0))
	_speaker_glow = ensure_rect("SpeakerGlow", Rect2(284.0, 338.0, 132.0, 76.0), Color(0.28, 0.88, 0.98, 0.34))
	_number_plate = ensure_rect("NumberPlate", Rect2(548.0, 278.0, 498.0, 54.0), Color(0.10, 0.16, 0.28, 1.0))
	_status_plate = ensure_rect("StatusPlate", Rect2(548.0, 344.0, 498.0, 130.0), Color(0.09, 0.13, 0.22, 1.0))
	_prompt_band = ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.04, 0.08, 0.16, 0.92))
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_speaker_stage.z_index = -3
	_status_stage.z_index = -3
	_badge_ring.z_index = -2
	_badge_core.z_index = -1
	_speaker_frame.z_index = -1
	_speaker_core.z_index = 0
	_speaker_glow.z_index = 1
	_number_plate.z_index = -1
	_status_plate.z_index = -1
	_prompt_band.z_index = -1

func _ensure_gradient_bands() -> void:
	if not _gradient_bands.is_empty():
		return
	for i in range(12):
		var band := ensure_rect("PaletteBand%d" % i, Rect2(0.0, float(i) * 60.0, 1280.0, 61.0), SOURCE_BG_PALETTE[i % SOURCE_BG_PALETTE.size()])
		band.z_index = -10
		_gradient_bands.append(band)

func _update_gradient_bands() -> void:
	var phase := fposmod(_gradient_time * 1.2, float(SOURCE_BG_PALETTE.size()))
	for i in range(_gradient_bands.size()):
		var sample := phase + float(i) * 0.34
		var index_a := int(floor(sample)) % SOURCE_BG_PALETTE.size()
		var index_b := (index_a + 1) % SOURCE_BG_PALETTE.size()
		var blend := fposmod(sample, 1.0)
		var color := SOURCE_BG_PALETTE[index_a].lerp(SOURCE_BG_PALETTE[index_b], blend)
		_gradient_bands[i].color = Color(color.r, color.g, color.b, 0.26)
		_gradient_bands[i].position.y = float(i) * 60.0 - fposmod(_gradient_time * 18.0, 60.0)

func _ensure_labels() -> void:
	_track_number_label = ensure_label("TrackNumberLabel", Vector2(572.0, 286.0), Vector2(186.0, 38.0), 28)
	_track_name_label = ensure_label("TrackNameLabel", Vector2(550.0, 352.0), Vector2(494.0, 32.0), 23)
	_status_label = ensure_label("StatusLabel", Vector2(572.0, 394.0), Vector2(450.0, 26.0), 17)
	_summary_label = ensure_label("SummaryLabel", Vector2(572.0, 426.0), Vector2(450.0, 42.0), 15)
	_ticker_label = ensure_label("TickerLabel", Vector2(176.0, 596.0), Vector2(928.0, 26.0), 20)
	_track_number_label.modulate = Color(0.93, 0.98, 1.0, 1.0)
	_track_name_label.modulate = Color(0.98, 0.93, 0.62, 1.0)
	_status_label.modulate = Color(0.78, 0.88, 1.0, 0.94)
	_summary_label.modulate = Color(0.78, 0.88, 1.0, 0.94)
	_ticker_label.modulate = Color(0.24, 0.86, 0.98, 0.96)
	_track_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if _badge_label == null:
		_badge_label = ensure_label("BadgeLabel", Vector2(886.0, 160.0), Vector2(124.0, 38.0), 18)
	_badge_label.text = _bridge.get_menu_badge_text("AUDIO")
	_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

func _ensure_rows() -> void:
	if _row_labels.size() > 0:
		return
	for i in range(1):
		var top := 486.0 + float(i) * 24.0
		var card := ensure_rect("RowCard%d" % i, Rect2(548.0, top, 498.0, 24.0), Color(0.10, 0.16, 0.29, 0.96))
		var row := ensure_label("RowLabel%d" % i, Vector2(570.0, top - 1.0), Vector2(154.0, 26.0), 14)
		var value := ensure_label("ValueLabel%d" % i, Vector2(728.0, top - 1.0), Vector2(290.0, 26.0), 13)
		row.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(row)
		_value_labels.append(value)

func _ensure_mascot() -> void:
	_cream_mascot = get_node_or_null("CreamMascot") as Control
	if _cream_mascot == null:
		_cream_mascot = Control.new()
		_cream_mascot.name = "CreamMascot"
		_cream_mascot.set_script(load("res://scripts/SoundTestMascot.gd"))
		add_child(_cream_mascot)
	_cream_mascot.position = Vector2(244.0, 278.0)
	_cream_mascot.size = Vector2(212.0, 194.0)
	_cream_mascot.z_index = 2

func _update_header() -> void:
	if _track_number_label:
		_track_number_label.text = _bridge.get_sound_test_track_number_text()
	if _track_name_label:
		_track_name_label.text = _bridge.get_sound_test_track_name()
	if _status_label:
		_status_label.text = _bridge.get_sound_test_status_text()
		_status_label.visible = true
	if _summary_label:
		_summary_label.text = _bridge.get_sound_test_summary_text().replace("\n", "   ")

func _update_chrome() -> void:
	var colors: Dictionary = _bridge.get_sound_test_chrome_colors()
	if _accent:
		_accent.color = colors.get("accent", Color(0.18, 0.78, 0.98, 1.0))
	if _hero_glow:
		var accent := Color(colors.get("accent", Color(0.18, 0.78, 0.98, 1.0)))
		_hero_glow.color = Color(accent.r * 0.55, accent.g * 0.55, accent.b * 0.65, 0.18)
	if _header_plate:
		var accent_plate := Color(colors.get("accent", Color(0.18, 0.78, 0.98, 1.0)))
		_header_plate.color = Color(accent_plate.r * 0.18, accent_plate.g * 0.24, accent_plate.b * 0.30, 0.92)
	if _header_band:
		var header := Color(colors.get("accent", Color(0.18, 0.78, 0.98, 1.0)))
		_header_band.color = Color(header.r * 0.30, header.g * 0.26, header.b * 0.30, 0.92)
	if _speaker_stage:
		var accent_stage := Color(colors.get("accent", Color(0.18, 0.78, 0.98, 1.0)))
		_speaker_stage.color = Color(accent_stage.r * 0.16, accent_stage.g * 0.20, accent_stage.b * 0.28, 0.94)
	if _status_stage:
		var accent_status := Color(colors.get("accent", Color(0.18, 0.78, 0.98, 1.0)))
		_status_stage.color = Color(accent_status.r * 0.12, accent_status.g * 0.18, accent_status.b * 0.28, 0.94)
	if _badge_core:
		var badge := Color(colors.get("accent", Color(0.18, 0.78, 0.98, 1.0)))
		_badge_core.color = Color(badge.r * 0.30, badge.g * 0.26, badge.b * 0.30, 0.96)

func _update_rows() -> void:
	var rows: Array = _bridge.get_sound_test_rows()
	for i in range(_row_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_row_labels[i].visible = visible
		_value_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var lift := 0.0
		var top := 486.0 + float(i) * 24.0
		_row_cards[i].position.y = top + lift
		_row_labels[i].position.y = top - 2.0 + lift
		_value_labels[i].position.y = top - 2.0 + lift
		_row_cards[i].color = Color(0.22, 0.42, 0.62, 0.98) if is_selected else Color(0.10, 0.16, 0.29, 0.96)
		_row_labels[i].text = str(row.get("label", ""))
		_value_labels[i].text = str(row.get("value", ""))
		_row_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0) if is_selected else Color(0.88, 0.94, 1.0, 0.94)
		_value_labels[i].modulate = Color(0.96, 0.88, 0.52, 1.0) if is_selected else Color(0.68, 0.80, 0.96, 0.92)

func _update_name_ticker() -> void:
	if _ticker_label == null:
		return
	var ticker_text := "   %02d  %s   " % [_bridge.get_sound_test_track_number(), _bridge.get_sound_test_track_name()]
	_ticker_label.text = ticker_text.repeat(3)
	var cycle_width := 1320.0
	var offset := fmod(float(Time.get_ticks_msec()) * 0.18, cycle_width)
	_ticker_label.position.x = 1088.0 - offset

func _update_speaker_animation() -> void:
	if _speaker_glow == null:
		return
	var chrome: Dictionary = _bridge.get_sound_test_chrome_colors()
	var glow_base: Color = chrome.get("glow", Color(0.28, 0.88, 0.98, 0.34))
	var pulse := 0.32 + 0.18 * sin(float(Time.get_ticks_msec()) * 0.008)
	if _bridge.is_sound_test_playing():
		pulse += 0.26
	_speaker_glow.color = Color(glow_base.r, glow_base.g, glow_base.b, clamp(pulse, 0.20, 0.72))

func _set_screen_visible(screen_visible: bool) -> void:
	for band in _gradient_bands:
		band.visible = screen_visible
	if _backdrop:
		_backdrop.visible = screen_visible
	if _header_plate:
		_header_plate.visible = screen_visible
	if _panel:
		_panel.visible = screen_visible
	if _hero_glow:
		_hero_glow.visible = screen_visible
	if _accent:
		_accent.visible = screen_visible
	if _header_band:
		_header_band.visible = screen_visible
	if _speaker_stage:
		_speaker_stage.visible = screen_visible
	if _status_stage:
		_status_stage.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _speaker_frame:
		_speaker_frame.visible = screen_visible
	if _speaker_core:
		_speaker_core.visible = screen_visible
	if _speaker_glow:
		_speaker_glow.visible = screen_visible
	if _number_plate:
		_number_plate.visible = screen_visible
	if _status_plate:
		_status_plate.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	if _track_number_label:
		_track_number_label.visible = screen_visible
	if _track_name_label:
		_track_name_label.visible = screen_visible
	if _status_label:
		_status_label.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _ticker_label:
		_ticker_label.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	if _cream_mascot:
		_cream_mascot.visible = screen_visible
	for card in _row_cards:
		card.visible = screen_visible
	for label in _row_labels:
		label.visible = screen_visible
	for label in _value_labels:
		label.visible = screen_visible
