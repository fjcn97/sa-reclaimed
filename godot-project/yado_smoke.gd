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

	var yado = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	yado.enemy_profile = 5
	yado.yado_phase = 0
	yado.yado_phase_timer = 2.0
	yado.yado_facing = 1
	var player = bridge.get_player_state()
	player.world_x = 400.0
	player.world_y = 300.0
	for _frame in range(119):
		bridge._update_yado_motion(yado, 1.0 / 60.0)
	_check(yado.yado_phase == 0, "Yado keeps the source 120-frame cooldown")
	bridge._update_yado_motion(yado, 1.0 / 60.0)
	_check(yado.yado_phase == 1 and yado.yado_phase_timer > 1.9, "Yado enters the 120-frame attack animation")

	for _frame in range(61):
		bridge._update_yado_motion(yado, 1.0 / 60.0)
	var projectile = null
	for entity in bridge._level_state.entities:
		if entity.type == bridge.ENTITY_PROJECTILE and entity.enemy_profile == 17:
			projectile = entity
			break
	_check(projectile != null, "Yado fires when 60 frames remain in the attack")
	if projectile != null:
		var before_y: float = projectile.world_y
		bridge._update_enemy_motion(1.0 / 60.0)
		_check(projectile.velocity_x > 0.0 and is_equal_approx(projectile.world_y, before_y), "Yado projectile travels horizontally without gravity")

	for _frame in range(61):
		bridge._update_yado_motion(yado, 1.0 / 60.0)
	_check(yado.yado_phase == 0 and yado.variant == 0, "Yado returns to idle after the attack")

	player.world_x = 200.0
	yado.yado_phase_timer = 1.0
	bridge._update_yado_motion(yado, 1.0 / 60.0)
	_check(yado.yado_phase == 2 and yado.yado_facing == -1, "Yado starts the source turn animation when facing changes")

	print("YADO_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("YADO_FAIL: " + label)
