class_name GameplayPlayerSimulationFlow
extends RefCounted

## Advances character movement, action states, collision and camera for one gameplay frame.
static func advance(bridge: Object, held_input: int, frame_input: int, delta: float) -> void:
	var runtime: GameplayRuntimeState = bridge.get_gameplay_runtime_state()
	var previous_world_x: float = bridge.get_player_state().world_x
	var previous_world_y: float = bridge.get_player_state().world_y
	bridge.update_platform_motion(delta)

	var move_direction: int = 0
	if held_input & bridge.DPAD_LEFT:
		move_direction -= 1
	if held_input & bridge.DPAD_RIGHT:
		move_direction += 1
	var speed_multiplier: float = 1.35 if runtime.speed_up_timer > 0.0 else 1.0
	var snow_multiplier: float = 0.95 if bridge.get_stage_surface_state().on_slowing_snow else 1.0
	var current_move_speed: float = (bridge.INTRO_BOOST_SPEED if bridge.get_stage_intro_state().start_boost_timer > 0.0 else runtime.move_speed) * speed_multiplier * snow_multiplier
	if bridge.get_player_state().super_sonic:
		current_move_speed = 900.0 * speed_multiplier
	var current_move_direction: int = 1 if bridge.get_stage_intro_state().start_boost_timer > 0.0 and move_direction == 0 else move_direction
	var gravity_direction: float = -1.0 if runtime.gravity_inverted else 1.0
	if bridge.get_player_state().is_grounded and current_move_direction != 0 and absf(bridge.get_player_state().speed_x) > 160.0 and signf(bridge.get_player_state().speed_x) != signf(current_move_direction) and runtime.braking_dust_cooldown <= 0.0:
		bridge.spawn_dust_cloud(bridge.get_player_state().world_x, bridge.get_player_state().world_y)
		runtime.braking_dust_cooldown = 0.10
	_handle_action_input(bridge, held_input, frame_input)

	if bridge.DASH_EFFECT_SYSTEM.advance(bridge, delta):
		pass
	elif runtime.spindash_charging:
		bridge.get_player_state().is_grounded = true
		bridge.get_player_state().speed_x = 0.0
		bridge.get_player_state().ground_speed = 0.0
		bridge.get_player_state().char_state = 8
		bridge.get_player_state().anim_id = 2
		if held_input & bridge.DPAD_DOWN:
			runtime.spindash_charge = minf(1.0, runtime.spindash_charge + delta * 1.8)
		else:
			runtime.spindash_charging = false
			runtime.spindash_release_timer = 0.55
			runtime.spindash_velocity_x = runtime.facing_direction * (260.0 + runtime.spindash_charge * 360.0)
			runtime.spindash_charge = 0.0
			bridge.spawn_dust_cloud(bridge.get_player_state().world_x, bridge.get_player_state().world_y)
	elif runtime.spindash_release_timer > 0.0:
		bridge.get_player_state().is_grounded = true
		bridge.get_player_state().world_x += runtime.spindash_velocity_x * delta
		bridge.get_player_state().speed_x = runtime.spindash_velocity_x
		bridge.get_player_state().ground_speed = runtime.spindash_velocity_x
		bridge.get_player_state().char_state = 5
		bridge.get_player_state().anim_id = 2
		if fmod(runtime.spindash_release_timer, 0.12) < delta:
			bridge.spawn_dust_cloud(bridge.get_player_state().world_x, bridge.get_player_state().world_y)
	elif runtime.grind_timer > 0.0:
		_advance_grind(bridge, frame_input, delta)
	else:
		_advance_standard_movement(bridge, current_move_direction, current_move_speed, gravity_direction, frame_input, delta)

	_advance_air_abilities(bridge, held_input, frame_input, current_move_direction, current_move_speed, gravity_direction, delta)
	bridge.get_player_state().world_y += runtime.velocity_y * delta
	bridge.get_player_state().speed_y = runtime.velocity_y
	bridge.get_player_state().world_x = clamp(bridge.get_player_state().world_x, bridge.get_level_state().min_x, bridge.get_level_state().max_x)
	bridge.resolve_platforms(previous_world_x, previous_world_y)
	bridge.handle_fall_and_restart()
	bridge.get_player_state().anim_id = 1 if bridge.get_player_state().is_grounded and move_direction != 0 else 0
	bridge.get_player_state().rotation = int(clamp(runtime.velocity_y / 8.0, -16.0, 16.0))
	bridge.handle_entity_interactions(held_input, frame_input, delta)
	bridge.sync_grind_effect()
	bridge.store_boost_effect_position()
	bridge.update_camera()

static func _handle_action_input(bridge: Object, held_input: int, frame_input: int) -> void:
	var runtime: GameplayRuntimeState = bridge.get_gameplay_runtime_state()
	var abilities: PlayerAbilityState = bridge.get_player_ability_state()
	if not (frame_input & bridge.B_BUTTON):
		return
	if bridge.get_player_state().is_grounded and held_input & bridge.DPAD_DOWN:
		runtime.spindash_charging = true
		runtime.spindash_charge = maxf(runtime.spindash_charge, 0.08)
		bridge.spindash_direction_from_player()
	elif bridge.get_player_state().variant == 3 and not bridge.get_player_state().is_grounded:
		abilities.glide_timer = 1.0
		bridge.get_player_state().char_state = 7
	else:
		abilities.attack_timer = 0.22
		bridge.get_player_state().char_state = 8
		if bridge.get_player_state().variant == 4:
			bridge.spawn_amy_attack_hearts()
		elif bridge.get_player_state().variant == 2:
			bridge.spawn_character_attack_effect(bridge.ENTITY_TAIL_SWIPE)
		elif bridge.get_player_state().variant == 3:
			bridge.spawn_character_attack_effect(bridge.ENTITY_KNUCKLES_FIRE)
		elif bridge.get_player_state().variant == 0:
			bridge.spawn_character_attack_effect(bridge.ENTITY_SONIC_SKID)

static func _advance_grind(bridge: Object, frame_input: int, delta: float) -> void:
	var runtime: GameplayRuntimeState = bridge.get_gameplay_runtime_state()
	runtime.grind_timer = maxf(0.0, runtime.grind_timer - delta)
	var reached_end: bool = (runtime.grind_velocity_x > 0.0 and bridge.get_player_state().world_x >= runtime.grind_end_x) or (runtime.grind_velocity_x < 0.0 and bridge.get_player_state().world_x <= runtime.grind_end_x)
	var jump_off: bool = bool(frame_input & bridge.A_BUTTON) and runtime.grind_end_mode != 0
	if reached_end or jump_off or runtime.grind_timer <= 0.0:
		runtime.grind_timer = 0.0
		bridge.get_player_state().world_x = runtime.grind_end_x if reached_end else bridge.get_player_state().world_x
		if runtime.grind_end_mode != 0 or jump_off:
			runtime.velocity_y = -runtime.jump_speed
			bridge.get_player_state().is_grounded = false
			bridge.get_player_state().char_state = 1
		else:
			runtime.velocity_y = 0.0
			bridge.get_player_state().world_y = runtime.grind_y
			bridge.get_player_state().is_grounded = true
	else:
		bridge.get_player_state().world_x += runtime.grind_velocity_x * delta
		bridge.get_player_state().world_y = runtime.grind_y
		bridge.get_player_state().speed_x = runtime.grind_velocity_x
		bridge.get_player_state().speed_y = 0.0
		bridge.get_player_state().is_grounded = false
		bridge.get_player_state().char_state = 6

static func _advance_standard_movement(bridge: Object, move_direction: int, move_speed: float, gravity_direction: float, frame_input: int, delta: float) -> void:
	var runtime: GameplayRuntimeState = bridge.get_gameplay_runtime_state()
	if bridge.get_stage_surface_state().on_slidy_ice and bridge.get_player_state().is_grounded:
		var ice_target_speed: float = move_direction * move_speed
		if move_direction != 0:
			bridge.get_player_state().speed_x = move_toward(bridge.get_player_state().speed_x, ice_target_speed, 420.0 * delta)
		else:
			bridge.get_player_state().speed_x = move_toward(bridge.get_player_state().speed_x, 0.0, 24.0 * delta)
		bridge.get_player_state().ground_speed = bridge.get_player_state().speed_x
	else:
		bridge.get_player_state().ground_speed = move_direction * move_speed
		bridge.get_player_state().speed_x = move_direction * move_speed
	if move_direction != 0:
		runtime.facing_direction = signf(move_direction)
	if bridge.get_player_state().is_grounded:
		bridge.get_player_state().world_x += bridge.get_player_state().speed_x * delta
		if frame_input & bridge.A_BUTTON or bridge.get_input_buffer_system().jump_buffer_timer > 0.0:
			runtime.velocity_y = -runtime.jump_speed * gravity_direction
			bridge.get_player_state().is_grounded = false
			bridge.get_player_state().char_state = 1
			bridge.get_input_buffer_system().consume_jump()
	else:
		runtime.velocity_y += runtime.gravity * gravity_direction * delta

static func _advance_air_abilities(bridge: Object, held_input: int, frame_input: int, move_direction: int, move_speed: float, gravity_direction: float, delta: float) -> void:
	var runtime: GameplayRuntimeState = bridge.get_gameplay_runtime_state()
	var abilities: PlayerAbilityState = bridge.get_player_ability_state()
	if not bridge.get_player_state().is_grounded and (bridge.get_player_state().variant == 1 or bridge.get_player_state().variant == 2) and held_input & bridge.A_BUTTON:
		if frame_input & bridge.A_BUTTON:
			abilities.flight_timer = bridge.CREAM_FLIGHT_DURATION if bridge.get_player_state().variant == 1 else bridge.TAILS_FLIGHT_DURATION
		if abilities.flight_timer > 0.0:
			runtime.velocity_y = -120.0 * gravity_direction
			bridge.get_player_state().world_x += move_direction * move_speed * 0.65 * delta
			bridge.get_player_state().char_state = 9
		else:
			bridge.get_player_state().char_state = 10
	elif not bridge.get_player_state().is_grounded and bridge.get_player_state().variant == 3 and abilities.glide_timer > 0.0:
		runtime.velocity_y = 80.0 * gravity_direction
		bridge.get_player_state().world_x += move_direction * move_speed * 0.8 * delta
		bridge.get_player_state().char_state = 7
