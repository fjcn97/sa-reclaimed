class_name SaveProfileCodec
extends RefCounted

## Converts the live profile state into the stable JSON save schema.
## File access and backup recovery remain in SaveFileStore.

static func build_payload(bridge) -> Dictionary:
	return {
		"save_id": bridge._save_id,
		"unlocked_level_index": bridge._unlocked_level_index,
		"character_unlocked_level_indices": bridge._character_unlocked_level_indices,
		"selected_level_index": bridge._selected_level_index,
		"best_scores": bridge._best_scores,
		"profile_score": bridge._profile_score,
		"level_cleared_flags": bridge._level_cleared_flags,
		"time_attack_best_times": bridge._time_attack_best_times,
		"time_attack_record_tables": bridge._time_attack_record_tables,
		"tiny_chao_unlocked": bridge._tiny_chao_unlocked,
		"tiny_chao_roster": bridge._tiny_chao_roster,
		"true_area_unlocked": bridge._true_area_unlocked,
		"extra_zone_status": bridge._extra_zone_status,
		"difficulty_index": bridge._difficulty_index,
		"time_limit_enabled": bridge._time_limit_enabled,
		"language_index": bridge._language_index,
		"button_bindings": bridge._button_bindings,
		"sound_test_track_index": bridge._sound_test_track_index,
		"sound_test_unlocked": bridge._sound_test_unlocked,
		"player_profile_name": bridge._player_profile_name,
		"multi_record_rows": bridge._multi_record_rows,
		"multiplayer_record_totals": bridge._multiplayer_record_totals,
		"boss_time_attack_unlocked": bridge._boss_time_attack_unlocked,
		"selected_character_index": bridge._selected_character_index,
		"character_unlocked": bridge._character_unlocked,
		"completed_character_routes": bridge._completed_character_routes,
		"extra_ending_credits_played": bridge._extra_ending_credits_played,
		"chaos_emeralds_message_seen": bridge._chaos_emeralds_message_seen,
		"chaos_emerald_mask": bridge._chaos_emerald_mask,
		"chaos_emerald_masks": bridge._chaos_emerald_masks,
	}
