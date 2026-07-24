extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._open_missing_emeralds_message()
	_check(bridge.is_missing_emeralds_screen(), "missing emerald card opens")
	_check(bridge.get_missing_emeralds_title_text().contains("CHAOS EMERALDS"), "missing emerald message is present")
	bridge.advance_ui_timers(6.99)
	_check(bridge.is_missing_emeralds_screen(), "card holds for the original 420 frames")
	bridge.advance_ui_timers(0.01)
	_check(bridge.is_title_screen(), "card returns to title after its source duration")
	var previous_language := int(bridge._language_index)
	bridge._language_index = 2
	_check(bridge.get_missing_emeralds_title_text().contains("CHAOS-EMERALDE"), "German notification text remains localized")
	bridge._language_index = previous_language
	print("MISSING_EMERALDS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MISSING_EMERALDS_FAIL: " + label)
