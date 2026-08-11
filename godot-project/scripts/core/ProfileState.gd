class_name ProfileState
extends RefCounted

## Persistent player-profile data. Runtime flows may coordinate this state, but
## the profile itself owns values that are serialized to a save file.
const PROFILE_CATALOG := preload("res://scripts/core/ProfileCatalog.gd")
var save_id: int = 0
var unlocked_level_index: int = 0
var character_unlocked_level_indices: Array = [0, 0, 0, 0, 0]
var selected_level_index: int = 0
var best_scores: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var profile_score: int = 0
var level_cleared_flags: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
var time_attack_best_times: Dictionary = {}
var time_attack_record_tables: Dictionary = {}
var true_area_unlocked: bool = false
var extra_zone_status: int = 0
var difficulty_index: int = 0
var difficulty_before_edit: int = 0
var time_limit_enabled: bool = true
var time_limit_before_edit: bool = true
var language_index: int = 1
var pending_language_index: int = 1
var language_index_before_edit: int = 1
var button_bindings: Array = PROFILE_CATALOG.default_button_bindings()
var button_bindings_before_edit: Array = PROFILE_CATALOG.default_button_bindings()
var sound_test_track_index: int = 0
var sound_test_state: int = 0
var sound_test_unlocked: bool = false
var player_profile_name: Array = ["S", "O", "N", "I", "C", " "]
var multiplayer_record_rows: Array = []
var multiplayer_record_totals: Dictionary = {"wins": 0, "losses": 0, "draws": 0}
var boss_time_attack_unlocked: bool = false
var character_unlocked: Array = [true, false, false, false, false]
var completed_character_routes: Array = [false, false, false, false, false]
var extra_ending_credits_played: bool = false
var chaos_emeralds_message_seen: bool = false
var chaos_emerald_mask: int = 0
var chaos_emerald_masks: Array = [0, 0, 0, 0, 0]

func configure(default_button_bindings: Array) -> void:
	button_bindings = default_button_bindings.duplicate()
	button_bindings_before_edit = default_button_bindings.duplicate()

func reset(default_button_bindings: Array, default_record_rows: Array, default_record_totals: Dictionary) -> void:
	save_id = 0
	unlocked_level_index = 0
	character_unlocked_level_indices = [0, 0, 0, 0, 0]
	selected_level_index = 0
	best_scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	profile_score = 0
	level_cleared_flags = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
	time_attack_best_times = {}
	time_attack_record_tables = {}
	true_area_unlocked = false
	extra_zone_status = 0
	difficulty_index = 0
	difficulty_before_edit = 0
	time_limit_enabled = true
	time_limit_before_edit = true
	language_index = 1
	pending_language_index = 1
	language_index_before_edit = 1
	button_bindings = default_button_bindings.duplicate()
	button_bindings_before_edit = default_button_bindings.duplicate()
	sound_test_track_index = 0
	sound_test_state = 0
	sound_test_unlocked = false
	player_profile_name = [" ", " ", " ", " ", " ", " "]
	multiplayer_record_rows = default_record_rows.duplicate(true)
	multiplayer_record_totals = default_record_totals.duplicate(true)
	boss_time_attack_unlocked = false
	character_unlocked = [true, false, false, false, false]
	completed_character_routes = [false, false, false, false, false]
	extra_ending_credits_played = false
	chaos_emeralds_message_seen = false
	chaos_emerald_mask = 0
	chaos_emerald_masks = [0, 0, 0, 0, 0]
