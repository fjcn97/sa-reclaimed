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
	var smoke_path := ProjectSettings.globalize_path("res://.completed_save_smoke.json")
	bridge._save_path = smoke_path
	bridge.load_completed_save_game()
	_check(bridge._unlocked_level_index == bridge._level_names.size() - 1, "true area unlocked")
	_check(bridge._extra_zone_status == 2, "completed extra zone status")
	_check(bridge._character_unlocked_level_indices[0] == bridge._level_names.size() - 1, "sonic reaches true area")
	_check(bridge._character_unlocked_level_indices[1] == bridge._level_names.size() - 2, "other characters reach final zone")
	_check(bridge._character_unlocked == [true, true, true, true, true], "all characters unlocked")
	_check(bridge._completed_character_routes == [true, true, true, true, true], "all routes completed")
	_check(bridge._chaos_emerald_masks == [127, 127, 127, 127, 127], "all emeralds granted per character")
	_check(bridge._sound_test_unlocked and bridge._boss_time_attack_unlocked, "extra modes unlocked")
	_check(bridge._tiny_chao_unlocked and bridge._extra_ending_credits_played, "chao and credits unlocked")
	_check(bridge.get_chaos_emerald_count() == 7, "selected character has seven emeralds")
	_check(FileAccess.file_exists(smoke_path), "completed save persisted")
	DirAccess.remove_absolute(smoke_path)
	DirAccess.remove_absolute(smoke_path + ".bak")
	print("COMPLETED_SAVE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("COMPLETED_SAVE_FAIL: " + label)
