extends SceneTree

const DISPATCHER := preload("res://scripts/core/EnemyMotionDispatcher.gd")
const BRIDGE := preload("res://scripts/CoreBridge.gd")
const LEVEL_STATE := preload("res://scripts/core/LevelState.gd")
const ENTITY_STATE := preload("res://scripts/core/EntityState.gd")
const TYPES := preload("res://scripts/core/EntityTypes.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = BRIDGE.new()
	get_root().add_child(bridge)
	var level = LEVEL_STATE.new()
	level.min_x = 0.0
	level.max_x = 400.0
	level.min_y = 0.0
	level.max_y = 300.0
	var enemy = ENTITY_STATE.new()
	enemy.type = TYPES.ENTITY_ENEMY
	enemy.active = true
	enemy.world_x = 10.0
	enemy.patrol_min_x = 10.0
	enemy.patrol_max_x = 100.0
	enemy.velocity_x = -20.0
	level.entities.append(enemy)
	var fan = ENTITY_STATE.new()
	fan.type = TYPES.ENTITY_FAN
	fan.active = true
	fan.variant = 1
	fan.state_timer = 60.0
	level.entities.append(fan)
	var projectile = ENTITY_STATE.new()
	projectile.type = TYPES.ENTITY_PROJECTILE
	projectile.active = true
	projectile.world_x = 500.0
	projectile.world_y = 100.0
	projectile.velocity_x = 1.0
	level.entities.append(projectile)

	DISPATCHER.update(bridge, level, 1.0)
	_check(enemy.velocity_x == 20.0 and enemy.world_x == 10.0, "Dispatcher preserves generic patrol turnaround")
	_check(fan.fan_speed == 1.0 and fan.state_timer == 120.0, "Dispatcher updates periodic fan motion")
	_check(not projectile.active, "Dispatcher deactivates out-of-bounds projectiles")

	var profile = ENTITY_STATE.new()
	profile.type = TYPES.ENTITY_ENEMY
	profile.active = true
	profile.enemy_profile = 13
	level.entities.append(profile)
	DISPATCHER.update(bridge, level, 0.5)
	_check(profile.state_timer > 0.0, "Dispatcher routes enemy profiles through bridge handlers")

	print("ENEMY_MOTION_DISPATCHER_CHECKS=%d" % checks)
	bridge.queue_free()
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ENEMY_MOTION_DISPATCHER_FAIL: " + label)
