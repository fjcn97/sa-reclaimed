extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	var controller: Node = load("res://scripts/PlayerController.gd").new()
	get_root().add_child(controller)
	_check(controller._keycode_to_bit(KEY_ENTER) == bridge.A_BUTTON, "Enter confirms menus")
	_check(controller._keycode_to_bit(KEY_KP_ENTER) == bridge.A_BUTTON, "keypad Enter confirms menus")
	_check(controller._keycode_to_bit(KEY_ESCAPE) == bridge.B_BUTTON, "Escape backs out of menus")
	_check(controller._keycode_to_bit(KEY_Z) == bridge.A_BUTTON, "Z remains A")
	_check(controller._keycode_to_bit(KEY_X) == 0, "X has no menu action")
	bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_GAME_START)
	var character_back := InputEventKey.new()
	character_back.keycode = KEY_ESCAPE
	character_back.pressed = true
	controller._handle_key_event(character_back)
	_check(not bridge.is_character_select(), "Escape immediately backs out of character select")
	bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_GAME_START)
	var character_confirm := InputEventKey.new()
	character_confirm.keycode = KEY_ENTER
	character_confirm.pressed = true
	controller._handle_key_event(character_confirm)
	_check(not bridge.is_character_select(), "Enter immediately confirms character select")
	bridge.open_options_screen()
	var options_down := InputEventKey.new()
	options_down.keycode = KEY_DOWN
	options_down.pressed = true
	controller._handle_key_event(options_down)
	_check(bridge._options_menu_index == 1, "Down immediately moves the options cursor")
	var options_confirm := InputEventKey.new()
	options_confirm.keycode = KEY_ENTER
	options_confirm.pressed = true
	var difficulty_before: int = bridge._difficulty_index
	controller._handle_key_event(options_confirm)
	_check(bridge._difficulty_index == wrapi(difficulty_before + 1, 0, 3), "Enter immediately confirms the focused option")
	bridge.open_options_screen()
	var options_back := InputEventKey.new()
	options_back.keycode = KEY_ESCAPE
	options_back.pressed = true
	controller._handle_key_event(options_back)
	_check(not bridge.is_save_options(), "Escape immediately leaves the options menu")
	var stick := InputEventJoypadMotion.new()
	stick.axis = JOY_AXIS_LEFT_X
	stick.axis_value = -0.8
	controller._handle_joypad_motion(stick)
	_check((controller._joypad_axis_input & bridge.DPAD_LEFT) != 0, "Left analog stick maps to left")
	stick.axis_value = 0.0
	controller._handle_joypad_motion(stick)
	_check((controller._joypad_axis_input & (bridge.DPAD_LEFT | bridge.DPAD_RIGHT)) == 0, "Analog deadzone releases horizontal input")
	var down_press := InputEventKey.new()
	down_press.keycode = KEY_DOWN
	down_press.pressed = true
	controller._handle_key_event(down_press)
	_check((controller._fallback_held_input & bridge.DPAD_DOWN) != 0, "Arrow key press enters held input")
	var down_release := InputEventKey.new()
	down_release.keycode = KEY_DOWN
	down_release.pressed = false
	down_release.echo = true
	controller._handle_key_event(down_release)
	_check((controller._fallback_held_input & bridge.DPAD_DOWN) == 0, "Arrow key release clears even echoed input")
	controller.queue_free()
	print("INPUT_MAPPING_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("INPUT_MAPPING_FAIL: " + label)
