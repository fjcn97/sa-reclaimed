extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var flute = bridge._add_entity(bridge._level_state, bridge.ENTITY_GERMAN_FLUTE, 240.0, 300.0)
	flute.german_flute = true
	flute.german_flute_kind = 0
	player.world_x = 240.0
	player.world_y = 300.0
	bridge._try_german_flute(flute)
	_check(flute.german_flute_phase == 0 and flute.activated, "flute captures the player")
	bridge._update_german_flute_state(0.1, 0)
	_check(player.char_state == 8 and player.world_y > 300.0, "flute aligns the player before the exhaust")
	bridge._update_german_flute_state(0.5, 0)
	_check(flute.german_flute_phase == 1 and player.speed_y < 0.0, "flute starts its upward draft")
	bridge._update_german_flute_state(0.8, 0)
	_check(flute.german_flute_phase == 2, "flute reaches its oscillating phase")
	var first_x: float = player.world_x
	bridge._update_german_flute_state(0.1, bridge.DPAD_RIGHT)
	_check(player.world_x > first_x and player.char_state == 9, "flute allows horizontal control while oscillating")
	bridge._update_german_flute_state(3.1, 0)
	_check(not flute.activated and flute.german_flute_timer == 0.0, "flute exits after its source duration")

	print("GERMAN_FLUTE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("GERMAN_FLUTE_FAIL: " + label)
