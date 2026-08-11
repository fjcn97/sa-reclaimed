extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE, 0)
	bridge._selected_level_index = 999
	bridge._sound_test_state = bridge.SOUND_TEST_STATE_PLAYING
	bridge._time_attack_boss_mode = true
	bridge.reset_to_title()
	_check(bridge._game_state == bridge.GAME_STATE_TITLE, "reset returns to title state")
	_check(bridge._title_phase == bridge.TITLE_PHASE_PRESS_START, "reset restores press-start phase")
	_check(bridge._sound_test_state == bridge.SOUND_TEST_STATE_STOPPED, "reset stops sound-test playback")
	_check(not bridge._time_attack_boss_mode, "reset clears time-attack mode")
	_check(bridge._selected_level_index <= bridge._unlocked_level_index, "reset clamps the selected level")
	_check(not bridge.is_character_select(), "reset closes character selection")
	print("TITLE_FRONTEND_RESET_FLOW_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TITLE_FRONTEND_RESET_FLOW_FAIL: " + label)
