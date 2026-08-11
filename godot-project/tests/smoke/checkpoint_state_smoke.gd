extends SceneTree

const CHECKPOINT_STATE := preload("res://scripts/core/CheckpointState.gd")

func _init() -> void:
	var state = CHECKPOINT_STATE.new()
	state.begin(Vector2(120.0, 96.0))
	_check(state.spawn_x == 120.0 and state.respawn_y == 96.0, "begin aligns spawn and respawn")
	state.set_checkpoint(Vector2(320.0, 140.0), 37.5)
	_check(state.respawn_x == 320.0 and state.respawn_y == 140.0, "checkpoint updates respawn")
	_check(state.checkpoint_time == 37.5, "checkpoint retains elapsed time")
	print("CHECKPOINT_STATE_CHECKS=3")
	quit(0)

func _check(condition: bool, message: String) -> void:
	if not condition:
		push_error("CHECKPOINT_STATE_FAILED " + message)
		quit(1)
