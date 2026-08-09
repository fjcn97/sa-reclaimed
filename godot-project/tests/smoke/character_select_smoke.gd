extends SceneTree

const CHARACTER_SELECT_INPUT_ROUTER := preload("res://scripts/core/CharacterSelectInputRouter.gd")

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	var original_unlocks: Array = bridge._character_unlocked.duplicate()
	var original_variant: int = bridge._player_state.variant
	bridge._character_unlocked = [true, false, false, false, false]
	bridge._player_state.variant = 0
	bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_GAME_START)
	_check(bridge.get_character_select_intro_progress() == 0.0, "character intro starts closed")
	var router := CHARACTER_SELECT_INPUT_ROUTER.new()
	router.handle(bridge, bridge.B_BUTTON)
	_check(not bridge.is_character_select(), "back cancels character select during its intro")
	bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_GAME_START)
	router.handle(bridge, bridge.A_BUTTON)
	_check(not bridge.is_character_select(), "confirm accepts character select during its intro")
	bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_GAME_START)
	bridge.advance_ui_timers(24.0 / 60.0)
	_check(bridge.get_character_select_intro_progress() > 0.0 and bridge.get_character_select_intro_progress() < 1.0, "character intro advances")
	bridge.skip_character_select_intro()
	_check(bridge.is_character_select_input_ready(), "character intro can be skipped")
	var rows: Array = bridge.get_character_select_rows()
	_check(rows.size() == 5, "locked roster slots remain visible")
	_check(str(rows[1].get("status", "")) == "LOCKED", "locked character status")
	_check(not bool(rows[1].get("available", true)), "locked roster exposes a language-independent availability flag")
	var original_language: int = bridge._language_index
	bridge._language_index = 2
	_check(bridge.get_character_select_summary_text().contains("LAEUFER"), "character summary follows saved language")
	bridge._language_index = original_language
	bridge.move_character_selection(1)
	_check(bridge.get_character_menu_index() == 1, "locked slot is navigable")
	bridge.confirm_character_selection()
	_check(bridge.is_character_select(), "locked character cannot confirm")
	_check(bridge.get_character_menu_index() == 1, "locked selection is retained")
	for _step in range(3):
		bridge.move_character_selection(1)
	_check(bridge.get_character_menu_index() == 4, "amy slot remains in carousel")
	bridge._character_unlocked = original_unlocks
	bridge._player_state.variant = original_variant
	bridge.open_title_screen_and_skip_intro()
	print("CHARACTER_SELECT_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CHARACTER_SELECT_FAIL: " + label)
