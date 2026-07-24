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

	var ring = bridge._add_entity(bridge._level_state, bridge.ENTITY_SPECIAL_RING, 300.0, 300.0)
	var player = bridge.get_player_state()
	player.world_x = 300.0
	player.world_y = 320.0
	bridge._try_collect_special_ring(ring)
	_check(player.special_rings == 1 and ring.active and ring.special_ring_collected, "Special Ring starts its source collection animation")
	_check(is_equal_approx(ring.special_ring_collect_timer, 0.5), "Special Ring keeps a 30-frame collection timer")

	bridge._update_special_ring_motion(ring, 29.0 / 60.0)
	_check(ring.active, "Special Ring remains present until its animation ends")
	bridge._update_special_ring_motion(ring, 1.0 / 60.0)
	_check(not ring.active, "Special Ring despawns after its collection animation")

	print("SPECIAL_RING_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SPECIAL_RING_FAIL: " + label)
