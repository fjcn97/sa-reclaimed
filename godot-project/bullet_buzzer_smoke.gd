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

	var buzzer = bridge._add_entity(bridge._level_state, bridge.ENTITY_BULLET_BUZZER, 300.0, 300.0)
	buzzer.origin_x = 300.0
	buzzer.origin_y = 300.0
	buzzer.state_timer = 0.0
	buzzer.variant = 0
	buzzer.bullet_buzzer_angle = 0.0
	bridge._update_bullet_buzzer_motion(buzzer, 1.0 / 60.0)
	_check(buzzer.variant == 1 and buzzer.bullet_buzzer_angle > 0.0, "Bullet Buzzer enters its source attack state")
	_check(is_equal_approx(buzzer.bullet_buzzer_attack_timer, 50.0 / 60.0), "Bullet Buzzer uses the source 50-frame attack animation")

	var before: int = bridge._level_state.entities.size()
	buzzer.bullet_buzzer_attack_timer = 17.0 / 60.0
	bridge._update_bullet_buzzer_motion(buzzer, 1.0 / 60.0)
	_check(buzzer.bullet_buzzer_projectile_spawned and bridge._level_state.entities.size() == before + 3, "Bullet Buzzer creates its three-projectile salvo on frame 34")

	buzzer.bullet_buzzer_attack_timer = 1.0 / 60.0
	bridge._update_bullet_buzzer_motion(buzzer, 1.0 / 60.0)
	_check(buzzer.variant == 0 and is_equal_approx(buzzer.state_timer, 1.0), "Bullet Buzzer returns to the source cooldown")

	print("BULLET_BUZZER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("BULLET_BUZZER_FAIL: " + label)
