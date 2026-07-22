extends CanvasLayer

@export var title_label: Label = null
@export var prompt_label: Label = null
@export var detail_label: Label = null

var _backdrop: ColorRect = null
var _hero_glow: ColorRect = null
var _header_plate: ColorRect = null
var _panel: ColorRect = null
var _header_band: ColorRect = null
var _header_glow: ColorRect = null
var _left_stage: ColorRect = null
var _right_stage: ColorRect = null
var _prompt_band: ColorRect = null
var _launch_fade: ColorRect = null
var _map_card: ColorRect = null
var _map_frame: ColorRect = null
var _summary_card: ColorRect = null
var _summary_label: Label = null
var _zone_chip: ColorRect = null
var _act_chip: ColorRect = null
var _type_chip: ColorRect = null
var _banner_plate: ColorRect = null
var _banner_shadow: ColorRect = null
var _banner_trim: ColorRect = null
var _zone_label: Label = null
var _act_label: Label = null
var _type_label: Label = null
var _banner_label: Label = null
var _badge_ring: ColorRect = null
var _badge_core: ColorRect = null
var _badge_label: Label = null
var _avatar_marker: ColorRect = null
var _marker_glow: ColorRect = null
var _map_nodes: Array[ColorRect] = []
var _map_node_labels: Array[Label] = []
var _map_links: Array[ColorRect] = []
var _emerald_badges: Array[ColorRect] = []
var _emerald_labels: Array[Label] = []
var _row_cards: Array[ColorRect] = []
var _row_labels: Array[Label] = []
var _value_labels: Array[Label] = []
var _status_labels: Array[Label] = []
var _marker_visual_pos: Vector2 = Vector2.ZERO
var _marker_target_pos: Vector2 = Vector2.ZERO
var _marker_from_pos: Vector2 = Vector2.ZERO
var _selected_map_index: int = -1
var _map_pulse_time: float = 0.0
var _map_ready: bool = false
var _banner_slide_x: float = 0.0
var _banner_target_text: String = ""
var _banner_display_text: String = ""

func _ready() -> void:
	set_process(true)
	if title_label == null:
		title_label = get_node_or_null("TitleLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if detail_label == null:
		detail_label = get_node_or_null("DetailLabel")
	_ensure_chrome()
	_ensure_map_graphics()
	_ensure_emerald_badges()
	_ensure_rows()
	_set_screen_visible(false)

func _process(delta: float) -> void:
	_map_pulse_time += delta
	var screen_visible := CoreBridge.is_course_select_screen()
	_set_screen_visible(screen_visible)
	if not screen_visible:
		_map_ready = false
		return
	var pulse := 0.5 + (sin(Time.get_ticks_msec() / 220.0) * 0.5)
	if title_label:
		title_label.text = CoreBridge.get_course_select_title()
		title_label.position = Vector2(248.0, 116.0)
		title_label.size = Vector2(620.0, 56.0)
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title_label.modulate = Color(0.98, 0.98, 1.0, 1.0)
	if prompt_label:
		prompt_label.text = CoreBridge.get_course_select_prompt()
		prompt_label.position = Vector2(184.0, 548.0)
		prompt_label.size = Vector2(912.0, 34.0)
		prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		prompt_label.modulate = Color(1.0, 0.90, 0.52, 0.72 + (pulse * 0.26))
	if detail_label:
		detail_label.text = CoreBridge.get_course_select_detail()
		detail_label.position = Vector2(164.0, 664.0)
		detail_label.size = Vector2(952.0, 34.0)
		detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		detail_label.modulate = Color(0.72, 0.86, 1.0, 0.92)
	_update_chrome()
	_update_summary()
	_update_map()
	_update_emerald_badges()
	_update_rows()

func _ensure_chrome() -> void:
	_backdrop = _ensure_rect("BackdropShade", Rect2(0.0, 0.0, 1280.0, 720.0), Color(0.02, 0.05, 0.10, 0.74))
	_hero_glow = _ensure_rect("CourseHeroGlow", Rect2(144.0, 92.0, 992.0, 176.0), Color(0.10, 0.32, 0.60, 0.18))
	_header_plate = _ensure_rect("CourseHeaderPlate", Rect2(148.0, 96.0, 984.0, 124.0), Color(0.08, 0.10, 0.18, 0.94))
	_panel = _ensure_rect("CoursePanel", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.04, 0.09, 0.19, 0.96))
	_header_band = _ensure_rect("CourseHeaderBand", Rect2(212.0, 246.0, 318.0, 256.0), Color(0.08, 0.15, 0.30, 0.92))
	_header_glow = _ensure_rect("CourseHeaderGlow", Rect2(176.0, 180.0, 928.0, 10.0), Color(0.30, 0.56, 0.88, 0.72))
	_left_stage = _ensure_rect("CourseLeftStage", Rect2(204.0, 246.0, 340.0, 256.0), Color(0.08, 0.12, 0.24, 0.94))
	_right_stage = _ensure_rect("CourseRightStage", Rect2(576.0, 246.0, 498.0, 256.0), Color(0.10, 0.16, 0.28, 0.94))
	_prompt_band = _ensure_rect("CoursePromptBand", Rect2(176.0, 532.0, 928.0, 98.0), Color(0.04, 0.08, 0.16, 0.92))
	_launch_fade = _ensure_rect("LaunchFade", Rect2(176.0, 120.0, 928.0, 468.0), Color(0.92, 0.97, 1.0, 0.0))
	_map_card = _ensure_rect("CourseMapCard", Rect2(224.0, 276.0, 234.0, 188.0), Color(0.07, 0.13, 0.24, 0.97))
	_map_frame = _ensure_rect("CourseMapFrame", Rect2(238.0, 290.0, 206.0, 160.0), Color(0.10, 0.18, 0.32, 0.96))
	_summary_card = _ensure_rect("CourseSummaryCard", Rect2(218.0, 470.0, 314.0, 44.0), Color(0.07, 0.13, 0.23, 0.95))
	_summary_label = _ensure_label("CourseSummaryLabel", Vector2(238.0, 474.0), Vector2(274.0, 34.0), 13)
	_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_zone_chip = _ensure_rect("ZoneChip", Rect2(600.0, 252.0, 108.0, 30.0), Color(0.10, 0.20, 0.36, 0.96))
	_act_chip = _ensure_rect("ActChip", Rect2(718.0, 252.0, 108.0, 30.0), Color(0.10, 0.20, 0.36, 0.96))
	_type_chip = _ensure_rect("TypeChip", Rect2(836.0, 252.0, 194.0, 30.0), Color(0.18, 0.28, 0.18, 0.96))
	_banner_shadow = _ensure_rect("BannerShadow", Rect2(612.0, 300.0, 370.0, 46.0), Color(0.02, 0.04, 0.08, 0.72))
	_banner_plate = _ensure_rect("BannerPlate", Rect2(600.0, 288.0, 370.0, 46.0), Color(0.18, 0.36, 0.66, 0.96))
	_banner_trim = _ensure_rect("BannerTrim", Rect2(614.0, 294.0, 342.0, 6.0), Color(0.76, 0.90, 1.0, 0.30))
	_zone_label = _ensure_label("ZoneChipLabel", Vector2(600.0, 252.0), Vector2(108.0, 30.0), 14)
	_act_label = _ensure_label("ActChipLabel", Vector2(718.0, 252.0), Vector2(108.0, 30.0), 14)
	_type_label = _ensure_label("TypeChipLabel", Vector2(836.0, 252.0), Vector2(194.0, 30.0), 14)
	_banner_label = _ensure_label("BannerLabel", Vector2(626.0, 292.0), Vector2(318.0, 36.0), 24)
	_badge_ring = _ensure_rect("CourseBadgeRing", Rect2(880.0, 108.0, 140.0, 140.0), Color(0.22, 0.48, 0.84, 0.22))
	_badge_core = _ensure_rect("CourseBadgeCore", Rect2(915.0, 143.0, 70.0, 70.0), Color(0.10, 0.18, 0.33, 0.96))
	_badge_label = _ensure_label("CourseBadgeLabel", Vector2(886.0, 160.0), Vector2(128.0, 36.0), 18)
	_zone_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_act_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_backdrop.z_index = -10
	_hero_glow.z_index = -9
	_header_plate.z_index = -8
	_panel.z_index = -7
	_header_band.z_index = -6
	_header_glow.z_index = -5
	_left_stage.z_index = -5
	_right_stage.z_index = -5
	_prompt_band.z_index = -5
	_launch_fade.z_index = 3
	_map_card.z_index = -4
	_map_frame.z_index = -3
	_summary_card.z_index = -3
	_zone_chip.z_index = -2
	_act_chip.z_index = -2
	_type_chip.z_index = -2
	_banner_shadow.z_index = -2
	_banner_plate.z_index = -1
	_banner_trim.z_index = 0
	_badge_ring.z_index = -1
	_badge_core.z_index = 0

func _ensure_map_graphics() -> void:
	if _avatar_marker != null:
		return
	_marker_glow = _ensure_rect("CourseMarkerGlow", Rect2(0.0, 0.0, 28.0, 28.0), Color(1.0, 0.90, 0.34, 0.24))
	_marker_glow.z_index = 1
	_avatar_marker = _ensure_rect("CourseAvatarMarker", Rect2(0.0, 0.0, 16.0, 16.0), Color(1.0, 0.88, 0.32, 1.0))
	_avatar_marker.z_index = 2
	for i in range(16):
		var link := _ensure_rect("CourseMapLink%d" % i, Rect2(0.0, 0.0, 8.0, 8.0), Color(0.16, 0.28, 0.44, 0.86))
		link.z_index = 0
		_map_links.append(link)
		var node := _ensure_rect("CourseMapNode%d" % i, Rect2(0.0, 0.0, 22.0, 22.0), Color(0.20, 0.28, 0.38, 0.96))
		node.z_index = 1
		var label := _ensure_label("CourseMapNodeLabel%d" % i, Vector2.ZERO, Vector2(54.0, 16.0), 11)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_map_nodes.append(node)
		_map_node_labels.append(label)

func _ensure_emerald_badges() -> void:
	if _emerald_badges.size() > 0:
		return
	for i in range(7):
		var badge := _ensure_rect("EmeraldBadge%d" % i, Rect2(218.0 + float(i) * 38.0, 514.0, 28.0, 28.0), Color(0.18, 0.28, 0.40, 0.92))
		var label := _ensure_label("EmeraldLabel%d" % i, Vector2(218.0 + float(i) * 38.0, 514.0), Vector2(28.0, 28.0), 10)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_emerald_badges.append(badge)
		_emerald_labels.append(label)

func _ensure_rows() -> void:
	if _row_cards.size() > 0:
		return
	for i in range(4):
		var top := 350.0 + float(i) * 34.0
		var card := _ensure_rect("CourseRowCard%d" % i, Rect2(620.0, top, 410.0, 28.0), Color(0.08, 0.14, 0.26, 0.96))
		var name_label := _ensure_label("CourseRowLabel%d" % i, Vector2(638.0, top - 1.0), Vector2(156.0, 16.0), 16)
		var value_label := _ensure_label("CourseValueLabel%d" % i, Vector2(638.0, top + 13.0), Vector2(178.0, 14.0), 10)
		var status_label := _ensure_label("CourseStatusLabel%d" % i, Vector2(850.0, top + 5.0), Vector2(158.0, 16.0), 11)
		status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_row_cards.append(card)
		_row_labels.append(name_label)
		_value_labels.append(value_label)
		_status_labels.append(status_label)

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
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label

func _update_summary() -> void:
	if _summary_label:
		_summary_label.text = CoreBridge.get_course_select_summary_text()
		_summary_label.modulate = Color(0.88, 0.94, 1.0, 0.96)
	if _zone_label:
		_zone_label.text = CoreBridge.get_course_select_zone_label()
		_zone_label.modulate = Color(0.94, 0.97, 1.0, 0.98)
	if _act_label:
		_act_label.text = CoreBridge.get_course_select_act_label()
		_act_label.modulate = Color(0.94, 0.97, 1.0, 0.98)
	if _type_label:
		_type_label.text = CoreBridge.get_course_select_type_label()
		_type_label.modulate = Color(0.96, 0.98, 0.90, 0.98)
	if _badge_label:
		_badge_label.text = "ST"
		_badge_label.modulate = Color(1.0, 0.95, 0.74, 0.98)
	_update_banner()
	_update_launch_fade()

func _update_banner() -> void:
	var selected_text := CoreBridge.get_course_select_banner_text()
	if _banner_target_text != selected_text:
		_banner_target_text = selected_text
		if _banner_display_text.is_empty():
			_banner_display_text = selected_text
	if CoreBridge.is_course_select_traveling():
		_banner_slide_x = maxf(-442.0, _banner_slide_x - get_process_delta_time() * 940.0)
		if _banner_slide_x <= -220.0 and _banner_display_text != _banner_target_text:
			_banner_display_text = _banner_target_text
	else:
		if _banner_display_text != _banner_target_text:
			_banner_display_text = _banner_target_text
		_banner_slide_x = minf(0.0, _banner_slide_x + get_process_delta_time() * 880.0)
		if CoreBridge.is_course_select_settling():
			_banner_slide_x = lerpf(18.0, 0.0, CoreBridge.get_course_select_settle_progress())
	if _banner_plate:
		_banner_plate.position = Vector2(600.0 + _banner_slide_x, 288.0)
		_banner_plate.color = Color(0.24, 0.44, 0.74, 0.98) if CoreBridge.is_course_select_settling() else Color(0.18, 0.36, 0.66, 0.96)
	if _banner_shadow:
		_banner_shadow.position = Vector2(612.0 + _banner_slide_x, 300.0)
	if _banner_trim:
		_banner_trim.position = Vector2(614.0 + _banner_slide_x, 294.0)
	if _banner_label:
		_banner_label.position = Vector2(626.0 + _banner_slide_x, 292.0)
		_banner_label.text = _banner_display_text
		_banner_label.modulate = Color(1.0, 0.98, 0.90, 1.0) if CoreBridge.is_course_select_settling() else Color(0.98, 0.98, 1.0, 1.0)

func _update_launch_fade() -> void:
	if _launch_fade == null:
		return
	if CoreBridge.is_course_select_starting():
		var progress := CoreBridge.get_course_select_start_progress()
		_launch_fade.color = Color(0.94, 0.98, 1.0, progress * 0.90)
	else:
		_launch_fade.color = Color(0.94, 0.98, 1.0, 0.0)

func _update_map() -> void:
	var nodes: Array = CoreBridge.get_course_select_map_nodes()
	var marker_pulse := 0.5 + 0.5 * sin(_map_pulse_time * 6.0)
	var course_positions: Dictionary = {}
	for node_data in nodes:
		course_positions[int(node_data.get("index", -1))] = Vector2(node_data.get("position", Vector2.ZERO))
	for i in range(_map_links.size()):
		_map_links[i].visible = i < nodes.size() - 1
		if not _map_links[i].visible:
			continue
		var from_node: Dictionary = nodes[i]
		var to_node: Dictionary = nodes[i + 1]
		var from_pos: Vector2 = Vector2(from_node.get("position", Vector2.ZERO))
		var to_pos: Vector2 = Vector2(to_node.get("position", Vector2.ZERO))
		var delta: Vector2 = to_pos - from_pos
		var width: float = max(absf(delta.x), 8.0)
		var height: float = max(absf(delta.y), 8.0)
		_map_links[i].position = Vector2(254.0 + minf(from_pos.x, to_pos.x), 310.0 + minf(from_pos.y, to_pos.y))
		_map_links[i].size = Vector2(width, height)
		var active_path := bool(from_node.get("unlocked", false)) and bool(to_node.get("unlocked", false))
		_map_links[i].color = Color(0.30, 0.64, 0.94, 0.92) if active_path else Color(0.18, 0.34, 0.54, 0.56)
	for i in range(_map_nodes.size()):
		var visible := i < nodes.size()
		_map_nodes[i].visible = visible
		_map_node_labels[i].visible = visible
		if not visible:
			continue
		var node: Dictionary = nodes[i]
		var pos: Vector2 = Vector2(node.get("position", Vector2.ZERO))
		var selected := bool(node.get("selected", false))
		var unlocked := bool(node.get("unlocked", false))
		var cleared := bool(node.get("cleared", false))
		var bob := sin(_map_pulse_time * 2.4 + float(i) * 0.8) * 2.0
		_map_nodes[i].position = Vector2(244.0 + pos.x, 298.0 + pos.y + bob)
		_map_node_labels[i].position = Vector2(231.0 + pos.x, 320.0 + pos.y + bob)
		_map_node_labels[i].size = Vector2(44.0, 14.0)
		_map_nodes[i].size = Vector2(26.0, 26.0) if selected else Vector2(22.0, 22.0)
		_map_nodes[i].color = Color(1.0, 0.84, 0.28, 0.84 + marker_pulse * 0.16) if selected else (Color(0.30, 0.76, 0.48, 0.98) if cleared else (Color(0.30, 0.54, 0.90, 0.96) if unlocked else Color(0.22, 0.26, 0.32, 0.92)))
		_map_node_labels[i].text = str(int(node.get("index", 0)) + 1)
		_map_node_labels[i].modulate = Color(1.0, 0.96, 0.84, 1.0) if selected else Color(0.96, 0.98, 1.0, 1.0)
		if selected:
			_marker_target_pos = Vector2(250.0 + pos.x + 3.0, 276.0 + pos.y + bob)
			if _selected_map_index != i:
				_selected_map_index = i
				if not _map_ready:
					_marker_visual_pos = _marker_target_pos
					_marker_from_pos = _marker_target_pos
					_map_ready = true
	if _avatar_marker and nodes.size() > 0:
		if CoreBridge.is_course_select_traveling():
			var from_index := CoreBridge.get_course_select_travel_from_index()
			var to_index := CoreBridge.get_course_select_travel_to_index()
			if course_positions.has(from_index):
				var from_pos: Vector2 = course_positions[from_index]
				_marker_from_pos = Vector2(250.0 + from_pos.x + 3.0, 276.0 + from_pos.y)
			if course_positions.has(to_index):
				var to_pos: Vector2 = course_positions[to_index]
				_marker_target_pos = Vector2(250.0 + to_pos.x + 3.0, 276.0 + to_pos.y)
			var travel_progress := ease(CoreBridge.get_course_select_travel_progress(), -2.0)
			_marker_visual_pos = _marker_from_pos.lerp(_marker_target_pos, travel_progress)
		else:
			var marker_speed := clampf(get_process_delta_time() * 8.0, 0.0, 1.0)
			_marker_visual_pos = _marker_visual_pos.lerp(_marker_target_pos, marker_speed)
			_marker_from_pos = _marker_visual_pos
		_avatar_marker.position = _marker_visual_pos
		if _marker_glow:
			_marker_glow.position = _marker_visual_pos - Vector2(6.0, 6.0)
			_marker_glow.size = Vector2(28.0, 28.0)
			_marker_glow.color = Color(1.0, 0.90, 0.34, 0.20 + marker_pulse * 0.12)
		var settle_bonus := 0.0
		if CoreBridge.is_course_select_settling():
			settle_bonus = 4.0 * (1.0 - CoreBridge.get_course_select_settle_progress())
		_avatar_marker.size = Vector2(16.0 + sin(_map_pulse_time * 6.0) * 2.0 + settle_bonus, 16.0 + sin(_map_pulse_time * 6.0) * 2.0 + settle_bonus)
		_avatar_marker.color = Color(1.0, 0.94, 0.46, 1.0) if CoreBridge.is_course_select_settling() else Color(1.0, 0.88, 0.32, 0.90 + marker_pulse * 0.10)
		_avatar_marker.visible = true
		if _marker_glow:
			_marker_glow.visible = true
	elif _avatar_marker:
		_avatar_marker.visible = false
		if _marker_glow:
			_marker_glow.visible = false

func _update_emerald_badges() -> void:
	var rows: Array = CoreBridge.get_course_select_emerald_rows()
	for i in range(_emerald_badges.size()):
		var visible := i < rows.size()
		_emerald_badges[i].visible = visible
		_emerald_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[i]
		var active := bool(row.get("active", false))
		_emerald_badges[i].color = Color(0.28, 0.80, 0.88, 0.96) if active else Color(0.18, 0.28, 0.40, 0.92)
		_emerald_labels[i].text = str(row.get("label", ""))
		_emerald_labels[i].modulate = Color(0.04, 0.08, 0.14, 1.0) if active else Color(0.84, 0.90, 0.98, 0.94)

func _update_rows() -> void:
	var rows: Array = CoreBridge.get_course_select_rows()
	var row_start := clampi(CoreBridge.get_selected_level_index() - 1, 0, maxi(rows.size() - _row_cards.size(), 0))
	for i in range(_row_cards.size()):
		var row_index := row_start + i
		var visible := row_index < rows.size()
		_row_cards[i].visible = visible
		_row_labels[i].visible = visible
		_value_labels[i].visible = visible
		_status_labels[i].visible = visible
		if not visible:
			continue
		var row: Dictionary = rows[row_index]
		var selected := bool(row.get("selected", false))
		var top := 350.0 + float(i) * 34.0
		var lift := -3.0 if selected else 0.0
		_row_cards[i].position = Vector2(620.0, top + lift)
		_row_labels[i].position = Vector2(638.0, top - 1.0 + lift)
		_value_labels[i].position = Vector2(638.0, top + 13.0 + lift)
		_status_labels[i].position = Vector2(850.0, top + 5.0 + lift)
		_row_cards[i].color = Color(0.22, 0.38, 0.62, 0.98) if selected else Color(0.08, 0.14, 0.26, 0.96)
		_row_labels[i].text = str(row.get("name", ""))
		_value_labels[i].text = str(row.get("value", ""))
		_status_labels[i].text = str(row.get("status", ""))
		_row_labels[i].modulate = Color(1.0, 0.98, 0.84, 1.0) if selected else Color(0.98, 0.98, 1.0, 1.0)
		_value_labels[i].modulate = Color(0.70, 0.84, 1.0, 0.94)
		match str(row.get("status", "")):
			"CLEARED":
				_status_labels[i].modulate = Color(0.36, 0.92, 0.56, 1.0)
			"READY", "UNLOCKED":
				_status_labels[i].modulate = Color(1.0, 0.88, 0.40, 1.0)
			_:
				_status_labels[i].modulate = Color(0.78, 0.84, 0.94, 0.92)

func _update_chrome() -> void:
	var banner_active := CoreBridge.is_course_select_settling()
	var banner_color := Color(0.24, 0.44, 0.74, 0.98) if banner_active else Color(0.18, 0.36, 0.66, 0.96)
	if _hero_glow:
		_hero_glow.color = Color(banner_color.r * 0.72, banner_color.g * 0.82, banner_color.b, 0.18)
	if _header_plate:
		_header_plate.color = Color(banner_color.r * 0.22, banner_color.g * 0.28, banner_color.b * 0.42, 0.92)
	if _panel:
		_panel.color = Color(banner_color.r * 0.20, banner_color.g * 0.24, banner_color.b * 0.40, 0.96)
	if _header_band:
		_header_band.color = Color(banner_color.r * 0.34, banner_color.g * 0.40, banner_color.b * 0.62, 0.92)
	if _header_glow:
		_header_glow.color = Color(banner_color.r, banner_color.g, banner_color.b, 0.72)
	if _left_stage:
		_left_stage.color = Color(banner_color.r * 0.30, banner_color.g * 0.34, banner_color.b * 0.58, 0.94)
	if _right_stage:
		_right_stage.color = Color(0.10, 0.16, 0.28, 0.94)
	if _prompt_band:
		_prompt_band.color = Color(0.04, 0.08, 0.16, 0.92)
	if _map_card:
		_map_card.color = Color(banner_color.r * 0.24, banner_color.g * 0.30, banner_color.b * 0.48, 0.97)
	if _map_frame:
		_map_frame.color = Color(banner_color.r * 0.36, banner_color.g * 0.44, banner_color.b * 0.62, 0.96)
	if _summary_card:
		_summary_card.color = Color(0.07, 0.13, 0.23, 0.95)
	if _zone_chip:
		_zone_chip.color = Color(banner_color.r * 0.58, banner_color.g * 0.60, banner_color.b * 0.76, 0.96)
	if _act_chip:
		_act_chip.color = Color(banner_color.r * 0.58, banner_color.g * 0.60, banner_color.b * 0.76, 0.96)
	if _type_chip:
		_type_chip.color = Color(0.16, 0.28, 0.22, 0.96)
	if _badge_ring:
		_badge_ring.color = Color(banner_color.r + 0.56, banner_color.g + 0.40, banner_color.b * 0.40, 0.22)
	if _badge_core:
		_badge_core.color = Color(banner_color.r * 0.28, banner_color.g * 0.34, banner_color.b * 0.50, 0.96)

func _set_screen_visible(screen_visible: bool) -> void:
	if _backdrop:
		_backdrop.visible = screen_visible
	if _hero_glow:
		_hero_glow.visible = screen_visible
	if _header_plate:
		_header_plate.visible = screen_visible
	if _panel:
		_panel.visible = screen_visible
	if _header_band:
		_header_band.visible = screen_visible
	if _header_glow:
		_header_glow.visible = screen_visible
	if _left_stage:
		_left_stage.visible = screen_visible
	if _right_stage:
		_right_stage.visible = screen_visible
	if _prompt_band:
		_prompt_band.visible = screen_visible
	if _launch_fade:
		_launch_fade.visible = screen_visible
	if _map_card:
		_map_card.visible = screen_visible
	if _map_frame:
		_map_frame.visible = screen_visible
	if _summary_card:
		_summary_card.visible = screen_visible
	if _summary_label:
		_summary_label.visible = screen_visible
	if _zone_chip:
		_zone_chip.visible = screen_visible
	if _act_chip:
		_act_chip.visible = screen_visible
	if _type_chip:
		_type_chip.visible = screen_visible
	if _banner_shadow:
		_banner_shadow.visible = screen_visible
	if _banner_plate:
		_banner_plate.visible = screen_visible
	if _banner_trim:
		_banner_trim.visible = screen_visible
	if _zone_label:
		_zone_label.visible = screen_visible
	if _act_label:
		_act_label.visible = screen_visible
	if _type_label:
		_type_label.visible = screen_visible
	if _banner_label:
		_banner_label.visible = screen_visible
	if _badge_ring:
		_badge_ring.visible = screen_visible
	if _badge_core:
		_badge_core.visible = screen_visible
	if _badge_label:
		_badge_label.visible = screen_visible
	if _avatar_marker:
		_avatar_marker.visible = screen_visible
	if _marker_glow:
		_marker_glow.visible = screen_visible
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
	for label in _value_labels:
		label.visible = screen_visible
	for label in _status_labels:
		label.visible = screen_visible
	for link in _map_links:
		link.visible = screen_visible and link.visible
	for node in _map_nodes:
		node.visible = screen_visible and node.visible
	for label in _map_node_labels:
		label.visible = screen_visible and label.visible
	for badge in _emerald_badges:
		badge.visible = screen_visible and badge.visible
	for label in _emerald_labels:
		label.visible = screen_visible and label.visible
