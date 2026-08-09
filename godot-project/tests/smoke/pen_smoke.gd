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

	var pen = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	pen.enemy_profile = 1
	pen.world_x = 300.0
	pen.patrol_min_x = 260.0
	pen.patrol_max_x = 340.0
	pen.pen_direction = -1.0
	pen.velocity_x = -30.0
	var player = bridge.get_player_state()
	player.world_x = 220.0
	player.world_y = 300.0
	bridge._update_pen_motion(pen, 1.0 / 60.0)
	_check(pen.pen_boosting and is_equal_approx(pen.velocity_x, -120.0), "Pen boosts toward a player ahead")

	player.world_x = 400.0
	bridge._update_pen_motion(pen, 1.0 / 60.0)
	_check(not pen.pen_boosting and is_equal_approx(pen.velocity_x, -30.0), "Pen returns to its normal speed when the player is behind")

	pen.world_x = pen.patrol_min_x + 0.5
	pen.pen_direction = -1.0
	pen.velocity_x = -30.0
	pen.pen_turn_timer = 0.0
	bridge._update_pen_motion(pen, 1.0 / 60.0)
	_check(pen.pen_turn_timer > 0.0, "Pen pauses for its turn animation at the border")
	for _frame in range(18):
		bridge._update_pen_motion(pen, 1.0 / 60.0)
	_check(pen.pen_direction > 0.0 and pen.velocity_x > 0.0, "Pen reverses after the turn animation")

	print("PEN_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PEN_FAIL: " + label)
