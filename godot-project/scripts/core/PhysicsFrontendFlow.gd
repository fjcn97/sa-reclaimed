class_name PhysicsFrontendFlow
extends RefCounted

## Handles non-gameplay frames before the stage simulation runs.
## Returns true when the frame has been fully consumed.
static func handle(bridge: Object, held_input: int, frame_input: int, delta: float) -> bool:
	if bridge.get_game_state() == bridge.GAME_STATE_TITLE:
		if frame_input & bridge.DPAD_UP:
			bridge.set_selected_level_index(max(0, bridge.get_selected_level_index() - 1))
			bridge.save_profile()
			bridge.set_status_text(bridge.get_title_prompt_text())
		if frame_input & bridge.DPAD_DOWN:
			bridge.set_selected_level_index(min(bridge.get_profile_state().unlocked_level_index, bridge.get_selected_level_index() + 1))
			bridge.save_profile()
			bridge.set_status_text(bridge.get_title_prompt_text())
		if frame_input & bridge.B_BUTTON:
			bridge.set_game_state(bridge.GAME_STATE_SAVE_OPTIONS)
			bridge.get_options_navigation_state().save_menu_index = 0
			bridge.set_status_text(bridge.get_save_menu_text())
		if frame_input & bridge.START_BUTTON or frame_input & bridge.A_BUTTON:
			bridge.init_level(bridge.get_selected_level_index())
		bridge.update_camera()
		return true
	if bridge.get_game_state() == bridge.GAME_STATE_SAVE_OPTIONS:
		if bridge.is_save_reset_pending():
			if frame_input & bridge.START_BUTTON or frame_input & bridge.A_BUTTON:
				bridge.reset_progress()
				bridge.set_save_reset_pending(false)
				bridge.open_press_start_screen()
			if frame_input & bridge.B_BUTTON or frame_input & bridge.SELECT_BUTTON:
				bridge.set_save_reset_pending(false)
			bridge.update_camera()
			return true
		if frame_input & bridge.DPAD_UP or frame_input & bridge.DPAD_DOWN:
			bridge.get_options_navigation_state().save_menu_index = 1 - bridge.get_options_navigation_state().save_menu_index
		if frame_input & bridge.START_BUTTON or frame_input & bridge.A_BUTTON:
			if bridge.get_options_navigation_state().save_menu_index == 0:
				bridge.set_save_reset_pending(true)
				bridge.set_status_text("CONFIRM RESET? %s YES, %s NO" % [bridge.get_confirm_label(), bridge.get_secondary_label()])
			else:
				bridge.open_press_start_screen()
		if frame_input & bridge.B_BUTTON or frame_input & bridge.SELECT_BUTTON:
			bridge.open_press_start_screen()
		bridge.update_camera()
		return true
	if bridge.STAGE_INTRO_SYSTEM.advance(bridge, delta, frame_input):
		return true
	if bridge.get_game_state() == bridge.GAME_STATE_CLEAR:
		if not bridge.is_clear_input_ready():
			var is_final_or_extra_stage: bool = bridge.get_selected_level_index() >= bridge.get_level_count() - 2
			if frame_input & bridge.A_BUTTON and bridge.get_clear_result_state().count_delay_timer <= delta and not is_final_or_extra_stage:
				bridge.finish_clear_counting(true)
		else:
			if frame_input & bridge.START_BUTTON or frame_input & bridge.A_BUTTON:
				bridge.clear_replay()
			if frame_input & bridge.B_BUTTON or frame_input & bridge.SELECT_BUTTON:
				bridge.clear_return_to_title()
		bridge.update_camera()
		return true
	if bridge.get_game_state() == bridge.GAME_STATE_PAUSED:
		bridge.update_pause_menu_input(held_input, frame_input)
		return true
	if bridge.get_title_demo_state().active:
		if held_input != 0 or frame_input != 0:
			bridge.open_press_start_screen("DEMO INTERRUPTED")
			return true
		if bridge.get_title_demo_state().advance(delta):
			bridge.open_press_start_screen()
			return true
	if bridge.get_game_state() == bridge.GAME_STATE_PLAYING and frame_input & bridge.START_BUTTON and not bridge.is_multiplayer_run():
		bridge.toggle_pause(held_input)
		bridge.update_camera()
		return true
	return false
