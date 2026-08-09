extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node_or_null("CoreBridge")
	if bridge == null:
		bridge = preload("res://scripts/CoreBridge.gd").new()
		bridge.name = "CoreBridge"
		get_root().add_child(bridge)
	var original: Array = bridge._button_bindings.duplicate()
	bridge._button_bindings = ["JUMP", "ATTACK", "TRICK"]
	bridge.open_options_screen()
	for _step in range(4):
		bridge.move_save_selection(1)
	bridge.accept_save_selection()
	_check(bridge.is_button_config_screen(), "button config opens")
	_check(bridge.get_button_config_focus_label() == "A: JUMP", "A stage starts on jump")
	_check(bridge.translate_gameplay_input(bridge.A_BUTTON) == bridge.A_BUTTON, "normal jump")
	bridge.adjust_save_selection(1)
	_check(bridge.get_button_config_focus_label() == "A: ATTACK", "A stage cycles actions")
	_check(bridge.translate_gameplay_input(bridge.A_BUTTON) == bridge.B_BUTTON, "reverse jump")
	bridge.accept_save_selection()
	_check(bridge.get_save_menu_index() == 1, "A confirms into B stage")
	bridge.adjust_save_selection(1)
	_check(bridge._button_bindings[1] != bridge._button_bindings[0], "B stage avoids A conflict")
	bridge.accept_save_selection()
	_check(bridge.get_save_menu_index() == 2, "B confirms into R stage")
	var before_r_adjust: Array = bridge._button_bindings.duplicate()
	bridge.adjust_save_selection(1)
	_check(bridge._button_bindings == before_r_adjust, "R stage ignores direction")
	bridge.cancel_save_selection()
	_check(bridge.get_save_menu_index() == 1, "R B returns to B stage")
	bridge.trigger_save_special_action()
	_check(bridge._button_bindings == ["JUMP", "ATTACK", "TRICK"], "select restores defaults")
	bridge.cancel_save_selection()
	_check(bridge.is_options_main_screen(), "button config cancel")
	bridge.open_options_screen()
	for _step in range(4):
		bridge.move_save_selection(1)
	bridge.accept_save_selection()
	bridge.adjust_save_selection(1)
	bridge.accept_save_selection()
	bridge.accept_save_selection()
	bridge.accept_save_selection()
	_check(bridge.is_options_main_screen(), "button config commit")
	_check(bridge._button_bindings[0] == "ATTACK", "A assignment persists")
	_check(bridge._button_bindings.size() == 3 and bridge._button_bindings[0] != bridge._button_bindings[1] and bridge._button_bindings[1] != bridge._button_bindings[2], "permutation persists")
	bridge._button_bindings = original
	bridge._button_bindings_before_edit = original.duplicate()
	bridge._save_save_data()
	print("BUTTON_CONFIG_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("BUTTON_CONFIG_FAIL: " + label)
