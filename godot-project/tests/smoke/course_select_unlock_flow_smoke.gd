extends SceneTree

const FLOW := preload("res://scripts/core/CourseSelectUnlockFlow.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var flow := FLOW.new()
	_check(flow.start(1.0) == "NEW COURSE PATH UNLOCKING", "starts with path notice")
	_check(flow.phase == FLOW.PHASE_PATH and flow.is_active(), "starts in active path phase")
	_check(flow.advance(0.5, 0.25, "TEST COURSE") == "NEW COURSE PATH UNLOCKING", "retains path notice while timing")
	_check(is_equal_approx(flow.progress(), 0.5), "reports path progress")
	_check(flow.advance(0.5, 0.25, "TEST COURSE") == "NEW COURSE PATH OPEN", "opens the new path")
	_check(flow.phase == FLOW.PHASE_SCROLL_BACK, "moves to scroll-back phase")
	flow.advance(0.35, 0.25, "TEST COURSE")
	_check(flow.phase == FLOW.PHASE_SCROLL_NEXT and flow.notice_text == "MOVING TO NEW COURSE", "moves to next-course scroll")
	flow.advance(0.55, 0.25, "TEST COURSE")
	_check(flow.phase == FLOW.PHASE_PAUSE and flow.notice_text == "NEW COURSE READY", "pauses on ready notice")
	_check(flow.advance(0.25, 0.25, "TEST COURSE") == "COURSE READY: TEST COURSE", "finishes with selected course notice")
	_check(not flow.is_active(), "stops after final pause")
	flow.reset()
	_check(not flow.is_active() and flow.notice_text.is_empty(), "reset clears owned state")
	print("COURSE_SELECT_UNLOCK_FLOW_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("COURSE_SELECT_UNLOCK_FLOW_FAIL: " + label)
