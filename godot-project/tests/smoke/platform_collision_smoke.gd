extends SceneTree

const COLLISION := preload("res://scripts/core/PlatformCollisionSystem.gd")
const PLAYER_STATE := preload("res://scripts/core/PlayerState.gd")
const PLATFORM_STATE := preload("res://scripts/core/PlatformState.gd")
const LEVEL_STATE := preload("res://scripts/core/LevelState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var level = LEVEL_STATE.new()
	level.ground_y = 400.0
	level.min_y = 0.0
	var platform = PLATFORM_STATE.new()
	platform.x1 = 0.0
	platform.x2 = 100.0
	platform.top_y = 100.0
	platform.bottom_y = 112.0
	platform.thickness = 12.0
	platform.crumble_delay = 0.25
	platform.arrow_mode = true
	platform.speeding_mode = true
	level.platforms.append(platform)
	var player = PLAYER_STATE.new()
	player.world_x = 50.0
	player.world_y = 96.0
	player.is_grounded = false
	var velocity_y := 30.0
	velocity_y = COLLISION.resolve(level, player, 50.0, 80.0, velocity_y, false, 0, 16.0, 16.0)
	_check(player.is_grounded and player.world_y == 84.0, "Downward collision lands on platform top")
	_check(velocity_y == 0.0 and player.speed_y == 0.0, "Landing clears vertical velocity")
	_check(platform.crumble_phase == 1 and platform.arrow_active and platform.speeding_active and platform.speeding_player_attached, "Landing activates platform behaviors")

	var inverted_player = PLAYER_STATE.new()
	inverted_player.world_x = 50.0
	inverted_player.world_y = 100.0
	inverted_player.is_grounded = false
	var inverted_velocity := -30.0
	inverted_velocity = COLLISION.resolve(level, inverted_player, 50.0, 128.0, inverted_velocity, true, 0, 16.0, 16.0)
	_check(inverted_player.is_grounded and inverted_player.world_y == 128.0, "Inverted collision lands below platform")

	var slope = PLATFORM_STATE.new()
	slope.x1 = 0.0
	slope.x2 = 100.0
	slope.top_y = 100.0
	slope.bottom_y = 112.0
	slope.thickness = 12.0
	slope.sloped = true
	slope.slope_start_y = 100.0
	slope.slope_end_y = 120.0
	level.platforms = [slope]
	var slope_player = PLAYER_STATE.new()
	slope_player.world_x = 50.0
	slope_player.world_y = 116.0
	var slope_velocity := 30.0
	COLLISION.resolve(level, slope_player, 50.0, 80.0, slope_velocity, false, 0, 16.0, 16.0)
	_check(slope_player.rotation == 2, "Sloped collision updates surface rotation")

	print("PLATFORM_COLLISION_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PLATFORM_COLLISION_FAIL: " + label)
