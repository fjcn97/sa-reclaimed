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

	var balloon = bridge._add_entity(bridge._level_state, bridge.ENTITY_BALLOON, 300.0, 300.0)
	balloon.world_x = 300.0
	balloon.world_y = 300.0
	balloon.origin_x = 300.0
	balloon.origin_y = 300.0
	balloon.patrol_min_x = 260.0
	balloon.patrol_max_x = 340.0
	balloon.velocity_x = 30.0
	balloon.state_timer = 120.0 / 60.0
	balloon.variant = 0
	balloon.balloon_amplitude_x = 16.0
	balloon.balloon_amplitude_y = 8.0
	var starting_y: float = balloon.world_y
	bridge._update_balloon_motion(balloon, 1.0 / 60.0)
	_check(balloon.balloon_angle > 0.0 and not is_equal_approx(balloon.world_y, starting_y), "Balloon advances its source sine offsets")

	balloon.state_timer = 0.0
	bridge._update_balloon_motion(balloon, 1.0 / 60.0)
	_check(balloon.variant == 1 and is_equal_approx(balloon.state_timer, 0.75), "Balloon enters its 45-frame attack animation")

	var before: int = bridge._level_state.entities.size()
	balloon.state_timer = 1.0 / 60.0
	bridge._update_balloon_motion(balloon, 1.0 / 60.0)
	_check(balloon.variant == 0 and bridge._level_state.entities.size() == before + 1, "Balloon emits one projectile at the end of its attack")

	var projectile = bridge._level_state.entities[bridge._level_state.entities.size() - 1]
	_check(is_equal_approx(projectile.velocity_y, 260.0), "Balloon projectile uses its downward source velocity")

	print("BALLOON_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("BALLOON_FAIL: " + label)
