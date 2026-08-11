extends SceneTree

const STATE := preload("res://scripts/core/FrontendIntroState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var state := STATE.new()
	state.start("title", 1.0)
	_check(not state.is_ready("title") and is_equal_approx(state.progress("title", 1.0), 0.0), "started screen begins closed")
	state.advance("title", 0.4)
	_check(is_equal_approx(state.progress("title", 1.0), 0.4), "screen intro reports progress")
	state.cap("title", 0.25)
	_check(is_equal_approx(state.timer("title"), 0.25), "skip caps remaining sweep")
	state.advance("title", 0.25)
	_check(state.is_ready("title"), "intro becomes ready at zero")
	state.start("character", 2.0)
	state.stop("character")
	_check(state.is_ready("character"), "stop immediately readies an intro")
	state.reset()
	_check(state.is_ready("title") and state.is_ready("character"), "reset clears all keyed timers")
	print("FRONTEND_INTRO_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("FRONTEND_INTRO_STATE_FAIL: " + label)
