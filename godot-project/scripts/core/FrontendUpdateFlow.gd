class_name FrontendUpdateFlow
extends RefCounted

## Handles frontend states that consume the current UI frame before title and
## results timers continue through CoreBridge's remaining state handlers.
static func advance_critical(bridge: Object, delta: float, held_input: int, frame_input: int) -> bool:
	bridge._update_screen_fade(delta)
	bridge._race_start_message_timer = maxf(0.0, bridge._race_start_message_timer - delta)
	if bridge._game_state == bridge.GAME_STATE_PAUSED:
		bridge._update_pause_menu_input(held_input, frame_input)
		return true
	if bridge._game_state == bridge.GAME_STATE_FINAL_INTRO:
		bridge._final_intro_timer = maxf(0.0, bridge._final_intro_timer - delta)
		if bridge._final_intro_timer <= 0.0:
			bridge.skip_final_intro()
		return true
	return false
