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

	var kyura = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	kyura.enemy_profile = 14
	kyura.origin_x = 300.0
	kyura.origin_y = 300.0
	kyura.target_x = 16.0
	kyura.target_y = 0.0
	kyura.kyura_switch_timer = 8.0 / 60.0
	kyura.kyura_projectile_counter = 12
	for _frame in range(8):
		bridge._update_kyura_motion(kyura, 1.0 / 60.0)
	_check(kyura.kyura_recovering and is_zero_approx(kyura.kyura_phase_units), "Kyura holds after the source eight active frames")
	for _frame in range(4):
		bridge._update_kyura_motion(kyura, 1.0 / 60.0)
	_check(is_equal_approx(kyura.kyura_phase_units, 8.0), "Kyura advances by eight GBA angle units every 12 frames")
	_check(is_equal_approx(kyura.world_x, 300.0 + cos(8.0 * TAU / 256.0 * 5.0) * 16.0), "Kyura uses the source horizontal amplitude")

	for _frame in range(128):
		bridge._update_kyura_motion(kyura, 1.0 / 60.0)
	var projectiles: Array = []
	for entity in bridge._level_state.entities:
		if entity.type == bridge.ENTITY_PROJECTILE and entity.enemy_profile == 14:
			projectiles.append(entity)
	_check(projectiles.size() >= 1, "Kyura fires after the source projectile countdown")
	if not projectiles.is_empty():
		var first = projectiles[0]
		_check(is_zero_approx(first.velocity_x) and first.velocity_y > 0.0, "Kyura projectiles descend instead of moving sideways")
		_check(first.state_timer > 0.0, "Kyura projectile has a bounded lifetime")

	print("KYURA_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("KYURA_FAIL: " + label)
