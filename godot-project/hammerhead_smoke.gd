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

	var hammerhead = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	hammerhead.enemy_profile = 7
	hammerhead.origin_y = 300.0
	hammerhead.world_y = 300.0
	hammerhead.state_timer = TAU * 0.5
	var phase_step: float = 1.5 * 4.0 * TAU / 1024.0
	bridge._update_hammerhead_motion(hammerhead, 1.0 / 60.0)
	_check(is_equal_approx(hammerhead.state_timer, TAU * 0.5 + phase_step), "Hammerhead advances four source phase units per stage tick")
	_check(is_equal_approx(hammerhead.world_y, 300.0 + sin(TAU * 0.5 + phase_step) * 120.0), "Hammerhead converts the source Q2.14 offset to pixels")
	_check(is_equal_approx(hammerhead.previous_world_y, 300.0), "Hammerhead retains the previous platform position")

	print("HAMMERHEAD_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("HAMMERHEAD_FAIL: " + label)
