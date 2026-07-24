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
	var gohla = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	gohla.enemy_profile = 6
	gohla.velocity_x = -30.0
	gohla.patrol_min_x = 285.0
	gohla.patrol_max_x = 300.0
	var before_x: float = gohla.world_x
	bridge._update_gohla_motion(gohla, 1.0 / 60.0)
	_check(gohla.world_x < before_x, "gohla follows the source half-pixel patrol")
	var before_phase: float = gohla.state_timer
	bridge._update_gohla_motion(gohla, 1.0 / 60.0)
	_check(gohla.state_timer != before_phase, "gohla orbit phase advances")
	for _i in range(30):
		bridge._update_gohla_motion(gohla, 1.0 / 60.0)
	_check(gohla.world_x >= gohla.patrol_min_x and gohla.world_x <= gohla.patrol_max_x, "gohla stays within its imported range")
	_check(gohla.velocity_x > 0.0 or gohla.gohla_turn_timer > 0.0, "gohla reverses at the source border")
	print("GOHLA_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("GOHLA_FAIL: " + label)
