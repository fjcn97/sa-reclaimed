extends RefCounted
class_name MenuInputRouter

const SAVE_OPTIONS_INPUT_ROUTER := preload("res://scripts/core/SaveOptionsInputRouter.gd")
const TITLE_INPUT_ROUTER := preload("res://scripts/core/TitleInputRouter.gd")
const CHARACTER_SELECT_INPUT_ROUTER := preload("res://scripts/core/CharacterSelectInputRouter.gd")
const SYSTEM_MENU_INPUT_ROUTER := preload("res://scripts/core/SystemMenuInputRouter.gd")

var _title_input_router: TitleInputRouter = TITLE_INPUT_ROUTER.new()
var _character_select_input_router: CharacterSelectInputRouter = CHARACTER_SELECT_INPUT_ROUTER.new()
var _system_menu_input_router: SystemMenuInputRouter = SYSTEM_MENU_INPUT_ROUTER.new()

func handle(frame_input: int) -> void:
	if CoreBridge.is_tiny_chao_garden_play_screen():
		# Garden input is consumed by advance_ui_timers before generic menu input.
		return

	if CoreBridge.is_title_screen():
		_title_input_router.handle(frame_input)
		return

	if SAVE_OPTIONS_INPUT_ROUTER.handle(CoreBridge, frame_input):
		return

	if CoreBridge.is_character_select():
		_character_select_input_router.handle(frame_input)
		return

	_system_menu_input_router.handle(frame_input)
