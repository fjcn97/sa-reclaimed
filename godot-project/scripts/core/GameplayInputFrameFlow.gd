class_name GameplayInputFrameFlow
extends RefCounted

## Records a frame's input and advances timers shared by all game states.
static func advance(bridge: Object, frame_input: int, delta: float) -> void:
	var runtime: GameplayRuntimeState = bridge.get_gameplay_runtime_state()
	var abilities: PlayerAbilityState = bridge.get_player_ability_state()
	bridge.set_frame_input(frame_input)
	bridge.update_screen_shake(delta)
	bridge.record_input_frame(frame_input)
	bridge.get_input_buffer_system().advance(delta)
	bridge.get_input_buffer_system().request_jump(frame_input, bridge.get_player_state().is_grounded, bridge.JUMP_BUFFER_DURATION, bridge.A_BUTTON)
	abilities.damage_cooldown = maxf(0.0, abilities.damage_cooldown - delta)
	abilities.invincibility_timer = maxf(0.0, abilities.invincibility_timer - delta)
	bridge.get_gameplay_runtime_state().speed_up_timer = maxf(0.0, bridge.get_gameplay_runtime_state().speed_up_timer - delta)
	bridge.get_dash_effect_state().boost_effect_timer = maxf(0.0, bridge.get_dash_effect_state().boost_effect_timer - delta)
	runtime.spindash_release_timer = maxf(0.0, runtime.spindash_release_timer - delta)
	runtime.braking_dust_cooldown = maxf(0.0, runtime.braking_dust_cooldown - delta)
