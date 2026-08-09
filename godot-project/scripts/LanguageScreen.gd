# LanguageScreen.gd
# Presents an original-inspired dedicated language selection screen.
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
var _language_stage: ColorRect = null
var _summary_stage: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _language_card: ColorRect = null
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _summary_label: Label = null
var _badge_label: Label = null
var _row_cards: Array[ColorRect] = []
var _row_labels: Array[Label] = []
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
	_ensure_rows()
	_set_screen_visible(CoreBridge.is_language_screen())

func _process(_delta: float) -> void:
	var active: bool = CoreBridge.is_language_screen()
	_set_screen_visible(active)
	if not active:
		return
	if title_label:
		title_label.text = CoreBridge.get_language_title_text()
		title_label.position = Vector2(356.0, 76.0)
		title_label.size = Vector2(568.0, 52.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.14, 0.28, 0.42, 1.0)
	if prompt_label:
		prompt_label.visible = false
	if detail_label:
		detail_label.text = CoreBridge.get_language_detail_text()
		detail_label.position = Vector2(148.0, 636.0)
		detail_label.size = Vector2(984.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.16, 0.30, 0.46, 0.96)
	_update_chrome()
	_update_summary()
	_update_rows()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.98, 0.99, 1.0, 1.0))
	_hero_glow = ensure_rect("HeroGlow", Rect2(104.0, 96.0, 1072.0, 504.0), Color(0.24, 0.78, 0.96, 0.10))
	_header_plate = ensure_rect("HeaderPlate", Rect2(150.0, 68.0, 980.0, 82.0), Color(1.0, 1.0, 1.0, 0.98))
	_panel = ensure_rect("Panel", Rect2(118.0, 170.0, 1044.0, 400.0), Color(0.98, 1.0, 1.0, 0.99))
	_accent = ensure_rect("AccentBar", Rect2(118.0, 150.0, 1044.0, 10.0), Color(0.24, 0.80, 0.96, 0.96))
	_header_band = ensure_rect("HeaderBand", LIST_STAGE_RECT, Color(0.90, 0.97, 1.0, 0.98))
	_language_stage = ensure_rect("LanguageStage", LIST_STAGE_RECT, Color(0.90, 0.97, 1.0, 0.98))
	_summary_stage = ensure_rect("SummaryStage", Rect2(610.0, 214.0, 236.0, 258.0), Color(0.24, 0.80, 0.96, 0.94))
	_badge_ring = ensure_rect("BadgeRing", Rect2(892.0, 224.0, 220.0, 220.0), Color(0.24, 0.80, 0.96, 0.22))
	_badge_core = ensure_rect("BadgeCore", Rect2(954.0, 286.0, 96.0, 96.0), Color(1.0, 1.0, 1.0, 0.96))
	_language_card = ensure_rect("LanguageCard", Rect2(184.0, 236.0, 364.0, 214.0), Color(0.96, 0.99, 1.0, 0.98))
	_summary_card = ensure_rect("SummaryCard", Rect2(638.0, 236.0, 180.0, 214.0), Color(0.96, 0.99, 1.0, 0.98))
	_prompt_band = ensure_rect("PromptBand", FOOTER_RECT, Color(0.96, 0.99, 1.0, 0.99))
	_backdrop.z_index = -9
	_hero_glow.z_index = -8
	_header_plate.z_index = -7
	_panel.z_index = -6
	_accent.z_index = -5
	_header_band.z_index = -4
	_language_stage.z_index = -3
	_summary_stage.z_index = -3
	_badge_ring.z_index = -2
	_badge_core.z_index = -1
	_language_card.z_index = -1
	_summary_card.z_index = -1
	_prompt_band.z_index = -1

func _ensure_rows() -> void:
	if _summary_label == null:
		_summary_label = ensure_label("SummaryLabel", Vector2(280.0, 486.0), Vector2(720.0, 42.0), 18)
		_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if _row_labels.size() > 0:
		return
	for i in range(6):
		var top := 236.0 + float(i) * 40.0
		var card := ensure_rect("RowCard%d" % i, Rect2(LIST_ROW_X, top, LIST_ROW_WIDTH, 36.0), Color(0.88, 0.95, 1.0, 1.0))
		var row := ensure_label("RowLabel%d" % i, Vector2(LIST_LABEL_X, top - 1.0), Vector2(LIST_VALUE_WIDTH + 302.0, 36.0), 20)
		var status := ensure_label("StatusLabel%d" % i, Vector2.ZERO, Vector2.ZERO, 1)
		row.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(row)
		_status_labels.append(status)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.visible = false
	if _badge_label == null:
		_badge_label = ensure_label("BadgeLabel", Vector2(902.0, 316.0), Vector2(200.0, 34.0), 22)
	if _badge_label:
		_badge_label.visible = false

func _update_chrome() -> void:
	var colors := CoreBridge.get_language_chrome_colors()
	if _header_plate:
		_header_plate.color = Color(1.0, 1.0, 1.0, 0.98)
	if _hero_glow:
		var accent := Color(colors.get("accent", Color(0.24, 0.80, 0.96, 1.0)))
		_hero_glow.color = Color(accent.r, accent.g, accent.b, 0.10)
	if _accent:
		_accent.color = colors.get("accent", Color(0.24, 0.80, 0.96, 1.0))
	if _header_band:
		_header_band.color = Color(0.90, 0.97, 1.0, 0.98)
	if _language_stage:
		_language_stage.color = Color(0.90, 0.97, 1.0, 0.98)
	if _summary_stage:
		_summary_stage.visible = false
	if _badge_core:
		_badge_core.color = Color(1.0, 1.0, 1.0, 0.96)
	if _language_card:
		_language_card.color = Color(0.96, 0.99, 1.0, 0.98)
	if _summary_card:
		_summary_card.visible = false

func _update_rows() -> void:
	var rows: Array = CoreBridge.get_language_rows()
	for i in range(_row_labels.size()):
		var visible := i < rows.size()
		_row_cards[i].visible = visible
		_row_labels[i].visible = visible
		_status_labels[i].visible = false
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var is_selected := bool(row.get("selected", false))
		var top := 236.0 + float(i) * 40.0
		var lift := 0.0
		_row_cards[i].position.y = top + lift
		_row_cards[i].size = Vector2(LIST_ROW_WIDTH, 36.0)
		_row_labels[i].position.y = top - 1.0 + lift
		_status_labels[i].visible = false
		_row_cards[i].color = Color(0.24, 0.80, 0.96, 0.98) if is_selected else Color(0.88, 0.95, 1.0, 1.0)
		_row_labels[i].text = str(row.get("label", ""))
		_row_labels[i].modulate = Color(1.0, 1.0, 1.0, 1.0) if is_selected else Color(0.14, 0.28, 0.42, 1.0)

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
	if _language_stage:
		_language_stage.visible = screen_visible
	if _summary_stage:
		_summary_stage.visible = false
	if _badge_ring:
		_badge_ring.visible = false
	if _badge_core:
		_badge_core.visible = false
	if _language_card:
		_language_card.visible = false
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
	for card in _row_cards:
		card.visible = screen_visible
	for label in _row_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = false
