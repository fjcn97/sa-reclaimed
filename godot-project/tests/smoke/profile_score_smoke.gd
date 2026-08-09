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
	var smoke_path := ProjectSettings.globalize_path("res://.profile_score_smoke.json")
	bridge._save_path = smoke_path
	bridge._profile_score = 0
	bridge._player_state.rings = 37
	bridge._update_progress_for_clear()
	_check(bridge.get_profile_score() == 37, "stage rings enter profile score")
	var saved_id: int = bridge._save_id
	_check(saved_id != 0, "save receives nonzero id")
	bridge._special_stage_ring_count = 19
	bridge._game_state = bridge.GAME_STATE_SPECIAL_STAGE
	bridge._finish_special_stage()
	_check(bridge.get_profile_score() == 56, "special stage rings enter profile score")
	var loaded: Node = preload("res://scripts/CoreBridge.gd").new()
	loaded._save_path = smoke_path
	loaded._load_save_data()
	_check(loaded._save_id == saved_id, "save id persists")
	_check(loaded.get_profile_score() == 56, "profile score persists")
	_check(loaded.get_tiny_chao_info_rows()[0] == "SCORE  56", "tiny chao receives profile score")
	loaded._language_index = 5
	_check(loaded.get_tiny_chao_language_text() == "ENGLISH", "italian maps to tiny chao english build")
	DirAccess.remove_absolute(smoke_path)
	DirAccess.remove_absolute(smoke_path + ".bak")
	print("PROFILE_SCORE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PROFILE_SCORE_FAIL: " + label)
