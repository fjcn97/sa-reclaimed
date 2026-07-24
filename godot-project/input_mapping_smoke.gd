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
	controller.queue_free()
	print("INPUT_MAPPING_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("INPUT_MAPPING_FAIL: " + label)
