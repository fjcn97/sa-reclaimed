extends SceneTree

const CLEAR_RESULT_STATE := preload("res://scripts/core/ClearResultState.gd")

func _init() -> void:
	var state = CLEAR_RESULT_STATE.new()
	state.begin(42.0, 1000, 12, 3, "A", 50000, 1200, 3000, 2.5, 1.2, false)
	assert(state.final_score_snapshot == 55200)
	assert(state.total_display_score == 1000)
	assert(not state.counting_done)
	state.reset()
	assert(state.rank_text == "D" and state.previous_best_time == -1.0)
	print("CLEAR_RESULT_STATE_CHECKS=4")
	quit()
