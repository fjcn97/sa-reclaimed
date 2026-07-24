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

	var circus = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	circus.enemy_profile = 4
	circus.origin_x = 300.0
	circus.origin_y = 300.0
	circus.circus_phase = 0
	circus.circus_phase_timer = 0.0
	bridge._update_circus_motion(circus, 1.0 / 60.0)
	_check(circus.circus_phase == 1 and circus.variant == 1, "Circus enters its preparation animation")

	circus.circus_phase_timer = 0.0
	var before: int = bridge._level_state.entities.size()
	bridge._update_circus_motion(circus, 1.0 / 60.0)
	_check(circus.circus_phase == 2 and bridge._level_state.entities.size() == before + 1, "Circus spawns one falling projectile after preparation")
	var projectile = bridge._level_state.entities[bridge._level_state.entities.size() - 1]
	_check(projectile.enemy_profile == 4 and is_equal_approx(projectile.velocity_y, -300.0), "Circus projectile starts with the source launch speed")

	circus.circus_phase_timer = 0.0
	bridge._update_circus_motion(circus, 1.0 / 60.0)
	_check(circus.circus_phase == 3 and circus.variant == 3, "Circus enters its retraction animation")

	circus.circus_phase_timer = 0.0
	bridge._update_circus_motion(circus, 1.0 / 60.0)
	_check(circus.circus_phase == 0 and is_equal_approx(circus.circus_phase_timer, 0.5), "Circus returns to its source cooldown")

	print("CIRCUS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CIRCUS_FAIL: " + label)
