# Source-aligned entry/results surface for the migrated special-stage runner.
# The collectible field is represented by deterministic lane checkpoints.
extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _glow: ColorRect = null
var _panel: ColorRect = null
var _rule: ColorRect = null
var _ring_card: ColorRect = null
var _ring_label: Label = null
var _run_card: ColorRect = null
var _run_label: Label = null
var _pause_card: ColorRect = null
var _pause_label: Label = null
var _lane_cards: Array[ColorRect] = []
var _emerald_slots: Array[ColorRect] = []
var _emerald_labels: Array[Label] = []
var _time: float = 0.0

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_set_screen_visible(CoreBridge.is_special_stage_screen())

func _process(delta: float) -> void:
	var active := CoreBridge.is_special_stage_screen()
	_set_screen_visible(active)
	if not active:
		return
	_time += delta
	var pulse := 0.5 + sin(_time * 2.2) * 0.5
	if title_label:
		title_label.text = CoreBridge.get_special_stage_title_text()
		title_label.modulate = Color(0.96, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_special_stage_prompt_text()
		prompt_label.modulate = Color(1.0, 0.88, 0.40, 0.82 + pulse * 0.18)
	if detail_label:
		detail_label.text = CoreBridge.get_special_stage_detail_text()
		detail_label.modulate = Color(0.74, 0.88, 1.0, 0.88)
	if _rule:
		_rule.color = Color(0.24, 0.78, 0.94, 0.48 + pulse * 0.30)
	if _glow:
		_glow.color = Color(0.12, 0.42, 0.66, 0.14 + pulse * 0.08)
	_update_results()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.02, 0.06, 0.98))
	_glow = _ensure_rect("StageGlow", Rect2(112.0, 106.0, 1056.0, 510.0), Color(0.12, 0.42, 0.66, 0.18))
	_panel = _ensure_rect("StagePanel", Rect2(166.0, 144.0, 948.0, 430.0), Color(0.05, 0.11, 0.22, 0.97))
	_rule = _ensure_rect("StageRule", Rect2(246.0, 274.0, 788.0, 6.0), Color(0.24, 0.78, 0.94, 0.72))
	_ring_card = _ensure_rect("RingCard", Rect2(320.0, 342.0, 640.0, 106.0), Color(0.08, 0.17, 0.30, 0.98))
	_ring_label = _ensure_label("RingLabel", Vector2(342.0, 360.0), Vector2(596.0, 70.0), 24)
	_ring_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_run_card = _ensure_rect("RunCard", Rect2(284.0, 342.0, 712.0, 128.0), Color(0.08, 0.17, 0.30, 0.98))
	_run_label = _ensure_label("RunLabel", Vector2(310.0, 352.0), Vector2(660.0, 34.0), 18)
	_run_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_pause_card = _ensure_rect("PauseCard", Rect2(390.0, 300.0, 500.0, 160.0), Color(0.04, 0.06, 0.12, 0.98))
	_pause_label = _ensure_label("PauseLabel", Vector2(410.0, 338.0), Vector2(460.0, 84.0), 24)
	_pause_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_pause_label.text = CoreBridge.get_special_stage_pause_text()
	_backdrop.z_index = -5
	_glow.z_index = -4
	_panel.z_index = -3
	_rule.z_index = -2
	_ring_card.z_index = -1
	for i in range(7):
		var x := 278.0 + float(i) * 104.0
		var slot := _ensure_rect("EmeraldSlot%d" % i, Rect2(x, 492.0, 54.0, 26.0), Color(0.12, 0.20, 0.32, 0.98))
		var label := _ensure_label("EmeraldLabel%d" % i, Vector2(x, 516.0), Vector2(54.0, 18.0), 10)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_emerald_slots.append(slot)
		_emerald_labels.append(label)
	for i in range(3):
		var lane := _ensure_rect("Lane%d" % i, Rect2(370.0, 394.0 + float(i) * 22.0, 540.0, 14.0), Color(0.12, 0.24, 0.38, 0.98))
		_lane_cards.append(lane)

func _ensure_rect(node_name: String, rect: Rect2, color: Color) -> ColorRect:
	var node := get_node_or_null(node_name) as ColorRect
	if node == null:
		node = ColorRect.new()
		node.name = node_name
		add_child(node)
	node.position = rect.position
	node.size = rect.size
	node.color = color
	return node

func _ensure_label(node_name: String, pos: Vector2, size: Vector2, font_size: int) -> Label:
	var node := get_node_or_null(node_name) as Label
	if node == null:
		node = Label.new()
		node.name = node_name
		add_child(node)
	node.position = pos
	node.size = size
	node.add_theme_font_size_override("font_size", font_size)
	node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return node

func _update_results() -> void:
	var results := CoreBridge.is_special_stage_results_screen()
	var running := CoreBridge.is_special_stage_running_screen() and not results
	var paused := CoreBridge.is_special_stage_paused()
	_ring_card.visible = results
	_ring_label.visible = results
	_run_card.visible = running
	_run_label.visible = running
	_pause_card.visible = paused
	_pause_label.visible = paused
	if paused:
		_pause_label.text = CoreBridge.get_special_stage_pause_text()
	if running:
		var robo_state: Dictionary = CoreBridge.get_special_stage_guard_state()
		_run_label.text = CoreBridge.get_special_stage_run_display_text(CoreBridge.get_special_stage_motion_text(), int(float(robo_state.get("progress", 0.0)) * 100.0))
	var lane_index := CoreBridge.get_special_stage_lane()
	var robo_state: Dictionary = CoreBridge.get_special_stage_guard_state()
	var robo_near := running and bool(robo_state.get("near_player", false))
	for i in range(_lane_cards.size()):
		_lane_cards[i].visible = running
		_lane_cards[i].color = Color(0.92, 0.30, 0.24, 0.98) if robo_near and i == int(robo_state.get("lane", 1)) else (Color(0.28, 0.72, 0.94, 0.98) if i == lane_index else Color(0.12, 0.24, 0.38, 0.98))
	if results:
		_ring_label.text = CoreBridge.get_special_stage_result_display_text()
	for i in range(_emerald_slots.size()):
		var target := results and CoreBridge.is_special_stage_target_reached() and i == CoreBridge.get_special_stage_emerald_index()
		_emerald_slots[i].color = Color(0.26, 0.78, 0.50, 0.98) if target else Color(0.12, 0.20, 0.32, 0.98)
		_emerald_labels[i].text = CoreBridge.get_special_stage_new_label() if target else ""
		_emerald_labels[i].modulate = Color(0.76, 1.0, 0.82, 1.0) if target else Color(0.48, 0.58, 0.70, 0.92)

func _set_screen_visible(screen_visible: bool) -> void:
	for node in [_backdrop, _glow, _panel, _rule, _ring_card, _ring_label, _run_card, _run_label, _pause_card, _pause_label, title_label, prompt_label, detail_label]:
		if node:
			node.visible = screen_visible
	for node in _emerald_slots:
		node.visible = screen_visible
	for node in _emerald_labels:
		node.visible = screen_visible
	for node in _lane_cards:
		node.visible = screen_visible and node.visible
