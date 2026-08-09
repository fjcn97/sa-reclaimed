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
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var loop = bridge._add_entity(bridge._level_state, bridge.ENTITY_GAPPED_LOOP, 240.0, 300.0)
	loop.gapped_loop = true
	loop.gapped_loop_direction = 1.0
	loop.gapped_loop_center_x = 240.0
	loop.gapped_loop_center_y = 300.0
	player.world_x = 340.0
	player.world_y = 300.0
	player.is_grounded = true
	player.speed_x = 200.0
	bridge._try_gapped_loop(loop)
	_check(loop.gapped_loop_active, "forward loop captures a fast grounded player")
	var first_x: float = player.world_x
	bridge._update_gapped_loop_state(0.2)
	_check(player.world_x != first_x and player.char_state == 5, "loop follows its rotating path")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	loop = bridge._add_entity(bridge._level_state, bridge.ENTITY_GAPPED_LOOP, 240.0, 300.0)
	loop.gapped_loop = true
	loop.gapped_loop_direction = 1.0
	loop.gapped_loop_center_x = 240.0
	loop.gapped_loop_center_y = 300.0
	player.world_x = 340.0
	player.world_y = 300.0
	player.is_grounded = true
	player.speed_x = 100.0
	bridge._try_gapped_loop(loop)
	_check(not loop.gapped_loop_active, "loop rejects speed below the source threshold")

	print("GAPPED_LOOP_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("GAPPED_LOOP_FAIL: " + label)
