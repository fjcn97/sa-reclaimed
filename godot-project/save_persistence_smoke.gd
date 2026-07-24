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
	var original_path: String = bridge._save_path
	var smoke_path := ProjectSettings.globalize_path("res://.save_persistence_smoke.json")
	bridge._save_path = smoke_path
	bridge._language_index = 4
	bridge._unlocked_level_index = bridge._level_names.size() - 1
	bridge._sound_test_unlocked = true
	bridge._button_bindings = ["ATTACK", "JUMP", "TRICK"]
	bridge._save_save_data()
	bridge._language_index = 0
	bridge._save_save_data()
	var backup_probe := FileAccess.open(smoke_path + ".bak", FileAccess.READ)
	_check(backup_probe != null, "save keeps previous backup")
	if backup_probe:
		backup_probe.close()
	var primary_file := FileAccess.open(smoke_path, FileAccess.WRITE)
	if primary_file:
		primary_file.store_string("{corrupt save")
		primary_file.close()
	bridge._language_index = 1
	bridge._load_save_data()
	_check(bridge._language_index == 4, "corrupt primary recovers backup")
	var sanitized_rows: Array = bridge._sanitize_multiplayer_record_rows([{"name": "RIVAL", "wins": 700, "losses": -2, "draws": 101}])
	var sanitized_totals: Dictionary = bridge._sanitize_multiplayer_record_totals({"wins": 700, "losses": -2, "draws": 101})
	_check(sanitized_rows[0]["wins"] == 99 and sanitized_rows[0]["losses"] == 0 and sanitized_rows[0]["draws"] == 99, "record rows clamp to source limit")
	_check(sanitized_totals["wins"] == 99 and sanitized_totals["losses"] == 0 and sanitized_totals["draws"] == 99, "record totals clamp to source limit")
	bridge._reset_progress()
	_check(bridge._language_index == 4, "reset preserves selected language")
	_check(bridge._unlocked_level_index == 0, "reset clears unlocked levels")
	_check(not bridge._sound_test_unlocked, "reset clears sound test unlock")
	_check(bridge._button_bindings == ["JUMP", "ATTACK", "TRICK"], "reset restores default bindings")
	if FileAccess.file_exists(smoke_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(smoke_path))
	if FileAccess.file_exists(smoke_path + ".bak"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(smoke_path + ".bak"))
	bridge._save_path = original_path
	print("SAVE_PERSISTENCE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("SAVE_PERSISTENCE_FAIL: " + label)
