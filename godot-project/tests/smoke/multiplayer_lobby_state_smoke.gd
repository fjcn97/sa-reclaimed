extends SceneTree

const MULTIPLAYER_LOBBY_STATE := preload("res://scripts/core/MultiplayerLobbyState.gd")

var checks: int = 0
var failed: bool = false

func _init() -> void:
	var state = MULTIPLAYER_LOBBY_STATE.new()
	state.reset(7)
	_check(state.outcome_return_phase == 7 and not state.waiting, "reset restores lobby defaults")
	state.open_lobby(9, 2)
	_check(state.cursor == 1 and state.exit_timer == 0.0, "lobby open clamps cursor and clears exit")
	state.begin_wait()
	_check(state.waiting and is_equal_approx(state.wait_timer, state.wait_duration), "wait starts from configured duration")
	var timers := state.advance_lobby(state.wait_duration)
	_check(bool(timers.wait_complete), "wait completion is reported")
	state.open_outcome(4, 12)
	_check(state.outcome_type == 1 and state.outcome_return_phase == 12, "outcome is clamped and routed")
	_check(state.advance_outcome(state.outcome_duration), "outcome completion is reported")
	state.begin_exit(0.25)
	timers = state.advance_lobby(0.25)
	_check(bool(timers.exit_complete), "exit completion is reported")
	print("MULTIPLAYER_LOBBY_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MULTIPLAYER_LOBBY_STATE_FAIL: " + label)
