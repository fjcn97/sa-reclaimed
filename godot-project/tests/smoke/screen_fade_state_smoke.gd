extends SceneTree

const STATE := preload("res://scripts/core/ScreenFadeState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var state := STATE.new()
	state.advance(0.0, 1, 0, false, false, false)
	_check(is_zero_approx(state.opacity()), "first observed state does not flash")
	state.advance(0.1, 2, 0, false, false, false)
	_check(is_equal_approx(state.opacity(), 0.64), "state transition fades at configured speed")
	state.advance(0.1, 2, 0, false, false, false)
	_check(is_equal_approx(state.opacity(), 0.28), "fade decays without another transition")
	state.advance(0.1, 2, 0, true, false, false)
	_check(is_zero_approx(state.opacity()), "suppressed menu state clears fade")
	state.advance(0.0, 3, 0, false, false, true)
	_check(is_zero_approx(state.opacity()), "paused transition does not flash")
	state.advance(0.0, 4, 0, false, false, false)
	_check(is_equal_approx(state.opacity(), 1.0), "active state transition begins full fade")
	state.reset()
	_check(is_zero_approx(state.opacity()) and state.last_state == -1, "reset clears observation state")
	print("SCREEN_FADE_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SCREEN_FADE_STATE_FAIL: " + label)
