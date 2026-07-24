extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge._save_path = "C:/Users/Fabio/Downloads/code-projects/sa-reclaimed/godot-project/.godot-local/chaos_emerald_save_smoke.json"
	var original_masks: Array = bridge._chaos_emerald_masks.duplicate()
	var original_character: int = bridge._selected_character_index
	bridge._chaos_emerald_masks = [1, 2, 4, 8, 16]
	bridge._selected_character_index = 0
	_check(bridge.get_chaos_emerald_count() == 1, "Sonic reads only Sonic emerald mask")
	bridge._selected_character_index = 1
	_check(bridge.get_chaos_emerald_count() == 1, "Cream has an independent emerald mask")
	bridge._selected_character_index = 0
	var rows: Array = bridge.get_course_select_emerald_rows()
	_check(bool(rows[0].get("active", false)), "Course Select reads active character emeralds")
	_check(not bool(rows[1].get("active", false)), "Course Select does not leak another character mask")
	bridge._save_save_data()
	bridge._chaos_emerald_masks = [0, 0, 0, 0, 0]
	bridge._load_save_data()
	bridge._selected_character_index = 1
	_check(bridge.get_chaos_emerald_count() == 1, "per-character masks survive save/load")
	bridge._chaos_emerald_masks = original_masks
	bridge._selected_character_index = original_character
	bridge._sync_active_character_level_progress()
	bridge._save_save_data()
	bridge.open_title_screen_and_skip_intro()
	print("CHAOS_EMERALD_CHARACTER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CHAOS_EMERALD_CHARACTER_FAIL: " + label)
