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

	var horizontal = bridge._add_entity(bridge._level_state, bridge.ENTITY_KOURA, 100.0, 300.0)
	horizontal.origin_x = 100.0
	horizontal.origin_y = 300.0
	horizontal.patrol_min_x = 90.0
	horizontal.patrol_max_x = 110.0
	horizontal.velocity_x = -30.0
	horizontal.koura_motion_variant = 0
	bridge._update_koura_motion(horizontal, 1.0 / 60.0)
	_check(horizontal.world_x < 100.0, "horizontal Koura follows the source half-pixel motion")
	horizontal.world_x = horizontal.patrol_min_x
	bridge._update_koura_motion(horizontal, 1.0 / 60.0)
	_check(horizontal.velocity_x > 0.0, "horizontal Koura reverses at the left border")

	var oscillator = bridge._add_entity(bridge._level_state, bridge.ENTITY_KOURA, 180.0, 300.0)
	oscillator.origin_x = 180.0
	oscillator.origin_y = 300.0
	oscillator.koura_motion_variant = 2
	var before_y: float = oscillator.world_y
	bridge._update_koura_motion(oscillator, 1.0 / 60.0)
	_check(not is_equal_approx(oscillator.world_y, before_y), "horizontal Koura variant oscillates vertically")

	var vertical = bridge._add_entity(bridge._level_state, bridge.ENTITY_KOURA, 260.0, 300.0)
	vertical.origin_y = 300.0
	vertical.koura_motion_variant = 3
	vertical.koura_patrol_min_y = 290.0
	vertical.koura_patrol_max_y = 310.0
	vertical.velocity_y = -30.0
	bridge._update_koura_motion(vertical, 1.0 / 60.0)
	_check(vertical.world_y < 300.0, "vertical Koura follows the source vertical motion")
	vertical.world_y = vertical.koura_patrol_min_y
	bridge._update_koura_motion(vertical, 1.0 / 60.0)
	_check(vertical.velocity_y > 0.0, "vertical Koura reverses at the top border")

	var imported = bridge._add_entity(bridge._level_state, bridge.ENTITY_KOURA, 400.0, 300.0)
	bridge._configure_source_enemy(imported, "KOURA", {"fields": [0, 0, 0, 0, "KOURA", -2, 0, 10, 2]})
	_check(imported.koura_motion_variant == 0 and imported.patrol_max_x > imported.patrol_min_x, "source Koura fields select horizontal bounds")

	print("KOURA_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("KOURA_FAIL: " + label)
