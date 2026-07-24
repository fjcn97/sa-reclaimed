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
	var handle = bridge._add_entity(bridge._level_state, bridge.ENTITY_FLYING_HANDLE, 240.0, 300.0)
	handle.flying_handle = true
	handle.flying_handle_top_y = 180.0
	handle.flying_handle_bottom_y = 300.0
	handle.world_y = 300.0
	player.world_x = 240.0
	player.world_y = 300.0
	player.is_grounded = false
	bridge._try_flying_handle(handle, 0)
	_check(handle.activated and player.char_state == 8, "flying handle captures an airborne player")
	bridge._update_flying_handle_state(0.1)
	_check(player.world_y == handle.world_y, "captured player follows the handle position")
	bridge._update_flying_handle_state(0.5)
	bridge._try_flying_handle(handle, bridge.A_BUTTON)
	_check(not handle.activated and bridge._velocity_y < 0.0, "A releases the handle into a jump")
	bridge._update_flying_handle_state(0.1)
	_check(handle.effect_offset != 0.0, "idle handle keeps its source oscillation")

	print("FLYING_HANDLE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("FLYING_HANDLE_FAIL: " + label)
