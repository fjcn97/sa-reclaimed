extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var funnel = bridge._add_entity(bridge._level_state, bridge.ENTITY_FUNNEL_SPHERE, 240.0, 300.0)
	funnel.funnel_sphere = true
	player.world_x = 240.0
	player.world_y = 300.0
	player.is_grounded = false
	player.speed_x = 0.0
	bridge._try_funnel_sphere(funnel)
	_check(funnel.activated and player.char_state == 6, "funnel captures an airborne player")
	bridge._update_funnel_sphere_state(0.1)
	_check(player.world_x > 240.0, "funnel first moves the player to the right")
	bridge._update_funnel_sphere_state(1.2)
	_check(not funnel.activated and player.speed_y == 360.0, "slow entry exits with the source downward launch")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	funnel = bridge._add_entity(bridge._level_state, bridge.ENTITY_FUNNEL_SPHERE, 240.0, 300.0)
	funnel.funnel_sphere = true
	player.world_x = 240.0
	player.world_y = 300.0
	player.speed_x = 400.0
	bridge._try_funnel_sphere(funnel)
	bridge._update_funnel_sphere_state(1.3)
	_check(player.speed_y == -600.0, "fast entry exits with the source upward launch")

	print("FUNNEL_SPHERE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("FUNNEL_SPHERE_FAIL: " + label)
