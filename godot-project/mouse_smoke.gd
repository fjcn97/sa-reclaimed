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

	var mouse = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	mouse.enemy_profile = 3
	mouse.world_x = 300.0
	mouse.origin_y = 300.0
	mouse.patrol_min_x = 260.0
	mouse.patrol_max_x = 340.0
	mouse.mouse_direction = -1.0
	mouse.velocity_x = -30.0
	var player = bridge.get_player_state()
	player.world_x = 220.0
	player.world_y = 300.0
	bridge._update_mouse_motion(mouse, 1.0 / 60.0)
	_check(mouse.mouse_boosting and is_equal_approx(mouse.velocity_x, -120.0), "Mouse boosts toward a player ahead")

	player.world_x = 400.0
	bridge._update_mouse_motion(mouse, 1.0 / 60.0)
	_check(not mouse.mouse_boosting and is_equal_approx(mouse.velocity_x, -30.0), "Mouse returns to normal speed when the player is behind")

	mouse.world_x = mouse.patrol_min_x + 0.5
	mouse.mouse_direction = -1.0
	mouse.velocity_x = -30.0
	mouse.mouse_turn_timer = 0.0
	bridge._update_mouse_motion(mouse, 1.0 / 60.0)
	_check(mouse.mouse_turn_timer > 0.0, "Mouse pauses for its turn animation at the border")
	for _frame in range(18):
		bridge._update_mouse_motion(mouse, 1.0 / 60.0)
	_check(mouse.mouse_direction > 0.0 and mouse.velocity_x > 0.0, "Mouse reverses after the turn animation")

	mouse.mouse_position_offset = 8.0
	bridge._update_mouse_motion(mouse, 1.0 / 60.0)
	_check(is_equal_approx(mouse.world_y, 308.0), "Mouse applies the source special position offset")

	print("MOUSE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MOUSE_FAIL: " + label)
