extends SceneTree

const PLATFORM_BUILDER := preload("res://scripts/core/PlatformBuilder.gd")
const LEVEL_STATE := preload("res://scripts/core/LevelState.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var level = LEVEL_STATE.new()
	PLATFORM_BUILDER.add_platform(level, 100.0, 400.0, 240.0, 32.0)
	_check(level.platforms.size() == 1, "Platform builder appends a platform")
	_check(is_equal_approx(level.platforms[0].x2, 340.0), "Platform builder computes the right edge")
	_check(is_equal_approx(level.platforms[0].top_y, 368.0), "Platform builder computes the top surface")

	PLATFORM_BUILDER.add_sloped_platform(level, 500.0, 300.0, 400.0, 340.0, 20.0, 3)
	_check(level.platforms[1].sloped, "Sloped builder marks non-flat geometry")
	_check(level.platforms[1].collision_layer == 3, "Sloped builder preserves collision layers")

	PLATFORM_BUILDER.add_crumbling_platform(level, 800.0, 400.0, 80.0, 16.0, 0.0)
	_check(is_equal_approx(level.platforms[2].crumble_delay, 0.1), "Crumbling builder clamps its delay")

	PLATFORM_BUILDER.add_moving_platform(level, 1000.0, 400.0, 80.0, 16.0, 1, -20.0, 2.0, 0.25)
	_check(level.platforms[3].moving and level.platforms[3].motion_axis == 1, "Moving builder configures its axis")
	_check(is_equal_approx(level.platforms[3].motion_amplitude, 0.0), "Moving builder clamps negative amplitude")

	print("PLATFORM_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PLATFORM_BUILDER_FAIL: " + label)
