extends SceneTree

const STATE := preload("res://scripts/core/TitleDemoState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var state := STATE.new()
	_check(not state.advance_idle(14.9, false), "idle countdown waits for full duration")
	_check(state.advance_idle(0.1, false), "idle countdown reaches demo threshold")
	_check(not state.advance_idle(1.0, true) and is_zero_approx(state.idle_time), "input resets idle countdown")
	state.start()
	_check(state.active and is_zero_approx(state.elapsed), "demo start resets elapsed time")
	_check(state.frame_input(4) == 4, "demo emits confirm pulse at start")
	_check(not state.advance(19.9), "demo remains active before end duration")
	_check(state.advance(0.1), "demo reaches automatic end duration")
	state.reset()
	_check(not state.active and is_zero_approx(state.idle_time) and is_zero_approx(state.elapsed), "reset clears demo lifecycle")
	print("TITLE_DEMO_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TITLE_DEMO_STATE_FAIL: " + label)
