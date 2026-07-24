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

	var ring = bridge._add_entity(bridge._level_state, bridge.ENTITY_DASH_RING, 300.0, 300.0)
	var player = bridge.get_player_state()
	player.world_x = 300.0
	player.world_y = 300.0
	ring.variant = bridge.DASH_RING_UP
	bridge._try_dash_ring(ring, 1.0 / 60.0)
	_check(is_equal_approx(player.world_x, 300.0) and is_equal_approx(player.world_y, 300.0), "Dash Ring anchors the player at its source position")
	_check(is_equal_approx(bridge._dash_velocity_x, 0.0) and is_equal_approx(bridge._dash_velocity_y, -480.0), "Dash Ring uses the source 8-pixel-per-frame vertical speed")

	bridge._dash_timer = 0.0
	ring.activated = false
	player.world_x = 300.0
	player.world_y = 300.0
	ring.variant = bridge.DASH_RING_RIGHT
	bridge._try_dash_ring(ring, 1.0 / 60.0)
	_check(is_equal_approx(bridge._dash_velocity_x, 480.0) and is_equal_approx(bridge._dash_velocity_y, 0.0), "Dash Ring maps the right orientation to horizontal speed")

	bridge._dash_timer = 0.0
	ring.activated = false
	player.world_x = 400.0
	bridge._try_dash_ring(ring, 1.0 / 60.0)
	_check(not ring.activated, "Dash Ring ignores players outside its collision box")

	print("DASH_RING_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("DASH_RING_FAIL: " + label)
