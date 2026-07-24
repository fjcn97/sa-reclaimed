extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._selected_character_index = 1
	bridge._selected_level_index = 0
	bridge._unlocked_level_index = 1
	bridge._open_special_stage()
	bridge._special_stage_phase = 1
	bridge._special_stage_timer = 1.0 / 60.0
	bridge._special_stage_ring_count = 5
	bridge._special_stage_target_reached = false
	bridge.advance_ui_timers(1.0 / 60.0)
	_check(bridge.is_special_stage_results_screen(), "results phase opens")
	_check(bridge._special_stage_points_remaining == 500, "ring points start at 100 per ring")
	_check(bridge.get_special_stage_score() == 0, "result score starts at zero")

	bridge.advance_ui_timers(1.0 / 60.0)
	_check(bridge._special_stage_points_remaining == 400, "results drain 100 per frame")
	_check(bridge.get_special_stage_score() == 100, "results display the counted score")

	bridge.advance_special_stage_screen()
	_check(bridge._special_stage_points_remaining == 0, "A clears remaining ring points")
	_check(bridge.get_special_stage_score() == 500, "A preserves final ring score")
	_check(absf(bridge._special_stage_timer - 1.0) < 0.01, "A starts the 60-frame result hold")

	for _frame in range(60):
		bridge.advance_ui_timers(1.0 / 60.0)
	_check(bridge.is_intro_screen(), "result hold returns to the next stage")

	bridge._open_special_stage()
	bridge._special_stage_phase = 1
	bridge._special_stage_timer = 1.0 / 60.0
	bridge._special_stage_ring_count = 1200
	bridge._special_stage_target_reached = false
	bridge.advance_ui_timers(1.0 / 60.0)
	_check(bridge._special_stage_points_remaining == 99900, "special stage score uses the source cap")

	print("SPECIAL_STAGE_RESULTS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SPECIAL_STAGE_RESULTS_FAILED %s" % label)
