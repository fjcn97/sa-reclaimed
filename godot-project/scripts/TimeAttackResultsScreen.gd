extends ScreenBase

# Mirrors time_attack_results.c as a separate result task rather than mixing
# its medal and record presentation into the regular stage-clear screen.
var _backdrop: ColorRect
var _panel: ColorRect
var _accent: ColorRect
var _time_card: ColorRect
var _medal_card: ColorRect
var _title: Label
var _stage: Label
var _time: Label
var _medal: Label
var _record: Label
var _prompt: Label

func _ready() -> void:
	layer = 97
	_build_screen()
	_set_visible(false)

func _process(_delta: float) -> void:
	var active := CoreBridge.is_time_attack_clear_screen()
	_set_visible(active)
	if not active:
		return
	var progress := CoreBridge.get_time_attack_results_progress()
	var eased := 1.0 - pow(1.0 - progress, 3.0)
	var slide := (1.0 - eased) * 180.0
	_title.position = Vector2(220.0 + slide, 108.0)
	_stage.position = Vector2(220.0 + slide, 178.0)
	_time.position = Vector2(220.0 + slide, 274.0)
	_medal.position = Vector2(694.0 - slide, 264.0)
	_record.position = Vector2(694.0 - slide, 420.0)
	_prompt.position = Vector2(220.0, 586.0)
	_title.text = CoreBridge.get_time_attack_results_title_text()
	_stage.text = CoreBridge.get_clear_stage_label()
	_time.text = CoreBridge.get_time_attack_results_time_text()
	_medal.text = CoreBridge.get_time_attack_results_medal_text()
	_record.text = CoreBridge.get_time_attack_results_record_text()
	_prompt.text = CoreBridge.get_time_attack_results_prompt_text()
	var alpha := 0.40 + eased * 0.60
	_title.modulate.a = alpha
	_stage.modulate.a = alpha
	_time.modulate.a = alpha
	_medal.modulate.a = alpha
	_record.modulate.a = alpha
	_prompt.modulate.a = alpha
	_accent.size.x = 760.0 * eased
	_time_card.modulate.a = alpha
	_medal_card.modulate.a = alpha

func _build_screen() -> void:
	_backdrop = _rect("Backdrop", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.01, 0.03, 0.08, 0.90), -10)
	_panel = _rect("Panel", Rect2(150.0, 86.0, 980.0, 544.0), Color(0.05, 0.12, 0.22, 0.98), -9)
	_accent = _rect("Accent", Rect2(260.0, 214.0, 760.0, 8.0), Color(0.48, 0.82, 1.0, 1.0), -8)
	_time_card = _rect("TimeCard", Rect2(220.0, 250.0, 424.0, 216.0), Color(0.08, 0.20, 0.34, 0.98), -7)
	_medal_card = _rect("MedalCard", Rect2(694.0, 250.0, 366.0, 216.0), Color(0.16, 0.22, 0.34, 0.98), -7)
	_title = _label("Title", Vector2(220.0, 108.0), Vector2(840.0, 52.0), 38, HORIZONTAL_ALIGNMENT_CENTER)
	_stage = _label("Stage", Vector2(220.0, 178.0), Vector2(840.0, 32.0), 20, HORIZONTAL_ALIGNMENT_CENTER)
	_time = _label("Time", Vector2(220.0, 274.0), Vector2(424.0, 116.0), 58, HORIZONTAL_ALIGNMENT_CENTER)
	_medal = _label("Medal", Vector2(694.0, 264.0), Vector2(366.0, 86.0), 42, HORIZONTAL_ALIGNMENT_CENTER)
	_record = _label("Record", Vector2(694.0, 420.0), Vector2(366.0, 30.0), 16, HORIZONTAL_ALIGNMENT_CENTER)
	_prompt = _label("Prompt", Vector2(220.0, 586.0), Vector2(840.0, 32.0), 18, HORIZONTAL_ALIGNMENT_CENTER)
	_title.modulate = Color(0.94, 0.98, 1.0, 1.0)
	_stage.modulate = Color(0.62, 0.84, 1.0, 1.0)
	_time.modulate = Color(0.96, 0.98, 1.0, 1.0)
	_medal.modulate = Color(1.0, 0.86, 0.34, 1.0)
	_record.modulate = Color(0.74, 0.90, 1.0, 1.0)
	_prompt.modulate = Color(0.86, 0.94, 1.0, 1.0)

func _rect(node_name: String, rect: Rect2, color: Color, z: int) -> ColorRect:
	var node := ColorRect.new()
	node.name = node_name
	node.position = rect.position
	node.size = rect.size
	node.color = color
	node.z_index = z
	add_child(node)
	return node

func _label(node_name: String, pos: Vector2, size: Vector2, font_size: int, alignment: HorizontalAlignment) -> Label:
	var node := Label.new()
	node.name = node_name
	node.position = pos
	node.size = size
	node.horizontal_alignment = alignment
	node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	node.add_theme_font_size_override("font_size", font_size)
	node.z_index = -6
	add_child(node)
	return node

func _set_visible(value: bool) -> void:
	visible = value
