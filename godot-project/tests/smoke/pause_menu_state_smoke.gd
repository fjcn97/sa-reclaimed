extends SceneTree

const STATE := preload("res://scripts/core/PauseMenuState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var state := STATE.new()
	state.open(true)
	_check(state.a_hold_lock and state.a_previous_held and state.menu_index == 0, "opening from A press owns release lock")
	_check(not state.consume_a_release(false), "initial A release is consumed")
	_check(not state.a_hold_lock, "initial release clears lock")
	_check(not state.consume_a_release(true), "later A press does not confirm")
	_check(state.consume_a_release(false), "later A release confirms selection")
	state.select(1)
	_check(state.menu_index == 1, "down selects quit action")
	state.select(-1)
	_check(state.menu_index == 0, "up selects continue action")
	state.reset()
	_check(state.menu_index == 0 and not state.a_hold_lock and not state.a_previous_held, "reset clears pause state")
	print("PAUSE_MENU_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PAUSE_MENU_STATE_FAIL: " + label)
