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

	var straw = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	straw.enemy_profile = 9
	straw.world_x = 300.0
	straw.world_y = 300.0
	straw.velocity_x = 0.0
	straw.velocity_y = 0.0
	straw.straw_phase = 0
	straw.straw_phase_timer = 30.0 / 60.0
	straw.straw_cycles = 5
	var player = bridge.get_player_state()
	player.world_x = 200.0
	player.world_y = 300.0
	bridge._update_straw_motion(straw, 1.0 / 60.0)
	_check(straw.velocity_x < 0.0 and straw.world_x < 300.0, "Straw steers toward the player in its active phase")
	var velocity_during_active: float = straw.velocity_x
	for _frame in range(29):
		bridge._update_straw_motion(straw, 1.0 / 60.0)
	_check(straw.straw_phase == 1 and is_equal_approx(straw.velocity_x, velocity_during_active - 3.75 * 29.0), "Straw enters the 100-frame drift phase after 30 active frames")

	var drift_velocity: float = straw.velocity_x
	bridge._update_straw_motion(straw, 1.0 / 60.0)
	_check(is_equal_approx(straw.velocity_x, drift_velocity), "Straw does not steer during the drift phase")

	for _cycle in range(4):
		for _frame in range(100):
			bridge._update_straw_motion(straw, 1.0 / 60.0)
		for _frame in range(30):
			bridge._update_straw_motion(straw, 1.0 / 60.0)
		for _frame in range(100):
			bridge._update_straw_motion(straw, 1.0 / 60.0)
	_check(straw.straw_phase == 2, "Straw becomes permanently ballistic after five cycles")
	var ballistic_velocity: Vector2 = Vector2(straw.velocity_x, straw.velocity_y)
	bridge._update_straw_motion(straw, 1.0 / 60.0)
	_check(is_equal_approx(straw.velocity_x, ballistic_velocity.x) and is_equal_approx(straw.velocity_y, ballistic_velocity.y), "Straw keeps its ballistic velocity")

	print("STRAW_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("STRAW_FAIL: " + label)
