extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node_or_null("CoreBridge")
	if bridge == null:
		bridge = preload("res://scripts/CoreBridge.gd").new()
		bridge.name = "CoreBridge"
		get_root().add_child(bridge)
	bridge.init_level(1, false, false)

	var fan = bridge._add_entity(bridge._level_state, bridge.ENTITY_FAN, 300.0, 300.0)
	fan.width = 100.0
	fan.height = 100.0
	fan.velocity_x = 1.0
	fan.variant = 0
	fan.fan_speed = 1.0
	var player = bridge.get_player_state()
	player.world_x = 310.0
	player.world_y = 300.0
	player.speed_x = 0.0
	bridge._try_fan(fan, 0, 1.0 / 60.0)
	_check(is_equal_approx(player.world_x, 319.6), "Fan displaces the player by the source ratio-scaled amount")
	_check(is_equal_approx(player.speed_x, 576.0), "Fan reports its source displacement as player speed")

	player.world_x = 310.0
	player.speed_x = 100.0
	bridge._try_fan(fan, 0, 1.0 / 60.0)
	_check(is_equal_approx(player.speed_x, 115.0), "Fan accelerates a player already moving with the airflow")

	fan.variant = 1
	fan.state_timer = 0.0
	bridge._update_enemy_motion(1.0 / 60.0)
	_check(is_equal_approx(fan.fan_speed, 0.0), "Periodic fan starts in its one-second off phase")
	fan.state_timer = 120.0
	bridge._update_enemy_motion(1.0 / 60.0)
	_check(is_equal_approx(fan.fan_speed, 1.0), "Periodic fan reaches full speed after its acceleration phase")

	print("FAN_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("FAN_FAIL: " + label)
