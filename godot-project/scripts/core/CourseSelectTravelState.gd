class_name CourseSelectTravelState
extends RefCounted

## Owns the course-map travel and settle interpolation state.
var travel_duration: float = 0.18
var settle_duration: float = 0.10
var travel_timer: float = 0.0
var settle_timer: float = 0.0
var from_index: int = 0
var to_index: int = 0

func reset(selected_index: int) -> void:
	travel_timer = 0.0
	settle_timer = 0.0
	from_index = selected_index
	to_index = selected_index

func begin(selected_index: int, direction: int, max_index: int) -> int:
	from_index = selected_index
	to_index = clampi(selected_index + direction, 0, max_index)
	if to_index == from_index:
		return -1
	travel_timer = travel_duration
	settle_timer = 0.0
	return to_index

## Returns true exactly once when travel settles.
func advance(delta: float) -> bool:
	if travel_timer > 0.0:
		travel_timer = maxf(0.0, travel_timer - delta)
		if travel_timer <= 0.0:
			settle_timer = settle_duration
	if settle_timer <= 0.0:
		return false
	settle_timer = maxf(0.0, settle_timer - delta)
	return settle_timer <= 0.0

func is_traveling() -> bool:
	return travel_timer > 0.0

func is_settling() -> bool:
	return settle_timer > 0.0

func travel_progress() -> float:
	return _progress(travel_timer, travel_duration)

func settle_progress() -> float:
	return _progress(settle_timer, settle_duration)

func _progress(timer: float, duration: float) -> float:
	if duration <= 0.0 or timer <= 0.0:
		return 1.0
	return clampf(1.0 - (timer / duration), 0.0, 1.0)
