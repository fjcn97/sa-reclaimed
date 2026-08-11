extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node_or_null("CoreBridge")
	if bridge == null:
		bridge = preload("res://scripts/CoreBridge.gd").new()
		bridge.name = "CoreBridge"
		get_root().add_child(bridge)
	bridge._selected_character_index = 0
	bridge._selected_level_index = 0
	bridge.init_level(0, true, false)
	bridge._game_state = bridge.GAME_STATE_PLAYING
	bridge.pause_game()
	bridge._pause_menu_state.menu_index = 1
	bridge._pause_menu_state.a_previous_held = true
	bridge._pause_menu_state.a_hold_lock = false
	bridge.advance_ui_timers(1.0 / 60.0, 0, bridge.B_BUTTON)
	_check(not bridge.is_paused(), "B wins over A release in time attack")

	bridge.init_level(0, true, false)
	bridge._game_state = bridge.GAME_STATE_PLAYING
	bridge.pause_game()
	bridge._pause_menu_state.menu_index = 1
	bridge._pause_menu_state.a_previous_held = true
	bridge.advance_ui_timers(1.0 / 60.0, 0, bridge.START_BUTTON)
	_check(not bridge.is_paused(), "START wins over A release")

	bridge.init_level(0, true, false)
	bridge._game_state = bridge.GAME_STATE_PLAYING
	bridge.pause_game()
	bridge._pause_menu_state.menu_index = 1
	bridge._pause_menu_state.a_previous_held = true
	bridge.advance_ui_timers(1.0 / 60.0, 0, 0)
	_check(not bridge.is_paused() and bridge.is_title_screen(), "A release routes selected time attack quit")

	bridge.init_level(0, false, false)
	bridge._game_state = bridge.GAME_STATE_PLAYING
	bridge.pause_game()
	bridge._pause_menu_state.menu_index = 1
	bridge._pause_menu_state.a_previous_held = true
	bridge.advance_ui_timers(1.0 / 60.0, 0, 0)
	_check(not bridge.is_paused() and bridge.is_title_screen(), "A release routes single-player quit")

	bridge.init_level(0, false, false)
	bridge._game_state = bridge.GAME_STATE_PLAYING
	bridge.toggle_pause(bridge.A_BUTTON)
	bridge.advance_ui_timers(1.0 / 60.0, 0, 0)
	_check(bridge.is_paused() and not bridge.is_pause_a_hold_locked(), "initial A release only clears the source hold lock")
	bridge.advance_ui_timers(1.0 / 60.0, bridge.A_BUTTON, bridge.A_BUTTON)
	bridge.advance_ui_timers(1.0 / 60.0, 0, 0)
	_check(not bridge.is_paused(), "a later A press and release confirms")

	bridge.init_level(0, false, false)
	bridge._game_state = bridge.GAME_STATE_PLAYING
	bridge.pause_game()
	bridge._pause_menu_state.menu_index = 1
	bridge.advance_ui_timers(1.0 / 60.0, 0, bridge.B_BUTTON)
	_check(bridge.is_paused(), "single-player B does not close the pause menu")

	bridge.init_level(0, false, true)
	bridge._game_state = bridge.GAME_STATE_PLAYING
	bridge.pause_game()
	bridge._pause_menu_state.menu_index = 1
	bridge._pause_menu_state.a_previous_held = true
	_check(str(bridge.get_pause_menu_rows()[1].get("value", "")) == "RETURN TO MULTIPLAYER", "multiplayer pause quit row uses the lobby destination")
	bridge.advance_ui_timers(1.0 / 60.0, 0, 0)
	_check(bridge.is_title_screen() and bridge.is_multiplayer_lobby_screen(), "multiplayer pause quit returns to the lobby")

	bridge.init_level(0, false, true)
	bridge._game_state = bridge.GAME_STATE_PLAYING
	bridge.pause_game()
	bridge.advance_ui_timers(1.0 / 60.0, 0, bridge.B_BUTTON)
	_check(not bridge.is_paused() and bridge.is_gameplay_active(), "multiplayer B resumes the current stage")

	var previous_language: int = int(bridge._language_index)
	bridge._language_index = 2
	_check(bridge.get_pause_title_text() == "PAUSE", "pause title remains localized in German")
	_check(bridge.get_pause_badge_text() == "PAUSIERT", "pause badge uses semantic localized text")
	bridge._pause_menu_state.menu_index = 1
	_check(bridge.get_pause_summary_text().begins_with("SPIELSTUFE VERLASSEN"), "pause summary follows the selected quit action")
	bridge._language_index = previous_language

	print("PAUSE_MENU_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PAUSE_MENU_FAIL: " + label)
