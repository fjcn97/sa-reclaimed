extends ScreenBase

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _accent: ColorRect = null
var _summary_card: ColorRect = null
var _prompt_band: ColorRect = null
var _emerald_nodes: Array[ColorRect] = []
var _emerald_labels: Array[Label] = []
var _summary_label: Label = null
var _pulse_time: float = 0.0

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_emeralds()
	_set_screen_visible(CoreBridge.is_chaos_emeralds_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_chaos_emeralds_screen()
	_set_screen_visible(active)
	if not active:
		return
	_pulse_time += delta * 1.8
	var pulse := 0.5 + sin(_pulse_time) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_chaos_emeralds_title_text()
		title_label.position = Vector2(184.0, 124.0)
		title_label.size = Vector2(912.0, 52.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_chaos_emeralds_prompt_text()
		prompt_label.position = Vector2(180.0, 548.0)
		prompt_label.size = Vector2(920.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.54, 0.74 + pulse * 0.18)
	if detail_label:
		detail_label.text = CoreBridge.get_chaos_emeralds_detail_text()
		detail_label.position = Vector2(164.0, 642.0)
		detail_label.size = Vector2(952.0, 56.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.86, 0.92, 1.0, 0.96)
	_update_emeralds()
	_update_summary()
	_update_chrome()

func _ensure_chrome() -> void:
	_backdrop = ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.02, 0.05, 0.82))
	_hero_glow = ensure_rect("HeroGlow", Rect2(144.0, 104.0, 992.0, 188.0), Color(0.24, 0.42, 0.62, 0.18))
	_header_plate = ensure_rect("HeaderPlate", Rect2(176.0, 118.0, 928.0, 92.0), Color(0.08, 0.14, 0.24, 0.96))
	_panel = ensure_rect("Panel", Rect2(190.0, 232.0, 900.0, 286.0), Color(0.08, 0.12, 0.22, 0.96))
	_accent = ensure_rect("AccentBar", Rect2(190.0, 216.0, 900.0, 10.0), Color(0.24, 0.80, 0.92, 1.0))
	_summary_card = ensure_rect("SummaryCard", Rect2(794.0, 278.0, 254.0, 194.0), Color(0.10, 0.18, 0.24, 0.98))
	_prompt_band = ensure_rect("PromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.05, 0.08, 0.14, 0.92))
	_summary_label = ensure_label("SummaryLabel", Vector2(820.0, 304.0), Vector2(202.0, 140.0), 16)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_backdrop.z_index = -8
	_hero_glow.z_index = -7
	_header_plate.z_index = -6
	_accent.z_index = -5
	_panel.z_index = -4
	_summary_card.z_index = -3
	_prompt_band.z_index = -2

func _ensure_emeralds() -> void:
	if _emerald_nodes.size() > 0:
		return
	for i in range(7):
		var col := i % 4
		var row := i / 4
		var left := 254.0 + float(col) * 118.0
		var top := 290.0 + float(row) * 104.0
		var badge := ensure_rect("Emerald%d" % i, Rect2(left, top, 82.0, 82.0), Color(0.18, 0.28, 0.38, 0.96))
		var label := ensure_label("EmeraldLabel%d" % i, Vector2(left, top + 88.0), Vector2(82.0, 18.0), 11)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_emerald_nodes.append(badge)
		_emerald_labels.append(label)

func _update_emeralds() -> void:
	var rows: Array = CoreBridge.get_chaos_emeralds_rows()
	var colors := [
		Color(0.24, 0.84, 0.42, 0.98),
		Color(0.98, 0.84, 0.24, 0.98),
		Color(0.26, 0.54, 0.98, 0.98),
		Color(0.94, 0.28, 0.26, 0.98),
		Color(0.72, 0.34, 0.94, 0.98),
		Color(0.28, 0.88, 0.96, 0.98),
		Color(0.94, 0.96, 1.0, 0.98),
	]
	for i in range(_emerald_nodes.size()):
		var visible := i < rows.size()
		_emerald_nodes[i].visible = visible
		_emerald_labels[i].visible = visible
		if not visible:
			continue
		_emerald_nodes[i].color = colors[min(i, colors.size() - 1)]
		_emerald_labels[i].text = str(rows[i].get("label", ""))
		_emerald_labels[i].modulate = Color(0.90, 0.96, 1.0, 0.96)

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_chaos_emeralds_summary_text()
		_summary_label.modulate = Color(0.90, 0.96, 1.0, 0.96)

func _update_chrome() -> void:
	if _hero_glow:
		_hero_glow.color = Color(0.16, 0.38 + absf(sin(_pulse_time * 0.8)) * 0.08, 0.58, 0.20)

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
	if _summary_card:
		_summary_card.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if title_label:
		title_label.visible = screen_visible
	if prompt_label:
		prompt_label.visible = screen_visible
	if detail_label:
		detail_label.visible = screen_visible
	for badge in _emerald_nodes:
		badge.visible = screen_visible
	for label in _emerald_labels:
		label.visible = screen_visible
