extends SceneTree

const DISPATCHER := preload("res://scripts/core/EntityInteractionDispatcher.gd")
const BRIDGE := preload("res://scripts/CoreBridge.gd")
const LEVEL_STATE := preload("res://scripts/core/LevelState.gd")
const ENTITY_STATE := preload("res://scripts/core/EntityState.gd")
const TYPES := preload("res://scripts/core/EntityTypes.gd")

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = BRIDGE.new()
	get_root().add_child(bridge)
	var level = LEVEL_STATE.new()
	var ring = ENTITY_STATE.new()
	ring.type = TYPES.ENTITY_RING
	ring.world_x = 100.0
	ring.world_y = 0.0
	ring.active = true
	level.entities.append(ring)
	bridge._level_state = level
	bridge._player_state.world_x = 100.0
	bridge._player_state.world_y = 20.0
	bridge._player_state.is_alive = true
	DISPATCHER.dispatch(bridge, level, 0, 0, 1.0 / 60.0)
	_check(not ring.active and ring.collected, "Dispatcher routes ring entities to collection")
	_check(bridge._player_state.rings == 1, "Dispatcher preserves bridge interaction state")
	_check(level.entities.size() == 2 and level.entities[1].type == TYPES.ENTITY_RING_EFFECT, "Interaction handler can spawn its effect through the bridge")

	var inactive = ENTITY_STATE.new()
	inactive.type = TYPES.ENTITY_RING
	inactive.active = false
	level.entities.append(inactive)
	DISPATCHER.dispatch(bridge, level, 0, 0, 1.0 / 60.0)
	_check(not inactive.collected, "Dispatcher skips inactive entities")

	print("ENTITY_INTERACTION_DISPATCHER_CHECKS=%d" % checks)
	bridge.queue_free()
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ENTITY_INTERACTION_DISPATCHER_FAIL: " + label)
