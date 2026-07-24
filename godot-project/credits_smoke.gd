extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._ending_variant = bridge.ENDING_VARIANT_NORMAL
	bridge._open_credits()
	_check(bridge.is_credits_screen(), "credits screen opens")
	_check(bridge.get_credits_page_index() == 0, "credits start on first slide")
	_check(bridge.get_credits_slide_group() == 0, "first slide belongs to first source group")
	_check(bridge.get_credits_source_tilemap() == "credits_0", "first page uses original credits tilemap")
	_check(bridge.get_credits_source_group_text().contains("1 / 4"), "first page exposes original source group")
	_check(not bridge.can_skip_credits(), "normal credits do not expose replay skip")
	bridge.advance_ui_timers(2.99)
	_check(bridge.get_credits_page_index() == 0, "intro holds for 180 frames")
	bridge.advance_ui_timers(0.01)
	_check(bridge.get_credits_page_index() == 1, "intro advances into first slide timer")
	bridge.advance_ui_timers(2.50)
	_check(bridge.get_credits_page_index() == 2, "slides advance every 150 frames")
	_check(bridge.get_credits_source_tilemap() == "credits_2", "page advance follows original tilemap order")
	for i in range(4):
		bridge.advance_ui_timers(2.50)
	_check(bridge.get_credits_slide_group() == 1, "six-slide group boundary is preserved")
	for i in range(6):
		bridge.advance_ui_timers(2.50)
	_check(bridge.get_credits_slide_group() == 2, "second source group boundary is preserved")
	var previous_language: int = int(bridge._language_index)
	bridge._language_index = 2
	_check(bridge.get_credits_page_index_text().begins_with("SEITE "), "credits page index is localized")
	_check(bridge.get_credits_detail_text().contains("UEBERSPRINGEN"), "credits skip prompt is localized")
	bridge._language_index = previous_language

	bridge._ending_variant = bridge.ENDING_VARIANT_FINAL
	bridge._completed_character_routes[bridge.CHARACTER_NAMES_AMY_INDEX()] = true
	_check(bridge.can_skip_credits(), "completed final route enables START skip")
	bridge.skip_credits()
	_check(bridge.is_credits_end_screen(), "START skip enters credits end")
	bridge.open_title_screen_and_skip_intro()
	print("CREDITS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CREDITS_FAIL: " + label)
