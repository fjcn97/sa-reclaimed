extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false, false)
	bridge._open_game_over(false)
	_check(bridge.get_game_over_title_text() == "GAME OVER", "normal game over title")
	var previous_language: int = int(bridge._language_index)
	bridge._language_index = 2
	_check(bridge.get_game_over_title_text() == "GAME OVER", "German game over title remains valid")
	_check(bridge.get_game_over_badge_text() == "VORBEI", "game over badge is localized")
	bridge._language_index = previous_language
	bridge.advance_ui_timers(140.0 / 60.0 + 0.02)
	_check(bridge.is_game_over_screen(), "normal game over keeps its source intro duration")
	bridge.advance_ui_timers(260.0 / 60.0 + 0.02)
	_check(bridge.is_title_screen(), "normal game over returns to title")

	bridge.init_level(0, false, false)
	bridge._open_game_over(true)
	bridge.advance_ui_timers(140.0 / 60.0 - 0.02)
	_check(bridge.is_game_over_screen(), "time over holds until source end frame")
	bridge.advance_ui_timers(0.04)
	_check(bridge.is_intro_screen(), "normal time over restarts stage")

	bridge.init_level(0, true, false)
	bridge._open_game_over(false)
	bridge.advance_ui_timers(bridge.GAME_OVER_DURATION_SECONDS + 0.02)
	_check(bridge.is_title_screen(), "time attack game over returns to title")

	bridge.init_level(0, true, false)
	bridge._open_game_over(true)
	bridge.advance_ui_timers(bridge.TIME_OVER_DURATION_SECONDS + 0.02)
	_check(bridge.is_time_attack_lobby_screen(), "time attack time over returns to lobby")
	print("GAME_OVER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("GAME_OVER_FAIL: " + label)
