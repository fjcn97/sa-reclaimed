extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = preload("res://scripts/CoreBridge.gd").new()
	get_root().add_child(bridge)
	bridge.init_level(0, false, false)
	var player = bridge.get_player_state()
	player.world_x = 320.0
	player.world_y = 300.0
	player.rings = 10
	bridge._spawn_scattered_rings(player.rings)
	var rings := _active_scatter_rings(bridge)
	_check(rings.size() == 10, "damage scatters the source ring count")
	_check(rings[0].state_timer == 2.8, "scattered rings use the source lifetime")
	var start_x: float = rings[0].world_x
	var start_y: float = rings[0].world_y
	bridge._update_scattered_ring(rings[0], 1.0 / 60.0)
	_check(rings[0].world_x != start_x or rings[0].world_y != start_y, "scattered rings advance with source velocity")
	_check(rings[0].velocity_y > -210.0, "scattered rings apply source gravity")
	for _frame in range(180):
		bridge._update_scattered_ring(rings[0], 1.0 / 60.0)
	_check(not rings[0].active, "scattered rings expire after the source lifetime")
	print("SCATTER_RING_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _active_scatter_rings(bridge: Node) -> Array:
	var result: Array = []
	for entity in bridge.get_entities():
		if entity.type == bridge.ENTITY_SCATTER_RING and entity.active:
			result.append(entity)
	return result

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SCATTER_RING_FAIL: " + label)
