class_name SaveLifecycleFlow
extends RefCounted

## Coordinates persistence boundaries; encoding and file I/O remain delegated
## to the existing codec and store services.
static func save(bridge: Object) -> void:
	if bridge._save_id == 0:
		bridge._save_id = randi()
		if bridge._save_id == 0:
			bridge._save_id = 1
	var payload: Dictionary = bridge.SAVE_PROFILE_CODEC.build_payload(bridge)
	bridge.SAVE_FILE_STORE.write_json_with_backup(bridge._save_path, payload)

static func read_dictionary(bridge: Object, path: String) -> Variant:
	return bridge.SAVE_FILE_STORE.read_json_dictionary(path)
static func reset(bridge: Object) -> void:
	# save.c preserves the selected language when it creates a fresh save.
	var preserved_language := clampi(bridge._language_index, 0, bridge.get_language_items().size() - 1)
	bridge._unlocked_level_index = 0
	bridge._character_unlocked_level_indices = [0, 0, 0, 0, 0]
	bridge._selected_level_index = 0
	bridge._best_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	bridge._profile_score = 0
	bridge._level_cleared_flags = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
	bridge._time_attack_best_times = {}
	bridge._time_attack_record_tables = {}
	bridge._tiny_chao_unlocked = false
	bridge._tiny_chao_roster = bridge._get_default_tiny_chao_roster()
	bridge._true_area_unlocked = false
	bridge._extra_zone_status = 0
	bridge._difficulty_index = 0
	bridge._difficulty_before_edit = bridge._difficulty_index
	bridge._time_limit_enabled = true
	bridge._time_limit_before_edit = bridge._time_limit_enabled
	bridge._language_index = preserved_language
	bridge._pending_language_index = bridge._language_index
	bridge._button_bindings = bridge.PROFILE_CATALOG.default_button_bindings()
	bridge._button_bindings_before_edit = bridge._button_bindings.duplicate()
	bridge._sound_test_track_index = 0
	bridge._sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
	bridge._sound_test_unlocked = false
	bridge._player_profile_name = [" ", " ", " ", " ", " ", " "]
	bridge._multi_record_rows = bridge._get_cleared_multiplayer_record_rows()
	bridge._multiplayer_record_totals = bridge._get_default_multiplayer_record_totals()
	bridge._boss_time_attack_unlocked = false
	bridge._selected_character_index = 0
	bridge._character_unlocked = [true, false, false, false, false]
	bridge._completed_character_routes = [false, false, false, false, false]
	bridge._extra_ending_credits_played = false
	bridge._chaos_emeralds_message_seen = false
	bridge._chaos_emerald_mask = 0
	bridge._chaos_emerald_masks = [0, 0, 0, 0, 0]
	bridge._save_reset_pending = false
	bridge._save_save_data()
static func load(bridge: Object) -> void:
	bridge._save_id = 0
	bridge._unlocked_level_index = 0
	bridge._character_unlocked_level_indices = [0, 0, 0, 0, 0]
	bridge._best_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	bridge._profile_score = 0
	bridge._level_cleared_flags = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
	bridge._time_attack_best_times = {}
	bridge._time_attack_record_tables = {}
	bridge._difficulty_index = 0
	bridge._difficulty_before_edit = bridge._difficulty_index
	bridge._time_limit_enabled = true
	bridge._time_limit_before_edit = bridge._time_limit_enabled
	bridge._language_index = 1
	bridge._pending_language_index = bridge._language_index
	bridge._language_index_before_edit = bridge._language_index
	bridge._button_bindings = bridge.PROFILE_CATALOG.default_button_bindings()
	bridge._button_bindings_before_edit = bridge._button_bindings.duplicate()
	bridge._sound_test_track_index = 0
	bridge._sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
	bridge._sound_test_unlocked = false
	bridge._player_profile_name = [" ", " ", " ", " ", " ", " "]
	bridge._multi_record_rows = bridge._get_default_multiplayer_record_rows()
	bridge._multiplayer_record_totals = bridge._get_default_multiplayer_record_totals()
	bridge._boss_time_attack_unlocked = false
	bridge._selected_character_index = 0
	bridge._chaos_emeralds_message_seen = false
	bridge._chaos_emerald_mask = 0
	bridge._chaos_emerald_masks = [0, 0, 0, 0, 0]
	bridge._character_unlocked = [true, false, false, false, false]
	bridge._completed_character_routes = [false, false, false, false, false]
	bridge._extra_ending_credits_played = false
	bridge._tiny_chao_roster = bridge._get_default_tiny_chao_roster()
	bridge._true_area_unlocked = false
	bridge._extra_zone_status = 0
	var parsed = bridge._read_save_dictionary(bridge._save_path)
	if typeof(parsed) != TYPE_DICTIONARY:
		# save.c keeps older flash sectors available when the newest sector is
		# corrupt. The backup provides the same recovery property for JSON saves.
		parsed = bridge._read_save_dictionary(bridge._save_path + ".bak")
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("save_id"):
		bridge._save_id = maxi(0, int(parsed["save_id"]))
	if parsed.has("unlocked_level_index"):
		bridge._unlocked_level_index = clamp(int(parsed["unlocked_level_index"]), 0, bridge._level_names.size() - 1)
	if parsed.has("character_unlocked_level_indices") and parsed["character_unlocked_level_indices"] is Array:
		var character_levels: Array = parsed["character_unlocked_level_indices"]
		for i in range(min(character_levels.size(), bridge._character_unlocked_level_indices.size())):
			bridge._character_unlocked_level_indices[i] = clampi(int(character_levels[i]), 0, bridge._level_names.size() - 1)
	else:
		bridge._character_unlocked_level_indices[0] = bridge._unlocked_level_index
	if parsed.has("true_area_unlocked"):
		bridge._true_area_unlocked = bool(parsed["true_area_unlocked"])
	elif parsed.has("unlocked_level_index"):
		bridge._true_area_unlocked = int(parsed["unlocked_level_index"]) >= bridge._level_names.size() - 1
	if parsed.has("extra_zone_status"):
		bridge._extra_zone_status = clampi(int(parsed["extra_zone_status"]), 0, 2)
	else:
		bridge._extra_zone_status = 2 if bridge._true_area_unlocked else 0
	if parsed.has("selected_level_index"):
		bridge._selected_level_index = clamp(int(parsed["selected_level_index"]), 0, bridge._unlocked_level_index)
	if parsed.has("best_scores") and parsed["best_scores"] is Array:
		var scores: Array = parsed["best_scores"]
		for i in range(min(scores.size(), bridge._best_scores.size())):
			bridge._best_scores[i] = int(scores[i])
	if parsed.has("profile_score"):
		bridge._profile_score = maxi(0, int(parsed["profile_score"]))
	if parsed.has("level_cleared_flags") and parsed["level_cleared_flags"] is Array:
		var flags: Array = parsed["level_cleared_flags"]
		for i in range(min(flags.size(), bridge._level_cleared_flags.size())):
			bridge._level_cleared_flags[i] = bool(flags[i])
	if parsed.has("time_attack_best_times"):
		bridge._time_attack_best_times = bridge._sanitize_time_attack_best_times(parsed["time_attack_best_times"])
	if parsed.has("time_attack_record_tables"):
		bridge._time_attack_record_tables = bridge._sanitize_time_attack_record_tables(parsed["time_attack_record_tables"])
	for key in bridge._time_attack_best_times.keys():
		if not bridge._time_attack_record_tables.has(key):
			bridge._time_attack_record_tables[key] = [float(bridge._time_attack_best_times[key])]
	if parsed.has("tiny_chao_unlocked"):
		bridge._tiny_chao_unlocked = bool(parsed["tiny_chao_unlocked"])
	if parsed.has("tiny_chao_roster"):
		bridge._tiny_chao_roster = bridge._sanitize_tiny_chao_roster(parsed["tiny_chao_roster"])
	bridge._sync_tiny_chao_selection()
	if parsed.has("difficulty_index"):
		bridge._difficulty_index = clampi(int(parsed["difficulty_index"]), 0, 2)
	if parsed.has("time_limit_enabled"):
		bridge._time_limit_enabled = bool(parsed["time_limit_enabled"])
	if parsed.has("language_index"):
		bridge._language_index = clampi(int(parsed["language_index"]), 0, bridge.get_language_items().size() - 1)
	bridge._pending_language_index = bridge._language_index
	bridge._language_index_before_edit = bridge._language_index
	if parsed.has("button_bindings"):
		bridge._button_bindings = bridge._sanitize_button_bindings(parsed["button_bindings"])
	bridge._button_bindings_before_edit = bridge._button_bindings.duplicate()
	if parsed.has("sound_test_track_index"):
		bridge._sound_test_track_index = clampi(int(parsed["sound_test_track_index"]), 0, bridge._sound_test_tracks.size() - 1)
	if parsed.has("sound_test_unlocked"):
		bridge._sound_test_unlocked = bool(parsed["sound_test_unlocked"])
	if parsed.has("player_profile_name"):
		bridge._player_profile_name = bridge._sanitize_profile_name(parsed["player_profile_name"])
	if parsed.has("multi_record_rows"):
		bridge._multi_record_rows = bridge._sanitize_multiplayer_record_rows(parsed["multi_record_rows"])
	if parsed.has("multiplayer_record_totals"):
		bridge._multiplayer_record_totals = bridge._sanitize_multiplayer_record_totals(parsed["multiplayer_record_totals"])
	if parsed.has("boss_time_attack_unlocked"):
		bridge._boss_time_attack_unlocked = bool(parsed["boss_time_attack_unlocked"])
	if not parsed.has("sound_test_unlocked") and bridge._boss_time_attack_unlocked:
		bridge._sound_test_unlocked = true
	if parsed.has("selected_character_index"):
		bridge._selected_character_index = clampi(int(parsed["selected_character_index"]), 0, bridge._character_names.size() - 1)
	if parsed.has("character_unlocked") and parsed["character_unlocked"] is Array:
		var characters: Array = parsed["character_unlocked"]
		for i in range(min(characters.size(), bridge._character_unlocked.size())):
			bridge._character_unlocked[i] = bool(characters[i])
	elif bridge._unlocked_level_index > 0 or (bridge._level_cleared_flags.size() > 0 and bridge._level_cleared_flags[0]):
		bridge._character_unlocked[1] = true
	if parsed.has("completed_character_routes") and parsed["completed_character_routes"] is Array:
		var completed_routes: Array = parsed["completed_character_routes"]
		for i in range(min(completed_routes.size(), bridge._completed_character_routes.size())):
			bridge._completed_character_routes[i] = bool(completed_routes[i])
	if parsed.has("extra_ending_credits_played"):
		bridge._extra_ending_credits_played = bool(parsed["extra_ending_credits_played"])
	if parsed.has("chaos_emeralds_message_seen"):
		bridge._chaos_emeralds_message_seen = bool(parsed["chaos_emeralds_message_seen"])
	if parsed.has("chaos_emerald_masks") and parsed["chaos_emerald_masks"] is Array:
		var emerald_masks: Array = parsed["chaos_emerald_masks"]
		for i in range(min(emerald_masks.size(), bridge._chaos_emerald_masks.size())):
			bridge._chaos_emerald_masks[i] = clampi(int(emerald_masks[i]), 0, 127)
	elif parsed.has("chaos_emerald_mask"):
		# Older Godot saves had one global mask; preserve it for Sonic.
		bridge._chaos_emerald_masks[0] = clampi(int(parsed["chaos_emerald_mask"]), 0, 127)
	bridge._chaos_emerald_mask = bridge._get_selected_chaos_emerald_mask()
	bridge._sync_active_character_level_progress()
