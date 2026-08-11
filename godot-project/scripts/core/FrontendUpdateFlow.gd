class_name FrontendUpdateFlow
extends RefCounted

## Handles frontend states that consume the current UI frame before title and
## results timers continue through CoreBridge's remaining state handlers.
static func advance_critical(bridge: Object, delta: float, held_input: int, frame_input: int) -> bool:
	bridge.update_screen_fade(delta)
	var stage_intro = bridge.get_stage_intro_state()
	stage_intro.race_start_message_timer = maxf(0.0, stage_intro.race_start_message_timer - delta)
	if bridge.get_game_state() == bridge.GAME_STATE_PAUSED:
		bridge.update_pause_menu_input(held_input, frame_input)
		return true
	if bridge.get_game_state() == bridge.GAME_STATE_FINAL_INTRO:
		stage_intro.final_intro_timer = maxf(0.0, stage_intro.final_intro_timer - delta)
		if stage_intro.final_intro_timer <= 0.0:
			bridge.skip_final_intro()
		return true
	return false
