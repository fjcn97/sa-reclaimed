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
	bridge.init_level(4, false, false)
	var player = bridge.get_player_state()
	var spring = bridge._add_entity(bridge._level_state, bridge.ENTITY_SPRING, 320.0, 300.0)
	spring.flying_spring = true
	spring.origin_x = spring.world_x
	spring.origin_y = spring.world_y
	spring.width = 40.0
	spring.height = 24.0
	player.world_x = 320.0
	player.world_y = 300.0
	player.is_grounded = false
	bridge._velocity_y = 120.0
	bridge._try_bounce_from_spring(spring, 1.0 / 60.0)
	_check(bridge._velocity_y == -330.0, "flying spring uses the source propeller launch")
	_check(spring.flying_spring_motion_state == 1 and spring.flying_spring_step == 0, "flying spring enters compression state")
	for _i in range(14):
		bridge._update_flying_spring_motion(1.0 / 60.0)
	_check(spring.flying_spring_motion_state >= 2, "compression advances into source recovery states")
	for _i in range(80):
		bridge._update_flying_spring_motion(1.0 / 60.0)
	_check(spring.flying_spring_motion_state == 0, "flying spring returns to idle after animation")
	print("FLYING_SPRING_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("FLYING_SPRING_FAIL: " + label)
