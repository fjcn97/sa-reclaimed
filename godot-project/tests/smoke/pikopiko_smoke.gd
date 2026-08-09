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

	var piko = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	piko.enemy_profile = 18
	piko.world_x = 300.0
	piko.world_y = 300.0
	piko.patrol_min_x = 260.0
	piko.patrol_max_x = 340.0
	piko.velocity_x = -60.0
	piko.pikopiko_clamp_ground = false
	bridge._update_pikopiko_motion(piko, 1.0 / 60.0)
	_check(is_equal_approx(piko.world_x, 299.0), "Piko Piko moves one source pixel per frame")

	piko.world_x = piko.patrol_min_x + 0.5
	piko.velocity_x = -60.0
	bridge._update_pikopiko_motion(piko, 1.0 / 60.0)
	_check(piko.world_x == piko.patrol_min_x and piko.velocity_x > 0.0, "Piko Piko reverses immediately at the left border")

	piko.world_x = piko.patrol_max_x - 0.5
	piko.velocity_x = 60.0
	bridge._update_pikopiko_motion(piko, 1.0 / 60.0)
	_check(piko.world_x == piko.patrol_max_x and piko.velocity_x < 0.0, "Piko Piko reverses immediately at the right border")

	piko.pikopiko_clamp_ground = true
	piko.world_y = 100.0
	bridge._update_pikopiko_motion(piko, 1.0 / 60.0)
	_check(is_equal_approx(piko.world_y, bridge._level_state.ground_y - 16.0), "Piko Piko applies its source ground clamp mode")

	print("PIKOPIKO_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PIKOPIKO_FAIL: " + label)
