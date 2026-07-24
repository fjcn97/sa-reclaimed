extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var stick = bridge._add_entity(bridge._level_state, bridge.ENTITY_WINDUP_STICK, 240.0, 300.0)
	stick.windup_stick = true
	stick.width = 48.0
	stick.height = 24.0
	player.world_x = 240.0
	player.world_y = 300.0
	player.is_grounded = false
	bridge._velocity_y = -100.0
	bridge._try_windup_stick(stick, 0)
	_check(stick.windup_stick_mode == 1, "rising player selects the upward windup state")
	_check(player.speed_y == -490.0, "upward windup adds the source 6.5px/frame impulse")
	var first_x: float = player.world_x
	bridge._try_windup_stick(stick, bridge.DPAD_RIGHT)
	_check(player.world_x > first_x, "airborne windup allows horizontal correction")
	bridge._update_windup_stick_state(1.0)
	_check(not stick.activated, "windup animation cooldown expires")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	stick = bridge._add_entity(bridge._level_state, bridge.ENTITY_WINDUP_STICK, 240.0, 300.0)
	stick.windup_stick = true
	player.world_x = 240.0
	player.world_y = 300.0
	player.is_grounded = true
	player.speed_x = 300.0
	player.ground_speed = 300.0
	bridge._velocity_y = 0.0
	bridge._try_windup_stick(stick, 0)
	_check(player.ground_speed == 450.0, "ground windup applies the source turn-up increment")

	print("WINDUP_STICK_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("WINDUP_STICK_FAIL: " + label)
