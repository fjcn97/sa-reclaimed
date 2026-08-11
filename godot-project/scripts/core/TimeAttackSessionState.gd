class_name TimeAttackSessionState
extends RefCounted

## Owns the selected time-attack mode, lobby position, and result return timers.

var result_timer: float = 0.0
var exit_timer: float = 0.0
var lobby_cursor: int = 0
var boss_mode: bool = false

func reset() -> void:
	result_timer = 0.0
	exit_timer = 0.0
	lobby_cursor = 0
	boss_mode = false

func open_lobby(is_boss_mode: bool) -> void:
	boss_mode = is_boss_mode
	lobby_cursor = 0
	result_timer = 0.0
	exit_timer = 0.0
