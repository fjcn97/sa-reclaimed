class_name StageIntroSystem
extends RefCounted

## Drives the stage-entry countdown and hands control to active gameplay.

static func advance(bridge: Object, delta: float, frame_input: int) -> bool:
	if bridge.get_game_state() != bridge.GAME_STATE_INTRO:
		return false
	var state = bridge.get_stage_intro_state()
	# countdown.c only enables the boost from a newly pressed Right input.
	if frame_input & bridge.DPAD_RIGHT:
		if state.intro_timer < bridge.INTRO_BOOST_WINDOW and not state.intro_boost_disabled:
			state.intro_speed_boost = true
		elif state.intro_timer >= bridge.INTRO_BOOST_WINDOW:
			state.intro_boost_disabled = true
	if (frame_input & bridge.A_BUTTON or frame_input & bridge.B_BUTTON) and state.intro_timer > bridge.INTRO_COUNTDOWN_START and bridge.can_skip_intro():
		state.intro_timer = bridge.INTRO_COUNTDOWN_START
	state.intro_timer = maxf(0.0, state.intro_timer - delta)
	if state.intro_timer <= bridge.INTRO_GO_TIME:
		state.intro_primed = true
		bridge.set_status_text("GO!")
	elif state.intro_timer <= bridge.INTRO_COUNTDOWN_START:
		state.intro_primed = true
		bridge.set_status_text("BOSS READY" if bridge.is_boss_intro() else bridge.get_intro_countdown_text())
	else:
		bridge.set_status_text("READY!")
	if state.intro_timer <= 0.0:
		bridge.set_game_state(bridge.GAME_STATE_PLAYING)
		state.race_start_message_timer = 0.0 if bridge.is_boss_intro() else 1.0
		state.start_boost_timer = bridge.INTRO_BOOST_DURATION if state.intro_speed_boost and not state.intro_boost_disabled else 0.0
		bridge.get_player_state().speed_x = bridge.INTRO_BOOST_SPEED if state.start_boost_timer > 0.0 else 0.0
		bridge.get_player_state().ground_speed = bridge.get_player_state().speed_x
		bridge.set_status_text("DEFEAT THE BOSS" if bridge.is_boss_intro() else ("OUTRUN RIVALS" if bridge.get_run_mode_state().from_multiplayer else "REACH THE GOAL"))
	bridge.update_camera()
	return true
