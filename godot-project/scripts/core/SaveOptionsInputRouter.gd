class_name SaveOptionsInputRouter
extends RefCounted

const NAVIGATION := preload("res://scripts/core/SaveOptionsNavigation.gd")

## Routes only the save/options front end. The generic router delegates here
## before considering unrelated title or gameplay states.

static func handle(bridge: Object, frame_input: int) -> bool:
	if not bridge.is_save_options():
		return false
	if bridge.handle_save_shoulder_input(frame_input):
		return true
	if bridge.is_save_main_menu_screen():
		if frame_input & bridge.A_BUTTON:
			bridge.accept_save_selection()
			return true
		if frame_input & bridge.B_BUTTON:
			if not bridge.trigger_save_secondary_action():
				bridge.cancel_save_selection()
			return true
	if bridge.is_name_entry_screen():
		if frame_input & bridge.DPAD_UP:
			bridge.move_save_selection(-1)
			return true
		if frame_input & bridge.DPAD_DOWN:
			bridge.move_save_selection(1)
			return true
		if frame_input & bridge.DPAD_LEFT:
			bridge.adjust_save_selection(-1)
			return true
		if frame_input & bridge.DPAD_RIGHT:
			bridge.adjust_save_selection(1)
			return true
	if bridge.is_player_data_screen() or bridge.is_language_screen():
		var first_direction := bridge.DPAD_UP if bridge.is_player_data_screen() else bridge.DPAD_DOWN
		var first_amount := -1 if bridge.is_player_data_screen() else 1
		if frame_input & first_direction:
			bridge.move_save_selection(first_amount)
			return true
		var second_direction := bridge.DPAD_DOWN if bridge.is_player_data_screen() else bridge.DPAD_UP
		if frame_input & second_direction:
			bridge.move_save_selection(-first_amount)
			return true
	if bridge.is_options_main_screen():
		if frame_input & bridge.A_BUTTON:
			bridge.accept_save_selection()
			return true
		if frame_input & bridge.B_BUTTON:
			bridge.cancel_save_selection()
			return true
	if bridge.is_sound_test_screen():
		if frame_input & bridge.DPAD_LEFT:
			bridge.adjust_save_selection(-1)
		if frame_input & bridge.DPAD_RIGHT:
			bridge.adjust_save_selection(1)
		if frame_input & bridge.DPAD_UP:
			bridge.move_save_selection(-1)
		if frame_input & bridge.DPAD_DOWN:
			bridge.move_save_selection(1)
		if frame_input & bridge.A_BUTTON:
			bridge.accept_save_selection()
		if frame_input & bridge.B_BUTTON:
			bridge.cancel_save_selection()
		return true
	var up_first := bridge.is_player_data_screen() or bridge.is_name_entry_screen() or bridge.is_multiplayer_records_screen() or bridge.is_time_records_courses_view()
	if up_first and frame_input & bridge.DPAD_UP or not up_first and frame_input & bridge.DPAD_DOWN:
		bridge.move_save_selection(-1 if up_first else 1)
		return true
	if up_first and frame_input & bridge.DPAD_DOWN or not up_first and frame_input & bridge.DPAD_UP:
		bridge.move_save_selection(1 if up_first else -1)
		return true
	if frame_input & bridge.DPAD_LEFT:
		bridge.adjust_save_selection(-1)
	elif frame_input & bridge.DPAD_RIGHT:
		bridge.adjust_save_selection(1)
	if NAVIGATION.direction_consumes_action(bridge, frame_input):
		return true
	if frame_input & bridge.A_BUTTON:
		bridge.accept_save_selection()
		return true
	if frame_input & bridge.START_BUTTON:
		if not bridge.trigger_save_start_action() and (bridge.is_name_entry_screen() or bridge.is_language_screen()):
			bridge.accept_save_selection()
	if frame_input & bridge.SELECT_BUTTON and bridge.is_button_config_screen():
		bridge.trigger_save_special_action()
	if frame_input & bridge.B_BUTTON:
		if not bridge.trigger_save_secondary_action():
			bridge.cancel_save_selection()
	return true
