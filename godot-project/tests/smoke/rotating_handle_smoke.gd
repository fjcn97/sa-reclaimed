extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	player.world_x = 220.0
	player.world_y = 300.0
	player.is_grounded = false
	player.speed_x = 180.0
	var handle = bridge._add_entity(bridge._level_state, bridge.ENTITY_ROTATING_HANDLE, 220.0, 300.0)
	bridge._try_rotating_handle(handle, 0, 0, 1.0 / 60.0)
	_check(handle.activated, "airborne player grabs the rotating handle")
	var first_angle: float = handle.rotating_handle_angle
	bridge._try_rotating_handle(handle, 0, 0, 1.0)
	_check(handle.activated, "handle keeps the player attached without jump")
	_check(handle.rotating_handle_angle != first_angle, "handle continues rotating while attached")
	_check(handle.variant >= 0 and handle.variant <= 11, "handle selects the source twelve-frame rotation variant")
	_check(handle.rotating_handle_quartile == 1, "handle records the source release quadrant")
	bridge._try_rotating_handle(handle, 0, bridge.A_BUTTON, 1.0 / 60.0)
	_check(not handle.activated, "jump releases the handle")
	_check(absf(player.speed_x) > 0.0 or absf(player.speed_y) > 0.0, "release applies launch velocity")
	_check(player.speed_x != 0.0 and player.speed_y != 0.0, "release follows the source quadrant launch vector")
	print("ROTATING_HANDLE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ROTATING_HANDLE_FAIL: " + label)
