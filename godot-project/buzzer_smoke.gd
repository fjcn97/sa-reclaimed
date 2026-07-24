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

	var buzzer = bridge._add_entity(bridge._level_state, bridge.ENTITY_BUZZER, 300.0, 300.0)
	buzzer.origin_x = 300.0
	buzzer.origin_y = 300.0
	buzzer.world_x = 300.0
	buzzer.world_y = 300.0
	buzzer.patrol_min_x = 260.0
	buzzer.patrol_max_x = 340.0
	buzzer.velocity_x = 45.0
	buzzer.variant = 0
	buzzer.buzzer_cooldown = 0.0
	var player = bridge.get_player_state()
	player.is_alive = true
	player.world_x = 330.0
	player.world_y = 340.0
	bridge._update_buzzer_motion(buzzer, 1.0 / 60.0)
	_check(buzzer.variant == 1 and is_equal_approx(buzzer.buzzer_attack_timer, 32.0 / 60.0), "Buzzer enters its source attack sector")

	buzzer.buzzer_attack_timer = 1.0 / 60.0
	bridge._update_buzzer_motion(buzzer, 1.0 / 60.0)
	_check(buzzer.variant == 2, "Buzzer begins its return pass after 32 attack frames")
	buzzer.buzzer_attack_timer = 1.0 / 60.0
	bridge._update_buzzer_motion(buzzer, 1.0 / 60.0)
	_check(buzzer.variant == 0 and is_equal_approx(buzzer.buzzer_cooldown, 1.0), "Buzzer returns with the source 60-frame cooldown")

	buzzer.buzzer_cooldown = 0.0
	buzzer.world_x = buzzer.patrol_max_x - 0.5
	buzzer.velocity_x = 45.0
	buzzer.variant = 0
	bridge._update_buzzer_motion(buzzer, 1.0 / 60.0)
	_check(buzzer.buzzer_turn_timer > 0.0, "Buzzer pauses at the map border before turning")
	for _frame in range(18):
		bridge._update_buzzer_motion(buzzer, 1.0 / 60.0)
	_check(buzzer.velocity_x < 0.0, "Buzzer reverses after the turn animation")

	print("BUZZER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("BUZZER_FAIL: " + label)
