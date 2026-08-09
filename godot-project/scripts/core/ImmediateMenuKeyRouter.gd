class_name ImmediateMenuKeyRouter
extends RefCounted

const INPUT_BINDINGS := preload("res://scripts/core/InputBindings.gd")

## Handles keyboard commands that must execute on the event itself rather than
## waiting for the next buffered menu frame (text entry and character select).

static func handle(bridge: Object, event: InputEventKey) -> bool:
	if not event.pressed or event.echo:
		return false
	var keycode := event.keycode if event.keycode != KEY_NONE else event.physical_keycode
	if bridge.is_name_entry_screen():
		if keycode == KEY_ESCAPE:
			bridge.cancel_save_selection()
			return true
		if keycode == KEY_BACKSPACE or keycode == KEY_DELETE:
			bridge.trigger_save_secondary_action()
			return true
		var typed_character := _typed_name_character(event)
		if not typed_character.is_empty() and bridge.enter_name_entry_character(typed_character):
			return true
	if bridge.is_character_select():
		if keycode == KEY_ESCAPE and not bridge.is_multiplayer_character_select_screen():
			bridge.cancel_character_selection()
			return true
		if keycode == KEY_ENTER or keycode == KEY_KP_ENTER:
			bridge.confirm_character_selection()
			return true
	if bridge.is_save_options():
		return _handle_save_options_key(bridge, keycode)
	return false

static func _handle_save_options_key(bridge: Object, keycode: int) -> bool:
	var bit := INPUT_BINDINGS.keycode_to_bit(keycode)
	if bit == 0:
		return false
	# The main list commits/backtracks before directional movement, matching
	# its visual instructions and avoiding a buffered key event being dropped.
	if bridge.is_save_main_menu_screen():
		if bit & bridge.A_BUTTON:
			bridge.accept_save_selection()
			return true
		if bit & bridge.B_BUTTON:
			if not bridge.trigger_save_secondary_action():
				bridge.cancel_save_selection()
			return true
	if bit & bridge.DPAD_UP:
		bridge.move_save_selection(-1)
		return true
	if bit & bridge.DPAD_DOWN:
		bridge.move_save_selection(1)
		return true
	if bit & bridge.DPAD_LEFT:
		bridge.adjust_save_selection(-1)
		return true
	if bit & bridge.DPAD_RIGHT:
		bridge.adjust_save_selection(1)
		return true
	if bit & bridge.A_BUTTON:
		bridge.accept_save_selection()
		return true
	if bit & bridge.START_BUTTON:
		if not bridge.trigger_save_start_action() and (bridge.is_name_entry_screen() or bridge.is_language_screen()):
			bridge.accept_save_selection()
		return true
	if bit & bridge.SELECT_BUTTON:
		bridge.trigger_save_special_action()
		return true
	if bit & bridge.B_BUTTON:
		if not bridge.trigger_save_secondary_action():
			bridge.cancel_save_selection()
		return true
	return false

static func _typed_name_character(event: InputEventKey) -> String:
	if event.unicode > 0:
		return char(event.unicode).to_upper()
	match event.keycode:
		KEY_MINUS:
			return "-"
		KEY_SLASH:
			return "/"
		KEY_PERIOD:
			return "."
		KEY_SPACE:
			return " "
		_:
			return ""
