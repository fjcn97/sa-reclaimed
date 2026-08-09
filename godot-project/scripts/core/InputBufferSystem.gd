class_name InputBufferSystem
extends RefCounted

var jump_buffer_timer: float = 0.0
var _frame_history: Array = []

func reset(frame_count: int) -> void:
	_frame_history.clear()
	for _i in range(frame_count):
		_frame_history.append(0)
	jump_buffer_timer = 0.0

func advance(delta: float) -> void:
	jump_buffer_timer = maxf(0.0, jump_buffer_timer - delta)

func record(frame_input: int, frame_count: int) -> void:
	_frame_history.push_front(frame_input)
	while _frame_history.size() > frame_count:
		_frame_history.pop_back()

func request_jump(frame_input: int, is_grounded: bool, jump_buffer_duration: float, jump_button: int) -> void:
	if frame_input & jump_button and not is_grounded:
		jump_buffer_timer = jump_buffer_duration

func consume_jump() -> void:
	jump_buffer_timer = 0.0

func recent_mask(window: int) -> int:
	var mask := 0
	var count := mini(window, _frame_history.size())
	for i in range(count):
		mask |= int(_frame_history[i])
	return mask
