extends SceneTree

const SPECIAL_STAGE_STATE := preload("res://scripts/core/SpecialStageState.gd")

func _init() -> void:
	var state = SPECIAL_STAGE_STATE.new()
	state.configure([0.2, 0.3], [10, 20], ["ring", "bomb"])
	state.score = 99
	state.paused = true
	state.reset()
	assert(state.robo_zone_speeds == [0.2, 0.3])
	assert(state.ring_targets == [10, 20])
	assert(state.score == 0 and not state.paused and state.lane == 1)
	print("SPECIAL_STAGE_STATE_CHECKS=3")
	quit()
