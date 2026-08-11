class_name CourseSelectUnlockFlow
extends RefCounted

## Owns course-path reveal state. The bridge observes this object and applies
## the returned presentation notice, rather than exposing its private fields.
const PHASE_PATH := 0
const PHASE_SCROLL_BACK := 1
const PHASE_SCROLL_NEXT := 2
const PHASE_PAUSE := 3

var phase: int = PHASE_PATH
var phase_timer: float = 0.0
var phase_duration: float = 0.0
var timer: float = 0.0
var notice_text: String = ""

func reset() -> void:
	phase = PHASE_PATH
	phase_timer = 0.0
	phase_duration = 0.0
	timer = 0.0
	notice_text = ""

func start(path_duration: float) -> String:
	phase = PHASE_PATH
	phase_duration = path_duration
	phase_timer = phase_duration
	timer = phase_timer
	notice_text = "NEW COURSE PATH UNLOCKING"
	return notice_text

func advance(delta: float, pause_duration: float, ready_course_text: String) -> String:
	phase_timer = maxf(0.0, phase_timer - delta)
	if phase_timer > 0.0:
		timer = phase_timer
		return notice_text
	match phase:
		PHASE_PATH:
			_begin_phase(PHASE_SCROLL_BACK, 0.35, "NEW COURSE PATH OPEN")
		PHASE_SCROLL_BACK:
			_begin_phase(PHASE_SCROLL_NEXT, 0.55, "MOVING TO NEW COURSE")
		PHASE_SCROLL_NEXT:
			_begin_phase(PHASE_PAUSE, pause_duration, "NEW COURSE READY")
		PHASE_PAUSE:
			phase_timer = 0.0
			timer = 0.0
			notice_text = "COURSE READY: %s" % ready_course_text
	if phase != PHASE_PAUSE:
		timer = phase_timer
	return notice_text

func is_active() -> bool:
	return timer > 0.0

func progress() -> float:
	if phase_duration <= 0.0:
		return 1.0
	return clampf(1.0 - (phase_timer / phase_duration), 0.0, 1.0)

func _begin_phase(next_phase: int, duration: float, next_notice: String) -> void:
	phase = next_phase
	phase_duration = duration
	phase_timer = duration
	notice_text = next_notice
