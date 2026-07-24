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

	var madillo = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 100.0, 300.0)
	madillo.enemy_profile = 12
	madillo.origin_x = 100.0
	madillo.origin_y = 300.0
	madillo.patrol_min_x = 80.0
	madillo.patrol_max_x = 120.0
	var player = bridge.get_player_state()
	player.world_x = 40.0
	player.world_y = 300.0
	bridge._update_madillo_motion(madillo, 1.0 / 60.0)
	_check(madillo.variant == 1 and madillo.velocity_x == -90.0, "Madillo launches toward a player on the left")
	var before_x: float = madillo.world_x
	bridge._update_madillo_motion(madillo, 1.0 / 60.0)
	_check(madillo.world_x < before_x, "Madillo uses the source 1.5 px/frame attack speed")

	madillo.world_x = madillo.patrol_min_x + 0.5
	madillo.velocity_x = -90.0
	madillo.variant = 1
	bridge._update_madillo_motion(madillo, 1.0 / 60.0)
	_check(madillo.variant == 2 and madillo.madillo_return_timer > 1.9, "Madillo enters the 120-frame return phase at the border")
	var speed_before_return: float = absf(madillo.velocity_x)
	bridge._update_madillo_motion(madillo, 1.0 / 60.0)
	_check(absf(madillo.velocity_x) < speed_before_return, "Madillo decelerates during the return phase")

	for _frame in range(120):
		bridge._update_madillo_motion(madillo, 1.0 / 60.0)
	_check(madillo.variant == 0 and is_zero_approx(madillo.velocity_x), "Madillo returns to its idle state after 120 frames")

	print("MADILLO_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MADILLO_FAIL: " + label)
