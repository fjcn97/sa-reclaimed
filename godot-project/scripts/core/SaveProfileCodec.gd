class_name SaveProfileCodec
extends RefCounted

## Converts the live profile state into the stable JSON save schema.
## File access and backup recovery remain in SaveFileStore.

static func build_payload(profile: ProfileState, tiny_chao_state: TinyChaoGardenState, selected_character_index: int) -> Dictionary:
	return {
		"save_id": profile.save_id,
		"unlocked_level_index": profile.unlocked_level_index,
		"character_unlocked_level_indices": profile.character_unlocked_level_indices,
		"selected_level_index": profile.selected_level_index,
		"best_scores": profile.best_scores,
		"profile_score": profile.profile_score,
		"level_cleared_flags": profile.level_cleared_flags,
		"time_attack_best_times": profile.time_attack_best_times,
		"time_attack_record_tables": profile.time_attack_record_tables,
		"tiny_chao_unlocked": tiny_chao_state.unlocked,
		"tiny_chao_roster": tiny_chao_state.roster,
		"true_area_unlocked": profile.true_area_unlocked,
		"extra_zone_status": profile.extra_zone_status,
		"difficulty_index": profile.difficulty_index,
		"time_limit_enabled": profile.time_limit_enabled,
		"language_index": profile.language_index,
		"button_bindings": profile.button_bindings,
		"sound_test_track_index": profile.sound_test_track_index,
		"sound_test_unlocked": profile.sound_test_unlocked,
		"player_profile_name": profile.player_profile_name,
		"multi_record_rows": profile.multiplayer_record_rows,
		"multiplayer_record_totals": profile.multiplayer_record_totals,
		"boss_time_attack_unlocked": profile.boss_time_attack_unlocked,
		"selected_character_index": selected_character_index,
		"character_unlocked": profile.character_unlocked,
		"completed_character_routes": profile.completed_character_routes,
		"extra_ending_credits_played": profile.extra_ending_credits_played,
		"chaos_emeralds_message_seen": profile.chaos_emeralds_message_seen,
		"chaos_emerald_mask": profile.chaos_emerald_mask,
		"chaos_emerald_masks": profile.chaos_emerald_masks,
	}
