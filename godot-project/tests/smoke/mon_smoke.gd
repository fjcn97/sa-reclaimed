extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node_or_null("CoreBridge")
	if bridge == null:
		bridge = preload("res://scripts/CoreBridge.gd").new()
		bridge.name = "CoreBridge"
		get_root().add_child(bridge)
	bridge.init_level(1, false, false)

	var mon = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	mon.enemy_profile = 16
	mon.origin_x = 300.0
	mon.origin_y = 300.0
	mon.world_x = 300.0
	mon.world_y = 300.0
	var player = bridge.get_player_state()
	player.world_x = 400.0
	player.world_y = 300.0
	bridge._update_mon_motion(mon, 1.0 / 60.0)
	_check(mon.variant == 1 and is_equal_approx(mon.mon_phase_timer, 18.0 / 60.0), "Mon activates inside the source 120x50 range")

	player.world_x = 400.0
	for _frame in range(17):
		bridge._update_mon_motion(mon, 1.0 / 60.0)
	_check(mon.variant == 1, "Mon keeps the source 18-frame alert phase")
	bridge._update_mon_motion(mon, 1.0 / 60.0)
	_check(mon.variant == 2 and is_equal_approx(mon.velocity_y, -330.0), "Mon launches at the source jump speed")

	var before_velocity: float = mon.velocity_y
	bridge._update_mon_motion(mon, 1.0 / 60.0)
	_check(mon.velocity_y > before_velocity, "Mon uses the source 52/256 gravity increment")

	var landed := false
	for _frame in range(80):
		bridge._update_mon_motion(mon, 1.0 / 60.0)
		if mon.variant == 3:
			landed = true
			break
	_check(landed and mon.mon_phase_timer > 0.0, "Mon enters the landing animation phase")

	for _frame in range(18):
		bridge._update_mon_motion(mon, 1.0 / 60.0)
	_check(mon.variant == 1, "Mon repeats the alert phase while the player remains nearby")

	print("MON_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MON_FAIL: " + label)
