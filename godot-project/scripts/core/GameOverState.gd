class_name GameOverState
extends RefCounted

## Owns the automatic Game Over / Time Over sequence timers.
var timer: float = 0.0
var input_lock_timer: float = 0.0
var time_over: bool = false
var duration: float = 0.0

func reset() -> void:
	timer = 0.0
	input_lock_timer = 0.0
	time_over = false
	duration = 0.0

func start(is_time_over: bool, game_over_duration: float, time_over_duration: float) -> void:
	time_over = is_time_over
	duration = time_over_duration if time_over else game_over_duration
	timer = duration
	input_lock_timer = 0.0

## Returns true exactly once when the automatic sequence expires.
func advance(delta: float) -> bool:
	input_lock_timer = maxf(0.0, input_lock_timer - delta)
	if timer <= 0.0:
		return false
	timer = maxf(0.0, timer - delta)
	return timer <= 0.0

func is_input_ready() -> bool:
	return input_lock_timer <= 0.0

func progress() -> float:
	if duration <= 0.0:
		return 1.0
	return clampf(1.0 - (timer / duration), 0.0, 1.0)
