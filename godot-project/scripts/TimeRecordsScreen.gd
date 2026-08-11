# TimeRecordsScreen.gd
# Presents an original-inspired dedicated time records screen.
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
var _header_card: ColorRect = null
var _prompt_band: ColorRect = null
var _character_card: ColorRect = null
var _character_glow: ColorRect = null
var _character_nameplate: ColorRect = null
var _records_view := TimeRecordsTableView.new()
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
	_records_view.setup(self)
	_records_view.character_card = _character_card
	_records_view.character_glow = _character_glow
	_records_view.character_nameplate = _character_nameplate
	_set_screen_visible(_bridge != null and _bridge.is_time_records_screen())

func _process(_delta: float) -> void:
	if _bridge == null:
		_bridge = resolve_state_bridge()
	var active: bool = _bridge != null and _bridge.is_time_records_screen()
	_set_screen_visible(active)
	if not active:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 210.0) * 0.5)
	if title_label:
		title_label.text = _bridge.get_time_records_title_text()
		title_label.position = Vector2(254.0, 116.0)
		title_label.size = Vector2(612.0, 56.0)
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = _bridge.get_time_records_prompt_text()
		prompt_label.position = Vector2(176.0, 552.0)
		prompt_label.size = Vector2(928.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.52, 0.74 + (pulse * 0.26))
	if detail_label:
		detail_label.text = "%s   |   %s" % [_bridge.get_time_records_summary_text().replace("\n", "   "), _bridge.get_time_records_detail_text()]
		detail_label.position = Vector2(170.0, 668.0)
		detail_label.size = Vector2(940.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.80, 0.90, 1.0, 0.92)
	_update_chrome()
	_records_view.update(_bridge.get_time_records_view_state())

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.03, 0.04, 0.08, 0.68))
	_hero_glow = ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.16, 0.28, 0.62, 0.18))
	_header_plate = ensure_rect("HeaderPlate", Rect2(146.0, 96.0, 988.0, 124.0), Color(0.08, 0.10, 0.18, 0.94))
	_panel = ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.08, 0.08, 0.14, 0.96))
	_accent = ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.26, 0.52, 0.96, 1.0))
	_header_band = ensure_rect("HeaderBand", Rect2(210.0, 246.0, 288.0, 238.0), Color(0.12, 0.18, 0.34, 0.92))
	_badge_ring = ensure_rect("BadgeRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(0.92, 0.78, 0.24, 0.22))
	_badge_core = ensure_rect("BadgeCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.12, 0.18, 0.34, 0.96))
	_records_stage = ensure_rect("RecordsStage", Rect2(522.0, 246.0, 550.0, 238.0), Color(0.08, 0.12, 0.22, 0.94))
	_header_card = ensure_rect("HeaderCard", Rect2(204.0, 246.0, 292.0, 238.0), Color(0.08, 0.12, 0.22, 0.94))
	_character_card = ensure_rect("CharacterCard", Rect2(224.0, 300.0, 244.0, 102.0), Color(0.08, 0.12, 0.22, 0.94))
	_character_glow = ensure_rect("CharacterGlow", Rect2(236.0, 312.0, 220.0, 52.0), Color(0.26, 0.52, 0.96, 0.18))
	_character_nameplate = ensure_rect("CharacterNameplate", Rect2(236.0, 372.0, 220.0, 24.0), Color(0.12, 0.18, 0.34, 0.94))
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
	_header_card.z_index = -2
	_character_card.z_index = -1
	_character_glow.z_index = 0
	_character_nameplate.z_index = 1
	_prompt_band.z_index = -1

func _update_chrome() -> void:
	var colors: Dictionary = _bridge.get_time_records_chrome_colors()
	var time_attack_context: bool = _bridge.is_time_attack_level_select_screen()
	if _accent:
		_accent.color = colors.get("accent", Color(0.26, 0.52, 0.96, 1.0))
	if _hero_glow:
		var accent := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_hero_glow.color = Color(accent.r * 0.45, accent.g * 0.45, accent.b * 0.62, 0.18)
	if _header_plate:
		var panel_color := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_header_plate.color = Color(panel_color.r * 0.24, panel_color.g * 0.26, panel_color.b * 0.34, 0.92)
	if _header_band:
		var header := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_header_band.color = Color(header.r * 0.28, header.g * 0.24, header.b * 0.34, 0.92)
	if _badge_core:
		var badge := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_badge_core.color = Color(badge.r * 0.28, badge.g * 0.24, badge.b * 0.34, 0.96)
	if _header_card:
		_header_card.color = colors.get("stage", Color(0.08, 0.12, 0.22, 0.94))
	if _records_stage:
		_records_stage.color = colors.get("stage", Color(0.08, 0.12, 0.22, 0.94))
	if _character_card:
		_character_card.color = colors.get("stage", Color(0.08, 0.12, 0.22, 0.94))
	if _character_glow:
		var accent := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_character_glow.color = Color(accent.r * 0.56, accent.g * 0.48, accent.b * 0.30, 0.26) if time_attack_context else Color(accent.r * 0.45, accent.g * 0.45, accent.b * 0.62, 0.18)
	if _character_nameplate:
		var accent := Color(colors.get("accent", Color(0.26, 0.52, 0.96, 1.0)))
		_character_nameplate.color = Color(accent.r * 0.38, accent.g * 0.28, accent.b * 0.20, 0.92) if time_attack_context else Color(accent.r * 0.28, accent.g * 0.24, accent.b * 0.34, 0.92)
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
	if _header_card:
		_header_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _character_card:
		_character_card.visible = screen_visible
	if _character_glow:
		_character_glow.visible = screen_visible
	if _character_nameplate:
		_character_nameplate.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	_records_view.set_visible(screen_visible)
