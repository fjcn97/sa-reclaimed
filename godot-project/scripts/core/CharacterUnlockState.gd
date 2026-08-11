class_name CharacterUnlockState
extends RefCounted

## Owns the currently queued character-unlock scene and its source-frame timing.

var timer: float = 0.0
var segment: int = 0
var scene_frame: float = 0.0
var pending_character: int = -1

func reset() -> void:
	timer = 0.0
	segment = 0
	scene_frame = 0.0
	pending_character = -1

func begin(character_index: int, segment_count: int, segment_frames: int, final_frames: int) -> void:
	pending_character = character_index
	timer = (segment_count * (segment_frames + 2) + final_frames + 2) / 60.0
	segment = 0
	scene_frame = 0.0

func advance(delta: float, segment_count: int, segment_frames: int, final_frames: int) -> bool:
	timer = maxf(0.0, timer - delta)
	scene_frame += delta * 60.0
	if segment < segment_count:
		if scene_frame > segment_frames:
			segment += 1
			scene_frame = 0.0
	elif scene_frame > final_frames:
		return true
	return false
