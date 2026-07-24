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
	var pipe = bridge._add_entity(bridge._level_state, bridge.ENTITY_HALF_PIPE, 240.0, 300.0)
	pipe.half_pipe = true
	pipe.half_pipe_direction = 1.0
	pipe.width = 240.0
	pipe.height = 160.0
	player.world_x = 180.0
	player.world_y = 300.0
	player.is_grounded = true
	player.speed_x = 300.0
	bridge._try_half_pipe(pipe)
	_check(pipe.half_pipe_active, "forward pipe captures a fast grounded player")
	bridge._update_half_pipe_state(0)
	_check(player.world_y < pipe.half_pipe_base_y and player.is_grounded, "pipe follows the speed-scaled arc")

	player.speed_x = 100.0
	bridge._update_half_pipe_state(0)
	_check(not pipe.half_pipe_active and not player.is_grounded, "pipe exits below the source speed threshold")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	pipe = bridge._add_entity(bridge._level_state, bridge.ENTITY_HALF_PIPE, 240.0, 300.0)
	pipe.half_pipe = true
	pipe.half_pipe_direction = 1.0
	pipe.width = 240.0
	pipe.height = 160.0
	player.world_x = 180.0
	player.world_y = 300.0
	player.is_grounded = true
	player.speed_x = 300.0
	bridge._try_half_pipe(pipe)
	bridge._update_half_pipe_state(bridge.A_BUTTON)
	_check(not pipe.half_pipe_active and not player.is_grounded and player.speed_y < 0.0, "A releases the pipe with a jump")

	print("HALF_PIPE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("HALF_PIPE_FAIL: " + label)
