class_name CheckpointState
extends RefCounted

## Owns stage spawn, latest respawn point, and checkpoint elapsed time.

var spawn_x: float = 0.0
var spawn_y: float = 0.0
var respawn_x: float = 0.0
var respawn_y: float = 0.0
var checkpoint_time: float = 0.0

func begin(spawn: Vector2) -> void:
	spawn_x = spawn.x
	spawn_y = spawn.y
	respawn_x = spawn.x
	respawn_y = spawn.y
	checkpoint_time = 0.0

func set_checkpoint(position: Vector2, elapsed_time: float) -> void:
	respawn_x = position.x
	respawn_y = position.y
	checkpoint_time = elapsed_time
