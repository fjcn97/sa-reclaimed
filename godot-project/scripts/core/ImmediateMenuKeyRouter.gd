class_name ImmediateMenuKeyRouter
extends RefCounted

const INPUT_BINDINGS := preload("res://scripts/core/InputBindings.gd")
const MENU_COMMAND := preload("res://scripts/core/MenuCommand.gd")
const SAVE_OPTIONS_COMMAND_POLICY := preload("res://scripts/core/SaveOptionsCommandPolicy.gd")

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
	return SAVE_OPTIONS_COMMAND_POLICY.execute(bridge, MENU_COMMAND.from_input_bit(bit, bridge))

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
