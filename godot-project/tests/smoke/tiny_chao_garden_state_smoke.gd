extends SceneTree

const TINY_CHAO_GARDEN_STATE := preload("res://scripts/core/TinyChaoGardenState.gd")

var checks: int = 0
var failed: bool = false

func _init() -> void:
	var state = TINY_CHAO_GARDEN_STATE.new()
	state.reset_profile([{"name": "CHAO", "hunger": 40, "mood": 60, "care": 2}])
	_check(not state.unlocked, "profile reset locks garden")
	_check(state.roster.size() == 1, "profile reset owns roster copy")
	state.unlocked = true
	state.session_id = "TCG-ABCD"
	state.begin_play()
	_check(state.session_id == "TCG-ABCD", "play start preserves session")
	_check(state.selected_index == 0 and state.play_x == 0.0 and state.play_y == 0.0, "play start resets navigation")
	var should_return := state.apply_update({"selected_index": 0, "play_x": 0.5, "play_y": -0.25, "hunger": 55, "mood": 70, "fruit": 2, "care": 3, "action_timer": 0.7, "action_text": "CHAO ATE FRUIT", "should_return": true})
	_check(should_return and state.fruit == 2 and state.action_text == "CHAO ATE FRUIT", "update application owns runtime fields")
	state.apply_selection({"hunger": 45, "mood": 50, "care": 4})
	_check(state.hunger == 45 and state.mood == 50 and state.care_count == 4, "selection sync updates displayed stats")
	state.reset_runtime()
	_check(state.unlocked and state.roster.size() == 1, "runtime reset preserves profile state")
	print("TINY_CHAO_GARDEN_STATE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TINY_CHAO_GARDEN_STATE_FAIL: " + label)
