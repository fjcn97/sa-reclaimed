extends RefCounted
class_name TitleInputRouter

## Owns title-front-end input precedence and delegates transitions to CoreBridge.
func handle(bridge: Object, frame_input: int) -> void:
	# Keep the router testable against an isolated bridge instance. The local
	# compatibility alias avoids changing the well-audited input-precedence body.
	var CoreBridge: Object = bridge
	if CoreBridge.is_title_screen():
		if CoreBridge.is_play_mode_screen() and not CoreBridge.is_play_mode_input_ready():
			return
		if CoreBridge.is_single_player_menu_screen() and not CoreBridge.is_single_player_input_ready():
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
			return
		# title_screen.c checks the Single Player cursor, then B, then A.
		# Keep B ahead of A when both arrive in the same frame.
		if CoreBridge.is_single_player_menu_screen():
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_title_selection(-1)
			elif frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_title_selection(1)
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
			elif frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
			return
		# title_screen.c's press-start task uses START; the modern Godot prompt
		# also exposes Z/touch confirm, so A follows the same start path.
		if CoreBridge.is_press_start_screen():
			if frame_input & (CoreBridge.START_BUTTON | CoreBridge.A_BUTTON):
				CoreBridge.start_title_selection()
			return
		# Link communication is not a cursor menu in the original. Only START
		# advances the host handshake; B returns to Pak Mode Select.
		if CoreBridge.is_multiplayer_connection_screen():
			if frame_input & CoreBridge.START_BUTTON:
				CoreBridge.start_title_selection()
			elif frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
			return
		# The original VS lobby commits YES/NO before reading Left/Right.
		if CoreBridge.is_multiplayer_lobby_screen() and (frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON):
			CoreBridge.start_title_selection()
			return
		if CoreBridge.is_multiplayer_lobby_screen():
			# multiplayer_lobby.c only reads host Left/Right after confirm;
			# B and Select must not fall through to the title save-options path.
			if frame_input & CoreBridge.DPAD_LEFT:
				CoreBridge.adjust_title_selection(-1)
			elif frame_input & CoreBridge.DPAD_RIGHT:
				CoreBridge.adjust_title_selection(1)
			return
		if CoreBridge.is_singlepak_results_screen():
			# Multiplayer results advance on their source-defined presentation timer.
			return
		if CoreBridge.is_time_attack_lobby_screen():
			# time_attack_lobby.c falls through from a blocked Up to Down,
			# allowing Up+Down at the top edge to move downward.
			var time_attack_cursor: int = CoreBridge.get_time_attack_lobby_cursor()
			if frame_input & CoreBridge.DPAD_UP and time_attack_cursor != 0:
				CoreBridge.move_title_selection(-1)
			elif frame_input & CoreBridge.DPAD_DOWN and time_attack_cursor != 3:
				CoreBridge.move_title_selection(1)
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
			return
		# The original mode-select screens handle confirm/back before their
		# directional toggle. This matters when a held direction overlaps A/B.
		if CoreBridge.is_time_attack_mode_screen() or CoreBridge.is_multiplayer_mode_screen():
			if CoreBridge.is_time_attack_mode_screen() and not CoreBridge.is_time_attack_mode_input_ready():
				if frame_input & CoreBridge.A_BUTTON:
					CoreBridge.skip_time_attack_mode_intro()
				return
			if CoreBridge.is_multiplayer_mode_screen() and not CoreBridge.is_multiplayer_mode_input_ready():
				if frame_input & CoreBridge.A_BUTTON:
					CoreBridge.skip_multiplayer_mode_intro()
				return
			# time_attack_mode_select.c and the multiplayer mode task still
			# process its vertical toggle after A/B. Apply it before the Godot
			# transition so A+Up/Down preserves the source-selected mode.
			if frame_input & (CoreBridge.DPAD_UP | CoreBridge.DPAD_DOWN) and frame_input & (CoreBridge.A_BUTTON | CoreBridge.B_BUTTON):
				CoreBridge.move_title_selection(1)
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
				return
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
				return
		# Course Select is a horizontal map, not a generic cursor menu. Its
		# movement animation also consumes Back and defers single-player A.
		if CoreBridge.is_course_select_screen():
			if CoreBridge.is_course_select_unlocking():
				# course_select.c consumes all input while the new path is revealed.
				return
			if frame_input & CoreBridge.DPAD_LEFT:
				CoreBridge.move_title_selection(-1)
				return
			if frame_input & CoreBridge.DPAD_RIGHT:
				CoreBridge.move_title_selection(1)
				return
			if CoreBridge.is_course_select_busy() or CoreBridge.is_course_select_starting():
				if frame_input & CoreBridge.A_BUTTON and not CoreBridge.is_multiplayer_course_select_screen():
					CoreBridge.start_title_selection()
				return
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
				return
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
			return
		if CoreBridge.is_play_mode_screen():
			# title_screen.c toggles once when either vertical direction is
			# present; Up+Down must not toggle twice.
			if frame_input & (CoreBridge.DPAD_UP | CoreBridge.DPAD_DOWN):
				CoreBridge.move_title_selection(1)
		else:
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_title_selection(-1)
			elif frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_title_selection(1)
		if frame_input & CoreBridge.DPAD_LEFT:
			CoreBridge.adjust_title_selection(-1)
		elif frame_input & CoreBridge.DPAD_RIGHT:
			CoreBridge.adjust_title_selection(1)
		# title_screen.c checks B before A in the Single Player menu. Keep
		# simultaneous input on the return path instead of opening the item.
		if CoreBridge.is_single_player_menu_screen():
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.open_save_options_from_title()
				return
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.start_title_selection()
				return
		# Course Select reserves a Left/Right frame for map travel; the original
		# ignores confirmation when directional travel is pressed simultaneously.
		var title_direction_busy: bool = CoreBridge.is_course_select_screen() and bool(frame_input & (CoreBridge.DPAD_LEFT | CoreBridge.DPAD_RIGHT))
		var title_confirmed: bool = bool(frame_input & CoreBridge.A_BUTTON)
		if title_confirmed and not title_direction_busy:
			CoreBridge.start_title_selection()
			return
		if frame_input & CoreBridge.B_BUTTON:
			CoreBridge.open_save_options_from_title()
		return
