extends SimpleListMenuScreen

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
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _summary_label: Label = null
var _badge_label: Label = null
var _menu_cards: Array[ColorRect] = []
var _menu_labels: Array[Label] = []
var _meta_labels: Array[Label] = []
var _status_labels: Array[Label] = []

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_menu_rows()
	_set_screen_visible(false)

func _process(_delta: float) -> void:
	var screen_visible := CoreBridge.is_single_player_menu_screen()
	_set_screen_visible(screen_visible)
	if not screen_visible:
		return

	if title_label:
		title_label.text = CoreBridge.get_single_player_title_text()
		title_label.position = Vector2(326.0, 76.0)
		title_label.size = Vector2(628.0, 52.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.12, 0.22, 0.44, 1.0)
	if prompt_label:
		prompt_label.visible = false
	if detail_label:
		detail_label.text = CoreBridge.get_single_player_detail_text()
		detail_label.position = Vector2(148.0, 636.0)
		detail_label.size = Vector2(984.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.16, 0.28, 0.48, 0.96)
	_update_chrome()
	_update_menu_rows()
	_update_summary()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.98, 0.99, 1.0, 1.0))
	_hero_glow = ensure_rect("SinglePlayerHeroGlow", Rect2(104.0, 96.0, 1072.0, 504.0), Color(0.26, 0.54, 0.94, 0.10))
	_header_plate = ensure_rect("SinglePlayerHeaderPlate", Rect2(150.0, 68.0, 980.0, 82.0), Color(1.0, 1.0, 1.0, 0.98))
	_panel = ensure_rect("SinglePlayerPanel", Rect2(118.0, 170.0, 1044.0, 400.0), Color(0.98, 0.99, 1.0, 0.99))
	_accent = ensure_rect("SinglePlayerAccent", Rect2(118.0, 150.0, 1044.0, 10.0), Color(0.18, 0.54, 0.94, 0.96))
	_header_band = ensure_rect("SinglePlayerHeaderBand", LIST_STAGE_RECT, Color(0.90, 0.95, 1.0, 0.98))
	_menu_stage = ensure_rect("SinglePlayerMenuStage", LIST_STAGE_RECT, Color(0.90, 0.95, 1.0, 0.98))
	_summary_stage = ensure_rect("SinglePlayerSummaryStage", Rect2(610.0, 214.0, 236.0, 258.0), Color(0.20, 0.54, 0.96, 0.94))
	_badge_ring = ensure_rect("SinglePlayerBadgeRing", Rect2(890.0, 224.0, 224.0, 224.0), Color(0.22, 0.58, 0.98, 0.24))
	_badge_core = ensure_rect("SinglePlayerBadgeCore", Rect2(952.0, 286.0, 100.0, 100.0), Color(1.0, 1.0, 1.0, 0.96))
	_summary_card = ensure_rect("SinglePlayerSummary", Rect2(638.0, 236.0, 180.0, 214.0), Color(0.96, 0.98, 1.0, 0.98))
	_prompt_band = ensure_rect("SinglePlayerPromptBand", FOOTER_RECT, Color(0.96, 0.98, 1.0, 0.99))
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
	_summary_card.z_index = -1
	_prompt_band.z_index = -1

func _ensure_menu_rows() -> void:
	if _menu_cards.size() > 0:
		return
	for i in range(4):
		var top := 236.0 + float(i) * 48.0
		var card := ensure_rect("SinglePlayerCard%d" % i, Rect2(LIST_ROW_X, top, LIST_ROW_WIDTH, 42.0), Color(0.88, 0.93, 1.0, 1.0))
		var title := ensure_label("SinglePlayerOption%d" % i, Vector2(LIST_LABEL_X, top + 1.0), Vector2(276.0, 40.0), 20)
		var meta := ensure_label("SinglePlayerMeta%d" % i, Vector2(LIST_VALUE_X, top + 1.0), Vector2(LIST_VALUE_WIDTH, 40.0), 14)
		var status := ensure_label("SinglePlayerStatus%d" % i, Vector2.ZERO, Vector2.ZERO, 1)
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_menu_cards.append(card)
		_menu_labels.append(title)
		_meta_labels.append(meta)
		_status_labels.append(status)

func _update_chrome() -> void:
	var chrome := CoreBridge.get_single_player_chrome_colors()
	if _hero_glow:
		var header_color := Color(chrome.get("header", Color(0.09, 0.16, 0.31, 0.95)))
		_hero_glow.color = Color(header_color.r, header_color.g, header_color.b, 0.10)
	if _header_plate:
		_header_plate.color = Color(1.0, 1.0, 1.0, 0.98)
	if _panel:
		_panel.color = Color(0.98, 0.99, 1.0, 0.99)
	if _header_band:
		_header_band.color = Color(0.90, 0.95, 1.0, 0.98)
	if _accent:
		_accent.color = Color(chrome.get("header", _accent.color))
	if _menu_stage:
		_menu_stage.color = Color(0.90, 0.95, 1.0, 0.98)
	if _summary_stage:
		_summary_stage.visible = false
	if _badge_ring:
		_badge_ring.visible = false
	if _badge_core:
		_badge_core.visible = false
	if _summary_card:
		_summary_card.visible = false
	if _prompt_band:
		_prompt_band.color = Color(0.96, 0.98, 1.0, 0.99)
	if _badge_label == null:
		_badge_label = ensure_label("SinglePlayerBadgeLabel", Vector2(896.0, 316.0), Vector2(212.0, 34.0), 24)
	if _badge_label:
		_badge_label.visible = false

func _update_summary() -> void:
	if _summary_label == null:
		_summary_label = ensure_label("SinglePlayerSummaryLabel", Vector2(280.0, 446.0), Vector2(720.0, 82.0), 17)
		_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_summary_label.modulate = Color(0.14, 0.22, 0.38, 0.98)
	if _summary_label:
		_summary_label.text = CoreBridge.get_single_player_summary_text()
		_summary_label.visible = true

func _update_menu_rows() -> void:
	var rows: Array = CoreBridge.get_single_player_rows()
	for i in range(_menu_cards.size()):
		var visible := i < rows.size()
		_menu_cards[i].visible = visible
		_menu_labels[i].visible = visible
		_meta_labels[i].visible = visible
		_status_labels[i].visible = false
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var selected := bool(row.get("selected", false))
		var top := 236.0 + float(i) * 48.0
		var lift := 0.0
		_menu_cards[i].position.y = top + lift
		_menu_cards[i].size = Vector2(LIST_ROW_WIDTH, 42.0)
		_menu_labels[i].position.y = top + 1.0 + lift
		_meta_labels[i].position.y = top + 1.0 + lift
		_status_labels[i].visible = false
		_menu_cards[i].color = Color(0.18, 0.46, 0.86, 0.98) if selected else Color(0.88, 0.93, 1.0, 1.0)
		_menu_labels[i].text = str(row.get("name", ""))
		_menu_labels[i].modulate = Color(1.0, 1.0, 1.0, 1.0) if selected else Color(0.12, 0.22, 0.44, 1.0)
		_meta_labels[i].text = str(row.get("description", ""))
		_meta_labels[i].modulate = Color(0.96, 0.98, 1.0, 0.96) if selected else Color(0.28, 0.40, 0.60, 0.96)

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
		_summary_stage.visible = false
	if _badge_ring:
		_badge_ring.visible = false
	if _badge_core:
		_badge_core.visible = false
	if _summary_card:
		_summary_card.visible = false
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _badge_label:
		_badge_label.visible = false
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	for card in _menu_cards:
		card.visible = screen_visible
	for label in _menu_labels:
		label.visible = screen_visible
	for label in _meta_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = false
