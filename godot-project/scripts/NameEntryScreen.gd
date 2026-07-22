# NameEntryScreen.gd
# Presents a dedicated board-style profile name editor inspired by the original SA2 screen.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _accent: ColorRect = null
var _header_band: ColorRect = null
var _matrix_stage: ColorRect = null
var _preview_stage: ColorRect = null
var _matrix_card: ColorRect = null
var _preview_card: ColorRect = null
var _prompt_band: ColorRect = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _matrix_cursor: ColorRect = null
var _control_cursor: ColorRect = null
var _summary_label: Label = null
var _guide_label: Label = null
var _preview_title_label: Label = null
var _badge_label: Label = null
var _matrix_cells: Array[ColorRect] = []
var _matrix_labels: Array[Label] = []
var _control_cards: Array[ColorRect] = []
var _control_labels: Array[Label] = []
var _preview_slots: Array[ColorRect] = []
var _preview_labels: Array[Label] = []

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_matrix()
	_ensure_controls()
	_ensure_preview()
	_set_screen_visible(CoreBridge.is_name_entry_screen())

func _process(_delta: float) -> void:
	var active := CoreBridge.is_name_entry_screen()
	_set_screen_visible(active)
	if not active:
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 190.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_name_entry_title_text()
		title_label.position = Vector2(248.0, 116.0)
		title_label.size = Vector2(628.0, 56.0)
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_name_entry_prompt_text()
		prompt_label.position = Vector2(180.0, 550.0)
		prompt_label.size = Vector2(920.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.52, 0.74 + (pulse * 0.24))
	if detail_label:
		detail_label.text = CoreBridge.get_name_entry_detail_text()
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.80, 0.90, 1.0, 0.92)
	_update_chrome()
	_update_matrix()
	_update_controls()
	_update_summary()
	_update_preview()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.03, 0.04, 0.08, 0.68))
	_hero_glow = _ensure_rect("HeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.10, 0.28, 0.58, 0.18))
	_header_plate = _ensure_rect("HeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.08, 0.10, 0.16, 0.94))
	_panel = _ensure_rect("Panel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.06, 0.08, 0.14, 0.96))
	_accent = _ensure_rect("AccentBar", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.22, 0.78, 0.96, 1.0))
	_header_band = _ensure_rect("HeaderBand", Rect2(210.0, 246.0, 562.0, 238.0), Color(0.11, 0.18, 0.34, 0.92))
	_matrix_stage = _ensure_rect("MatrixStage", Rect2(204.0, 246.0, 562.0, 238.0), Color(0.07, 0.12, 0.22, 0.94))
	_preview_stage = _ensure_rect("PreviewStage", Rect2(792.0, 246.0, 280.0, 238.0), Color(0.08, 0.16, 0.30, 0.94))
	_badge_ring = _ensure_rect("BadgeRing", Rect2(878.0, 108.0, 140.0, 140.0), Color(0.92, 0.78, 0.24, 0.22))
	_badge_core = _ensure_rect("BadgeCore", Rect2(913.0, 143.0, 70.0, 70.0), Color(0.11, 0.18, 0.34, 0.96))
	_matrix_card = _ensure_rect("MatrixCard", Rect2(226.0, 278.0, 518.0, 196.0), Color(0.07, 0.12, 0.22, 0.94))
	_preview_card = _ensure_rect("PreviewCard", Rect2(818.0, 278.0, 228.0, 196.0), Color(0.08, 0.16, 0.30, 0.94))
	_prompt_band = _ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.04, 0.08, 0.16, 0.92))
	_matrix_cursor = _ensure_rect("MatrixCursor", Rect2(250.0, 294.0, 32.0, 22.0), Color(0.24, 0.50, 0.82, 0.28))
	_control_cursor = _ensure_rect("ControlCursor", Rect2(654.0, 294.0, 72.0, 22.0), Color(0.24, 0.50, 0.82, 0.28))
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_panel.z_index = -7
	_accent.z_index = -6
	_header_band.z_index = -5
	_matrix_stage.z_index = -4
	_preview_stage.z_index = -4
	_badge_ring.z_index = -3
	_badge_core.z_index = -2
	_matrix_card.z_index = -2
	_preview_card.z_index = -2
	_prompt_band.z_index = -1
	_matrix_cursor.z_index = 0
	_control_cursor.z_index = 0
	if _summary_label == null:
		_summary_label = _ensure_label("SummaryLabel", Vector2(836.0, 300.0), Vector2(192.0, 78.0), 16)
		_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	if _guide_label == null:
		_guide_label = _ensure_label("GuideLabel", Vector2(246.0, 294.0), Vector2(468.0, 18.0), 13)
		_guide_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if _preview_title_label == null:
		_preview_title_label = _ensure_label("PreviewTitleLabel", Vector2(836.0, 382.0), Vector2(190.0, 20.0), 14)
		_preview_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if _badge_label == null:
		_badge_label = _ensure_label("BadgeLabel", Vector2(886.0, 160.0), Vector2(124.0, 38.0), 18)

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

func _ensure_matrix() -> void:
	if _matrix_labels.size() > 0:
		return
	for row in range(CoreBridge.NAME_ENTRY_MATRIX_VISIBLE_ROWS):
		for col in range(CoreBridge.NAME_ENTRY_MATRIX_COLS):
			var x := 250.0 + float(col) * 36.0
			var y := 294.0 + float(row) * 25.0
			var cell := _ensure_rect("MatrixCell_%d_%d" % [row, col], Rect2(x, y, 32.0, 22.0), Color(0.10, 0.16, 0.29, 0.96))
			var label := _ensure_label("MatrixLabel_%d_%d" % [row, col], Vector2(x, y - 1.0), Vector2(32.0, 22.0), 13)
			_matrix_cells.append(cell)
			_matrix_labels.append(label)

func _ensure_controls() -> void:
	if _control_labels.size() > 0:
		return
	var labels := CoreBridge.get_name_entry_control_rows()
	for i in range(labels.size()):
		var y := 294.0 + float(i) * 25.0
		var card := _ensure_rect("ControlCard%d" % i, Rect2(650.0, y, 78.0, 22.0), Color(0.10, 0.16, 0.29, 0.96))
		var label := _ensure_label("ControlLabel%d" % i, Vector2(654.0, y - 1.0), Vector2(70.0, 22.0), 13)
		label.text = str(labels[i])
		_control_cards.append(card)
		_control_labels.append(label)

func _ensure_preview() -> void:
	if _preview_slots.size() > 0:
		return
	for i in range(6):
		var slot := _ensure_rect("PreviewSlot%d" % i, Rect2(824.0 + float(i) * 34.0, 414.0, 30.0, 48.0), Color(0.14, 0.22, 0.40, 0.98))
		var label := _ensure_label("PreviewLabel%d" % i, Vector2(826.0 + float(i) * 34.0, 418.0), Vector2(26.0, 38.0), 22)
		_preview_slots.append(slot)
		_preview_labels.append(label)

func _update_matrix() -> void:
	var rows := CoreBridge.get_name_entry_matrix_rows()
	var cursor_row := CoreBridge.get_name_entry_cursor_row()
	var cursor_col := CoreBridge.get_name_entry_cursor_col()
	for row in range(CoreBridge.NAME_ENTRY_MATRIX_VISIBLE_ROWS):
		for col in range(CoreBridge.NAME_ENTRY_MATRIX_COLS):
			var index := row * CoreBridge.NAME_ENTRY_MATRIX_COLS + col
			var text := ""
			if row < rows.size():
				var row_chars: Array = rows[row]
				if col < row_chars.size():
					text = str(row_chars[col])
			var is_selected := (not CoreBridge.is_name_entry_control_cursor()) and row == cursor_row and col == cursor_col
			_matrix_cells[index].color = Color(0.24, 0.44, 0.72, 0.96) if is_selected else Color(0.10, 0.16, 0.29, 0.96)
			_matrix_labels[index].text = text
			_matrix_labels[index].modulate = Color(1.0, 0.98, 0.84, 1.0) if is_selected else Color(0.90, 0.96, 1.0, 0.94)
			_matrix_cells[index].visible = not text.is_empty()
			_matrix_labels[index].visible = not text.is_empty()
	if _matrix_cursor:
		_matrix_cursor.visible = not CoreBridge.is_name_entry_control_cursor()
		_matrix_cursor.position = Vector2(250.0 + float(cursor_col) * 36.0, 294.0 + float(cursor_row) * 25.0)

func _update_controls() -> void:
	var control_selected := CoreBridge.is_name_entry_control_cursor()
	var control_index := maxi(0, CoreBridge.get_name_entry_cursor_row() - CoreBridge.NAME_ENTRY_CONTROL_ROW_BACK)
	for i in range(_control_labels.size()):
		var is_selected := control_selected and i == control_index
		_control_cards[i].color = Color(0.24, 0.44, 0.72, 0.96) if is_selected else Color(0.10, 0.16, 0.29, 0.96)
		_control_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0) if is_selected else Color(0.90, 0.96, 1.0, 0.94)
	if _control_cursor:
		_control_cursor.visible = control_selected
		_control_cursor.position = Vector2(650.0, 294.0 + float(control_index) * 25.0)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_name_entry_summary_text()
		_summary_label.modulate = Color(0.98, 0.98, 1.0, 0.98)
	if _guide_label:
		_guide_label.text = "CHARACTER BOARD   Q/E MOVE SLOT"
		_guide_label.modulate = Color(0.74, 0.86, 1.0, 0.92)
	if _preview_title_label:
		_preview_title_label.text = "LIVE NAME PREVIEW"
		_preview_title_label.modulate = Color(0.74, 0.88, 1.0, 0.96)
	if _badge_label:
		_badge_label.text = "NAME"
		_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

func _update_chrome() -> void:
	var chrome := CoreBridge.get_name_entry_chrome_colors()
	var accent := Color(chrome.get("accent", Color(0.22, 0.78, 0.96, 1.0)))
	var card := Color(chrome.get("card", Color(0.86, 0.94, 1.0, 0.98)))
	if _header_plate:
		_header_plate.color = Color(accent.r * 0.18, accent.g * 0.22, accent.b * 0.30, 0.92)
	if _accent:
		_accent.color = accent
	if _hero_glow:
		_hero_glow.color = Color(accent.r * 0.42, accent.g * 0.42, accent.b * 0.62, 0.18)
	if _header_band:
		_header_band.color = Color(accent.r * 0.30, accent.g * 0.24, accent.b * 0.34, 0.92)
	if _matrix_stage:
		_matrix_stage.color = Color(accent.r * 0.16, accent.g * 0.20, accent.b * 0.28, 0.94)
	if _preview_stage:
		_preview_stage.color = Color(card.r * 0.24, card.g * 0.28, card.b * 0.34, 0.94)
	if _badge_core:
		_badge_core.color = Color(accent.r * 0.30, accent.g * 0.24, accent.b * 0.34, 0.96)
	if _preview_card:
		_preview_card.color = Color(card.r * 0.26, card.g * 0.30, card.b * 0.36, 0.94)
	if _matrix_card:
		_matrix_card.color = Color(accent.r * 0.12, accent.g * 0.16, accent.b * 0.22, 0.94)
	if _matrix_cursor:
		_matrix_cursor.color = Color(accent.r, accent.g, accent.b, 0.28)
	if _control_cursor:
		_control_cursor.color = Color(accent.r, accent.g, accent.b, 0.28)

func _update_preview() -> void:
	var name_text := CoreBridge.get_profile_name_text()
	for i in range(_preview_labels.size()):
		var char_text := name_text.substr(i, 1) if i < name_text.length() else " "
		var is_selected := i == CoreBridge.get_name_entry_active_slot_index()
		_preview_labels[i].text = char_text
		_preview_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0) if is_selected else Color(0.98, 0.98, 1.0, 1.0)
		if i < _preview_slots.size():
			_preview_slots[i].color = Color(0.26, 0.44, 0.72, 1.0) if is_selected else Color(0.14, 0.22, 0.40, 0.98)

func _set_screen_visible(screen_visible: bool) -> void:
	for node in [
		_backdrop, _hero_glow, _header_plate, _panel, _accent, _header_band,
		_matrix_stage, _preview_stage, _matrix_card, _preview_card, _prompt_band,
		_badge_ring, _badge_core, _summary_label, _guide_label, _preview_title_label,
		_badge_label, _matrix_cursor, _control_cursor, title_label, prompt_label, detail_label
	]:
		if node:
			node.visible = screen_visible
	for card in _matrix_cells:
		card.visible = screen_visible and card.visible
	for label in _matrix_labels:
		label.visible = screen_visible and label.visible
	for card in _control_cards:
		card.visible = screen_visible
	for label in _control_labels:
		label.visible = screen_visible
	for slot in _preview_slots:
		slot.visible = screen_visible
	for label in _preview_labels:
		label.visible = screen_visible
