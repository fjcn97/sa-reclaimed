class_name StoryUnlockSystem
extends RefCounted

## Applies source-aligned unlock rules from completed character routes.

static func character_unlock_for_level(level_index: int) -> int:
	return {1: 1, 5: 2, 9: 3}.get(level_index, -1)

static func refresh(completed_routes: Array, character_unlocked: Array, chaos_emerald_masks: Array, level_count: int, tiny_chao_unlocked: bool, sound_test_unlocked: bool, boss_time_attack_unlocked: bool, true_area_unlocked: bool, extra_zone_status: int, unlocked_level_index: int) -> Dictionary:
	var completed_count := 0
	for i in range(mini(4, completed_routes.size())):
		if bool(completed_routes[i]):
			completed_count += 1
	var next_tiny := tiny_chao_unlocked or completed_count >= 1
	var next_sound := sound_test_unlocked or completed_count >= 2
	var next_boss := boss_time_attack_unlocked or completed_count >= 3
	if completed_count >= 4 and character_unlocked.size() > 4:
		character_unlocked[4] = true
	var sonic_has_all_emeralds := not chaos_emerald_masks.is_empty() and int(chaos_emerald_masks[0]) == 127
	var next_true_area := true_area_unlocked
	var next_extra_status := extra_zone_status
	var next_unlocked_level := unlocked_level_index
	if completed_count >= 4 and sonic_has_all_emeralds:
		next_true_area = true
		next_extra_status = maxi(next_extra_status, 1)
		next_unlocked_level = maxi(next_unlocked_level, level_count - 1)
	return {"tiny_chao_unlocked": next_tiny, "sound_test_unlocked": next_sound, "boss_time_attack_unlocked": next_boss, "true_area_unlocked": next_true_area, "extra_zone_status": next_extra_status, "unlocked_level_index": next_unlocked_level}
