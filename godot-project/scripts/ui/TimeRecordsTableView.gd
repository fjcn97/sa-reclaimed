extends RefCounted
class_name TimeRecordsTableView

var summary_label: Label = null
var character_label: Label = null
var heading_label: Label = null
var subtitle_label: Label = null
var badge_label: Label = null
var character_caption: Label = null
var character_card: ColorRect = null
var character_glow: ColorRect = null
var character_nameplate: ColorRect = null
var row_cards: Array[ColorRect] = []
var row_labels: Array[Label] = []
var time_labels: Array[Label] = []

func setup(screen: Object) -> void:

	if summary_label == null:
		summary_label = screen.call("ensure_label", "SummaryLabel", Vector2(228.0, 282.0), Vector2(224.0, 82.0), 15) as Label
		summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if character_label == null:
		character_label = screen.call("ensure_label", "CharacterLabel", Vector2(228.0, 434.0), Vector2(224.0, 28.0), 20) as Label
		character_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if heading_label == null:
		heading_label = screen.call("ensure_label", "HeadingLabel", Vector2(556.0, 278.0), Vector2(462.0, 28.0), 22) as Label
	if subtitle_label == null:
		subtitle_label = screen.call("ensure_label", "SubtitleLabel", Vector2(556.0, 308.0), Vector2(462.0, 22.0), 14) as Label
	if character_caption == null:
		character_caption = screen.call("ensure_label", "CharacterCaption", Vector2(244.0, 320.0), Vector2(204.0, 42.0), 24) as Label
		character_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if row_labels.size() == 0:
		for i in range(5):
			var top := 346.0 + float(i) * 30.0
			var card := screen.call("ensure_rect", "RowCard%d" % i, Rect2(548.0, top, 494.0, 24.0), Color(0.10, 0.16, 0.29, 0.96)) as ColorRect
			var row := screen.call("ensure_label", "RowLabel%d" % i, Vector2(572.0, top - 1.0), Vector2(176.0, 26.0), 16) as Label
			var time := screen.call("ensure_label", "TimeLabel%d" % i, Vector2(766.0, top - 1.0), Vector2(248.0, 26.0), 16) as Label
			row.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			time.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			row_cards.append(card)
			row_labels.append(row)
			time_labels.append(time)
	if badge_label == null:
		badge_label = screen.call("ensure_label", "BadgeLabel", Vector2(888.0, 160.0), Vector2(106.0, 40.0), 18) as Label
		badge_label.text = CoreBridge.get_menu_badge_text("RECORD")
		badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

func update() -> void:
	var time_attack_context := CoreBridge.is_time_attack_level_select_screen()
	if summary_label:
		summary_label.text = CoreBridge.get_time_records_summary_text().replace("\n", "\n\n") if time_attack_context else CoreBridge.get_time_records_summary_text().replace("\n", "   ")
		summary_label.modulate = Color(0.90, 0.96, 1.0, 0.98)
	if character_label:
		character_label.text = CoreBridge.get_time_records_character_text()
		character_label.modulate = Color(0.78, 0.88, 1.0, 1.0)
	if heading_label:
		heading_label.text = CoreBridge.get_time_records_course_heading_text()
		heading_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if subtitle_label:
		subtitle_label.text = CoreBridge.get_time_records_course_subtitle_text()
		subtitle_label.modulate = Color(0.72, 0.84, 1.0, 0.96)
	if character_caption:
		character_caption.text = CoreBridge.get_time_records_character_text()
		character_caption.modulate = Color(1.0, 0.97, 0.84, 0.98) if time_attack_context else Color(0.80, 0.90, 1.0, 0.0)
	if badge_label:
		badge_label.text = CoreBridge.get_menu_badge_text("TA" if time_attack_context else "RECORD")
		badge_label.modulate = Color(1.0, 0.95, 0.74, 0.95)

	var rows: Array = CoreBridge.get_time_record_rows()
	var mode_choice_view := rows.size() == 2
	if character_label:
		character_label.visible = not mode_choice_view and not time_attack_context
	if summary_label:
		summary_label.position = Vector2(228.0, 420.0) if time_attack_context else Vector2(228.0, 282.0)
		summary_label.size = Vector2(224.0, 72.0) if time_attack_context else Vector2(224.0, 82.0)
		summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if time_attack_context else HORIZONTAL_ALIGNMENT_LEFT
	if heading_label:
		heading_label.position = Vector2(556.0, 270.0) if time_attack_context else Vector2(556.0, 278.0)
	if subtitle_label:
		subtitle_label.position = Vector2(556.0, 304.0) if time_attack_context else Vector2(556.0, 308.0)
	for node in [character_card, character_glow, character_nameplate, character_caption]:
		if node:
			node.visible = time_attack_context
	for i in range(row_labels.size()):
		var visible := i < rows.size()
		row_cards[i].visible = visible
		row_labels[i].visible = visible
		time_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var top := (354.0 + float(i) * 46.0) if mode_choice_view else (344.0 + float(i) * 42.0 if time_attack_context else 346.0 + float(i) * 30.0)
		row_cards[i].position.y = top
		row_labels[i].position.y = top - 1.0
		time_labels[i].position.y = top - 1.0
		row_cards[i].size.y = 34.0 if time_attack_context and not mode_choice_view else 24.0
		var is_selected := bool(row.get("selected", false))
		var is_record_row := bool(row.get("recorded", false))
		row_labels[i].text = CoreBridge.get_time_records_best_label_text(i) if time_attack_context and not mode_choice_view else str(row.get("name", ""))
		time_labels[i].text = str(row.get("time", ""))
		row_labels[i].size.x = 188.0 if time_attack_context and not mode_choice_view else 176.0
		time_labels[i].size.x = 216.0 if time_attack_context and not mode_choice_view else 248.0
		if is_selected:
			row_cards[i].color = Color(0.22, 0.38, 0.62, 0.98)
			row_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0)
			time_labels[i].modulate = Color(0.96, 0.88, 0.52, 1.0)
		elif is_record_row:
			row_cards[i].color = Color(0.28, 0.20, 0.08, 0.96)
			row_labels[i].modulate = Color(0.98, 0.88, 0.64, 1.0)
			time_labels[i].modulate = Color(0.98, 0.82, 0.48, 1.0)
		else:
			row_cards[i].color = Color(0.10, 0.16, 0.29, 0.96)
			row_labels[i].modulate = Color(0.88, 0.94, 1.0, 0.94)
			time_labels[i].modulate = Color(0.72, 0.84, 1.0, 0.96)

func set_visible(screen_visible: bool) -> void:
	for node in [summary_label, character_label, heading_label, subtitle_label, badge_label, character_caption, character_card, character_glow, character_nameplate]:
		if node:
			node.visible = screen_visible
	for node in row_cards + row_labels + time_labels:
		node.visible = screen_visible
