# IntroScreen.gd
# Presents an original-inspired stage intro title card.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _time: float = 0.0
var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _header_band: ColorRect = null
var _accent: ColorRect = null
var _header_glow: ColorRect = null
var _left_stage: ColorRect = null
var _right_stage: ColorRect = null
var _wheel_ring: ColorRect = null
var _wheel_core: ColorRect = null
var _badge_strip: ColorRect = null
var _info_stage: ColorRect = null
var _prompt_band: ColorRect = null
var _triangle_accent: ColorRect = null
var _zone_chip: ColorRect = null
var _act_chip: ColorRect = null
var _character_chip: ColorRect = null
var _wheel_icon_label: Label = null
var _zone_label: Label = null
var _act_label: Label = null
var _character_label: Label = null
var _countdown_label: Label = null
var _badge_cards: Array[ColorRect] = []
var _badge_labels: Array[Label] = []

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
	_set_screen_visible(CoreBridge.is_intro_screen() or CoreBridge.is_final_intro_screen())

func _process(delta: float) -> void:
	_time += delta
	var intro_mode: bool = CoreBridge.is_intro_screen() or CoreBridge.is_final_intro_screen()
	_set_screen_visible(intro_mode)
	if not intro_mode:
		return
	if title_label:
		title_label.text = CoreBridge.get_intro_title_text()
		title_label.modulate = Color(0.98, 0.96, 1.0, 1.0)
		title_label.position = Vector2(246.0, 264.0)
		title_label.size = Vector2(430.0, 54.0)
		title_label.scale = Vector2.ONE * (1.0 + sin(_time * 2.0) * 0.01)
	if prompt_label:
		prompt_label.text = CoreBridge.get_intro_prompt_text()
		prompt_label.modulate = Color(1.0, 0.96, 0.74, 1.0 if CoreBridge.is_intro_go_phase() else 0.92)
		prompt_label.position = Vector2(186.0, 548.0)
		prompt_label.size = Vector2(908.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if detail_label:
		detail_label.text = CoreBridge.get_intro_detail_text()
		detail_label.modulate = Color(0.88, 0.94, 1.0, 1.0 if CoreBridge.is_intro_go_phase() else 0.84)
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_update_header_labels()
	_update_countdown_label()
	_update_stage_intro_timing(CoreBridge.get_intro_stage_frame())
	_update_chrome()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.04, 0.40))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 188.0), Color(0.12, 0.24, 0.44, 0.18))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.06, 0.10, 0.18, 0.94))
	_header_band = _ensure_rect("HeaderBand", Rect2(214.0, 246.0, 324.0, 256.0), Color(0.06, 0.10, 0.18, 0.94))
	_panel = _ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.06, 0.09, 0.16, 0.88))
	_accent = _ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.34, 0.80, 1.0, 0.96))
	_header_glow = _ensure_rect("HeaderGlow", Rect2(176.0, 168.0, 928.0, 6.0), Color(0.34, 0.80, 1.0, 0.24))
	_left_stage = _ensure_rect("LeftStage", Rect2(204.0, 246.0, 346.0, 256.0), Color(0.08, 0.12, 0.22, 0.92))
	_right_stage = _ensure_rect("RightStage", Rect2(576.0, 246.0, 498.0, 256.0), Color(0.10, 0.14, 0.24, 0.92))
	_info_stage = _ensure_rect("InfoStage", Rect2(230.0, 286.0, 292.0, 148.0), Color(0.08, 0.12, 0.22, 0.92))
	_wheel_ring = _ensure_rect("WheelRing", Rect2(868.0, 108.0, 140.0, 140.0), Color(0.12, 0.22, 0.34, 0.92))
	_wheel_core = _ensure_rect("WheelCore", Rect2(903.0, 143.0, 70.0, 70.0), Color(0.04, 0.08, 0.16, 0.96))
	_badge_strip = _ensure_rect("BadgeStrip", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.04, 0.08, 0.16, 0.84))
	_prompt_band = _ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.05, 0.09, 0.17, 0.92))
	_triangle_accent = _ensure_rect("TriangleAccent", Rect2(820.0, 352.0, 210.0, 126.0), Color(0.20, 0.72, 0.48, 0.18))
	_zone_chip = _ensure_rect("ZoneChip", Rect2(232.0, 160.0, 126.0, 34.0), Color(0.22, 0.56, 0.92, 0.96))
	_act_chip = _ensure_rect("ActChip", Rect2(374.0, 160.0, 102.0, 34.0), Color(0.12, 0.24, 0.46, 0.96))
	_character_chip = _ensure_rect("CharacterChip", Rect2(848.0, 160.0, 178.0, 34.0), Color(0.20, 0.72, 0.48, 0.96))
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_header_band.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_glow.z_index = -4
	_left_stage.z_index = -4
	_right_stage.z_index = -4
	_info_stage.z_index = -3
	_wheel_ring.z_index = -2
	_wheel_core.z_index = -1
	_prompt_band.z_index = -2
	_badge_strip.z_index = -2
	_triangle_accent.z_index = -2
	_zone_chip.z_index = -1
	_act_chip.z_index = -1
	_character_chip.z_index = -1

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

func _ensure_header_labels() -> void:
	_zone_label = _ensure_label("ZoneLabel", Vector2(246.0, 162.0), Vector2(98.0, 28.0), 16)
	_zone_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_act_label = _ensure_label("ActLabel", Vector2(388.0, 162.0), Vector2(74.0, 28.0), 16)
	_act_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_character_label = _ensure_label("CharacterLabel", Vector2(866.0, 162.0), Vector2(142.0, 28.0), 16)
	_character_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_wheel_icon_label = _ensure_label("WheelIconLabel", Vector2(912.0, 158.0), Vector2(52.0, 40.0), 24)
	_wheel_icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_countdown_label = _ensure_label("CountdownLabel", Vector2(752.0, 302.0), Vector2(244.0, 132.0), 84)
	_countdown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_countdown_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if _badge_cards.size() == 0:
		for i in range(10):
			var x := 104.0 + i * 108.0
			var card := _ensure_rect("BadgeCard%d" % i, Rect2(x, 594.0, 100.0, 32.0), Color(0.10, 0.16, 0.26, 0.92))
			card.z_index = -1
			_badge_cards.append(card)
			var label := _ensure_label("BadgeLabel%d" % i, Vector2(x, 592.0), Vector2(100.0, 36.0), 13)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			_badge_labels.append(label)

func _update_header_labels() -> void:
	if _zone_label:
		_zone_label.text = CoreBridge.get_intro_zone_label()
		_zone_label.modulate = Color(0.96, 0.98, 1.0, 1.0)
	if _act_label:
		_act_label.text = CoreBridge.get_intro_act_label()
		_act_label.modulate = Color(0.92, 0.96, 1.0, 1.0)
	if _character_label:
		_character_label.text = CoreBridge.get_intro_character_label()
		_character_label.modulate = Color(0.94, 1.0, 0.96, 1.0)
	if _wheel_icon_label:
		_wheel_icon_label.text = CoreBridge.get_intro_stage_icon_text()
		_wheel_icon_label.modulate = Color(0.96, 0.98, 1.0, 1.0)
	_update_badge_strip()

func _update_countdown_label() -> void:
	if _countdown_label == null:
		return
	var countdown_text := CoreBridge.get_intro_countdown_text()
	_countdown_label.text = countdown_text
	_countdown_label.visible = not countdown_text.is_empty()
	_countdown_label.modulate = Color(1.0, 0.96, 0.78, 1.0) if CoreBridge.is_intro_go_phase() else Color(0.94, 0.97, 1.0, 1.0)

func _update_stage_intro_timing(frame: float) -> void:
	# stage_intro.c reveals the banner at frame 7, holds it through frame 120,
	# then clears the masks by frame 150 before the countdown takes over.
	var reveal := clampf((frame - 7.0) / 3.0, 0.0, 1.0)
	var clear := 1.0
	if frame >= 120.0 and frame < 136.0:
		clear = lerpf(1.0, 0.24, (frame - 120.0) / 16.0)
	elif frame >= 136.0:
		clear = 0.24
	var alpha := reveal * clear
	if frame < 1.0:
		alpha = 0.0
	for label in [_zone_label, _act_label, _wheel_icon_label, _character_label]:
		if label:
			label.modulate.a = alpha
	for i in range(_badge_cards.size()):
		_badge_cards[i].modulate.a = alpha
		_badge_labels[i].modulate.a = alpha

func _update_badge_strip() -> void:
	var badges: Array = CoreBridge.get_intro_stage_badges()
	for i in range(_badge_cards.size()):
		var visible := i < badges.size()
		_badge_cards[i].visible = visible
		_badge_labels[i].visible = visible
		if not visible:
			continue
		var badge: Dictionary = badges[i]
		var selected := bool(badge.get("selected", false))
		var unlocked := bool(badge.get("unlocked", false))
		_badge_cards[i].color = Color(0.24, 0.56, 0.92, 0.94) if selected else (Color(0.16, 0.24, 0.38, 0.90) if unlocked else Color(0.08, 0.10, 0.14, 0.84))
		_badge_labels[i].text = str(badge.get("text", "--"))
		_badge_labels[i].modulate = Color(1.0, 1.0, 1.0, 1.0) if unlocked else Color(0.42, 0.46, 0.54, 0.90)

func _update_chrome() -> void:
	var go_mode := CoreBridge.is_intro_go_phase()
	var character_accent := CoreBridge.get_intro_character_accent_color()
	var pulse := absf(sin(_time * 0.9))
	if _hero_glow:
		_hero_glow.color = Color(character_accent.r * 0.34, character_accent.g * 0.34, character_accent.b * 0.42, 0.18 + pulse * 0.04)
	if _header_plate:
		_header_plate.color = Color(0.08, 0.12, 0.20, 0.92) if not go_mode else Color(0.16, 0.14, 0.08, 0.92)
	if _header_band:
		_header_band.color = Color(0.06, 0.09, 0.17, 0.92) if not go_mode else Color(0.12, 0.14, 0.08, 0.92)
	if _panel:
		_panel.color = Color(0.06, 0.09, 0.16, 0.88) if not go_mode else Color(0.10, 0.16, 0.08, 0.88)
	if _accent:
		_accent.color = Color(0.34, 0.80, 1.0, 0.96) if not go_mode else Color(0.96, 0.84, 0.18, 0.96)
	if _header_glow:
		_header_glow.color = Color(0.34, 0.80, 1.0, 0.20 + pulse * 0.10) if not go_mode else Color(0.96, 0.84, 0.18, 0.20 + pulse * 0.10)
	if _left_stage:
		_left_stage.color = Color(0.08, 0.12, 0.22, 0.92) if not go_mode else Color(0.12, 0.14, 0.08, 0.92)
	if _right_stage:
		_right_stage.color = Color(0.08, 0.12, 0.20, 0.92) if not go_mode else Color(0.14, 0.14, 0.08, 0.92)
	if _info_stage:
		_info_stage.color = Color(0.08, 0.12, 0.22, 0.92) if not go_mode else Color(0.12, 0.14, 0.08, 0.92)
	if _wheel_ring:
		_wheel_ring.color = Color(0.10, 0.18, 0.30, 0.94) if not go_mode else Color(0.24, 0.26, 0.12, 0.94)
	if _wheel_core:
		_wheel_core.color = Color(0.04, 0.08, 0.16, 0.96) if not go_mode else Color(0.10, 0.14, 0.08, 0.96)
	if _prompt_band:
		_prompt_band.color = Color(0.05, 0.09, 0.17, 0.92) if not go_mode else Color(0.12, 0.12, 0.07, 0.92)
	if _badge_strip:
		_badge_strip.color = Color(0.04, 0.08, 0.16, 0.84) if not go_mode else Color(0.10, 0.12, 0.06, 0.88)
	if _triangle_accent:
		_triangle_accent.color = Color(character_accent.r, character_accent.g, character_accent.b, 0.18 + pulse * 0.08)
	if _zone_chip:
		_zone_chip.color = Color(0.22, 0.56, 0.92, 0.96) if not go_mode else Color(0.28, 0.66, 0.28, 0.96)
	if _act_chip:
		_act_chip.color = Color(0.12, 0.24, 0.46, 0.96) if not go_mode else Color(0.20, 0.42, 0.18, 0.96)
	if _character_chip:
		_character_chip.color = Color(character_accent.r, character_accent.g, character_accent.b, 0.96) if not go_mode else Color(0.86, 0.60, 0.18, 0.96)
	if prompt_label:
		prompt_label.visible = CoreBridge.is_final_intro_screen() or CoreBridge.get_intro_countdown_text().is_empty()

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
	if _info_stage:
		_info_stage.visible = screen_visible
	if _wheel_ring:
		_wheel_ring.visible = screen_visible
	if _wheel_core:
		_wheel_core.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _badge_strip:
		_badge_strip.visible = screen_visible
	if _triangle_accent:
		_triangle_accent.visible = screen_visible
	if _zone_chip:
		_zone_chip.visible = screen_visible
	if _act_chip:
		_act_chip.visible = screen_visible
	if _character_chip:
		_character_chip.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	if _zone_label:
		_zone_label.visible = screen_visible
	if _act_label:
		_act_label.visible = screen_visible
	if _character_label:
		_character_label.visible = screen_visible
	if _wheel_icon_label:
		_wheel_icon_label.visible = screen_visible
	if _countdown_label:
		_countdown_label.visible = screen_visible and not CoreBridge.get_intro_countdown_text().is_empty()
	for card in _badge_cards:
		if not screen_visible:
			card.visible = false
	for label in _badge_labels:
		if not screen_visible:
			label.visible = false
