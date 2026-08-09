extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.open_options_screen()
	bridge._player_profile_name = ["S", "O", "N", "I", "C", " "]
	bridge._language_index = 1
	bridge._options_mode = bridge.OPTIONS_MODE_PLAYER_DATA
	bridge._player_data_menu_index = 0
	bridge.accept_save_selection()
	_check(bridge.is_name_entry_screen(), "player data opens name entry")
	_check(bridge.get_name_entry_active_slot_index() == 5, "existing name focuses first empty slot")
	_check(bridge._name_entry_matrix_page_index == 0, "name entry starts at the printable-key page")
	var printable_rows: Array = bridge.get_name_entry_matrix_rows()
	_check(printable_rows[0][0] == "A" and printable_rows[0][1] == "B" and printable_rows[0][2] == "C", "name-entry board displays printable letters")
	bridge._name_entry_menu_index = 0
	_check(bridge.enter_name_entry_character("A") and bridge._player_profile_name[0] == "A", "typed printable key updates the active name slot")
	bridge._language_index = 2
	var localized_name_rows: Array = bridge.get_name_entry_rows()
	_check(str(localized_name_rows[0]["label"]).begins_with("BUCHSTABE"), "name entry rows use the selected language")
	_check(bridge.get_name_entry_guide_text().is_empty(), "name entry hides the removed board guide")
	_check(bridge.get_name_entry_preview_title_text() == "NAMENSVORSCHAU", "name preview title follows the saved language")
	bridge._language_index = 1

	bridge._name_entry_cursor_row = 0
	bridge._name_entry_matrix_page_index = 0
	bridge.move_save_selection(-1)
	_check(bridge._name_entry_cursor_row == 3 and bridge._name_entry_matrix_page_index == 0, "up wraps to the final printable-key row")
	bridge.move_save_selection(1)
	_check(bridge._name_entry_cursor_row == 0 and bridge._name_entry_matrix_page_index == 0, "down wraps to first matrix page")

	bridge._name_entry_cursor_col = 0
	bridge._name_entry_cursor_row = bridge.NAME_ENTRY_MATRIX_VISIBLE_ROWS - 1
	bridge.adjust_save_selection(-1)
	_check(bridge.is_name_entry_control_cursor() and bridge._name_entry_cursor_col == 11 and bridge._name_entry_cursor_row == bridge.NAME_ENTRY_CONTROL_ROW_BACK, "left reaches controls from final printable-key row")
	bridge.adjust_save_selection(1)
	_check(bridge._name_entry_cursor_col == 0, "right wraps controls to matrix")

	bridge._player_profile_name = ["S", "O", "N", "I", "C", " "]
	bridge._name_entry_menu_index = 5
	bridge._delete_name_entry_character()
	_check(bridge.get_profile_name_text() == "SONI  ", "delete shifts name and preserves terminator")
	bridge._name_entry_cursor_col = bridge.NAME_ENTRY_CONTROLS_COL
	bridge._name_entry_cursor_row = bridge.NAME_ENTRY_CONTROL_ROW_END
	bridge._player_profile_name = ["S", "O", "N", "I", "C", " "]
	_check(not bridge.trigger_save_start_action(), "start at end falls through to confirmation")
	bridge.accept_save_selection()
	_check(bridge.is_player_data_screen(), "start confirmation saves profile from end control")

	print("NAME_ENTRY_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("NAME_ENTRY_FAIL: " + label)
