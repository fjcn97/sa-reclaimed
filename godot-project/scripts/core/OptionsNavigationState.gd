class_name OptionsNavigationState
extends RefCounted

## Owns the active options sub-screen and its top-level cursors.

var mode: int = 0
var menu_index: int = 0
var player_data_menu_index: int = 0
var save_menu_index: int = 0
var button_config_index: int = 0
var sound_test_menu_index: int = 0
var time_records_menu_index: int = 0
var time_records_view: int = 0
var time_records_context: int = 0
var time_records_boss_mode: bool = false
var time_records_character_index: int = 0
var time_records_course_index: int = 0
var time_records_act_index: int = 0
var multiplayer_records_menu_index: int = 0
var name_entry_menu_index: int = 0
var name_entry_cursor_col: int = 0
var name_entry_cursor_row: int = 0
var name_entry_matrix_page_index: int = 0
var name_entry_snapshot: Array = ["S", "O", "N", "I", "C", " "]
var multiplayer_name_entry_snapshot: Array = ["S", "O", "N", "I", "C", " "]
var delete_confirm_index: int = 1

func reset(main_mode: int) -> void:
	mode = main_mode
	menu_index = 0
	player_data_menu_index = 0
	save_menu_index = 0
	button_config_index = 0
	sound_test_menu_index = 0
	time_records_menu_index = 0
	multiplayer_records_menu_index = 0
	name_entry_menu_index = 0
	name_entry_cursor_col = 0
	name_entry_cursor_row = 0
	name_entry_matrix_page_index = 0
	name_entry_snapshot = ["S", "O", "N", "I", "C", " "]
	multiplayer_name_entry_snapshot = ["S", "O", "N", "I", "C", " "]
	delete_confirm_index = 1
