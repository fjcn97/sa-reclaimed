extends SceneTree

const MOTION := preload("res://scripts/core/PlatformMotionSystem.gd")
const PLAYER_STATE := preload("res://scripts/core/PlayerState.gd")
const PLATFORM_STATE := preload("res://scripts/core/PlatformState.gd")
const LEVEL_STATE := preload("res://scripts/core/LevelState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var level = LEVEL_STATE.new()
	var player = PLAYER_STATE.new()
	player.world_x = 50.0
	player.world_y = 84.0
	player.is_grounded = true
	var moving = PLATFORM_STATE.new()
	moving.x1 = 0.0
	moving.x2 = 100.0
	moving.top_y = 100.0
	moving.bottom_y = 112.0
	moving.thickness = 12.0
	moving.moving = true
	moving.motion_axis = 0
	moving.motion_amplitude = 20.0
	moving.motion_speed = 1.0
	level.platforms.append(moving)
	var original_x: float = player.world_x
	MOTION.update(level, player, 0.1, 16.0, 16.0, false, 0.0)
	_check(moving.x1 != 0.0 and player.world_x != original_x, "Moving platform advances and carries grounded player")

	var arrow = PLATFORM_STATE.new()
	arrow.x1 = 0.0
	arrow.x2 = 32.0
	arrow.top_y = 200.0
	arrow.bottom_y = 212.0
	arrow.thickness = 12.0
	arrow.arrow_mode = true
	arrow.arrow_active = true
	arrow.arrow_target_x = 40.0
	arrow.arrow_speed = 100.0
	level.platforms = [arrow]
	MOTION.update(level, player, 0.25, 16.0, 16.0, false, 0.0)
	_check(arrow.x1 == 25.0 and arrow.arrow_active, "Arrow platform moves toward its target")

	var crumble = PLATFORM_STATE.new()
	crumble.active = true
	crumble.crumble_timer = 0.1
	crumble.crumble_phase = 1
	level.platforms = [crumble]
	MOTION.update(level, player, 0.2, 16.0, 16.0, false, 0.0)
	_check(crumble.crumble_phase == 2 and crumble.crumble_break_timer > 0.0, "Crumbled platform enters its break phase")
	MOTION.update(level, player, 0.6, 16.0, 16.0, false, 0.0)
	_check(not crumble.active and crumble.crumble_phase == 3, "Crumbled platform deactivates after breaking")

	var speeding = PLATFORM_STATE.new()
	speeding.active = true
	speeding.speeding_mode = true
	speeding.speeding_active = true
	speeding.x1 = 0.0
	speeding.x2 = 54.0
	speeding.top_y = 100.0
	speeding.bottom_y = 112.0
	speeding.thickness = 12.0
	speeding.speeding_target_x = 100.0
	speeding.speeding_target_y = 100.0
	level.platforms = [speeding]
	MOTION.update(level, player, 0.1, 16.0, 16.0, false, 0.0)
	_check(speeding.x1 > 0.0 and speeding.speeding_active, "Speeding platform advances while active")

	print("PLATFORM_MOTION_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PLATFORM_MOTION_FAIL: " + label)
