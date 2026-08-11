extends SceneTree

const STATE := preload("res://scripts/core/CourseSelectPresentationState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var state := STATE.new()
	state.reset(12)
	_check(state.return_phase == 12 and not state.is_intro() and not state.is_starting(), "reset owns default return phase")
	state.open(18)
	_check(state.return_phase == 18 and state.is_intro(), "open begins intro and stores return phase")
	state.advance_intro(0.17)
	_check(is_equal_approx(state.intro_progress(), 0.5), "reports intro progress")
	state.request_confirmation()
	_check(state.consume_confirmation() and state.is_starting(), "consumes pending confirmation into start")
	_check(not state.consume_confirmation(), "confirmation is consumed once")
	state.advance_start(0.12)
	_check(is_equal_approx(state.start_progress(), 0.5), "reports start progress")
	_check(state.advance_start(0.12), "launch completes exactly once")
	_check(not state.advance_start(0.01), "completed launch does not repeat")
	state.open(3)
	state.start()
	state.cancel_start()
	_check(not state.is_starting(), "travel can cancel pending launch")
	print("COURSE_SELECT_PRESENTATION_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("COURSE_SELECT_PRESENTATION_STATE_FAIL: " + label)
