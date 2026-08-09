# SaveScreen.gd
# Presents the SA2-style top-level options overlay with a dedicated menu shell.
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
var _option_labels: Array[Label] = []
var _meta_labels: Array[Label] = []

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_option_labels()
	_set_screen_visible(CoreBridge.is_save_overlay_screen())

func _process(_delta: float) -> void:
	var save_mode: bool = CoreBridge.is_save_overlay_screen()
	_set_screen_visible(save_mode)
	if not save_mode:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 210.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_options_screen_title()
		title_label.position = Vector2(248.0, 116.0)
		title_label.size = Vector2(628.0, 56.0)
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_options_screen_subtitle()
		prompt_label.position = Vector2(180.0, 550.0)
		prompt_label.size = Vector2(920.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.52, 0.74 + (pulse * 0.24))
	if detail_label:
		detail_label.text = CoreBridge.get_save_detail_text()
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.80, 0.90, 1.0, 0.92)
	_update_option_labels()
	_update_summary()
	_update_chrome()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.03, 0.08, 0.68))
	_hero_glow = ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.12, 0.30, 0.54, 0.18))
	_header_plate = ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.07, 0.10, 0.18, 0.94))
	_panel = ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.05, 0.08, 0.16, 0.96))
	_accent = ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.23, 0.74, 0.95, 0.96))
	_header_band = ensure_rect("HeaderBand", Rect2(210.0, 246.0, 288.0, 238.0), Color(0.10, 0.18, 0.34, 0.92))
	_menu_stage = ensure_rect("MenuStage", Rect2(204.0, 246.0, 562.0, 238.0), Color(0.08, 0.12, 0.24, 0.94))
	_summary_stage = ensure_rect("SummaryStage", Rect2(792.0, 246.0, 280.0, 238.0), Color(0.10, 0.16, 0.28, 0.94))
	_badge_ring = ensure_rect("BadgeRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(0.92, 0.78, 0.24, 0.22))
	_badge_core = ensure_rect("BadgeCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.10, 0.18, 0.34, 0.96))
	_menu_card = ensure_rect("MenuCard", Rect2(220.0, 278.0, 530.0, 196.0), Color(0.08, 0.12, 0.24, 0.94))
	_summary_card = ensure_rect("SummaryCard", Rect2(818.0, 278.0, 228.0, 196.0), Color(0.10, 0.16, 0.28, 0.94))
	_prompt_band = ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.04, 0.08, 0.16, 0.92))
	_summary_label = ensure_label("SummaryLabel", Vector2(838.0, 304.0), Vector2(188.0, 148.0), 17)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_badge_label = ensure_label("BadgeLabel", Vector2(886.0, 160.0), Vector2(124.0, 38.0), 18)
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_menu_stage.z_index = -3
	_summary_stage.z_index = -3
	_badge_ring.z_index = -2
	_badge_core.z_index = -1
	_menu_card.z_index = -1
	_summary_card.z_index = -1
	_prompt_band.z_index = -1

func _ensure_option_labels() -> void:
	if _option_labels.size() > 0:
		return
	for i in range(8):
		var top := 292.0 + float(i) * 22.0
		var card := ensure_rect("RowCard%d" % i, Rect2(244.0, top, 482.0, 18.0), Color(0.10, 0.16, 0.29, 0.96))
		var option_label := ensure_label("OptionLabel%d" % i, Vector2(264.0, top - 3.0), Vector2(190.0, 22.0), 15)
		var meta_label := ensure_label("MetaLabel%d" % i, Vector2(460.0, top - 3.0), Vector2(238.0, 22.0), 12)
		option_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		meta_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_option_labels.append(option_label)
		_meta_labels.append(meta_label)

func _update_option_labels() -> void:
	var items: Array = CoreBridge.get_options_active_items()
	var selected_index: int = CoreBridge.get_save_menu_index()
	if CoreBridge.is_save_reset_pending():
		selected_index = 0
	for i in range(_option_labels.size()):
		var visible := i < items.size()
		_row_cards[i].visible = visible
		_option_labels[i].visible = visible
		_meta_labels[i].visible = visible
		if not visible:
			continue
		var top := 292.0 + float(i) * 22.0
		var selected := i == selected_index
		var lift := 0.0
		_row_cards[i].position.y = top + lift
		_option_labels[i].position.y = top - 3.0 + lift
		_meta_labels[i].position.y = top - 3.0 + lift
		var item_text := str(items[i])
		var item_visual := CoreBridge.get_options_item_visual(i)
		var meta_text := "%s   %s" % [CoreBridge.get_options_item_meta(i), CoreBridge.get_options_item_status(i)]
		_row_cards[i].color = _get_row_card_color(selected, item_visual)
		_option_labels[i].text = item_text
		_option_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0) if selected else Color(0.92, 0.96, 1.0, 0.94)
		_meta_labels[i].text = meta_text
		_meta_labels[i].modulate = _get_meta_color(item_visual)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_options_summary_text().replace("   ", "\n")
		_summary_label.modulate = Color(0.90, 0.96, 1.0, 0.98)
	if _badge_label:
		_badge_label.text = CoreBridge.get_options_badge_text()
		_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

func _update_chrome() -> void:
	var accent := Color(0.23, 0.74, 0.95, 0.96)
	var summary := Color(0.10, 0.16, 0.28, 0.94)
	if CoreBridge.is_save_reset_pending():
		accent = Color(0.94, 0.35, 0.22, 0.96)
		summary = Color(0.28, 0.10, 0.08, 0.94)
	elif CoreBridge.is_player_data_menu():
		accent = Color(0.22, 0.86, 0.58, 0.96)
		summary = Color(0.08, 0.18, 0.16, 0.94)
	if _accent:
		_accent.color = accent
	if _hero_glow:
		_hero_glow.color = Color(accent.r * 0.45, accent.g * 0.45, accent.b * 0.62, 0.18)
	if _header_plate:
		_header_plate.color = Color(accent.r * 0.20, accent.g * 0.22, accent.b * 0.30, 0.92)
	if _header_band:
		_header_band.color = Color(accent.r * 0.30, accent.g * 0.24, accent.b * 0.34, 0.92)
	if _menu_stage:
		_menu_stage.color = Color(accent.r * 0.18, accent.g * 0.22, accent.b * 0.32, 0.94)
	if _summary_stage:
		_summary_stage.color = summary
	if _badge_core:
		_badge_core.color = Color(accent.r * 0.30, accent.g * 0.24, accent.b * 0.34, 0.96)
	if _summary_card:
		_summary_card.color = summary

func _get_row_card_color(selected: bool, item_visual: String) -> Color:
	if CoreBridge.is_save_reset_pending():
		return Color(0.46, 0.18, 0.12, 0.98) if selected else Color(0.26, 0.12, 0.10, 0.96)
	if selected:
		return Color(0.20, 0.40, 0.66, 0.98)
	if item_visual == "erase":
		return Color(0.18, 0.10, 0.12, 0.96)
	return Color(0.10, 0.16, 0.29, 0.96)

func _get_meta_color(item_visual: String) -> Color:
	if CoreBridge.is_save_reset_pending():
		return Color(1.0, 0.84, 0.78, 0.96)
	if item_visual == "erase":
		return Color(0.98, 0.78, 0.78, 0.94)
	if item_visual == "profile":
		return Color(0.78, 0.96, 0.84, 0.96)
	return Color(0.80, 0.90, 1.0, 0.92)

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
	for label in _option_labels:
		label.visible = screen_visible
	for label in _meta_labels:
		label.visible = screen_visible
