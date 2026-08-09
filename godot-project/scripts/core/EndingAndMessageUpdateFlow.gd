class_name EndingAndMessageUpdateFlow
extends RefCounted

## Owns automatic non-gameplay screens: story handoffs, logos, credits,
## unlock scenes, message cards, and game-over timeout.
static func advance(bridge: Object, delta: float) -> void:
	match bridge._game_state:
		bridge.GAME_STATE_TO_BE_CONTINUED:
			bridge._to_be_continued_timer = maxf(0.0, bridge._to_be_continued_timer - delta)
			if bridge._to_be_continued_timer <= 0.0:
				bridge._resolve_to_be_continued()
		bridge.GAME_STATE_SEGA_LOGO:
			bridge._sega_logo_timer = maxf(0.0, bridge._sega_logo_timer - delta)
			if bridge._sega_logo_timer <= 0.0:
				bridge._resolve_sega_logo()
		bridge.GAME_STATE_SONIC_TEAM:
			bridge._sonic_team_timer = maxf(0.0, bridge._sonic_team_timer - delta)
			if bridge._sonic_team_timer <= 0.0:
				bridge._resolve_sonic_team_logo()
		bridge.GAME_STATE_CREDITS:
			bridge._credits_timer = maxf(0.0, bridge._credits_timer - delta)
			if bridge._credits_timer <= 0.0:
				bridge._advance_credits_page()
		bridge.GAME_STATE_COPYRIGHT:
			bridge._copyright_timer = maxf(0.0, bridge._copyright_timer - delta)
			if bridge._copyright_timer <= 0.0:
				bridge._resolve_copyright()
		bridge.GAME_STATE_CREDITS_END:
			bridge._advance_credits_end_story(delta)
			bridge._credits_end_timer = maxf(0.0, bridge._credits_end_timer - delta)
			if bridge._credits_end_timer <= 0.0:
				bridge._resolve_credits_end()
		bridge.GAME_STATE_CHARACTER_UNLOCK:
			bridge._character_unlock_timer = maxf(0.0, bridge._character_unlock_timer - delta)
			bridge._character_unlock_scene_frame += delta * 60.0
			if bridge._character_unlock_segment < bridge.CHARACTER_UNLOCK_SEGMENT_COUNT:
				if bridge._character_unlock_scene_frame > bridge.CHARACTER_UNLOCK_SEGMENT_FRAMES:
					bridge._character_unlock_segment += 1
					bridge._character_unlock_scene_frame = 0.0
			elif bridge._character_unlock_scene_frame > bridge.CHARACTER_UNLOCK_FINAL_FRAMES:
				bridge._resolve_character_unlock()
		bridge.GAME_STATE_CHAOS_EMERALDS:
			bridge._chaos_emeralds_timer = maxf(0.0, bridge._chaos_emeralds_timer - delta)
			if bridge._chaos_emeralds_timer <= 0.0:
				bridge._resolve_chaos_emeralds_message()
		bridge.GAME_STATE_MISSING_EMERALDS:
			bridge._missing_emeralds_timer = maxf(0.0, bridge._missing_emeralds_timer - delta)
			if bridge._missing_emeralds_timer <= 0.0:
				bridge._resolve_missing_emeralds_message()
		bridge.GAME_STATE_GAME_OVER:
			bridge._game_over_input_lock_timer = maxf(0.0, bridge._game_over_input_lock_timer - delta)
			bridge._game_over_timer = maxf(0.0, bridge._game_over_timer - delta)
			if bridge._game_over_timer <= 0.0:
				bridge._resolve_game_over_timeout()
