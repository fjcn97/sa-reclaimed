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

	var flickey = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 160.0, 280.0)
	flickey.enemy_profile = 15
	flickey.origin_x = 160.0
	flickey.origin_y = 280.0
	flickey.world_x = 160.0
	flickey.world_y = 280.0
	flickey.velocity_x = -90.0
	flickey.flickey_vertical_speed = -240.0
	flickey.patrol_min_x = 100.0
	flickey.patrol_max_x = 220.0
	for _history in range(64):
		flickey.flickey_history.append(Vector2(flickey.world_x, flickey.world_y))
	for _segment in range(4):
		flickey.trail_positions.append(Vector2(flickey.world_x, flickey.world_y))
	var before_y: float = flickey.world_y
	bridge._update_flickey_motion(flickey, 1.0 / 60.0)
	_check(flickey.world_y < before_y and flickey.flickey_vertical_speed > -240.0, "Flickey follows the source initial jump acceleration")

	flickey.world_y = bridge._level_state.ground_y - 16.0
	flickey.flickey_vertical_speed = 100.0
	bridge._update_flickey_motion(flickey, 1.0 / 60.0)
	_check(is_equal_approx(flickey.world_y, bridge._level_state.ground_y - 16.0) and flickey.flickey_vertical_speed < 0.0, "Flickey resets its vertical launch at the ground")

	flickey.world_x = flickey.patrol_min_x
	flickey.velocity_x = -90.0
	flickey.flickey_turn_timer = 0.0
	bridge._update_flickey_motion(flickey, 1.0 / 60.0)
	_check(flickey.flickey_turn_timer > 0.0, "Flickey pauses before reversing at a horizontal border")
	for _frame in range(25):
		bridge._update_flickey_motion(flickey, 1.0 / 60.0)
	_check(flickey.velocity_x > 0.0, "Flickey reverses after the source turn animation")
	_check(flickey.trail_positions[0].distance_to(flickey.trail_positions[3]) > 0.0, "Flickey iron balls use delayed history positions")

	var player = bridge.get_player_state()
	player.world_x = flickey.trail_positions[0].x
	player.world_y = flickey.trail_positions[0].y + 20.0
	bridge._damage_cooldown = 0.0
	bridge._try_hit_enemy(flickey)
	_check(bridge._damage_cooldown > 0.0, "Flickey iron balls have a damage hitbox")

	print("FLICKEY_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("FLICKEY_FAIL: " + label)
