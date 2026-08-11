class_name MultiplayerLobbyState
extends RefCounted

## Owns post-match lobby selection, acknowledgement, and outcome timing.

var cursor: int = 0
var waiting: bool = false
var wait_timer: float = 0.0
var wait_duration: float = 0.8
var exit_timer: float = 0.0
var outcome_type: int = 0
var outcome_timer: float = 0.0
var outcome_duration: float = (120.0 + 16.0) / 60.0
var outcome_return_phase: int = 0
var course_results_committed: bool = false

func reset(default_return_phase: int) -> void:
	cursor = 0
	waiting = false
	wait_timer = 0.0
	exit_timer = 0.0
	outcome_type = 0
	outcome_timer = 0.0
	outcome_return_phase = default_return_phase
	course_results_committed = false

func open_lobby(selected_cursor: int, item_count: int) -> void:
	cursor = clampi(selected_cursor, 0, max(item_count - 1, 0))
	waiting = false
	wait_timer = 0.0
	exit_timer = 0.0

func begin_wait() -> void:
	waiting = true
	wait_timer = wait_duration

func begin_exit(duration: float) -> void:
	exit_timer = duration

func open_outcome(outcome: int, return_phase: int) -> void:
	outcome_type = clampi(outcome, 0, 1)
	outcome_return_phase = return_phase
	outcome_timer = outcome_duration

func advance_outcome(delta: float) -> bool:
	if outcome_timer <= 0.0:
		return false
	outcome_timer = maxf(0.0, outcome_timer - delta)
	return outcome_timer <= 0.0

func advance_lobby(delta: float) -> Dictionary:
	exit_timer = maxf(0.0, exit_timer - delta)
	wait_timer = maxf(0.0, wait_timer - delta)
	return {"exit_complete": exit_timer <= 0.0, "wait_complete": waiting and wait_timer <= 0.0}
