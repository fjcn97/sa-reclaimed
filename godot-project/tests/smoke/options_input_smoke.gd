extends SceneTree

const SAVE_OPTIONS_INPUT_ROUTER := preload("res://scripts/core/SaveOptionsInputRouter.gd")

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node_or_null("CoreBridge")
	if bridge == null:
		bridge = preload("res://scripts/CoreBridge.gd").new()
		bridge.name = "CoreBridge"
		get_root().add_child(bridge)
	var original_language: int = bridge._language_index
	bridge.open_options_screen()
	var routed_difficulty_before: int = bridge._difficulty_index
	_check(SAVE_OPTIONS_INPUT_ROUTER.handle(bridge, bridge.DPAD_DOWN), "save-options router claims options input")
	_check(bridge._options_menu_index == 1, "save-options router moves the options cursor")
	SAVE_OPTIONS_INPUT_ROUTER.handle(bridge, bridge.A_BUTTON)
	_check(bridge._difficulty_index == wrapi(routed_difficulty_before + 1, 0, 3), "save-options router confirms the focused option")
	bridge._options_menu_index = 3
	SAVE_OPTIONS_INPUT_ROUTER.handle(bridge, bridge.A_BUTTON)
	var routed_language_before: int = bridge._language_index
	SAVE_OPTIONS_INPUT_ROUTER.handle(bridge, bridge.DPAD_DOWN)
	_check(bridge._pending_language_index != routed_language_before and bridge._language_index == routed_language_before, "save-options router keeps language navigation in preview state")
	SAVE_OPTIONS_INPUT_ROUTER.handle(bridge, bridge.B_BUTTON)
	_check(bridge.is_options_main_screen() and bridge._language_index == routed_language_before, "save-options router cancels the language preview")
	bridge.open_options_screen()
	bridge._language_index = 2
	var localized_options: Array = bridge.get_options_main_rows()
	var localized_items: Array = bridge.get_options_display_items()
	_check(localized_options[0]["label"] == localized_items[0], "options rows use the selected language")
	_check(localized_options[1]["status"] == "OEFFNEN" and localized_options[1]["action"] == "open", "options open state is localized and semantic")
	var erase_row: Dictionary = {}
	for row in localized_options:
		if str(row.get("action", "")) == "erase":
			erase_row = row
	_check(erase_row.get("status", "") == "LOESCHEN", "options erase state is localized and semantic")
	_check(bridge.get_options_main_title_text() == "OPTIONEN", "options title follows localization")
	_check(bridge.get_options_screen_subtitle() == "SPIELEINSTELLUNGEN", "options subtitle follows localization")
	_check(bridge.get_options_summary_text().contains("SCHWIERIGKEIT"), "options summary follows localization")
	var localized_player_data: Array = bridge.get_player_data_rows()
	var localized_player_items: Array = bridge.get_player_data_menu_items()
	_check(localized_player_data[1]["label"] == localized_player_items[1], "player data rows use the selected language")
	_check(localized_player_data[0]["status"] == "PROFIL" and bool(localized_player_data[0].get("profile", false)), "player data state is localized and semantic")
	_check(bridge.get_player_data_prompt_text() == "SPIELERDATEN WAEHLEN", "player data prompt follows localization")
	_check(bridge.get_language_title_text() == "SPRACHE", "language screen title follows localization")
	var localized_language_rows: Array = bridge.get_language_rows()
	_check(localized_language_rows[2]["status"] == "AKTUELL" and bool(localized_language_rows[2].get("current", false)), "language state is localized and semantic")
	var localized_button_rows: Array = bridge.get_button_config_rows()
	_check(localized_button_rows[0]["status"] == "AKTIV" and bool(localized_button_rows[0].get("active", false)), "button state is localized and semantic")
	_check(bridge.get_difficulty_rows()[2]["status"] == "WENIGER GEGNERDRUCK", "difficulty row status follows localization")
	_check(bridge.get_sound_test_status_text().begins_with("TITEL WAEHLEN"), "sound test status follows localization")
	_check(bridge.get_name_entry_prompt_text().is_empty(), "name entry prompt remains intentionally empty")
	bridge._options_mode = bridge.OPTIONS_MODE_DELETE_CONFIRM
	var localized_delete_rows: Array = bridge.get_delete_confirm_rows()
	_check(localized_delete_rows[0]["label"] == "JA", "delete confirmation choices follow localization")
	bridge.open_options_screen()
	bridge._language_index = 2
	bridge._options_menu_index = 0
	bridge.accept_save_selection()
	_check(bridge.is_player_data_screen(), "localized options still opens player data by index")
	bridge.cancel_save_selection()
	bridge._options_mode = bridge.OPTIONS_MODE_MAIN
	bridge._language_index = original_language
	for _step in range(3):
		bridge.move_save_selection(1)
	bridge.accept_save_selection()
	_check(bridge.is_language_screen(), "options opens language screen")
	var language_before_edit: int = bridge._language_index
	bridge.move_save_selection(1)
	_check(bridge._pending_language_index != language_before_edit, "language preview selection changes")
	_check(bridge._language_index == language_before_edit, "language preview leaves committed language unchanged")
	bridge.cancel_save_selection()
	_check(bridge.is_options_main_screen(), "B exits existing language edit")
	_check(bridge._language_index == language_before_edit and bridge._pending_language_index == language_before_edit, "B discards language preview")
	bridge.open_options_screen()
	for _step in range(3):
		bridge.move_save_selection(1)
	bridge.accept_save_selection()
	bridge.move_save_selection(1)
	var pending_language: int = bridge._pending_language_index
	bridge.accept_save_selection()
	_check(bridge.is_options_main_screen(), "A commits language edit")
	_check(bridge._language_index == pending_language, "A commits the pending language preview")
	bridge.open_options_screen()
	bridge.accept_save_selection()
	_check(bridge.is_player_data_screen(), "A wins over D-pad on options main")
	bridge.cancel_save_selection()
	_check(bridge.is_options_main_screen(), "B returns from player data")
	bridge.open_options_screen()
	bridge._options_menu_index = 1
	var difficulty_before: int = bridge._difficulty_index
	bridge.accept_save_selection()
	_check(bridge.is_options_main_screen(), "difficulty stays on options after toggle")
	_check(bridge._difficulty_index == wrapi(difficulty_before + 1, 0, 3), "difficulty cycles immediately")
	bridge.accept_save_selection()
	_check(bridge._difficulty_index == wrapi(difficulty_before + 2, 0, 3), "difficulty cycles from hard to easy")
	bridge.open_options_screen()
	bridge._options_menu_index = 2
	var time_limit_before: bool = bridge._time_limit_enabled
	bridge.accept_save_selection()
	_check(bridge.is_options_main_screen(), "time limit stays on options after toggle")
	_check(bridge._time_limit_enabled != time_limit_before, "time limit toggles immediately")
	bridge.accept_save_selection()
	_check(bridge._time_limit_enabled == time_limit_before, "time limit toggles back immediately")
	bridge._sound_test_unlocked = false
	bridge.open_options_screen()
	bridge._options_menu_index = 5
	bridge.accept_save_selection()
	_check(bridge.is_delete_confirm_screen(), "locked Sound Test slot resolves to delete-data confirmation")
	bridge._delete_confirm_index = 0
	bridge.accept_save_selection()
	_check(bridge.is_delete_final_confirm_screen(), "delete-data confirmation requires a final confirmation")
	bridge._delete_confirm_index = 1
	bridge.accept_save_selection()
	_check(bridge.is_options_main_screen() and bridge._options_menu_index == 5, "canceling final delete returns to its semantic menu item")
	bridge._sound_test_unlocked = true
	bridge.open_options_screen()
	bridge._options_menu_index = 5
	bridge.accept_save_selection()
	_check(bridge.is_sound_test_screen(), "unlocked Sound Test occupies the dynamic options slot")
	bridge.cancel_save_selection()
	_check(bridge.is_options_main_screen() and bridge._options_menu_index == 5, "Sound Test back returns to its dynamic slot")
	bridge._language_index = original_language
	bridge._pending_language_index = original_language
	bridge._language_index_before_edit = original_language
	bridge.open_title_screen_and_skip_intro()
	print("OPTIONS_INPUT_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("OPTIONS_INPUT_FAIL: " + label)
