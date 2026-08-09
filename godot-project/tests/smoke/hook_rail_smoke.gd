extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var start = bridge._add_entity(bridge._level_state, bridge.ENTITY_HOOK_RAIL, 200.0, 300.0)
	start.target_x = 600.0
	start.width = 400.0
	var end = bridge._add_entity(bridge._level_state, bridge.ENTITY_HOOK_RAIL, 600.0, 300.0)
	end.variant = 1
	player.world_x = 260.0
	player.world_y = 300.0
	player.is_grounded = false
	bridge._try_hook_rail(start, 0, 1.0 / 60.0)
	_check(bridge._hook_active, "forward approach captures the hook rail")
	var first_x: float = player.world_x
	bridge._try_hook_rail(start, 0, 0.5)
	_check(player.world_x != first_x, "hook rail advances the player along its path")
	bridge._try_hook_rail(start, bridge.A_BUTTON, 1.0 / 60.0)
	_check(not bridge._hook_active and not player.is_grounded, "jump releases the hook rail")
	_check(player.speed_y < 0.0, "hook rail release launches upward")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	start = bridge._add_entity(bridge._level_state, bridge.ENTITY_HOOK_RAIL, 200.0, 300.0)
	start.target_x = 600.0
	bridge._add_entity(bridge._level_state, bridge.ENTITY_HOOK_RAIL, 600.0, 300.0).variant = 1
	player.world_x = 520.0
	player.world_y = 300.0
	bridge._try_hook_rail(start, 0, 1.0 / 60.0)
	_check(not bridge._hook_active, "reverse-side approach does not trigger the start rail")

	print("HOOK_RAIL_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("HOOK_RAIL_FAIL: " + label)
