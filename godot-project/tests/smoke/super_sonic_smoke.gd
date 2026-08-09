extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = preload("res://scripts/CoreBridge.gd").new()
	get_root().add_child(bridge)
	bridge._selected_character_index = 0
	bridge._unlocked_level_index = bridge._level_names.size() - 1
	bridge._selected_level_index = bridge._level_names.size() - 1
	bridge._chaos_emerald_masks[0] = 127
	bridge.init_level(bridge._selected_level_index, false, false)
	var player = bridge.get_player_state()
	_check(player.super_sonic, "All emeralds activate the True Area 53 Super Sonic route")
	_check(player.rings == 50, "Super Sonic starts with the source-defined 50 rings")
	_check(bridge.is_player_boosting(), "Super Sonic exposes the rocket trail presentation")
	var initial_camera_x: float = bridge.get_camera_state().x
	bridge.physics_tick(bridge.DPAD_RIGHT, bridge.DPAD_RIGHT, 1.0 / 60.0)
	_check(player.speed_x == 900.0, "Super Sonic uses the extra-boss directional speed")
	_check(player.rings == 50, "Ring drain does not occur before one full second")
	_check(bridge.get_camera_state().x >= initial_camera_x, "Super Sonic camera follows its forward lead")
	for _frame in range(59):
		bridge.physics_tick(bridge.DPAD_RIGHT, 0, 1.0 / 60.0)
	_check(player.rings == 49, "Super Sonic drains one ring per source second")
	player.rings = 0
	bridge.physics_tick(0, 0, 1.0)
	_check(not player.is_alive and bridge.is_game_over_screen(), "Zero rings enters the source death/game-over path")
	print("SUPER_SONIC_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SUPER_SONIC_FAIL: " + label)
