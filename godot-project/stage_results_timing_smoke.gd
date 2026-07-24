extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._selected_character_index = 1
	bridge._selected_level_index = 0
	bridge.init_level(0, false, false)
	var goal: Object = _find_goal(bridge)
	_check(goal != null, "goal exists")
	if goal == null:
		quit(1)
		return

	bridge._elapsed_time = 0.0
	bridge._player_state.world_x = goal.world_x
	bridge._player_state.world_y = goal.world_y
	bridge._try_reach_goal(goal)
	_check(bridge.is_clear_screen(), "stage results opened")
	_check(int(bridge.get_clear_rows()[0].get("value", -1)) == 80000, "bonus waits through opening delay")

	for _frame in range(150):
		bridge.advance_ui_timers(1.0 / 60.0)
	_check(int(bridge.get_clear_rows()[0].get("value", -1)) == 80000, "bonus waits through opening delay")
	bridge.advance_ui_timers(1.0 / 60.0)
	_check(int(bridge.get_clear_rows()[0].get("value", -1)) < 80000, "bonus starts after 150 frames")

	for _frame in range(800):
		bridge.advance_ui_timers(1.0 / 60.0)
	_check(bridge._clear_counting_done, "bonus drains at one step per frame")
	_check(not bridge.is_clear_input_ready(), "results retain the source post-count tail")
	for _frame in range(311):
		bridge.advance_ui_timers(1.0 / 60.0)
	_check(bridge.is_intro_screen(), "results transition after the source post-count tail")
	bridge._selected_level_index = 0
	bridge.init_level(0, false, false)
	goal = _find_goal(bridge)
	bridge._player_state.world_x = goal.world_x
	bridge._player_state.world_y = goal.world_y
	bridge._try_reach_goal(goal)
	bridge.advance_ui_timers(2.5)
	bridge.physics_tick(0, bridge.A_BUTTON, 1.0 / 60.0)
	_check(bridge._clear_counting_done and not bridge.is_clear_input_ready(), "A fast-forwards scoring but preserves the source tail")
	bridge.advance_ui_timers(161.0 / 60.0)
	_check(bridge.is_intro_screen(), "fast-forwarded results use the shorter source tail")
	bridge._selected_level_index = bridge._level_names.size() - 1
	bridge._run_from_multiplayer = false
	var final_rows: Array = bridge.get_clear_rows()
	_check(final_rows.size() == 3, "final stage omits special ring row")

	print("STAGE_RESULTS_TIMING_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _find_goal(bridge: Node) -> Object:
	for entity in bridge.get_entities():
		if entity.type == bridge.ENTITY_GOAL:
			return entity
	return null

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("STAGE_RESULTS_TIMING_FAILED %s" % label)
