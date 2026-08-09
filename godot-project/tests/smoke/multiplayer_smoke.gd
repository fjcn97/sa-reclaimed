extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	var original_language: int = bridge._language_index
	bridge._language_index = 2
	_check(bridge.get_multiplayer_mode_title_text() == "PAK-MODUS", "multiplayer mode title follows saved language")
	_check(str(bridge.get_multiplayer_mode_rows()[0].get("description", "")).begins_with("2-4 SPIELER"), "multiplayer mode rows are localized")
	var original_profile: Array = bridge._player_profile_name.duplicate()
	bridge._player_profile_name = [" ", " ", " ", " ", " ", " "]
	var locked_mode_rows: Array = bridge.get_multiplayer_mode_rows()
	_check(locked_mode_rows[0]["status"] == "NAME NOETIG" and not bool(locked_mode_rows[0].get("available", true)), "multiplayer lock state is localized and semantic")
	bridge._player_profile_name = original_profile
	bridge._language_index = original_language
	bridge.open_multiplayer_comm_screen(0, 0)
	bridge._language_index = 2
	_check(bridge.get_multiplayer_comm_title() == "KOMMUNIKATION", "communication title follows saved language")
	_check(str(bridge.get_multiplayer_comm_rows()[0].get("value", "")).contains("VON 4"), "communication rows are localized")
	_check(bridge.get_multiplayer_outcome_title() == "VERBINDUNG ERFOLGREICH", "communication outcome follows saved language")
	_check(bridge.get_multiplayer_lobby_title() == "WEITER?", "multiplayer lobby follows saved language")
	bridge._multiplayer_result_snapshot = []
	bridge._multiplayer_result_mode = bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE
	_check(bridge.get_multiplayer_results_title() == "MULTIPLAYER-ERGEBNIS", "multiplayer results title follows saved language")
	bridge._multiplayer_result_mode = bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION
	_check(bridge.get_multiplayer_results_title() == "CHARAKTER GEWAEHLT", "character results title follows saved language")
	bridge._language_index = original_language
	bridge.open_title_screen_and_skip_intro()
	var original_players: Array = bridge._multiplayer_link_players.duplicate()
	var original_connected: Array = bridge._multiplayer_link_connected.duplicate()
	var original_characters: Array = bridge._multiplayer_player_characters.duplicate()
	var original_ranks: Array = bridge._multiplayer_player_ranks.duplicate()
	bridge._multiplayer_link_players = ["HOST"]
	bridge._multiplayer_link_connected = [true]
	bridge._multiplayer_player_characters = [0]
	bridge._multiplayer_player_ranks = [0]
	_check(bridge.get_multiplayer_comm_player_rows().size() == 4, "comm rows repair truncated session")
	_check(bridge.get_multiplayer_lobby_player_rows().size() == 4, "lobby rows repair truncated session")
	_check(bridge.get_multiplayer_link_count() == 1, "host remains connected")
	bridge._start_multiplayer_mode(0)
	_check(bridge.is_multiplayer_connection_screen(), "multiplayer opens connection screen")
	bridge.start_title_selection()
	_check(bridge.is_multiplayer_outcome_screen(), "link advances to outcome")
	bridge.advance_ui_timers(2.0)
	_check(bridge.is_multiplayer_outcome_screen(), "outcome holds for source presentation timer")
	bridge.advance_ui_timers(0.3)
	_check(bridge.is_character_select(), "successful multipak link enters character select")
	bridge._multiplayer_link_players = original_players
	bridge._multiplayer_link_connected = original_connected
	bridge._multiplayer_player_characters = original_characters
	bridge._multiplayer_player_ranks = original_ranks
	bridge.open_title_screen_and_skip_intro()
	print("MULTIPLAYER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MULTIPLAYER_FAIL: " + label)
