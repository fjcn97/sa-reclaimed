extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._save_path = "C:/Users/Fabio/Downloads/code-projects/sa-reclaimed/godot-project/.godot-local/tiny_chao_save_smoke.json"
	bridge.open_title_screen_at_single_player_menu(0)
	bridge._language_index = 2
	bridge._status_text = "LEFT/RIGHT MOVE   A CARE   B EXIT"
	_check(bridge.get_status_text() == "LINKS/RECHTS BEWEGEN   A PFLEGEN   B ENDE", "Tiny Chao status follows localization")
	bridge._language_index = 1
	bridge._tiny_chao_state.unlocked = false
	var locked_rows: Array = bridge.get_single_player_rows()
	_check(locked_rows.size() == 3, "single-player menu hides locked Tiny Chao branch")
	bridge._tiny_chao_state.unlocked = true
	bridge._save_save_data()
	bridge._tiny_chao_state.unlocked = false
	bridge._load_save_data()
	_check(bridge.is_tiny_chao_unlocked(), "Tiny Chao unlock survives save/load")
	var unlocked_rows: Array = bridge.get_single_player_rows()
	_check(unlocked_rows.size() == 4, "single-player menu reveals unlocked Tiny Chao branch")
	bridge.open_tiny_chao_garden_menu(0)
	_check(bridge.is_tiny_chao_screen(), "Tiny Chao menu opens as a title branch")
	bridge.start_title_selection()
	_check(bridge.get_title_phase() == bridge.TITLE_PHASE_TINY_CHAO_SETUP, "confirm enters Tiny Chao setup")
	var initial_token: String = bridge.get_tiny_chao_session_id()
	bridge.advance_ui_timers(0.1, 0, bridge.B_BUTTON)
	bridge.start_title_selection()
	bridge.start_title_selection()
	var refreshed_token: String = bridge.get_tiny_chao_session_id()
	_check(refreshed_token != initial_token, "new session creates a fresh handoff token")
	_check(bridge.is_tiny_chao_garden_play_screen(), "confirm enters garden play")
	_check(bridge.get_tiny_chao_session_id() != "TCG-0000" or initial_token != "TCG-0000", "garden handoff generates a session token")
	var initial_fruit: int = bridge._tiny_chao_state.fruit
	bridge.advance_ui_timers(0.1, 0, bridge.A_BUTTON)
	_check(bridge._tiny_chao_state.fruit == maxi(0, initial_fruit - 1), "A cares for the selected Chao")
	bridge.advance_ui_timers(0.1, 0, bridge.B_BUTTON)
	_check(bridge.get_title_phase() == bridge.TITLE_PHASE_TINY_CHAO_GARDEN, "B returns from garden to Tiny Chao menu")
	bridge.open_save_options_from_title()
	_check(bridge.is_single_player_menu_screen() and bridge.get_title_menu_index() == 3, "B returns from Tiny Chao menu to single-player menu")
	bridge._reset_progress()
	_check(not bridge.is_tiny_chao_unlocked(), "delete-data reset removes Tiny Chao unlock")
	bridge.open_title_screen_and_skip_intro()
	print("TINY_CHAO_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TINY_CHAO_FAIL: " + label)
