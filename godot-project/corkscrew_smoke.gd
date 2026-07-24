extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var start = bridge._add_entity(bridge._level_state, bridge.ENTITY_CORK_SCREW, 220.0, 300.0)
	player.world_x = 220.0
	player.world_y = 300.0
	player.is_grounded = false
	player.speed_x = 180.0
	bridge._try_corkscrew(start, 0, 1.0 / 60.0)
	_check(not start.activated, "airborne player cannot arm the corkscrew")
	player.is_grounded = true
	bridge._try_corkscrew(start, 0, 1.0 / 60.0)
	_check(start.activated, "forward corkscrew arms from the correct side")
	bridge._try_corkscrew(start, 0, 1.0 / 60.0)
	var first_y: float = player.world_y
	bridge._try_corkscrew(start, 0, 0.2)
	_check(start.activated, "corkscrew keeps the player in its active path")
	_check(player.world_y != first_y, "corkscrew follows the sinusoidal path")
	bridge._try_corkscrew(start, bridge.A_BUTTON, 1.0 / 60.0)
	_check(not start.activated, "jump exits the corkscrew")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	var stop = bridge._add_entity(bridge._level_state, bridge.ENTITY_CORK_SCREW, 420.0, 300.0)
	stop.variant = 1
	player.world_x = 420.0
	player.world_y = 300.0
	player.is_grounded = true
	player.speed_x = -180.0
	bridge._try_corkscrew(stop, 0, 1.0 / 60.0)
	_check(stop.activated, "reverse corkscrew arms from the opposite side")
	player.world_x = stop.world_x - 600.0
	bridge._try_corkscrew(stop, 0, 1.0 / 60.0)
	_check(not stop.activated, "reverse corkscrew exits after crossing its limit")

	print("CORKSCREW_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CORKSCREW_FAIL: " + label)
