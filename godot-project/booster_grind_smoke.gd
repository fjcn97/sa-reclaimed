extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = preload("res://scripts/CoreBridge.gd").new()
	bridge.name = "CoreBridge"
	get_root().add_child(bridge)
	bridge.init_level(1, false, false)
	var player = bridge.get_player_state()

	var booster = bridge._add_entity(bridge._level_state, bridge.ENTITY_BOOSTER, 300.0, 300.0)
	booster.width = 34.0
	booster.height = 24.0
	booster.velocity_x = 1.0
	player.world_x = 300.0
	player.world_y = 300.0
	player.is_grounded = true
	bridge._try_booster(booster, 1.0 / 60.0)
	_check(is_equal_approx(player.speed_x, 720.0), "Booster applies the source 3072 fixed-point speed")
	_check(is_equal_approx(player.world_x, 312.0), "Booster advances twelve pixels per source frame")

	var start = bridge._add_entity(bridge._level_state, bridge.ENTITY_GRIND_RAIL, 400.0, 300.0)
	start.width = 96.0
	start.height = 18.0
	start.rail_direction = 1.0
	start.rail_is_start = true
	player.world_x = 400.0
	player.world_y = 300.0
	player.is_grounded = true
	bridge._velocity_y = 0.0
	bridge._try_grind_rail(start)
	_check(bridge._grind_timer > 0.0 and player.char_state == 6, "Ground rail captures a grounded player")
	_check(is_equal_approx(bridge._grind_velocity_x, 240.0), "Rail starts with the source grinding velocity")

	var end = bridge._add_entity(bridge._level_state, bridge.ENTITY_GRIND_RAIL, 500.0, 300.0)
	end.width = 96.0
	end.rail_is_start = false
	player.world_x = 500.0
	bridge._try_grind_rail(end)
	_check(bridge._grind_timer > 0.0, "Rail end entities do not recapture the player")

	bridge._grind_timer = 0.0
	var air_start = bridge._add_entity(bridge._level_state, bridge.ENTITY_GRIND_RAIL, 600.0, 300.0)
	air_start.width = 96.0
	air_start.rail_is_start = true
	air_start.rail_air_start = true
	player.world_x = 600.0
	player.is_grounded = true
	bridge._velocity_y = 0.0
	bridge._try_grind_rail(air_start)
	_check(bridge._grind_timer == 0.0, "Air rail ignores grounded players")
	player.is_grounded = false
	bridge._velocity_y = 120.0
	bridge._try_grind_rail(air_start)
	_check(bridge._grind_timer > 0.0, "Air rail captures a descending airborne player")

	print("BOOSTER_GRIND_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("BOOSTER_GRIND_FAIL: " + label)
