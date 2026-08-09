extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var mill = bridge._add_entity(bridge._level_state, bridge.ENTITY_SMALL_WINDMILL, 240.0, 300.0)
	mill.small_windmill = true
	mill.small_windmill_type = 15
	player.world_x = 230.0
	player.world_y = 290.0
	player.speed_x = 0.0
	bridge._velocity_y = -300.0
	bridge._try_small_windmill(mill)
	_check(mill.small_windmill_touch_angle == 2, "top-left vertical approach selects source angle 2")
	_check(mill.activated, "windmill starts its scripted rotation")
	bridge._update_small_windmill_state(0.2)
	_check(player.char_state == 8 and player.is_grounded == false, "windmill keeps the player spinning")
	bridge._update_small_windmill_state(0.6)
	_check(not mill.activated and player.speed_x < 0.0 and player.speed_y == 0.0, "angle 2 releases left")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	mill = bridge._add_entity(bridge._level_state, bridge.ENTITY_SMALL_WINDMILL, 240.0, 300.0)
	mill.small_windmill = true
	mill.small_windmill_type = 1
	player.world_x = 250.0
	player.world_y = 290.0
	player.speed_x = 0.0
	bridge._velocity_y = -300.0
	bridge._try_small_windmill(mill)
	_check(not mill.activated, "disabled windmill quadrant rejects contact")

	print("SMALL_WINDMILL_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SMALL_WINDMILL_FAIL: " + label)
