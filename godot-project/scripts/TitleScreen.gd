# TitleScreen.gd
# Presents the dedicated press-start/title shell for the Godot remake.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var subtitle_label: Label = null
@export var stage_one_label: Label = null
@export var stage_two_label: Label = null

var _time: float = 0.0
var _backdrop: ColorRect = null
var _ocean_glow: ColorRect = null
var _header_plate: ColorRect = null
var _logo_panel: ColorRect = null
var _logo_rule: ColorRect = null
var _title_plate: ColorRect = null
var _left_stage: ColorRect = null
var _right_stage: ColorRect = null
var _mode_band: ColorRect = null
var _mode_plate: ColorRect = null
var _prompt_glow: ColorRect = null
var _prompt_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _badge_label: Label = null
var _subtitle_chip: ColorRect = null
var _wave_lines: Array[ColorRect] = []

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if subtitle_label == null:
		subtitle_label = get_node_or_null("SubtitleLabel")
	if stage_one_label == null:
		stage_one_label = get_node_or_null("StageOneLabel")
	if stage_two_label == null:
		stage_two_label = get_node_or_null("StageTwoLabel")
	_ensure_chrome()
	_set_screen_visible(CoreBridge.is_title_screen())

func _process(delta: float) -> void:
	_time += delta
	var title_mode: bool = CoreBridge.is_press_start_screen()
	_set_screen_visible(title_mode)
	if not title_mode:
		return

	var pulse := 0.5 + (sin(_time * 2.2) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_press_start_title_text()
		title_label.modulate = Color(0.14, 0.24, 0.44, 1.0)
		title_label.position = Vector2(248.0, 104.0)
		title_label.size = Vector2(784.0, 60.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if prompt_label:
		prompt_label.text = CoreBridge.get_press_start_prompt_text()
		# title_screen.c shows the press-start sprite for 40 of every 81 frames.
		prompt_label.visible = fmod(_time, 81.0 / 60.0) < (40.0 / 60.0)
		prompt_label.modulate = Color(0.18, 0.46, 0.84, 0.72 + (pulse * 0.22))
		prompt_label.position = Vector2(164.0, 566.0)
		prompt_label.size = Vector2(952.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if subtitle_label:
		subtitle_label.text = CoreBridge.get_press_start_subtitle_text()
		subtitle_label.modulate = Color(0.20, 0.38, 0.66, 0.96)
		subtitle_label.position = Vector2(454.0, 220.0)
		subtitle_label.size = Vector2(372.0, 30.0)
	var info_rows := CoreBridge.get_press_start_info_rows()
	if stage_one_label:
		if info_rows.size() > 0 and info_rows[0] is Dictionary:
			_apply_info_row(stage_one_label, info_rows[0] as Dictionary, Vector2(246.0, 330.0), Color(0.80, 0.90, 1.0, 0.94))
		else:
			stage_one_label.visible = false
	if stage_two_label:
		if info_rows.size() > 1 and info_rows[1] is Dictionary:
			_apply_info_row(stage_two_label, info_rows[1] as Dictionary, Vector2(262.0, 414.0), Color(1.0, 0.88, 0.44, 0.95), true)
		else:
			stage_two_label.visible = false
	_update_chrome()
	_update_badge(pulse)
	_update_wave_lines()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.98, 0.99, 1.0, 1.0))
	_ocean_glow = _ensure_rect("OceanGlow", Rect2(104.0, 92.0, 1072.0, 520.0), Color(0.22, 0.50, 0.92, 0.10))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(150.0, 72.0, 980.0, 88.0), Color(1.0, 1.0, 1.0, 0.98))
	_logo_panel = _ensure_rect("LogoPanel", Rect2(136.0, 90.0, 1008.0, 186.0), Color(1.0, 1.0, 1.0, 0.98))
	_logo_rule = _ensure_rect("LogoRule", Rect2(186.0, 180.0, 908.0, 10.0), Color(0.20, 0.48, 0.88, 0.22))
	_subtitle_chip = _ensure_rect("SubtitleChip", Rect2(446.0, 214.0, 388.0, 40.0), Color(0.90, 0.95, 1.0, 0.98))
	_title_plate = _ensure_rect("TitlePlate", Rect2(168.0, 308.0, 944.0, 184.0), Color(0.94, 0.97, 1.0, 0.98))
	_left_stage = _ensure_rect("LeftStage", Rect2(212.0, 340.0, 360.0, 108.0), Color(0.90, 0.95, 1.0, 0.98))
	_right_stage = _ensure_rect("RightStage", Rect2(706.0, 340.0, 360.0, 108.0), Color(0.90, 0.95, 1.0, 0.98))
	_mode_band = _ensure_rect("ModeBand", Rect2(250.0, 366.0, 780.0, 30.0), Color(0.94, 0.97, 1.0, 0.98))
	_mode_plate = _ensure_rect("ModePlate", Rect2(260.0, 430.0, 760.0, 70.0), Color(1.0, 0.92, 0.84, 0.98))
	_prompt_glow = _ensure_rect("PromptGlow", Rect2(118.0, 542.0, 1044.0, 130.0), Color(0.18, 0.46, 0.84, 0.12))
	_prompt_band = _ensure_rect("PromptBand", Rect2(118.0, 542.0, 1044.0, 130.0), Color(0.96, 0.98, 1.0, 0.99))
	_badge_ring = _ensure_rect("BadgeRing", Rect2(920.0, 320.0, 140.0, 140.0), Color(0.92, 0.40, 0.18, 0.20))
	_badge_core = _ensure_rect("BadgeCore", Rect2(955.0, 355.0, 70.0, 70.0), Color(1.0, 1.0, 1.0, 0.96))
	_badge_label = _ensure_label("BadgeLabel", Vector2(930.0, 372.0), Vector2(120.0, 32.0), 18)
	_badge_label.text = "START"
	_badge_label.modulate = Color(0.78, 0.30, 0.12, 0.95)
	if _wave_lines.size() == 0:
		for i in range(3):
			var line := _ensure_rect("WaveLine%d" % i, Rect2(186.0, 286.0 + float(i) * 10.0, 908.0, 4.0), Color(0.28, 0.56, 0.94, 0.10))
			_wave_lines.append(line)
	_backdrop.z_index = -10
	_ocean_glow.z_index = -9
	_header_plate.z_index = -8
	_logo_panel.z_index = -7
	_logo_rule.z_index = -6
	_subtitle_chip.z_index = -5
	_title_plate.z_index = -4
	_left_stage.z_index = -3
	_right_stage.z_index = -3
	_mode_band.z_index = -2
	_mode_plate.z_index = -2
	_prompt_glow.z_index = -2
	_prompt_band.z_index = -1
	_badge_ring.z_index = 0
	_badge_core.z_index = 1
	_badge_label.z_index = 2

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
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label

func _apply_info_row(label: Label, row: Dictionary, default_position: Vector2, default_color: Color, default_pulse: bool = false) -> void:
	label.text = str(row.get("text", ""))
	label.position = row.get("position", default_position)
	label.size = Vector2(760.0, 34.0)
	var color := Color(row.get("color", default_color))
	var pulse_enabled: bool = bool(row.get("pulse", default_pulse))
	if pulse_enabled:
		var min_alpha: float = float(row.get("pulse_min_alpha", 0.66))
		color.a = color.a if sin(_time * 4.0) > -0.1 else min_alpha
	label.modulate = color
	label.visible = not label.text.is_empty()

func _update_chrome() -> void:
	var chrome := CoreBridge.get_press_start_chrome_colors()
	var header_color := Color(chrome.get("header", Color(1.0, 1.0, 1.0, 0.98)))
	var panel_color := Color(chrome.get("panel", Color(0.90, 0.95, 1.0, 0.98)))
	var footer_color := Color(chrome.get("footer", Color(0.96, 0.98, 1.0, 0.99)))
	if _header_plate:
		_header_plate.color = header_color
	if _logo_panel:
		_logo_panel.color = header_color
	if _logo_rule:
		_logo_rule.color = Color(0.20, 0.48, 0.88, 0.22)
	if _subtitle_chip:
		_subtitle_chip.color = panel_color
	if _title_plate:
		_title_plate.color = panel_color
	if _left_stage:
		_left_stage.color = panel_color
	if _right_stage:
		_right_stage.color = panel_color
	if _mode_band:
		_mode_band.color = panel_color
	if _mode_plate:
		_mode_plate.color = Color(1.0, 0.92, 0.84, 0.98)
	if _prompt_glow:
		_prompt_glow.color = Color(0.18, 0.46, 0.84, 0.10 + absf(sin(_time * 1.8)) * 0.06)
	if _prompt_band:
		_prompt_band.color = footer_color
	if _ocean_glow:
		_ocean_glow.color = Color(0.22, 0.50, 0.92, 0.10)

func _update_badge(pulse: float) -> void:
	if _badge_ring:
		_badge_ring.color = Color(0.92, 0.40, 0.18, 0.12 + (pulse * 0.18))
	if _badge_core:
		_badge_core.color = Color(1.0, 1.0, 1.0, 0.96)
	if _badge_label:
		_badge_label.modulate = Color(0.78, 0.30, 0.12, 0.76 + (pulse * 0.24))

func _update_wave_lines() -> void:
	for i in range(_wave_lines.size()):
		var line := _wave_lines[i]
		if line == null:
			continue
		var phase := _time * 2.0 + float(i) * 0.6
		line.position.x = 186.0 + sin(phase) * 12.0
		line.size.x = 908.0 + cos(phase * 0.8) * 36.0
		line.color = Color(0.28, 0.56, 0.94, 0.08 + absf(sin(phase)) * 0.04)

func _set_screen_visible(screen_visible: bool) -> void:
	if _backdrop:
		_backdrop.visible = screen_visible
	if _ocean_glow:
		_ocean_glow.visible = screen_visible
	if _header_plate:
		_header_plate.visible = screen_visible
	if _logo_panel:
		_logo_panel.visible = screen_visible
	if _logo_rule:
		_logo_rule.visible = screen_visible
	if _subtitle_chip:
		_subtitle_chip.visible = screen_visible
	if _title_plate:
		_title_plate.visible = screen_visible
	if _left_stage:
		_left_stage.visible = screen_visible
	if _right_stage:
		_right_stage.visible = screen_visible
	if _mode_band:
		_mode_band.visible = screen_visible
	if _mode_plate:
		_mode_plate.visible = screen_visible
	if _prompt_glow:
		_prompt_glow.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	for line in _wave_lines:
		line.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if subtitle_label:
		subtitle_label.visible = screen_visible
	if stage_one_label:
		stage_one_label.visible = screen_visible
	if stage_two_label:
		stage_two_label.visible = screen_visible
