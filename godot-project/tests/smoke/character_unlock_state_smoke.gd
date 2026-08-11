extends SceneTree

const CHARACTER_UNLOCK_STATE := preload("res://scripts/core/CharacterUnlockState.gd")

func _init() -> void:
	var state = CHARACTER_UNLOCK_STATE.new()
	state.begin(3, 4, 340, 300)
	_check(state.pending_character == 3, "queued character is retained")
	_check(state.segment == 0 and state.scene_frame == 0.0, "unlock begins at the first frame")
	state.advance(341.0 / 60.0, 4, 340, 300)
	_check(state.segment == 1 and state.scene_frame == 0.0, "segment advances after source frame duration")
	state.segment = 4
	state.scene_frame = 300.0
	_check(state.advance(1.0 / 60.0, 4, 340, 300), "final scene signals completion")
	state.reset()
	_check(state.pending_character == -1 and state.segment == 0, "reset clears unlock state")
	print("CHARACTER_UNLOCK_STATE_CHECKS=5")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error("CHARACTER_UNLOCK_STATE_FAILED " + message)
		quit(1)
