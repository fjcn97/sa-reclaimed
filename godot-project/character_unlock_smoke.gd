extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._selected_level_index = 1
	bridge._unlocked_level_index = 2
	bridge._character_unlock_pending = 1
	bridge._open_character_unlock()
	_check(bridge.is_character_unlock_screen(), "unlock cutscene opens")
	_check(bridge._character_unlock_segment == 0 and bridge._character_unlock_scene_frame == 0.0, "unlock starts at first segment")
	_check(bridge.get_character_unlock_source_slide_tilemap() == "storyframe_cream_unlock_0", "Cream starts on original storyframe")
	_check(bridge.get_character_unlock_source_dialogue_tilemap() == "storyframe_cream_unlock_0_dlg_en", "Cream starts on English source dialogue")

	for _frame in range(8):
		bridge.advance_ui_timers(1.0 / 60.0)
	bridge.fast_forward_character_unlock()
	_check(bridge._character_unlock_scene_frame == 8.0, "START is ignored during first eight frames")
	bridge.advance_ui_timers(1.0 / 60.0)
	bridge.fast_forward_character_unlock()
	_check(bridge._character_unlock_scene_frame == 340.0, "START fast-forwards only current segment")
	bridge.advance_ui_timers(1.0 / 60.0)
	_check(bridge.is_character_unlock_screen() and bridge._character_unlock_segment == 1, "next segment remains visible")
	_check(bridge.get_character_unlock_source_slide_tilemap() == "storyframe_cream_unlock_1", "next unlock segment follows source slide order")

	bridge._character_unlock_segment = 3
	bridge._character_unlock_scene_frame = 340.0
	bridge.advance_ui_timers(1.0 / 60.0)
	_check(bridge.is_character_unlock_screen() and bridge._character_unlock_segment == 4, "final message follows four segments")
	_check(bridge.get_character_unlock_source_dialogue_tilemap() == "storyframe_cream_unlock_3_dlg_en", "final message holds the fourth source dialogue card")
	for _frame in range(301):
		bridge.advance_ui_timers(1.0 / 60.0)
	_check(not bridge.is_character_unlock_screen(), "final message resolves after source duration")

	print("CHARACTER_UNLOCK_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CHARACTER_UNLOCK_FAIL: " + label)
