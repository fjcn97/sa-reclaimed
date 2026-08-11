class_name EndingAndMessageUpdateFlow
extends RefCounted

## Owns automatic non-gameplay screens: story handoffs, logos, credits,
## unlock scenes, message cards, and game-over timeout.
static func advance(bridge: Object, delta: float) -> void:
	var message_cards = bridge.get_message_card_state()
	match bridge.get_game_state():
		bridge.GAME_STATE_TO_BE_CONTINUED:
			message_cards.to_be_continued_timer = maxf(0.0, message_cards.to_be_continued_timer - delta)
			if message_cards.to_be_continued_timer <= 0.0:
				bridge.resolve_to_be_continued()
		bridge.GAME_STATE_SEGA_LOGO:
			message_cards.sega_logo_timer = maxf(0.0, message_cards.sega_logo_timer - delta)
			if message_cards.sega_logo_timer <= 0.0:
				bridge.resolve_sega_logo()
		bridge.GAME_STATE_SONIC_TEAM:
			message_cards.sonic_team_timer = maxf(0.0, message_cards.sonic_team_timer - delta)
			if message_cards.sonic_team_timer <= 0.0:
				bridge.resolve_sonic_team_logo()
		bridge.GAME_STATE_CREDITS:
			bridge.get_credits_state().timer = maxf(0.0, bridge.get_credits_state().timer - delta)
			if bridge.get_credits_state().timer <= 0.0:
				bridge.advance_credits_page()
		bridge.GAME_STATE_COPYRIGHT:
			bridge.set_copyright_timer(maxf(0.0, bridge.get_copyright_timer() - delta))
			if bridge.get_copyright_timer() <= 0.0:
				bridge.resolve_copyright()
		bridge.GAME_STATE_CREDITS_END:
			bridge.advance_credits_end_story(delta)
			bridge.get_credits_state().end_timer = maxf(0.0, bridge.get_credits_state().end_timer - delta)
			if bridge.get_credits_state().end_timer <= 0.0:
				bridge.resolve_credits_end()
		bridge.GAME_STATE_CHARACTER_UNLOCK:
			if bridge.get_character_unlock_state().advance(delta, bridge.CHARACTER_UNLOCK_SEGMENT_COUNT, bridge.CHARACTER_UNLOCK_SEGMENT_FRAMES, bridge.CHARACTER_UNLOCK_FINAL_FRAMES):
				bridge.resolve_character_unlock()
		bridge.GAME_STATE_CHAOS_EMERALDS:
			message_cards.chaos_emeralds_timer = maxf(0.0, message_cards.chaos_emeralds_timer - delta)
			if message_cards.chaos_emeralds_timer <= 0.0:
				bridge.resolve_chaos_emeralds_message()
		bridge.GAME_STATE_MISSING_EMERALDS:
			message_cards.missing_emeralds_timer = maxf(0.0, message_cards.missing_emeralds_timer - delta)
			if message_cards.missing_emeralds_timer <= 0.0:
				bridge.resolve_missing_emeralds_message()
		bridge.GAME_STATE_GAME_OVER:
			if bridge.get_game_over_state().advance(delta):
				bridge.resolve_game_over_timeout()
