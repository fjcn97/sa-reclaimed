extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	_check(not bridge.is_mobile_platform(), "desktop runtime is not mobile")
	_check(not bridge.should_show_touch_controls(), "touch controls stay hidden on desktop")
	_check(not bridge.should_show_touch_gameplay_controls(), "gameplay touch controls stay hidden on desktop")
	_check(not bridge.should_show_touch_menu_controls(), "menu touch controls stay hidden on desktop")
	ProjectSettings.set_setting(bridge.TOUCH_CONTROLS_OVERRIDE_SETTING, true)
	_check(bridge.should_show_touch_controls(), "desktop debug override can show touch controls")
	ProjectSettings.set_setting(bridge.TOUCH_CONTROLS_OVERRIDE_SETTING, false)
	bridge._language_index = 2
	bridge._game_state = bridge.GAME_STATE_TITLE
	bridge._title_phase = bridge.TITLE_PHASE_PRESS_START
	var labels: Dictionary = bridge.get_touch_menu_labels()
	_check(labels["back"] == "Optionen", "touch labels follow localization")
	_check(labels["confirm"] == "Start", "touch action label follows localization")
	bridge._title_phase = bridge.TITLE_PHASE_SINGLE_PLAYER
	bridge._title_menu_index = 2
	_check(bridge.get_touch_menu_labels()["confirm"] == "Oeffnen", "touch action uses semantic options state")
	bridge._title_phase = bridge.TITLE_PHASE_TINY_CHAO_GARDEN
	bridge._title_menu_index = 1
	_check(bridge.get_touch_menu_labels()["confirm"] == "Zurueck", "touch action uses semantic back state")
	print("TOUCH_CONTROLS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TOUCH_CONTROLS_FAIL: " + label)
