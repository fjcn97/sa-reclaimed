extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var controller: Node = load("res://scripts/PlayerController.gd").new()
	get_root().add_child(controller)
	_check(controller._keycode_to_bit(KEY_ENTER) == CoreBridge.A_BUTTON, "Enter confirms menus")
	_check(controller._keycode_to_bit(KEY_KP_ENTER) == CoreBridge.A_BUTTON, "keypad Enter confirms menus")
	_check(controller._keycode_to_bit(KEY_ESCAPE) == CoreBridge.B_BUTTON, "Escape backs out of menus")
	_check(controller._keycode_to_bit(KEY_Z) == CoreBridge.A_BUTTON, "Z remains A")
	_check(controller._keycode_to_bit(KEY_X) == CoreBridge.B_BUTTON, "X remains B")
	var stick := InputEventJoypadMotion.new()
	stick.axis = JOY_AXIS_LEFT_X
	stick.axis_value = -0.8
	controller._handle_joypad_motion(stick)
	_check((controller._joypad_axis_input & CoreBridge.DPAD_LEFT) != 0, "Left analog stick maps to left")
	stick.axis_value = 0.0
	controller._handle_joypad_motion(stick)
	_check((controller._joypad_axis_input & (CoreBridge.DPAD_LEFT | CoreBridge.DPAD_RIGHT)) == 0, "Analog deadzone releases horizontal input")
	var down_press := InputEventKey.new()
	down_press.keycode = KEY_DOWN
	down_press.pressed = true
	controller._handle_key_event(down_press)
	_check((controller._fallback_held_input & CoreBridge.DPAD_DOWN) != 0, "Arrow key press enters held input")
	var down_release := InputEventKey.new()
	down_release.keycode = KEY_DOWN
	down_release.pressed = false
	down_release.echo = true
	controller._handle_key_event(down_release)
	_check((controller._fallback_held_input & CoreBridge.DPAD_DOWN) == 0, "Arrow key release clears even echoed input")
	controller.queue_free()
	print("INPUT_MAPPING_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("INPUT_MAPPING_FAIL: " + label)
