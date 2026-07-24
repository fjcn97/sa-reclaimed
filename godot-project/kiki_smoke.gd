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

	var kiki = bridge._add_entity(bridge._level_state, bridge.ENTITY_KIKI, 300.0, 100.0)
	kiki.origin_x = 300.0
	kiki.origin_y = 100.0
	kiki.world_y = 100.0
	kiki.kiki_vertical_min = 100.0
	kiki.kiki_vertical_max = 148.0
	kiki.kiki_vertical_direction = 1.0
	kiki.kiki_border_hits = 0
	kiki.variant = 0
	bridge._update_kiki_motion(kiki, 1.0 / 60.0)
	_check(is_equal_approx(kiki.world_y, 101.0), "Kiki moves one source pixel per frame")

	kiki.world_y = kiki.kiki_vertical_min
	kiki.kiki_vertical_direction = -1.0
	bridge._update_kiki_motion(kiki, 1.0 / 60.0)
	kiki.world_y = kiki.kiki_vertical_min
	kiki.kiki_vertical_direction = -1.0
	bridge._update_kiki_motion(kiki, 1.0 / 60.0)
	_check(kiki.variant == 1 and kiki.kiki_border_hits == 2, "Kiki attacks on every second upper-border crossing")

	var before: int = bridge._level_state.entities.size()
	kiki.kiki_attack_frames = 17
	bridge._update_kiki_motion(kiki, 1.0 / 60.0)
	_check(kiki.kiki_projectile_spawned and bridge._level_state.entities.size() == before + 1, "Kiki launches its projectile on attack frame 18")
	var projectile = bridge._level_state.entities[bridge._level_state.entities.size() - 1]
	_check(is_equal_approx(projectile.velocity_y, -120.0) and absf(projectile.velocity_x) <= 60.0, "Kiki uses the source projectile speeds")

	kiki.kiki_attack_frames = 29
	bridge._update_kiki_motion(kiki, 1.0 / 60.0)
	_check(kiki.variant == 0, "Kiki returns to its vertical patrol after the attack animation")

	print("KIKI_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("KIKI_FAIL: " + label)
