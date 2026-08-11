class_name GameplayRecoveryFlow
extends RefCounted

## Owns gameplay recovery transitions: falls, checkpoints, respawns and game over.
static func handle_fall(bridge: Object) -> void:
	var runtime: GameplayRuntimeState = bridge.get_gameplay_runtime_state()
	var player: PlayerState = bridge.get_player_state()
	var level: LevelState = bridge.get_level_state()
	var outside_bottom: bool = not runtime.gravity_inverted and player.world_y > level.max_y + 160.0
	var outside_top: bool = runtime.gravity_inverted and player.world_y < level.min_y - 160.0
	if not outside_bottom and not outside_top:
		return
	player.lives = max(0, player.lives - 1)
	if player.lives == 0:
		open_game_over(bridge)
	else:
		respawn_player(bridge)

static func restart_level(bridge: Object) -> void:
	var level: LevelState = bridge.get_level_state()
	bridge.set_level_state(bridge.build_level(level.level_id))
	level = bridge.get_level_state()
	bridge.get_checkpoint_state().begin(Vector2(level.spawn_x, level.spawn_y))
	bridge.get_player_ability_state().invincibility_timer = 0.0
	bridge.reset_player()

static func respawn_player(bridge: Object) -> void:
	var runtime: GameplayRuntimeState = bridge.get_gameplay_runtime_state()
	var abilities: PlayerAbilityState = bridge.get_player_ability_state()
	var player: PlayerState = bridge.get_player_state()
	var respawn_position: Vector2 = bridge.get_respawn_position()
	player.world_x = respawn_position.x
	player.world_y = respawn_position.y
	bridge.get_dash_effect_state().seed_trail(respawn_position)
	runtime.elapsed_time = bridge.get_checkpoint_state().checkpoint_time
	runtime.velocity_y = 0.0
	bridge.get_dash_effect_state().dash_timer = 0.0
	bridge.get_dash_effect_state().dash_velocity_x = 0.0
	bridge.get_dash_effect_state().dash_velocity_y = 0.0
	runtime.grind_timer = 0.0
	runtime.grind_velocity_x = 0.0
	runtime.grind_end_x = 0.0
	runtime.grind_y = 0.0
	runtime.grind_end_mode = 0
	runtime.gravity_inverted = false
	runtime.pipe_active = false
	runtime.pipe_timer = 0.0
	runtime.pipe_target_entity = null
	runtime.hook_active = false
	runtime.hook_timer = 0.0
	runtime.player_layer = 0
	runtime.corkscrew_timer = 0.0
	bridge.get_stage_intro_state().start_boost_timer = 0.0
	bridge.get_dash_effect_state().boost_effect_timer = 0.0
	abilities.attack_timer = 0.0
	abilities.flight_timer = 0.0
	abilities.glide_timer = 0.0
	player.speed_x = 0.0
	player.speed_y = 0.0
	player.ground_speed = 0.0
	player.is_grounded = true
	player.char_state = 0
	player.rotation = 0
	player.rings = 0
	player.special_rings = 0
	player.shielded = false
	bridge.get_player_ability_state().invincibility_timer = 0.0
	runtime.speed_up_timer = 0.0
	runtime.magnetic_shielded = false
	runtime.defeat_score_index = 0

static func open_game_over(bridge: Object, time_over: bool = false) -> void:
	bridge.set_game_state(bridge.GAME_STATE_GAME_OVER)
	bridge.get_player_state().is_alive = false
	bridge.get_game_over_state().start(time_over, bridge.GAME_OVER_DURATION_SECONDS, bridge.TIME_OVER_DURATION_SECONDS)
	bridge.set_status_text("TIME OVER" if time_over else "GAME OVER")

static func resolve_timeout(bridge: Object) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_GAME_OVER:
		return
	if bridge.get_run_mode_state().from_time_attack and bridge.get_game_over_state().time_over:
		bridge.open_time_attack_lobby(bridge.get_time_attack_session_state().boss_mode)
		return
	if bridge.get_game_over_state().time_over:
		bridge.init_restart()
		return
	bridge.reset_to_title()
