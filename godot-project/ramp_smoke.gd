extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var ramp = bridge._add_entity(bridge._level_state, bridge.ENTITY_RAMP, 220.0, 300.0)
	player.world_x = 220.0
	player.world_y = 300.0
	player.is_grounded = true
	player.speed_x = 180.0
	bridge._try_ramp(ramp, 0)
	_check(ramp.activated, "normal ramp keeps a fast player on its surface")
	_check(player.is_grounded, "normal ramp does not auto-launch on contact")
	bridge._try_ramp(ramp, bridge.A_BUTTON)
	_check(not ramp.activated and not player.is_grounded, "jump launches the normal ramp")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	var incline = bridge._add_entity(bridge._level_state, bridge.ENTITY_RAMP, 420.0, 300.0)
	incline.ramp_incline = true
	incline.variant = 1
	player.world_x = 420.0
	player.world_y = 300.0
	player.is_grounded = true
	player.speed_x = -180.0
	bridge._try_ramp(incline, 0)
	_check(incline.activated, "incline ramp activates in its configured direction")
	_check(player.speed_x < 0.0 and not player.is_grounded, "incline ramp applies the reverse spring launch")

	print("RAMP_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("RAMP_FAIL: " + label)
