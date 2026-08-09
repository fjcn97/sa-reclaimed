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

	var horizontal = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 100.0, 300.0)
	horizontal.enemy_profile = 10
	horizontal.origin_x = 100.0
	horizontal.patrol_min_x = 90.0
	horizontal.patrol_max_x = 110.0
	horizontal.velocity_x = -33.75
	for _history in range(64):
		horizontal.gejigeji_history.append(Vector2(horizontal.world_x, horizontal.world_y))
	for _segment in range(4):
		horizontal.trail_positions.append(Vector2(horizontal.world_x, horizontal.world_y))
	bridge._update_gejigeji_motion(horizontal, 1.0 / 60.0)
	_check(horizontal.world_x < 100.0, "horizontal Geji-Geji follows the source speed")
	_check(horizontal.trail_positions.size() == 4, "Geji-Geji keeps four delayed visual segments")

	horizontal.world_x = horizontal.patrol_min_x
	bridge._update_gejigeji_motion(horizontal, 1.0 / 60.0)
	_check(horizontal.gejigeji_pause_timer > 0.0 and horizontal.velocity_x > 0.0, "Geji-Geji pauses and reverses at a border")

	var vertical = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 220.0, 300.0)
	vertical.enemy_profile = 10
	vertical.gejigeji_vertical = true
	vertical.world_y = 300.0
	vertical.koura_patrol_min_y = 290.0
	vertical.koura_patrol_max_y = 310.0
	vertical.velocity_y = -33.75
	for _history in range(64):
		vertical.gejigeji_history.append(Vector2(vertical.world_x, vertical.world_y))
	for _segment in range(4):
		vertical.trail_positions.append(Vector2(vertical.world_x, vertical.world_y))
	bridge._update_gejigeji_motion(vertical, 1.0 / 60.0)
	_check(vertical.world_y < 300.0, "vertical Geji-Geji follows the source axis")

	var player = bridge.get_player_state()
	player.world_x = horizontal.trail_positions[0].x
	player.world_y = horizontal.trail_positions[0].y + 20.0
	bridge._damage_cooldown = 0.0
	bridge._try_hit_enemy(horizontal)
	_check(bridge._damage_cooldown > 0.0, "Geji-Geji tail has a damage hitbox")

	print("GEJIGEJI_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("GEJIGEJI_FAIL: " + label)
