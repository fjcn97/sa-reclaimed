extends RefCounted
class_name MenuInputRouter

const SAVE_OPTIONS_INPUT_ROUTER := preload("res://scripts/core/SaveOptionsInputRouter.gd")
const TITLE_INPUT_ROUTER := preload("res://scripts/core/TitleInputRouter.gd")
const CHARACTER_SELECT_INPUT_ROUTER := preload("res://scripts/core/CharacterSelectInputRouter.gd")
const SYSTEM_MENU_INPUT_ROUTER := preload("res://scripts/core/SystemMenuInputRouter.gd")

func handle(bridge: Object, frame_input: int) -> void:
	if bridge.is_tiny_chao_garden_play_screen():
		# Garden input is consumed by advance_ui_timers before generic menu input.
		return

	if bridge.is_title_screen():
		TITLE_INPUT_ROUTER.new().handle(bridge, frame_input)
		return

	if SAVE_OPTIONS_INPUT_ROUTER.handle(bridge, frame_input):
		return

	if bridge.is_character_select():
		CHARACTER_SELECT_INPUT_ROUTER.new().handle(bridge, frame_input)
		return

	SYSTEM_MENU_INPUT_ROUTER.new().handle(bridge, frame_input)
