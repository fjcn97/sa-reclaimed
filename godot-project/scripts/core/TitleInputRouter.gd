extends RefCounted
class_name TitleInputRouter

## Owns title-front-end input precedence and delegates transitions to bridge.
func handle(bridge: Object, frame_input: int) -> void:
	# Keep the router testable against an isolated bridge instance. The local
	# compatibility alias avoids changing the well-audited input-precedence body.

	if bridge.is_title_screen():
		if bridge.is_play_mode_screen() and not bridge.is_play_mode_input_ready():
			return
		if bridge.is_single_player_menu_screen() and not bridge.is_single_player_input_ready():
			if frame_input & bridge.B_BUTTON:
				bridge.open_save_options_from_title()
			return
		# title_screen.c checks the Single Player cursor, then B, then A.
		# Keep B ahead of A when both arrive in the same frame.
		if bridge.is_single_player_menu_screen():
			if frame_input & bridge.DPAD_UP:
				bridge.move_title_selection(-1)
			elif frame_input & bridge.DPAD_DOWN:
				bridge.move_title_selection(1)
			if frame_input & bridge.B_BUTTON:
				bridge.open_save_options_from_title()
			elif frame_input & bridge.A_BUTTON:
				bridge.start_title_selection()
			return
		# title_screen.c's press-start task uses START; the modern Godot prompt
		# also exposes Z/touch confirm, so A follows the same start path.
		if bridge.is_press_start_screen():
			if frame_input & (bridge.START_BUTTON | bridge.A_BUTTON):
				bridge.start_title_selection()
			return
		# Link communication is not a cursor menu in the original. Only START
		# advances the host handshake; B returns to Pak Mode Select.
		if bridge.is_multiplayer_connection_screen():
			if frame_input & bridge.START_BUTTON:
				bridge.start_title_selection()
			elif frame_input & bridge.B_BUTTON:
				bridge.open_save_options_from_title()
			return
		# The original VS lobby commits YES/NO before reading Left/Right.
		if bridge.is_multiplayer_lobby_screen() and (frame_input & bridge.START_BUTTON or frame_input & bridge.A_BUTTON):
			bridge.start_title_selection()
			return
		if bridge.is_multiplayer_lobby_screen():
			# multiplayer_lobby.c only reads host Left/Right after confirm;
			# B and Select must not fall through to the title save-options path.
			if frame_input & bridge.DPAD_LEFT:
				bridge.adjust_title_selection(-1)
			elif frame_input & bridge.DPAD_RIGHT:
				bridge.adjust_title_selection(1)
			return
		if bridge.is_singlepak_results_screen():
			# Multiplayer results advance on their source-defined presentation timer.
			return
		if bridge.is_time_attack_lobby_screen():
			# time_attack_lobby.c falls through from a blocked Up to Down,
			# allowing Up+Down at the top edge to move downward.
			var time_attack_cursor: int = bridge.get_time_attack_lobby_cursor()
			if frame_input & bridge.DPAD_UP and time_attack_cursor != 0:
				bridge.move_title_selection(-1)
			elif frame_input & bridge.DPAD_DOWN and time_attack_cursor != 3:
				bridge.move_title_selection(1)
			if frame_input & bridge.A_BUTTON:
				bridge.start_title_selection()
			return
		# The original mode-select screens handle confirm/back before their
		# directional toggle. This matters when a held direction overlaps A/B.
		if bridge.is_time_attack_mode_screen() or bridge.is_multiplayer_mode_screen():
			if bridge.is_time_attack_mode_screen() and not bridge.is_time_attack_mode_input_ready():
				if frame_input & bridge.A_BUTTON:
					bridge.skip_time_attack_mode_intro()
				return
			if bridge.is_multiplayer_mode_screen() and not bridge.is_multiplayer_mode_input_ready():
				if frame_input & bridge.A_BUTTON:
					bridge.skip_multiplayer_mode_intro()
				return
			# time_attack_mode_select.c and the multiplayer mode task still
			# process its vertical toggle after A/B. Apply it before the Godot
			# transition so A+Up/Down preserves the source-selected mode.
			if frame_input & (bridge.DPAD_UP | bridge.DPAD_DOWN) and frame_input & (bridge.A_BUTTON | bridge.B_BUTTON):
				bridge.move_title_selection(1)
			if frame_input & bridge.A_BUTTON:
				bridge.start_title_selection()
				return
			if frame_input & bridge.B_BUTTON:
				bridge.open_save_options_from_title()
				return
		# Course Select is a horizontal map, not a generic cursor menu. Its
		# movement animation also consumes Back and defers single-player A.
		if bridge.is_course_select_screen():
			if bridge.is_course_select_unlocking():
				# course_select.c consumes all input while the new path is revealed.
				return
			if frame_input & bridge.DPAD_LEFT:
				bridge.move_title_selection(-1)
				return
			if frame_input & bridge.DPAD_RIGHT:
				bridge.move_title_selection(1)
				return
			if bridge.is_course_select_busy() or bridge.is_course_select_starting():
				if frame_input & bridge.A_BUTTON and not bridge.is_multiplayer_course_select_screen():
					bridge.start_title_selection()
				return
			if frame_input & bridge.A_BUTTON:
				bridge.start_title_selection()
				return
			if frame_input & bridge.B_BUTTON:
				bridge.open_save_options_from_title()
			return
		if bridge.is_play_mode_screen():
			# title_screen.c toggles once when either vertical direction is
			# present; Up+Down must not toggle twice.
			if frame_input & (bridge.DPAD_UP | bridge.DPAD_DOWN):
				bridge.move_title_selection(1)
		else:
			if frame_input & bridge.DPAD_UP:
				bridge.move_title_selection(-1)
			elif frame_input & bridge.DPAD_DOWN:
				bridge.move_title_selection(1)
		if frame_input & bridge.DPAD_LEFT:
			bridge.adjust_title_selection(-1)
		elif frame_input & bridge.DPAD_RIGHT:
			bridge.adjust_title_selection(1)
		# title_screen.c checks B before A in the Single Player menu. Keep
		# simultaneous input on the return path instead of opening the item.
		if bridge.is_single_player_menu_screen():
			if frame_input & bridge.B_BUTTON:
				bridge.open_save_options_from_title()
				return
			if frame_input & bridge.A_BUTTON:
				bridge.start_title_selection()
				return
		# Course Select reserves a Left/Right frame for map travel; the original
		# ignores confirmation when directional travel is pressed simultaneously.
		var title_direction_busy: bool = bridge.is_course_select_screen() and bool(frame_input & (bridge.DPAD_LEFT | bridge.DPAD_RIGHT))
		var title_confirmed: bool = bool(frame_input & bridge.A_BUTTON)
		if title_confirmed and not title_direction_busy:
			bridge.start_title_selection()
			return
		if frame_input & bridge.B_BUTTON:
			bridge.open_save_options_from_title()
		return
