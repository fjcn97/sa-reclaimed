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
