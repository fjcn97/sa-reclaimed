extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._unlocked_level_index = 1

	_check_normal_course_flow(bridge)
	_check_boss_result_heading(bridge)
	_check_time_attack_flow(bridge)
	_check_time_attack_timeout_flow(bridge)
	_check_multiplayer_flow(bridge)

	print("RESULTS_FLOW_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check_normal_course_flow(bridge: Node) -> void:
	bridge._selected_level_index = 0
	bridge.init_level(0, false, false)
	var goal: Object = _find_goal(bridge)
	_check(goal != null, "normal goal exists")
	if goal == null:
		return
	bridge._player_state.world_x = goal.world_x
	bridge._player_state.world_y = goal.world_y
	bridge._try_reach_goal(goal)
	_check(bridge.is_clear_screen(), "normal course clear")
	bridge._finish_clear_counting()
	bridge.advance_ui_timers(310.0 / 60.0 + 1.0 / 60.0)
	_check(bridge.is_intro_screen(), "normal course chains to next stage")

func _check_time_attack_flow(bridge: Node) -> void:
	bridge._selected_level_index = 0
	bridge.init_level(0, true, false)
	bridge._complete_boss()
	_check(bridge.is_time_attack_clear_screen(), "time attack clear")
	bridge.advance_ui_timers(10.1)
	_check(bridge.is_time_attack_lobby_screen(), "time attack returns to lobby")

func _check_boss_result_heading(bridge: Node) -> void:
	bridge._selected_level_index = 1
	bridge.init_level(1, false, false)
	bridge._complete_boss()
	_check(bridge.is_clear_screen(), "boss course clear")
	_check(bridge.is_boss_course_result(), "boss result detected")
	_check(bridge.get_clear_title_text() == "BOSS DESTROYED", "boss result heading")

func _check_multiplayer_flow(bridge: Node) -> void:
	bridge._selected_level_index = 0
	bridge.init_level(0, false, true)
	var goal: Object = _find_goal(bridge)
	_check(goal != null, "multiplayer goal exists")
	if goal == null:
		return
	bridge._player_state.world_x = goal.world_x
	bridge._player_state.world_y = goal.world_y
	bridge._try_reach_goal(goal)
	_check(bridge.is_clear_screen(), "multiplayer course clear")
	bridge.advance_ui_timers(0.1)
	_check(bridge.is_singlepak_results_screen(), "multiplayer opens results")
	var previous_language: int = int(bridge._language_index)
	bridge._language_index = 2
	var result_rows: Array = bridge.get_singlepak_result_rows()
	var first_stat := str(result_rows[0].get("stat_text", "")) if result_rows.size() > 0 else ""
	_check(first_stat.contains("RINGE") or first_stat.contains("FESTGELEGT"), "multiplayer result stats are localized")
	_check(str(bridge.get_multiplayer_result_option_rows()[0].get("label", "")) == "RUECKSPIEL", "multiplayer result action is localized")
	var touch_labels: Dictionary = bridge.get_touch_menu_labels()
	_check(touch_labels.get("confirm", "") == "Rueckspiel", "multiplayer touch action uses semantic result mode")
	bridge._language_index = previous_language

func _check_time_attack_timeout_flow(bridge: Node) -> void:
	bridge._selected_level_index = 0
	bridge.init_level(0, true, false)
	bridge._game_state = bridge.GAME_STATE_PLAYING
	bridge._elapsed_time = bridge.MAX_COURSE_TIME_SECONDS
	bridge._player_state.is_alive = true
	bridge.physics_tick(0, 0, 0.1)
	_check(bridge.is_time_attack_lobby_screen(), "time attack timeout returns to lobby")

func _find_goal(bridge: Node) -> Object:
	for entity in bridge.get_entities():
		if entity.type == bridge.ENTITY_GOAL:
			return entity
	return null

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("RESULTS_FLOW_FAILED %s" % label)
