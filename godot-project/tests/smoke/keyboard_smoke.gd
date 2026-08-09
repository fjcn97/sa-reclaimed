extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var vertical = bridge._add_entity(bridge._level_state, bridge.ENTITY_KEYBOARD, 240.0, 300.0)
	vertical.keyboard = true
	vertical.keyboard_type = 0
	vertical.velocity_x = 1.0
	player.world_x = 240.0
	player.world_y = 300.0
	bridge._try_keyboard(vertical)
	_check(vertical.activated and player.char_state == 6, "keyboard triggers the spin/uncurl state")
	_check(player.speed_x == 180.0 and player.speed_y == -240.0, "vertical keyboard uses source acceleration")
	bridge._try_keyboard(vertical)
	_check(player.speed_x == 180.0, "keyboard cooldown blocks an immediate retrigger")
	bridge._update_keyboard_state(1.0)
	_check(not vertical.activated, "keyboard cooldown expires")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	var horizontal = bridge._add_entity(bridge._level_state, bridge.ENTITY_KEYBOARD, 240.0, 300.0)
	horizontal.keyboard = true
	horizontal.keyboard_type = 1
	horizontal.velocity_y = -1.0
	player.world_x = 240.0
	player.world_y = 300.0
	bridge._try_keyboard(horizontal)
	_check(player.speed_x == -300.0 and player.speed_y == -480.0, "horizontal keyboard uses its configured direction")

	print("KEYBOARD_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("KEYBOARD_FAIL: " + label)
