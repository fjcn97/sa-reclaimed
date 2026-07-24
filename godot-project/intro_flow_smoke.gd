extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._unlocked_level_index = 0
	bridge.init_level(0, false)
	_check(is_equal_approx(bridge.get_intro_stage_frame(), 0.0), "stage intro starts at source frame zero")
	bridge.physics_tick(0, 0, 8.0 / 60.0)
	_check(bridge.get_intro_stage_frame() >= 7.0, "stage intro reveals banner at source frame seven")
	bridge.init_level(0, false)
	bridge.physics_tick(0, 0, 3.4)
	_check(bridge.is_intro_screen(), "normal stage intro lasts before countdown")
	_check(bridge.get_intro_countdown_text().is_empty(), "normal stage intro has no early number")
	bridge.physics_tick(0, 0, 3.1)
	_check(bridge.get_intro_countdown_text() == "2", "normal countdown reaches two")
	bridge.physics_tick(0, 0, 2.5)
	_check(not bridge.is_intro_screen(), "normal countdown starts gameplay")
	_check(bridge.is_race_start_message_visible(), "normal countdown shows race message")
	bridge.advance_ui_timers(1.0)
	_check(not bridge.is_race_start_message_visible(), "race message ends after the source 60-frame window")
	bridge.init_level(0, false)
	bridge.physics_tick(0, 0, bridge.INTRO_TOTAL_TIME - bridge.INTRO_BOOST_WINDOW + 1.0 / 60.0)
	bridge.physics_tick(bridge.DPAD_RIGHT, bridge.DPAD_RIGHT, 1.0 / 60.0)
	bridge.physics_tick(0, 0, 0.06)
	_check(bridge.is_player_boosting(), "right pressed in the final countdown window enables the start boost")
	bridge.init_level(0, false)
	bridge.physics_tick(0, bridge.A_BUTTON, 0.1)
	_check(bridge.is_intro_screen(), "normal intro can skip to countdown")
	bridge.physics_tick(0, 0, 3.1)
	_check(not bridge.is_intro_screen(), "skipped countdown starts gameplay")
	bridge.open_time_attack_lobby(true)
	bridge.init_level(0, true)
	_check(not bridge.can_skip_intro(), "boss intro cannot skip")
	_check(bridge.get_intro_countdown_text().is_empty(), "boss intro has no countdown numbers")
	bridge.physics_tick(0, bridge.A_BUTTON, 0.1)
	_check(bridge.is_intro_screen(), "boss intro ignores skip input")
	bridge.physics_tick(0, 0, 3.3)
	_check(not bridge.is_intro_screen(), "boss intro starts encounter")
	_check(not bridge.is_race_start_message_visible(), "boss intro has no race message")
	bridge.open_title_screen_and_skip_intro()
	print("INTRO_FLOW_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("INTRO_FLOW_FAIL: " + label)
