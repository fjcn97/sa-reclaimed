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

	var bell = bridge._add_entity(bridge._level_state, bridge.ENTITY_ENEMY, 300.0, 300.0)
	bell.enemy_profile = 2
	bell.bell_phase = 0
	bell.bell_phase_timer = 120.0 / 60.0
	for _frame in range(119):
		bridge._update_bell_motion(bell, 1.0 / 60.0)
	_check(bell.bell_phase == 0 and bell.variant == 0, "Bell remains dormant for the source 120 frames")
	bridge._update_bell_motion(bell, 1.0 / 60.0)
	_check(bell.bell_phase == 1 and bell.variant == 1, "Bell activates its own hazard state")
	var projectile_count := 0
	for entity in bridge._level_state.entities:
		if entity.type == bridge.ENTITY_PROJECTILE:
			projectile_count += 1
	_check(projectile_count == 0, "Bell does not spawn a projectile in the original game")

	var active_timer: float = bell.bell_phase_timer
	for _frame in range(180):
		bridge._update_bell_motion(bell, 1.0 / 60.0)
	_check(bell.bell_phase == 0 and bell.bell_phase_timer > 1.9, "Bell returns to dormant timing after its active window")
	_check(active_timer > 2.0, "Bell uses the source 124/180-frame active duration")

	var player = bridge.get_player_state()
	player.world_x = bell.world_x
	player.world_y = bell.world_y + 20.0
	bridge._damage_cooldown = 0.0
	bridge._try_hit_enemy(bell)
	_check(bridge._damage_cooldown > 0.0, "Bell retains a contact damage hitbox")

	print("BELL_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("BELL_FAIL: " + label)
