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

	var kubinaga = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	kubinaga.enemy_profile = 11
	kubinaga.origin_x = 300.0
	kubinaga.origin_y = 300.0
	kubinaga.target_x = 300.0
	kubinaga.target_y = 300.0
	kubinaga.kubinaga_phase_timer = 0.0
	var player = bridge.get_player_state()
	player.world_x = 360.0
	player.world_y = 300.0
	bridge._update_kubinaga_motion(kubinaga, 1.0 / 60.0)
	_check(kubinaga.kubinaga_phase == 1, "Kubinaga starts extending when the player enters range")

	for _frame in range(40):
		bridge._update_kubinaga_motion(kubinaga, 1.0 / 60.0)
	_check(is_equal_approx(kubinaga.kubinaga_extension, 68.0) and kubinaga.kubinaga_phase == 2, "Kubinaga reaches the source extension hold")

	for _frame in range(20):
		bridge._update_kubinaga_motion(kubinaga, 1.0 / 60.0)
	var projectile_found := false
	for entity in bridge._level_state.entities:
		if entity.type == bridge.ENTITY_PROJECTILE and entity.enemy_profile == 11:
			projectile_found = true
			break
	_check(projectile_found, "Kubinaga fires a directed projectile during the hold")

	for _frame in range(45):
		bridge._update_kubinaga_motion(kubinaga, 1.0 / 60.0)
	_check(kubinaga.kubinaga_phase == 3 or kubinaga.kubinaga_extension < 68.0, "Kubinaga begins retracting after the shot")

	player.world_x = kubinaga.target_x
	player.world_y = kubinaga.target_y + 20.0
	bridge._damage_cooldown = 0.0
	bridge._try_hit_enemy(kubinaga)
	_check(bridge._damage_cooldown > 0.0, "Kubinaga head has a damage hitbox")

	print("KUBINAGA_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("KUBINAGA_FAIL: " + label)
