extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var horizontal = bridge._add_entity(bridge._level_state, bridge.ENTITY_IRON_BALL, 240.0, 300.0)
	horizontal.iron_ball = true
	horizontal.iron_ball_horizontal = true
	horizontal.iron_ball_amplitude = 64.0
	horizontal.origin_x = 240.0
	horizontal.origin_y = 300.0
	bridge._update_iron_ball_state(0.25)
	_check(horizontal.world_x != 240.0 and horizontal.world_y == 300.0, "horizontal iron ball follows its sine path")
	var first_x: float = horizontal.world_x
	bridge._update_iron_ball_state(0.25)
	_check(horizontal.world_x != first_x, "iron ball continues oscillating")

	bridge.init_level(0, false)
	var vertical = bridge._add_entity(bridge._level_state, bridge.ENTITY_IRON_BALL, 240.0, 300.0)
	vertical.iron_ball = true
	vertical.iron_ball_horizontal = false
	vertical.iron_ball_amplitude = 48.0
	vertical.origin_x = 240.0
	vertical.origin_y = 300.0
	bridge._update_iron_ball_state(0.25)
	_check(vertical.world_x == 240.0 and vertical.world_y != 300.0, "vertical iron ball moves on its Y axis")

	print("IRON_BALL_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("IRON_BALL_FAIL: " + label)
