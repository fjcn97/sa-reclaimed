extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	var sanitized: Array = bridge._sanitize_multiplayer_record_rows([
		{"name": "ABCDEFGHI", "wins": 120, "losses": -2, "draws": 101},
		{"name": "   ", "wins": 4, "losses": 4, "draws": 4},
		{"name": "RIVAL", "wins": 3, "losses": 2, "draws": 1},
	])
	_check(sanitized.size() == 2, "empty save slots stay unused")
	_check(sanitized[0]["name"] == "ABCDEF", "rival names use source six-character width")
	_check(sanitized[0]["wins"] == 99 and sanitized[0]["losses"] == 0 and sanitized[0]["draws"] == 99, "rival results clamp to two digits")
	bridge._language_index = 2
	_check(bridge.get_multiplayer_records_column_header_text() == ["S", "N", "U"], "records column headers follow localization")
	bridge._language_index = 1
	_check(int(sanitized[0]["player_id"]) != 0, "legacy rows receive stable player identity")
	bridge._multi_record_rows = []
	bridge._insert_or_promote_multiplayer_record("RIVAL", 10)
	bridge._insert_or_promote_multiplayer_record("RIVAL", 11)
	_check(bridge._multi_record_rows.size() == 2, "same name can represent distinct player ids")

	var rows: Array = []
	for i in range(10):
		rows.append({"name": "P%d" % i, "wins": i, "losses": 0, "draws": 0})
	bridge._multi_record_rows = rows
	bridge.open_options_screen()
	bridge._options_mode = bridge.OPTIONS_MODE_MULTI_RECORDS
	bridge._multi_records_menu_index = 0
	_check(bridge.get_multiplayer_records_scroll_max() == 6, "ten records expose the source scroll range")
	_check(bridge.get_multiplayer_records_visible_rows().size() == 4, "records view shows four rows")
	bridge._language_index = 2
	_check(bridge.get_multiplayer_records_scroll_hint_text() == "RUNTER", "records scroll hint follows localization")
	bridge._language_index = 1
	bridge.move_save_selection(1)
	_check(bridge._multi_records_menu_index == 1, "down scrolls one record row")
	bridge.move_save_selection(-1)
	_check(bridge._multi_records_menu_index == 0, "up scrolls one record row")
	bridge._multi_records_menu_index = 6
	_check(bridge.get_multiplayer_records_visible_rows().size() == 4, "last record page keeps four visible rows")
	bridge.cancel_save_selection()
	_check(bridge.is_player_data_screen() and bridge._player_data_menu_index == 2, "B returns to player data")

	print("MULTIPLAYER_RECORDS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MULTIPLAYER_RECORDS_FAIL: " + label)
