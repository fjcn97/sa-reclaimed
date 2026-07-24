extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var start = bridge._add_entity(bridge._level_state, bridge.ENTITY_PIPE_START, 200.0, 300.0)
	var exit = bridge._add_entity(bridge._level_state, bridge.ENTITY_PIPE_END, 500.0, 340.0)
	exit.pipe_exit_back_layer = true
	exit.pipe_exit_uncurl = true
	player.world_x = 212.0
	player.world_y = 300.0
	player.is_grounded = true
	bridge._try_pipe_start(start, 1.0 / 60.0)
	_check(bridge._pipe_active, "pipe starts inside its 24x24 entry area")
	_check(not player.is_grounded and player.char_state == 5, "pipe marks the player as scripted")
	bridge._try_pipe_start(start, 1.0)
	_check(not bridge._pipe_active, "pipe completes its travel")
	_check(bridge._player_layer == 1, "pipe exit applies the back-layer flag")
	_check(not player.is_grounded and player.char_state == 5, "pipe exit applies the uncurl flag")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	start = bridge._add_entity(bridge._level_state, bridge.ENTITY_PIPE_START, 200.0, 300.0)
	bridge._add_entity(bridge._level_state, bridge.ENTITY_PIPE_END, 500.0, 340.0)
	player.world_x = 230.0
	player.world_y = 300.0
	player.is_grounded = true
	bridge._try_pipe_start(start, 1.0 / 60.0)
	_check(not bridge._pipe_active, "pipe rejects players outside its entry rectangle")

	print("PIPE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PIPE_FAIL: " + label)
