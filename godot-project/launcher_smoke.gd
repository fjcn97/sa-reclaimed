extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var launcher = bridge._add_entity(bridge._level_state, bridge.ENTITY_LAUNCHER, 200.0, 300.0)
	launcher.launcher_cart_x = 200.0
	launcher.launcher_cart_y = 300.0
	launcher.launcher_base_x = 200.0
	launcher.launcher_target_x = 700.0
	launcher.launcher_direction = 1.0
	launcher.launcher_gravity_up = false
	player.world_x = 200.0
	player.world_y = 284.0
	player.is_grounded = false
	bridge._try_launcher(launcher, 0, 1.0 / 60.0)
	_check(launcher.launcher_active, "launcher captures the player at the cart")
	bridge._try_launcher(launcher, bridge.A_BUTTON, 1.0 / 60.0)
	_check(not launcher.launcher_active, "jump exits the launcher cart")
	_check(player.speed_y < 0.0 and not player.is_grounded, "launcher jump applies upward velocity")
	_check(launcher.launcher_returning, "launcher begins returning after an early exit")

	print("LAUNCHER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("LAUNCHER_FAIL: " + label)
