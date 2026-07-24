extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var bar = bridge._add_entity(bridge._level_state, bridge.ENTITY_TURNAROUND_BAR, 240.0, 300.0)
	bar.turnaround_bar = true
	player.world_x = 240.0
	player.world_y = 300.0
	player.is_grounded = true
	player.ground_speed = 300.0
	bridge._try_turnaround_bar(bar)
	_check(bar.turnaround_timer > 0.0 and player.char_state == 8, "fast grounded player grabs the bar")
	_check(player.ground_speed == 0.0, "bar stops the player during the turn")
	bridge._update_turnaround_bar_state(1.0)
	_check(bar.turnaround_timer == 0.0, "bar completes its turn animation")
	_check(player.speed_x < 0.0 and absf(player.speed_x) > 300.0, "bar reverses and boosts the outgoing speed")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	bar = bridge._add_entity(bridge._level_state, bridge.ENTITY_TURNAROUND_BAR, 240.0, 300.0)
	bar.turnaround_bar = true
	player.world_x = 250.0
	player.world_y = 300.0
	player.is_grounded = true
	player.ground_speed = 300.0
	bridge._try_turnaround_bar(bar)
	_check(bar.turnaround_timer == 0.0, "bar rejects contact outside its narrow trigger")

	print("TURNAROUND_BAR_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TURNAROUND_BAR_FAIL: " + label)
