class_name SaveLifecycleFlow
extends RefCounted

## Coordinates persistence boundaries; encoding and file I/O remain delegated
## to the existing codec and store services.
static func save(bridge: Object) -> void:
	var profile: ProfileState = bridge.get_profile_state()
	if profile.save_id == 0:
		profile.save_id = randi()
		if profile.save_id == 0:
			profile.save_id = 1
	var payload: Dictionary = bridge.SAVE_PROFILE_CODEC.build_payload(profile, bridge.get_tiny_chao_state(), bridge.get_character_selection_state().selected_index)
	bridge.SAVE_FILE_STORE.write_json_with_backup(bridge.get_save_path(), payload)

static func read_dictionary(bridge: Object, path: String) -> Variant:
	return bridge.SAVE_FILE_STORE.read_json_dictionary(path)
static func reset(bridge: Object) -> void:
	# save.c preserves the selected language when it creates a fresh save.
	var profile: ProfileState = bridge.get_profile_state()
	var preserved_language := clampi(profile.language_index, 0, bridge.get_language_items().size() - 1)
	profile.reset(
		bridge.PROFILE_CATALOG.default_button_bindings(),
		bridge.get_cleared_multiplayer_record_rows(),
		bridge.get_default_multiplayer_record_totals()
	)
	bridge.get_tiny_chao_state().reset_profile(bridge.get_default_tiny_chao_roster())
	profile.language_index = preserved_language
	profile.pending_language_index = profile.language_index
	bridge.get_character_selection_state().selected_index = 0
	profile.sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
	bridge.set_save_reset_pending(false)
	bridge.save_profile()
static func load(bridge: Object) -> void:
	var profile: ProfileState = bridge.get_profile_state()
	profile.reset(
		bridge.PROFILE_CATALOG.default_button_bindings(),
		bridge.get_default_multiplayer_record_rows(),
		bridge.get_default_multiplayer_record_totals()
	)
	profile.sound_test_state = bridge.SOUND_TEST_STATE_STOPPED
	bridge.get_character_selection_state().selected_index = 0
	bridge.get_tiny_chao_state().reset_profile(bridge.get_default_tiny_chao_roster())
	var parsed = bridge.read_save_dictionary(bridge.get_save_path())
	if typeof(parsed) != TYPE_DICTIONARY:
		# save.c keeps older flash sectors available when the newest sector is
		# corrupt. The backup provides the same recovery property for JSON saves.
		parsed = bridge.read_save_dictionary(bridge.get_save_path() + ".bak")
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("save_id"):
		profile.save_id = maxi(0, int(parsed["save_id"]))
	if parsed.has("unlocked_level_index"):
		profile.unlocked_level_index = clamp(int(parsed["unlocked_level_index"]), 0, bridge.get_level_count() - 1)
	if parsed.has("character_unlocked_level_indices") and parsed["character_unlocked_level_indices"] is Array:
		var character_levels: Array = parsed["character_unlocked_level_indices"]
		for i in range(min(character_levels.size(), profile.character_unlocked_level_indices.size())):
			profile.character_unlocked_level_indices[i] = clampi(int(character_levels[i]), 0, bridge.get_level_count() - 1)
	else:
		profile.character_unlocked_level_indices[0] = profile.unlocked_level_index
	if parsed.has("true_area_unlocked"):
		profile.true_area_unlocked = bool(parsed["true_area_unlocked"])
	elif parsed.has("unlocked_level_index"):
		profile.true_area_unlocked = int(parsed["unlocked_level_index"]) >= bridge.get_level_count() - 1
	if parsed.has("extra_zone_status"):
		profile.extra_zone_status = clampi(int(parsed["extra_zone_status"]), 0, 2)
	else:
		profile.extra_zone_status = 2 if profile.true_area_unlocked else 0
	if parsed.has("selected_level_index"):
		profile.selected_level_index = clamp(int(parsed["selected_level_index"]), 0, profile.unlocked_level_index)
	if parsed.has("best_scores") and parsed["best_scores"] is Array:
		var scores: Array = parsed["best_scores"]
		for i in range(min(scores.size(), profile.best_scores.size())):
			profile.best_scores[i] = int(scores[i])
	if parsed.has("profile_score"):
		profile.profile_score = maxi(0, int(parsed["profile_score"]))
	if parsed.has("level_cleared_flags") and parsed["level_cleared_flags"] is Array:
		var flags: Array = parsed["level_cleared_flags"]
		for i in range(min(flags.size(), profile.level_cleared_flags.size())):
			profile.level_cleared_flags[i] = bool(flags[i])
	if parsed.has("time_attack_best_times"):
		profile.time_attack_best_times = bridge.sanitize_time_attack_best_times(parsed["time_attack_best_times"])
	if parsed.has("time_attack_record_tables"):
		profile.time_attack_record_tables = bridge.sanitize_time_attack_record_tables(parsed["time_attack_record_tables"])
	for key in profile.time_attack_best_times.keys():
		if not profile.time_attack_record_tables.has(key):
			profile.time_attack_record_tables[key] = [float(profile.time_attack_best_times[key])]
	if parsed.has("tiny_chao_unlocked"):
		bridge.get_tiny_chao_state().unlocked = bool(parsed["tiny_chao_unlocked"])
	if parsed.has("tiny_chao_roster"):
		bridge.get_tiny_chao_state().roster = bridge.sanitize_tiny_chao_roster(parsed["tiny_chao_roster"])
	bridge.sync_tiny_chao_selection()
	if parsed.has("difficulty_index"):
		profile.difficulty_index = clampi(int(parsed["difficulty_index"]), 0, 2)
	if parsed.has("time_limit_enabled"):
		profile.time_limit_enabled = bool(parsed["time_limit_enabled"])
	if parsed.has("language_index"):
		profile.language_index = clampi(int(parsed["language_index"]), 0, bridge.get_language_items().size() - 1)
	profile.pending_language_index = profile.language_index
	profile.language_index_before_edit = profile.language_index
	if parsed.has("button_bindings"):
		profile.button_bindings = bridge.sanitize_button_bindings(parsed["button_bindings"])
	profile.button_bindings_before_edit = profile.button_bindings.duplicate()
	if parsed.has("sound_test_track_index"):
		profile.sound_test_track_index = clampi(int(parsed["sound_test_track_index"]), 0, bridge.get_sound_test_catalog_track_count() - 1)
	if parsed.has("sound_test_unlocked"):
		profile.sound_test_unlocked = bool(parsed["sound_test_unlocked"])
	if parsed.has("player_profile_name"):
		profile.player_profile_name = bridge.sanitize_profile_name(parsed["player_profile_name"])
	if parsed.has("multi_record_rows"):
		profile.multiplayer_record_rows = bridge.sanitize_multiplayer_record_rows(parsed["multi_record_rows"])
	if parsed.has("multiplayer_record_totals"):
		profile.multiplayer_record_totals = bridge.sanitize_multiplayer_record_totals(parsed["multiplayer_record_totals"])
	if parsed.has("boss_time_attack_unlocked"):
		profile.boss_time_attack_unlocked = bool(parsed["boss_time_attack_unlocked"])
	if not parsed.has("sound_test_unlocked") and profile.boss_time_attack_unlocked:
		profile.sound_test_unlocked = true
	if parsed.has("selected_character_index"):
		bridge.get_character_selection_state().selected_index = clampi(int(parsed["selected_character_index"]), 0, bridge.get_character_names().size() - 1)
	if parsed.has("character_unlocked") and parsed["character_unlocked"] is Array:
		var characters: Array = parsed["character_unlocked"]
		for i in range(min(characters.size(), profile.character_unlocked.size())):
			profile.character_unlocked[i] = bool(characters[i])
	elif profile.unlocked_level_index > 0 or (profile.level_cleared_flags.size() > 0 and profile.level_cleared_flags[0]):
		profile.character_unlocked[1] = true
	if parsed.has("completed_character_routes") and parsed["completed_character_routes"] is Array:
		var completed_routes: Array = parsed["completed_character_routes"]
		for i in range(min(completed_routes.size(), profile.completed_character_routes.size())):
			profile.completed_character_routes[i] = bool(completed_routes[i])
	if parsed.has("extra_ending_credits_played"):
		profile.extra_ending_credits_played = bool(parsed["extra_ending_credits_played"])
	if parsed.has("chaos_emeralds_message_seen"):
		profile.chaos_emeralds_message_seen = bool(parsed["chaos_emeralds_message_seen"])
	if parsed.has("chaos_emerald_masks") and parsed["chaos_emerald_masks"] is Array:
		var emerald_masks: Array = parsed["chaos_emerald_masks"]
		for i in range(min(emerald_masks.size(), profile.chaos_emerald_masks.size())):
			profile.chaos_emerald_masks[i] = clampi(int(emerald_masks[i]), 0, 127)
	elif parsed.has("chaos_emerald_mask"):
		# Older Godot saves had one global mask; preserve it for Sonic.
		profile.chaos_emerald_masks[0] = clampi(int(parsed["chaos_emerald_mask"]), 0, 127)
	profile.chaos_emerald_mask = bridge.get_selected_chaos_emerald_mask()
	bridge.sync_active_character_level_progress()
