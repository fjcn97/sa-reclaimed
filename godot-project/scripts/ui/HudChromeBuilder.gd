# Builds the reusable HUD chrome and returns its named presentation nodes.
extends RefCounted
class_name HudChromeBuilder

const UI_NODE_FACTORY := preload("res://scripts/ui/UiNodeFactory.gd")

static func build(parent: Node) -> Dictionary:
	var nodes := {}
	nodes["score_glow"] = _rect(parent, "ScoreGlow", Rect2(10.0, 12.0, 300.0, 56.0), Color(0.14, 0.28, 0.54, 0.18), -6)
	nodes["score_card"] = _rect(parent, "ScoreCard", Rect2(18.0, 18.0, 278.0, 42.0), Color(0.08, 0.16, 0.38, 0.92), -5)
	nodes["rings_card"] = _rect(parent, "RingsCard", Rect2(18.0, 70.0, 194.0, 42.0), Color(0.34, 0.18, 0.04, 0.92), -5)
	nodes["special_ring_card"] = _rect(parent, "SpecialRingCard", Rect2(18.0, 118.0, 194.0, 36.0), Color(0.08, 0.28, 0.40, 0.90), -5)
	nodes["lives_glow"] = _rect(parent, "LivesGlow", Rect2(10.0, 626.0, 236.0, 58.0), Color(0.10, 0.18, 0.36, 0.14), -6)
	nodes["lives_card"] = _rect(parent, "LivesCard", Rect2(18.0, 632.0, 214.0, 46.0), Color(0.08, 0.14, 0.28, 0.92), -5)
	nodes["timer_glow"] = _rect(parent, "TimerGlow", Rect2(972.0, 12.0, 278.0, 56.0), Color(0.16, 0.24, 0.58, 0.18), -6)
	nodes["timer_card"] = _rect(parent, "TimerCard", Rect2(980.0, 18.0, 262.0, 42.0), Color(0.12, 0.18, 0.42, 0.92), -5)
	nodes["status_card"] = _rect(parent, "StatusCard", Rect2(350.0, 18.0, 580.0, 46.0), Color(0.08, 0.10, 0.18, 0.86), -5)

	nodes["special_ring_label"] = _label(parent, "SpecialRingLabel", Vector2(34.0, 126.0), Vector2(164.0, 22.0), 12)
	nodes["powerup_label"] = _label(parent, "PowerupLabel", Vector2(222.0, 126.0), Vector2(132.0, 22.0), 12)
	nodes["score_title"] = _label(parent, "ScoreTitle", Vector2(34.0, 22.0), Vector2(86.0, 20.0), 14)
	nodes["rings_title"] = _label(parent, "RingsTitle", Vector2(34.0, 74.0), Vector2(86.0, 20.0), 14)
	nodes["time_title"] = _label(parent, "TimeTitle", Vector2(996.0, 22.0), Vector2(72.0, 20.0), 14)
	nodes["lives_title"] = _label(parent, "LivesTitle", Vector2(34.0, 636.0), Vector2(60.0, 20.0), 14)
	nodes["character_label"] = _label(parent, "CharacterLabel", Vector2(34.0, 652.0), Vector2(60.0, 20.0), 16)
	var chrome: Dictionary = CoreBridge.get_hud_chrome_colors()
	(nodes["score_title"] as Label).modulate = chrome.get("score_title", Color(0.68, 0.86, 1.0, 0.94))
	(nodes["rings_title"] as Label).modulate = chrome.get("rings_title", Color(1.0, 0.84, 0.36, 0.96))
	(nodes["time_title"] as Label).modulate = chrome.get("time_title", Color(0.74, 0.88, 1.0, 0.94))
	(nodes["lives_title"] as Label).modulate = chrome.get("lives_title", Color(0.72, 0.84, 1.0, 0.94))
	(nodes["character_label"] as Label).modulate = chrome.get("character", Color(0.98, 0.98, 1.0, 1.0))

	nodes["boss_panel"] = _rect(parent, "BossPanel", Rect2(432.0, 78.0, 416.0, 74.0), Color(0.18, 0.06, 0.10, 0.94), -4)
	nodes["boss_title"] = _label(parent, "BossTitle", Vector2(448.0, 86.0), Vector2(150.0, 22.0), 14)
	nodes["boss_phase"] = _label(parent, "BossPhase", Vector2(620.0, 86.0), Vector2(212.0, 22.0), 14)
	(nodes["boss_phase"] as Label).horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	nodes["boss_health_back"] = _rect(parent, "BossHealthBack", Rect2(448.0, 118.0, 384.0, 14.0), Color(0.04, 0.03, 0.06, 0.96), -3)
	nodes["boss_health_fill"] = _rect(parent, "BossHealthFill", Rect2(450.0, 120.0, 380.0, 10.0), Color(0.94, 0.24, 0.24, 1.0), -2)
	var boss_pips: Array[ColorRect] = []
	for i in range(8):
		boss_pips.append(_rect(parent, "BossHealthPip%d" % i, Rect2(450.0 + i * 47.5, 120.0, 42.0, 10.0), Color(1.0, 0.52, 0.34, 1.0), -1))
	nodes["boss_health_pips"] = boss_pips

	nodes["mp_panel"] = _rect(parent, "MultiplayerPanel", Rect2(828.0, 508.0, 420.0, 168.0), Color(0.16, 0.07, 0.12, 0.88), -4)
	nodes["mp_track"] = _rect(parent, "MultiplayerTrack", Rect2(960.0, 532.0, 236.0, 8.0), Color(0.88, 0.62, 0.18, 0.88), -3)
	nodes["mp_start_flag"] = _label(parent, "MultiplayerStartFlag", Vector2(922.0, 520.0), Vector2(34.0, 24.0), 14)
	nodes["mp_finish_flag"] = _label(parent, "MultiplayerFinishFlag", Vector2(1200.0, 520.0), Vector2(40.0, 24.0), 14)
	var row_cards: Array[ColorRect] = []
	var place_labels: Array[Label] = []
	var name_labels: Array[Label] = []
	var progress_labels: Array[Label] = []
	var markers: Array[ColorRect] = []
	for i in range(4):
		var row_y := 548.0 + i * 28.0
		row_cards.append(_rect(parent, "MultiplayerRowCard%d" % i, Rect2(846.0, row_y, 386.0, 24.0), Color(0.10, 0.05, 0.09, 0.82), -2))
		var place := _label(parent, "MultiplayerPlaceLabel%d" % i, Vector2(858.0, row_y), Vector2(58.0, 24.0), 14)
		place.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		place_labels.append(place)
		name_labels.append(_label(parent, "MultiplayerNameLabel%d" % i, Vector2(924.0, row_y), Vector2(188.0, 24.0), 14))
		var progress := _label(parent, "MultiplayerProgressLabel%d" % i, Vector2(1136.0, row_y), Vector2(84.0, 24.0), 14)
		progress.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		progress_labels.append(progress)
		markers.append(_rect(parent, "MultiplayerMarker%d" % i, Rect2(960.0, 531.0, 10.0, 10.0), Color(1.0, 0.88, 0.48, 1.0), -1))
	nodes["mp_row_cards"] = row_cards
	nodes["mp_place_labels"] = place_labels
	nodes["mp_name_labels"] = name_labels
	nodes["mp_progress_labels"] = progress_labels
	nodes["mp_markers"] = markers
	return nodes

static func _rect(parent: Node, node_name: String, rect: Rect2, color: Color, z_index: int) -> ColorRect:
	var node := UI_NODE_FACTORY.ensure_rect(parent, node_name, rect, color)
	node.z_index = z_index
	return node

static func _label(parent: Node, node_name: String, position: Vector2, size: Vector2, font_size: int) -> Label:
	return UI_NODE_FACTORY.ensure_label(parent, node_name, position, size, font_size, false)
