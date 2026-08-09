extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node_or_null("CoreBridge")
	if bridge == null:
		bridge = preload("res://scripts/CoreBridge.gd").new()
		bridge.name = "CoreBridge"
		get_root().add_child(bridge)
	bridge.open_options_screen()
	bridge._options_mode = bridge.OPTIONS_MODE_SOUND_TEST
	bridge._sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
	bridge._sound_test_track_index = 0
	_check(bridge.get_sound_test_track_count() == 57, "standard list matches source sound count")
	_check(bridge.get_sound_test_track_name() == "OPENING", "first source track name")
	bridge._language_index = 2
	_check(bridge.get_sound_test_track_number_text() == "NR. 01", "sound test track number follows the saved language")
	bridge._language_index = 1

	bridge.adjust_save_selection(-1)
	bridge.adjust_save_selection(1)
	_check(bridge._sound_test_track_index == 0, "left and right are both consumed in source order")
	bridge._sound_test_track_index = 2
	bridge.move_save_selection(-1)
	bridge.move_save_selection(1)
	_check(bridge._sound_test_track_index == 2, "up and down are both consumed in source order")
	bridge._sound_test_track_index = 0
	bridge.move_save_selection(1)
	_check(bridge._sound_test_track_index == bridge.get_sound_test_track_count() - 1, "down wraps from first track to last")
	bridge.move_save_selection(-1)
	_check(bridge._sound_test_track_index == 0, "up wraps from last track to first")
	bridge.move_save_selection(-1)
	_check(bridge._sound_test_track_index == 10, "up advances one sound-test column")

	bridge.accept_save_selection()
	bridge.cancel_save_selection()
	_check(bridge._sound_test_state == bridge.SOUND_TEST_STATE_STOPPED, "A then B leaves sound test stopped")
	bridge.cancel_save_selection()
	_check(bridge.is_options_main_screen(), "B exits stopped sound test")

	print("SOUND_TEST_INPUT_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SOUND_TEST_INPUT_FAIL: " + label)
