extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var crane = bridge._add_entity(bridge._level_state, bridge.ENTITY_CRANE, 240.0, 200.0)
	crane.crane = true
	crane.origin_x = 240.0
	crane.origin_y = 200.0
	crane.crane_hook_x = 240.0
	crane.crane_hook_y = 288.0
	player.world_x = 240.0
	player.world_y = 288.0
	bridge._velocity_y = 300.0
	bridge._try_crane(crane)
	_check(crane.crane_timer > 0.0 and crane.activated, "crane captures the hook contact")
	_check(crane.crane_launch_speed == 600.0, "crane derives launch speed from incoming fall speed")
	_check(player.char_state == 8, "crane holds the player in hanging state")
	bridge._update_crane_state(0.7)
	_check(not crane.activated and player.speed_y == -600.0, "crane releases with the calculated upward launch")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	crane = bridge._add_entity(bridge._level_state, bridge.ENTITY_CRANE, 240.0, 200.0)
	crane.crane = true
	crane.crane_hook_x = 240.0
	crane.crane_hook_y = 288.0
	player.world_x = 300.0
	player.world_y = 288.0
	bridge._try_crane(crane)
	_check(crane.crane_timer == 0.0, "crane rejects distant contact")

	print("CRANE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CRANE_FAIL: " + label)
