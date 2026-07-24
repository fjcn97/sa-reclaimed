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
	bridge.init_level(0, false, false)
	_check(bridge._source_interactable_type("GOAL_LEVER") == bridge.ENTITY_GOAL_LEVER, "goal lever has its own entity type")
	_check(bridge._source_interactable_type("TOGGLE__GOAL") == bridge.ENTITY_GOAL, "goal toggle remains the clear entity")
	var player = bridge.get_player_state()
	var lever = bridge._add_entity(bridge._level_state, bridge.ENTITY_GOAL_LEVER, 320.0, 300.0)
	player.world_x = 320.0
	player.world_y = 320.0
	bridge._try_goal_lever(lever)
	_check(lever.activated, "touching lever activates it")
	_check(not bridge._level_complete, "lever does not clear the stage")
	var goal = bridge._add_entity(bridge._level_state, bridge.ENTITY_GOAL, 480.0, 300.0)
	goal.goal_toggle = true
	player.world_x = 600.0
	player.ground_speed = 300.0
	player.is_grounded = true
	bridge._try_reach_goal(goal)
	_check(bridge._level_complete, "goal toggle clears the stage")
	_check(player.score == 5300, "single-player finish awards source speed bonus")
	print("GOAL_LEVER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("GOAL_LEVER_FAIL: " + label)
