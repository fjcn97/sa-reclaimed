extends SceneTree

const STATE := preload("res://scripts/core/CourseSelectTravelState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var state := STATE.new()
	state.reset(2)
	_check(state.from_index == 2 and state.to_index == 2, "reset anchors marker to selected course")
	_check(state.begin(2, 1, 4) == 3, "starts travel to adjacent unlocked course")
	_check(state.is_traveling() and not state.is_settling(), "travel is active before settling")
	state.advance(0.09)
	_check(is_equal_approx(state.travel_progress(), 0.5), "reports half travel progress")
	_check(not state.advance(0.09), "starting settle does not complete it")
	_check(state.is_settling() and not state.is_traveling(), "switches to settling after travel")
	_check(state.advance(0.10), "completes settling exactly once")
	_check(not state.is_settling() and is_equal_approx(state.settle_progress(), 1.0), "settle completion is stable")
	_check(state.begin(0, -1, 4) == -1, "clamped direction does not start travel")
	print("COURSE_SELECT_TRAVEL_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("COURSE_SELECT_TRAVEL_STATE_FAIL: " + label)
