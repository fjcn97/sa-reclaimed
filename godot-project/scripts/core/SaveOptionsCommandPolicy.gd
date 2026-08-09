class_name SaveOptionsCommandPolicy
extends RefCounted

const MENU_COMMAND := preload("res://scripts/core/MenuCommand.gd")

## Executes named commands for every save/options input source. Routers decide
## source-specific ordering; this policy is the single action implementation.

static func execute(bridge: Object, command: String) -> bool:
	if not bridge.is_save_options():
		return false
	match command:
		MENU_COMMAND.MOVE_UP:
			bridge.move_save_selection(-1)
		MENU_COMMAND.MOVE_DOWN:
			bridge.move_save_selection(1)
		MENU_COMMAND.MOVE_LEFT:
			bridge.adjust_save_selection(-1)
		MENU_COMMAND.MOVE_RIGHT:
			bridge.adjust_save_selection(1)
		MENU_COMMAND.CONFIRM:
			bridge.accept_save_selection()
		MENU_COMMAND.BACK:
			if not bridge.trigger_save_secondary_action():
				bridge.cancel_save_selection()
		MENU_COMMAND.START:
			if not bridge.trigger_save_start_action() and (bridge.is_name_entry_screen() or bridge.is_language_screen()):
				bridge.accept_save_selection()
		MENU_COMMAND.SPECIAL:
			bridge.trigger_save_special_action()
		MENU_COMMAND.SLOT_PREVIOUS, MENU_COMMAND.SLOT_NEXT:
			return bridge.handle_save_shoulder_input(bridge.L_BUTTON if command == MENU_COMMAND.SLOT_PREVIOUS else bridge.R_BUTTON)
		_:
			return false
	return true

static func execute_frame(bridge: Object, frame_input: int) -> bool:
	if not bridge.is_save_options():
		return false
	var commands := _ordered_commands(bridge, frame_input)
	for command in commands:
		execute(bridge, command)
		# Main/name/language menu branches consume their first action.
		if bridge.is_save_main_menu_screen() or bridge.is_name_entry_screen() or bridge.is_language_screen() or bridge.is_player_data_screen():
			return true
	return not commands.is_empty()

static func _ordered_commands(bridge: Object, frame_input: int) -> Array[String]:
	var result: Array[String] = []
	if frame_input & bridge.L_BUTTON: result.append(MENU_COMMAND.SLOT_PREVIOUS)
	if frame_input & bridge.R_BUTTON: result.append(MENU_COMMAND.SLOT_NEXT)
	if bridge.is_save_main_menu_screen():
		if frame_input & bridge.A_BUTTON: return [MENU_COMMAND.CONFIRM]
		if frame_input & bridge.B_BUTTON: return [MENU_COMMAND.BACK]
	if bridge.is_sound_test_screen():
		if frame_input & bridge.DPAD_LEFT: result.append(MENU_COMMAND.MOVE_LEFT)
		if frame_input & bridge.DPAD_RIGHT: result.append(MENU_COMMAND.MOVE_RIGHT)
		if frame_input & bridge.DPAD_UP: result.append(MENU_COMMAND.MOVE_UP)
		if frame_input & bridge.DPAD_DOWN: result.append(MENU_COMMAND.MOVE_DOWN)
		if frame_input & bridge.A_BUTTON: result.append(MENU_COMMAND.CONFIRM)
		if frame_input & bridge.B_BUTTON: result.append(MENU_COMMAND.BACK)
		return result
	var up_first: bool = bridge.is_player_data_screen() or bridge.is_name_entry_screen() or bridge.is_multiplayer_records_screen() or bridge.is_time_records_courses_view()
	if up_first:
		if frame_input & bridge.DPAD_UP: result.append(MENU_COMMAND.MOVE_UP)
		elif frame_input & bridge.DPAD_DOWN: result.append(MENU_COMMAND.MOVE_DOWN)
	else:
		if frame_input & bridge.DPAD_DOWN: result.append(MENU_COMMAND.MOVE_DOWN)
		elif frame_input & bridge.DPAD_UP: result.append(MENU_COMMAND.MOVE_UP)
	if frame_input & bridge.DPAD_LEFT: result.append(MENU_COMMAND.MOVE_LEFT)
	elif frame_input & bridge.DPAD_RIGHT: result.append(MENU_COMMAND.MOVE_RIGHT)
	if frame_input & bridge.A_BUTTON: result.append(MENU_COMMAND.CONFIRM)
	elif frame_input & bridge.START_BUTTON: result.append(MENU_COMMAND.START)
	elif frame_input & bridge.SELECT_BUTTON: result.append(MENU_COMMAND.SPECIAL)
	elif frame_input & bridge.B_BUTTON: result.append(MENU_COMMAND.BACK)
	return result
