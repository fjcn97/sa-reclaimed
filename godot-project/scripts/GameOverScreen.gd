extends ScreenBase

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _header_band: ColorRect = null
var _accent: ColorRect = null
var _left_stage: ColorRect = null
var _right_stage: ColorRect = null
var _message_card: ColorRect = null
var _prompt_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _badge_label: Label = null
var _over_label: Label = null
var _status_label: Label = null
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
	_ensure_labels()
	_set_screen_visible(false)

func _process(_delta: float) -> void:
	if _bridge == null:
		_bridge = resolve_state_bridge()
		if _bridge == null:
			_set_screen_visible(false)
			return
	var screen_visible: bool = _bridge.is_game_over_screen()
	_set_screen_visible(screen_visible)
	if not screen_visible:
		return
	var slide_offset: float = _bridge.get_game_over_slide_offset()
	var flash_alpha: float = _bridge.get_game_over_text_flash_alpha()
	if title_label:
		title_label.text = _bridge.get_game_over_primary_word()
		title_label.position = Vector2(258.0 + slide_offset, 220.0)
		title_label.size = Vector2(324.0, 54.0)
		title_label.modulate = Color(1.0, 0.92, 0.82, flash_alpha)
	if prompt_label:
		prompt_label.text = _bridge.get_game_over_secondary_word()
		prompt_label.position = Vector2(636.0 + slide_offset, 220.0)
		prompt_label.size = Vector2(384.0, 54.0)
		prompt_label.modulate = Color(1.0, 0.52, 0.24, flash_alpha)
	if _over_label:
		_over_label.text = _bridge.get_game_over_prompt_text()
		_over_label.position = Vector2(256.0, 382.0)
		_over_label.modulate = Color(0.98, 0.96, 0.90, 1.0 if _bridge.is_game_over_input_ready() else 0.72)
	if _status_label:
		_status_label.text = _bridge.get_game_over_status_text()
		_status_label.position = Vector2(256.0, 426.0)
		_status_label.modulate = Color(1.0, 0.74, 0.34, 0.96)
	if detail_label:
		detail_label.text = _bridge.get_game_over_detail_text()
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.94, 0.92, 0.88, 0.96)
	_update_chrome()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.04, 0.00, 0.00, 0.82))
	_hero_glow = ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.46, 0.12, 0.10, 0.18))
	_header_plate = ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.12, 0.04, 0.04, 0.94))
	_header_band = ensure_rect("HeaderBand", Rect2(214.0, 246.0, 332.0, 244.0), Color(0.14, 0.05, 0.05, 0.94))
	_panel = ensure_rect("OverPanel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.12, 0.03, 0.03, 0.96))
	_accent = ensure_rect("OverAccent", Rect2(176.0, 180.0, 928.0, 10.0), Color(1.0, 0.46, 0.18, 0.80))
	_left_stage = ensure_rect("LeftStage", Rect2(204.0, 246.0, 346.0, 244.0), Color(0.16, 0.08, 0.07, 0.94))
	_right_stage = ensure_rect("RightStage", Rect2(576.0, 246.0, 498.0, 244.0), Color(0.18, 0.08, 0.07, 0.94))
	_message_card = ensure_rect("MessageCard", Rect2(238.0, 360.0, 278.0, 96.0), Color(0.18, 0.08, 0.07, 0.94))
	_prompt_band = ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.10, 0.06, 0.05, 0.92))
	_badge_ring = ensure_rect("BadgeRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(1.0, 0.74, 0.34, 0.18))
	_badge_core = ensure_rect("BadgeCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.26, 0.10, 0.08, 0.96))
	_badge_label = ensure_label("BadgeLabel", Vector2(900.0, 162.0), Vector2(96.0, 32.0), 18)
	_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_header_band.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_left_stage.z_index = -4
	_right_stage.z_index = -4
	_message_card.z_index = -3
	_prompt_band.z_index = -2
	_badge_ring.z_index = -1
	_badge_core.z_index = 0

func _ensure_labels() -> void:
	_over_label = ensure_label("OverPromptLabel", Vector2(256.0, 382.0), Vector2(242.0, 34.0), 22)
	_status_label = ensure_label("OverStatusLabel", Vector2(256.0, 426.0), Vector2(242.0, 28.0), 14)
	_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _update_chrome() -> void:
	var time_over: bool = _bridge != null and _bridge.is_game_over_time_over()
	if _panel:
		_panel.color = Color(0.10, 0.06, 0.02, 0.96) if time_over else Color(0.12, 0.03, 0.03, 0.96)
	if _hero_glow:
		_hero_glow.color = Color(0.52, 0.42, 0.12, 0.18) if time_over else Color(0.46, 0.12, 0.10, 0.18)
	if _header_plate:
		_header_plate.color = Color(0.20, 0.14, 0.06, 0.92) if time_over else Color(0.14, 0.05, 0.05, 0.92)
	if _header_band:
		_header_band.color = Color(0.20, 0.14, 0.06, 0.94) if time_over else Color(0.14, 0.05, 0.05, 0.94)
	if _accent:
		_accent.color = Color(0.94, 0.74, 0.24, 0.88) if time_over else Color(1.0, 0.46, 0.18, 0.80)
	if _left_stage:
		_left_stage.color = Color(0.20, 0.14, 0.06, 0.92) if time_over else Color(0.16, 0.08, 0.07, 0.94)
	if _right_stage:
		_right_stage.color = Color(0.16, 0.12, 0.06, 0.92) if time_over else Color(0.18, 0.08, 0.07, 0.94)
	if _message_card:
		_message_card.color = Color(0.20, 0.14, 0.06, 0.94) if time_over else Color(0.18, 0.08, 0.07, 0.94)
	if _prompt_band:
		_prompt_band.color = Color(0.12, 0.10, 0.06, 0.92) if time_over else Color(0.10, 0.06, 0.05, 0.92)
	if _badge_ring:
		_badge_ring.color = Color(1.0, 0.82, 0.38, 0.22) if time_over else Color(1.0, 0.74, 0.34, 0.18)
	if _badge_core:
		_badge_core.color = Color(0.28, 0.20, 0.08, 0.96) if time_over else Color(0.26, 0.10, 0.08, 0.96)
	if _badge_label:
		_badge_label.text = _bridge.get_game_over_badge_text() if _bridge else ""
		_badge_label.modulate = Color(1.0, 0.95, 0.76, 0.96)

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
	if _left_stage:
		_left_stage.visible = screen_visible
	if _right_stage:
		_right_stage.visible = screen_visible
	if _message_card:
		_message_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	if _over_label:
		_over_label.visible = screen_visible
	if _status_label:
		_status_label.visible = screen_visible and not _status_label.text.is_empty()
