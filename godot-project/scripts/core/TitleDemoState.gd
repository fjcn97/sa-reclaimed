class_name TitleDemoState
extends RefCounted

## Owns the press-start idle countdown and recorded-demo lifecycle.
var idle_time: float = 0.0
var active: bool = false
var elapsed: float = 0.0

func reset() -> void:
	idle_time = 0.0
	active = false
	elapsed = 0.0

func advance_idle(delta: float, has_input: bool, idle_duration: float = 15.0) -> bool:
	idle_time = 0.0 if has_input else idle_time + delta
	return idle_time >= idle_duration

func start() -> void:
	idle_time = 0.0
	active = true
	elapsed = 0.0

## Returns true when the recorded demo reaches its automatic end.
func advance(delta: float, end_duration: float = 20.0) -> bool:
	if not active:
		return false
	elapsed += delta
	return elapsed >= end_duration

func frame_input(confirm_mask: int, period: float = 2.4, window: float = 0.08) -> int:
	return confirm_mask if active and fmod(elapsed, period) < window else 0
