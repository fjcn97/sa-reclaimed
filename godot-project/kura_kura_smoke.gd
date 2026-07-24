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
	var kura = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 360.0, 300.0)
	kura.enemy_profile = 8
	var before_angle: float = kura.state_timer
	bridge._update_kura_kura_motion(kura, 1.0 / 60.0)
	_check(kura.state_timer > before_angle, "kura kura follows the source orbit rate")
	var before_fireball: Vector2 = bridge._kura_kura_fireball_position(kura)
	bridge._update_kura_kura_motion(kura, 1.0 / 60.0)
	var after_fireball: Vector2 = bridge._kura_kura_fireball_position(kura)
	_check(before_fireball.distance_to(after_fireball) > 0.0, "fireball position advances around the body")
	var player = bridge.get_player_state()
	var hit_position: Vector2 = bridge._kura_kura_fireball_position(kura)
	player.world_x = hit_position.x
	player.world_y = hit_position.y + 20.0
	player.rings = 5
	bridge._damage_cooldown = 0.0
	bridge._try_hit_enemy(kura)
	_check(bridge._damage_cooldown > 0.0, "orbiting fireball has a real damage hitbox")
	print("KURA_KURA_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("KURA_KURA_FAIL: " + label)
