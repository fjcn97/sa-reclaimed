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
	bridge.init_level(0, false, false)
	var player = bridge.get_player_state()
	var trigger = bridge._add_entity(bridge._level_state, bridge.ENTITY_LAP_TRIGGER, 300.0, 300.0)
	trigger.width = 20.0
	trigger.height = 40.0
	trigger.lap_previous_player_x = 240.0
	player.world_y = 300.0
	player.world_x = 240.0
	bridge._try_lap_trigger(trigger)
	player.world_x = 300.0
	bridge._try_lap_trigger(trigger)
	player.world_x = 360.0
	bridge._try_lap_trigger(trigger)
	_check(trigger.lap_passed, "first crossing arms trigger")
	_check(player.rings == 0, "first crossing gives no bonus")

	bridge._checkpoint_time = 10.0
	player.world_x = 240.0
	bridge._try_lap_trigger(trigger)
	player.world_x = 300.0
	bridge._try_lap_trigger(trigger)
	player.world_x = 360.0
	bridge._try_lap_trigger(trigger)
	_check(player.rings == 15 and trigger.lap_last_bonus == 15, "fast lap gives fifteen rings")
	_check(trigger.lap_count == 1, "fast lap increments lap once")

	player.world_x = 300.0
	bridge._try_lap_trigger(trigger)
	player.world_x = 240.0
	bridge._try_lap_trigger(trigger)
	_check(trigger.lap_count == 0, "reverse crossing decrements lap")

	var slow_trigger = bridge._add_entity(bridge._level_state, bridge.ENTITY_LAP_TRIGGER, 500.0, 300.0)
	slow_trigger.width = 20.0
	slow_trigger.height = 40.0
	slow_trigger.lap_previous_player_x = 440.0
	player.world_x = 440.0
	bridge._try_lap_trigger(slow_trigger)
	player.world_x = 500.0
	bridge._try_lap_trigger(slow_trigger)
	player.world_x = 560.0
	bridge._try_lap_trigger(slow_trigger)
	bridge._checkpoint_time = 41.0
	player.world_x = 440.0
	bridge._try_lap_trigger(slow_trigger)
	player.world_x = 500.0
	bridge._try_lap_trigger(slow_trigger)
	player.world_x = 560.0
	bridge._try_lap_trigger(slow_trigger)
	_check(slow_trigger.lap_last_bonus == 5, "slow lap gives five rings")

	bridge._run_from_multiplayer = true
	player.rings = 253
	bridge._checkpoint_time = 40.0
	player.world_x = 440.0
	bridge._try_lap_trigger(slow_trigger)
	player.world_x = 500.0
	bridge._try_lap_trigger(slow_trigger)
	player.world_x = 560.0
	bridge._try_lap_trigger(slow_trigger)
	_check(player.rings == 255, "multiplayer ring bonus caps at 255")
	print("LAP_TRIGGER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("LAP_TRIGGER_FAIL: " + label)
