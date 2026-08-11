class_name CourseSelectPresentationState
extends RefCounted

## Owns course-select entry, confirmation, and launch presentation state.
var intro_duration: float = 0.34
var start_duration: float = 0.24
var return_phase: int = 0
var intro_timer: float = 0.0
var start_timer: float = 0.0
var confirm_pending: bool = false

func reset(default_return_phase: int) -> void:
	return_phase = default_return_phase
	intro_timer = 0.0
	start_timer = 0.0
	confirm_pending = false

func open(next_return_phase: int) -> void:
	return_phase = next_return_phase
	intro_timer = intro_duration
	start_timer = 0.0
	confirm_pending = false

func cancel_start() -> void:
	start_timer = 0.0

func request_confirmation() -> void:
	confirm_pending = true

func consume_confirmation() -> bool:
	if not confirm_pending:
		return false
	confirm_pending = false
	start()
	return true

func start() -> void:
	start_timer = start_duration

func advance_intro(delta: float) -> void:
	intro_timer = maxf(0.0, intro_timer - delta)

## Returns true exactly once when launch presentation has completed.
func advance_start(delta: float) -> bool:
	if start_timer <= 0.0:
		return false
	start_timer = maxf(0.0, start_timer - delta)
	return start_timer <= 0.0

func is_starting() -> bool:
	return start_timer > 0.0

func is_intro() -> bool:
	return intro_timer > 0.0

func intro_progress() -> float:
	return _progress(intro_timer, intro_duration)

func start_progress() -> float:
	return _progress(start_timer, start_duration)

func _progress(timer: float, duration: float) -> float:
	if duration <= 0.0 or timer <= 0.0:
		return 1.0
	return clampf(1.0 - (timer / duration), 0.0, 1.0)
