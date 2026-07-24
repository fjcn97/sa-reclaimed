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

	var cannon = bridge._add_entity(bridge._level_state, bridge.ENTITY_CANNON, 300.0, 300.0)
	cannon.world_x = 300.0
	cannon.world_y = 300.0
	cannon.cannon_facing_right = true
	cannon.cannon_angle = 0.0
	var player = bridge.get_player_state()
	player.world_x = 300.0
	player.world_y = 300.0
	bridge._try_cannon(cannon, 0, 1.0 / 60.0)
	_check(cannon.cannon_loading and not cannon.cannon_active, "Cannon enters its source loading state")

	bridge._try_cannon(cannon, 0, 1.0 / 60.0)
	_check(cannon.cannon_loading == false and cannon.cannon_active, "Cannon aligns and enters its active state")

	bridge._try_cannon(cannon, 0, 1.0 / 60.0)
	_check(cannon.cannon_angle > PI * 1.5 and cannon.cannon_angle < TAU, "Cannon advances its source 4-unit aim step")

	bridge._try_cannon(cannon, bridge.A_BUTTON, 1.0 / 60.0)
	_check(not cannon.cannon_active and absf(player.speed_x) > 0.0, "Cannon fires on the source jump/attack input")

	var timeout_cannon = bridge._add_entity(bridge._level_state, bridge.ENTITY_CANNON, 500.0, 300.0)
	timeout_cannon.cannon_facing_right = true
	timeout_cannon.cannon_angle = 0.0
	timeout_cannon.cannon_active = true
	timeout_cannon.cannon_timer = 511.0 / 60.0
	player.world_x = 500.0
	player.world_y = 300.0
	bridge._try_cannon(timeout_cannon, 0, 1.0 / 60.0)
	_check(not timeout_cannon.cannon_active, "Cannon fires automatically after 512 source frames")

	print("CANNON_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CANNON_FAIL: " + label)
