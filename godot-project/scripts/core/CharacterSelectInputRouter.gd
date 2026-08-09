extends RefCounted
class_name CharacterSelectInputRouter

func handle(bridge: Object, frame_input: int) -> void:
	if bridge.is_character_select():
		if not bridge.is_character_select_input_ready():
			# The displayed desktop guidance is actionable immediately. Do not
			# consume Enter merely to skip the carousel animation: it must confirm
			# the selected character, while Esc returns to the previous screen.
			if frame_input & bridge.B_BUTTON and not bridge.is_multiplayer_character_select_screen():
				bridge.cancel_character_selection()
				return
			if frame_input & bridge.A_BUTTON:
				bridge.confirm_character_selection()
			return
		var character_direction := 0
		if frame_input & bridge.DPAD_LEFT or frame_input & bridge.DPAD_UP:
			character_direction = -1
		elif frame_input & bridge.DPAD_RIGHT or frame_input & bridge.DPAD_DOWN:
			character_direction = 1
		if character_direction != 0:
			bridge.move_character_selection(character_direction)
			return
		if frame_input & bridge.A_BUTTON:
			bridge.confirm_character_selection()
		# character_select.c only handles B for single-player cancel;
		# Select is ignored on this screen.
		if frame_input & bridge.B_BUTTON and not bridge.is_multiplayer_character_select_screen():
			bridge.cancel_character_selection()
		return
