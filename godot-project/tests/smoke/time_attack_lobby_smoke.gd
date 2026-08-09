extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	var controller: Node = load("res://scripts/PlayerController.gd").new()
	get_root().add_child(controller)
	bridge._selected_character_index = 0
	bridge._selected_level_index = 0
	bridge._unlocked_level_index = 5
	bridge.open_time_attack_lobby(false)
	_check(bridge.is_time_attack_lobby_screen() and bridge.get_time_attack_lobby_cursor() == 0, "lobby starts on run")
	bridge._language_index = 2
	_check(bridge.get_time_attack_lobby_title() == "ZEITANGRIFF", "lobby title follows the saved language")
	_check(bridge.get_time_attack_lobby_record_label_text().begins_with("BESTE\n"), "lobby record label follows the saved language")
	_check(str(bridge.get_time_attack_lobby_rows()[0].get("name", "")) == "START", "lobby keeps translated source label stable in German")
	bridge._language_index = 1

	# time_attack_lobby.c checks Up first, then falls through to Down.
	controller._handle_menu_input(bridge.DPAD_UP | bridge.DPAD_DOWN)
	_check(bridge.get_time_attack_lobby_cursor() == 1, "Up+Down moves down from the top")
	controller._handle_menu_input(bridge.DPAD_UP)
	_check(bridge.get_time_attack_lobby_cursor() == 0, "Up moves toward the first row")
	controller._handle_menu_input(bridge.DPAD_DOWN | bridge.A_BUTTON)
	_check(bridge.is_character_select() and bridge.get_title_phase() == bridge.TITLE_PHASE_TIME_ATTACK_LOBBY, "Down+ A moves then opens character select")
	controller.queue_free()

	bridge.open_time_attack_lobby(false)
	bridge._selected_level_index = 5
	bridge._time_attack_lobby_cursor = 1
	controller = load("res://scripts/PlayerController.gd").new()
	get_root().add_child(controller)
	controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_character_select() and bridge.get_selected_level_index() == 0, "character row resets course to Zone 1 Act 1")
	controller.queue_free()

	bridge.open_time_attack_lobby(false)
	bridge._time_attack_lobby_cursor = 2
	controller = load("res://scripts/PlayerController.gd").new()
	get_root().add_child(controller)
	controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_course_select_screen(), "course row opens course select")
	bridge.open_time_attack_lobby(false)
	bridge._time_attack_lobby_cursor = 3
	controller._handle_menu_input(bridge.A_BUTTON)
	_check(bridge.is_title_screen() and bridge.get_title_phase() == bridge.TITLE_PHASE_PRESS_START, "back row returns to title")
	bridge.open_time_attack_lobby(false)
	bridge._time_attack_lobby_cursor = 0
	controller._handle_menu_input(bridge.B_BUTTON)
	_check(bridge.is_time_attack_lobby_screen(), "B is ignored by the source lobby")
	controller.queue_free()

	print("TIME_ATTACK_LOBBY_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TIME_ATTACK_LOBBY_FAIL: " + label)
