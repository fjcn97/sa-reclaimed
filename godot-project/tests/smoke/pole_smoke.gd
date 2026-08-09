extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var pole = bridge._add_entity(bridge._level_state, bridge.ENTITY_POLE, 240.0, 300.0)
	player.world_x = 240.0
	player.world_y = 300.0
	player.is_grounded = false
	bridge._try_pole(pole, 0, 0)
	_check(pole.pole_sliding and player.char_state == 4, "pole captures a touching player")
	bridge._try_pole(pole, bridge.DPAD_LEFT, bridge.A_BUTTON)
	_check(not pole.pole_sliding and player.speed_x < 0.0, "jump exits the pole toward the held direction")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	pole = bridge._add_entity(bridge._level_state, bridge.ENTITY_POLE, 240.0, 300.0)
	player.world_x = 240.0
	player.world_y = 300.0
	bridge._try_pole(pole, 0, 0)
	player.world_y = 340.0
	bridge._try_pole(pole, 0, 0)
	_check(not pole.pole_sliding and player.char_state == 1, "pole releases when the player leaves its bounds")

	print("POLE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("POLE_FAIL: " + label)
