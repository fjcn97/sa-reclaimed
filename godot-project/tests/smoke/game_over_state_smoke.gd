extends SceneTree

const STATE := preload("res://scripts/core/GameOverState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var state := STATE.new()
	state.start(false, 4.0, 2.0)
	_check(not state.time_over and is_equal_approx(state.timer, 4.0), "normal game over uses normal duration")
	_check(is_equal_approx(state.progress(), 0.0), "normal game over starts at zero progress")
	_check(not state.advance(2.0) and is_equal_approx(state.progress(), 0.5), "normal game over advances without completing")
	_check(state.advance(2.0), "normal game over completes once")
	_check(not state.advance(0.1), "completed sequence does not resolve again")
	state.start(true, 4.0, 2.0)
	_check(state.time_over and is_equal_approx(state.timer, 2.0), "time over uses time-over duration")
	_check(state.is_input_ready(), "default automatic sequence has no input lock")
	state.input_lock_timer = 0.5
	_check(not state.is_input_ready(), "input lock is state-owned")
	state.advance(0.5)
	_check(state.is_input_ready(), "advance releases input lock")
	state.reset()
	_check(not state.time_over and is_zero_approx(state.timer), "reset clears lifecycle state")
	print("GAME_OVER_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("GAME_OVER_STATE_FAIL: " + label)
