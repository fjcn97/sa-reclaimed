extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	var controller: Node = load("res://scripts/PlayerController.gd").new()
	get_root().add_child(controller)
	bridge._player_profile_name = [" ", " ", " ", " ", " ", " "]
	bridge.open_title_screen_at_multiplayer_menu(0)
	bridge._multiplayer_mode_intro_timer = 0.0
	controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_language_screen(), "multiplayer without profile opens language selection")
	controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_name_entry_screen(), "language selection opens multiplayer name entry")
	bridge._player_profile_name = ["S", "O", "N", "I", "C", " "]
	bridge._name_entry_cursor_col = bridge.NAME_ENTRY_CONTROLS_COL
	bridge._name_entry_cursor_row = bridge.NAME_ENTRY_CONTROL_ROW_END
	controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_multiplayer_mode_screen(), "saved multiplayer profile returns to mode menu")

	# mode_select.c confirms before applying the same-frame vertical toggle.
	# This keeps held direction input from selecting the wrong pak flow.
	bridge._multiplayer_mode_intro_timer = 0.0
	bridge._title_menu_index = 0
	controller._handle_menu_input(bridge.A_BUTTON | bridge.DPAD_UP)
	_check(bridge.is_multiplayer_connection_screen() and bridge._multiplayer_pak_mode == 1, "A+Up confirms the toggled single-pak mode")
	bridge.open_title_screen_at_multiplayer_menu(0)
	bridge._multiplayer_mode_intro_timer = 0.0
	controller._handle_menu_input(bridge.B_BUTTON | bridge.DPAD_DOWN)
	_check(bridge._title_phase == bridge.TITLE_PHASE_PLAY_MODE and bridge._title_menu_index == 1, "B+Down returns to play mode without confirming")
	bridge.open_title_screen_at_multiplayer_menu(0)
	bridge._multiplayer_mode_intro_timer = 0.0
	controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_multiplayer_connection_screen(), "multi-pak opens connection screen")
	controller._handle_menu_input(bridge.START_BUTTON)
	_check(bridge.is_multiplayer_outcome_screen(), "connection enters outcome screen")
	bridge._selected_character_index = 3
	bridge.advance_ui_timers(2.0)
	_check(bridge.is_multiplayer_outcome_screen(), "outcome holds for the source presentation timer")
	bridge.advance_ui_timers(0.3)
	_check(bridge.is_character_select() and bridge.get_character_menu_index() == 0, "successful link starts multiplayer character selection at Sonic")
	bridge._character_select_intro_timer = 0.0
	controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_singlepak_results_screen() and bridge.is_multiplayer_character_selection_results(), "character lock enters results")
	bridge.advance_ui_timers(2.0)
	_check(bridge.is_course_select_screen() and bridge.is_multiplayer_course_select_screen(), "results enters multiplayer course select")
	controller._handle_menu_input(bridge.A_BUTTON)
	bridge.advance_ui_timers(1.0)
	_check(bridge.is_multiplayer_connection_screen(), "course selection returns to communication")

	bridge.open_title_screen_at_multiplayer_menu(1)
	bridge._multiplayer_mode_intro_timer = 0.0
	controller._handle_menu_input(bridge.B_BUTTON)
	_check(bridge._title_phase == bridge.TITLE_PHASE_PLAY_MODE and bridge._title_menu_index == 1, "single-pak B cancels before transfer")
	bridge.open_title_screen_at_multiplayer_menu(1)
	bridge._multiplayer_mode_intro_timer = 0.0
	controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_multiplayer_connection_screen(), "single-pak opens connection screen")
	controller._handle_menu_input(bridge.START_BUTTON)
	_check(bridge.is_multiplayer_connection_screen() and bridge.is_singlepak_transfer_started(), "single-pak start begins transfer")
	controller._handle_menu_input(bridge.B_BUTTON)
	_check(bridge.is_multiplayer_connection_screen() and bridge._multiplayer_disconnect_timer == 0.0, "single-pak ignores B during transfer")
	for _step in range(3):
		bridge.advance_ui_timers(0.25)
	_check(bridge._title_phase == bridge.TITLE_PHASE_SINGLEPAK_SYNC, "single-pak transfer enters sync screen")
	for _step in range(4):
		controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_intro_screen(), "ready single-pak sync starts multiplayer stage")

	bridge.open_multiplayer_lobby_screen(1)
	controller._handle_menu_input(bridge.A_BUTTON)
	bridge.advance_ui_timers(bridge.MULTIPLAYER_LOBBY_EXIT_DURATION - 0.02)
	_check(bridge.is_multiplayer_lobby_screen(), "multiplayer exit keeps the source wave duration")
	bridge.advance_ui_timers(0.04)
	_check(bridge.is_title_screen(), "multiplayer exit returns to title after the wave")

	controller.queue_free()
	print("MULTIPLAYER_FLOW_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MULTIPLAYER_FLOW_FAIL: " + label)
