class_name RunModeState
extends RefCounted

## Owns the current playable session's mode flags.

var from_time_attack: bool = false
var from_multiplayer: bool = false

func begin(time_attack: bool, multiplayer: bool) -> void:
	from_time_attack = time_attack
	from_multiplayer = multiplayer

func reset() -> void:
	begin(false, false)
