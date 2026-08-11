class_name SaveOptionsActionFlow
extends RefCounted

## Self-contained save-options commands that do not need the large route
## dispatcher in CoreBridge. The bridge remains the state owner.

static func trigger_special(bridge: Object) -> bool:
	if bridge.get_game_state() != bridge.GAME_STATE_SAVE_OPTIONS or bridge.is_save_reset_pending() or bridge.get_options_navigation_state().mode != bridge.OPTIONS_MODE_BUTTON_CONFIG:
		return false
	bridge.get_profile_state().button_bindings = bridge.PROFILE_CATALOG.default_button_bindings()
	bridge.get_profile_state().button_bindings_before_edit = bridge.get_profile_state().button_bindings.duplicate()
	bridge.save_profile()
	bridge.get_options_navigation_state().button_config_index = 0
	bridge.update_save_menu_status()
	return true

static func trigger_start(bridge: Object) -> bool:
	if bridge.get_game_state() != bridge.GAME_STATE_SAVE_OPTIONS or bridge.is_save_reset_pending() or bridge.get_options_navigation_state().mode != bridge.OPTIONS_MODE_NAME_ENTRY:
		return false
	if not (bridge.get_options_navigation_state().name_entry_cursor_col == bridge.NAME_ENTRY_CONTROLS_COL and bridge.get_options_navigation_state().name_entry_cursor_row == bridge.NAME_ENTRY_CONTROL_ROW_END):
		bridge.get_options_navigation_state().name_entry_cursor_col = bridge.NAME_ENTRY_CONTROLS_COL
		bridge.get_options_navigation_state().name_entry_cursor_row = bridge.NAME_ENTRY_CONTROL_ROW_END
		bridge.update_save_menu_status()
		return true
	return false

static func trigger_secondary(bridge: Object) -> bool:
	if bridge.get_game_state() != bridge.GAME_STATE_SAVE_OPTIONS or bridge.is_save_reset_pending() or bridge.get_options_navigation_state().mode != bridge.OPTIONS_MODE_NAME_ENTRY:
		return false
	bridge.delete_name_entry_character()
	bridge.update_save_menu_status()
	return true

static func handle_shoulders(bridge: Object, frame_input: int) -> bool:
	if bridge.get_game_state() != bridge.GAME_STATE_SAVE_OPTIONS or bridge.is_save_reset_pending() or bridge.get_options_navigation_state().mode != bridge.OPTIONS_MODE_NAME_ENTRY:
		return false
	if frame_input & bridge.L_BUTTON:
		bridge.move_name_entry_active_slot(-1)
	elif frame_input & bridge.R_BUTTON:
		bridge.move_name_entry_active_slot(1)
	else:
		return false
	bridge.update_save_menu_status()
	return true
