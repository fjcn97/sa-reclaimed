class_name GameplayFramePreparationFlow
extends RefCounted

## Updates shared per-frame gameplay timers and resolves the time-limit exit.
## Returns true when the active run was ended by the time limit.
static func advance(bridge: Object, delta: float) -> bool:
	var runtime: GameplayRuntimeState = bridge.get_gameplay_runtime_state()
	var abilities: PlayerAbilityState = bridge.get_player_ability_state()
	runtime.elapsed_time += delta
	bridge.update_super_sonic(delta)
	bridge.get_stage_intro_state().start_boost_timer = maxf(0.0, bridge.get_stage_intro_state().start_boost_timer - delta)
	abilities.attack_timer = maxf(0.0, abilities.attack_timer - delta)
	abilities.flight_timer = maxf(0.0, abilities.flight_timer - delta)
	abilities.glide_timer = maxf(0.0, abilities.glide_timer - delta)
	var time_limit_active: bool = bridge.is_time_attack_run() or bridge.get_profile_state().time_limit_enabled
	if not time_limit_active or runtime.elapsed_time < bridge.MAX_COURSE_TIME_SECONDS:
		return false
	if bridge.is_time_attack_run():
		bridge.open_time_attack_lobby(bridge.get_time_attack_session_state().boss_mode)
	else:
		bridge.open_game_over(true)
	bridge.update_camera()
	return true
