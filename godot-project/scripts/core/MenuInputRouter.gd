extends RefCounted
class_name MenuInputRouter

func handle(frame_input: int) -> void:
	if CoreBridge.is_tiny_chao_garden_play_screen():
		# Garden input is consumed by advance_ui_timers before generic menu input.
		return

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
			var time_attack_cursor := CoreBridge.get_time_attack_lobby_cursor()
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
		var title_direction_busy := CoreBridge.is_course_select_screen() and bool(frame_input & (CoreBridge.DPAD_LEFT | CoreBridge.DPAD_RIGHT))
		var title_confirmed := bool(frame_input & CoreBridge.A_BUTTON)
		if title_confirmed and not title_direction_busy:
			CoreBridge.start_title_selection()
			return
		if frame_input & CoreBridge.B_BUTTON:
			CoreBridge.open_save_options_from_title()
		return

	if CoreBridge.is_save_options():
		if CoreBridge.handle_save_shoulder_input(frame_input):
			return
		# Options' top-level screen checks confirm/back before directional input.
		if CoreBridge.is_save_main_menu_screen():
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.accept_save_selection()
				return
			if frame_input & CoreBridge.B_BUTTON:
				if not CoreBridge.trigger_save_secondary_action():
					CoreBridge.cancel_save_selection()
				return
		# These source tasks consume the first matching D-pad direction even
		# when the cursor wraps or stays on the same active name slot.
		if CoreBridge.is_name_entry_screen():
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_save_selection(-1)
				return
			elif frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_save_selection(1)
				return
			elif frame_input & CoreBridge.DPAD_LEFT:
				CoreBridge.adjust_save_selection(-1)
				return
			elif frame_input & CoreBridge.DPAD_RIGHT:
				CoreBridge.adjust_save_selection(1)
				return
		if CoreBridge.is_player_data_screen():
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_save_selection(-1)
				return
			elif frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_save_selection(1)
				return
		if CoreBridge.is_language_screen():
			if frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_save_selection(1)
				return
			elif frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_save_selection(-1)
				return
		# Task_OptionsScreenMain checks A/B before its D-pad branches. Keep
		# simultaneous confirm-and-direction input on the current item.
		if CoreBridge.is_options_main_screen():
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.accept_save_selection()
				return
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.cancel_save_selection()
				return
		# sound_test.c evaluates all four directions independently, then A and
		# B independently. Preserve that order for simultaneous input frames.
		if CoreBridge.is_sound_test_screen():
			if frame_input & CoreBridge.DPAD_LEFT:
				CoreBridge.adjust_save_selection(-1)
			if frame_input & CoreBridge.DPAD_RIGHT:
				CoreBridge.adjust_save_selection(1)
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_save_selection(-1)
			if frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_save_selection(1)
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.accept_save_selection()
			if frame_input & CoreBridge.B_BUTTON:
				CoreBridge.cancel_save_selection()
			return
		# options_screen.c uses Down-first on its main menu and language
		# screen, but Up-first on Player Data and profile name entry.
		var save_vertical_up_first := CoreBridge.is_player_data_screen() or CoreBridge.is_name_entry_screen() or CoreBridge.is_multiplayer_records_screen() or CoreBridge.is_time_records_courses_view()
		if save_vertical_up_first and frame_input & CoreBridge.DPAD_UP:
			CoreBridge.move_save_selection(-1)
			return
		if not save_vertical_up_first and frame_input & CoreBridge.DPAD_DOWN:
			CoreBridge.move_save_selection(1)
			return
		if save_vertical_up_first and frame_input & CoreBridge.DPAD_DOWN:
			CoreBridge.move_save_selection(1)
			return
		if not save_vertical_up_first and frame_input & CoreBridge.DPAD_UP:
			CoreBridge.move_save_selection(-1)
			return
		if frame_input & CoreBridge.DPAD_LEFT:
			CoreBridge.adjust_save_selection(-1)
		elif frame_input & CoreBridge.DPAD_RIGHT:
			CoreBridge.adjust_save_selection(1)
		if CoreBridge.save_direction_consumes_action(frame_input):
			return
		# Converted options tasks handle A before all later actions and return,
		# so simultaneous A+START/B/Select cannot commit twice.
		if frame_input & CoreBridge.A_BUTTON:
			CoreBridge.accept_save_selection()
			return
		if frame_input & CoreBridge.START_BUTTON:
			var start_handled := CoreBridge.trigger_save_start_action()
			# options_screen.c accepts A or START on the language screen,
			# including edits to an existing profile.
			var start_can_confirm := CoreBridge.is_name_entry_screen() or CoreBridge.is_language_screen()
			if not start_handled and start_can_confirm:
				CoreBridge.accept_save_selection()
		if frame_input & CoreBridge.SELECT_BUTTON:
			# options_screen.c handles Select only in Button Config; all
			# other submenu tasks ignore it.
			if CoreBridge.is_button_config_screen():
				CoreBridge.trigger_save_special_action()
		if frame_input & CoreBridge.B_BUTTON:
			if not CoreBridge.trigger_save_secondary_action():
				CoreBridge.cancel_save_selection()
		return

	if CoreBridge.is_character_select():
		if not CoreBridge.is_character_select_input_ready():
			if frame_input & CoreBridge.A_BUTTON and not CoreBridge.is_multiplayer_character_select_screen():
				CoreBridge.skip_character_select_intro()
			return
		var character_direction := 0
		if frame_input & CoreBridge.DPAD_LEFT or frame_input & CoreBridge.DPAD_UP:
			character_direction = -1
		elif frame_input & CoreBridge.DPAD_RIGHT or frame_input & CoreBridge.DPAD_DOWN:
			character_direction = 1
		if character_direction != 0:
			CoreBridge.move_character_selection(character_direction)
			return
		if frame_input & CoreBridge.A_BUTTON:
			CoreBridge.confirm_character_selection()
		# character_select.c only handles B for single-player cancel;
		# Select is ignored on this screen.
		if frame_input & CoreBridge.B_BUTTON and not CoreBridge.is_multiplayer_character_select_screen():
			CoreBridge.cancel_character_selection()
		return

	if CoreBridge.is_intro_screen():
		if frame_input & CoreBridge.A_BUTTON:
			CoreBridge.skip_intro()
		if frame_input & CoreBridge.B_BUTTON:
			CoreBridge.skip_intro()
		return

	if CoreBridge.is_final_intro_screen():
		if frame_input & CoreBridge.START_BUTTON:
			CoreBridge.skip_final_intro()
		return

	if CoreBridge.is_clear_screen():
		if CoreBridge.is_time_attack_clear_screen() and (frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON):
			CoreBridge.clear_replay()
		return

	if CoreBridge.is_chaos_emeralds_screen():
		# missing_emeralds.c handles this message automatically without input.
		return

	if CoreBridge.is_missing_emeralds_screen():
		# missing_emeralds.c advances automatically and has no input handler.
		return

	if CoreBridge.is_to_be_continued_screen():
		# The ending sequence advances automatically in the original.
		return

	if CoreBridge.is_sega_logo_screen():
		if CoreBridge.can_skip_sega_logo() and (frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON):
			CoreBridge.skip_sega_logo()
		return

	if CoreBridge.is_sonic_team_logo_screen():
		if CoreBridge.can_skip_sonic_team_logo() and (frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON):
			CoreBridge.skip_sonic_team_logo()
		return

	if CoreBridge.is_credits_screen():
		# credits.c only accepts START for the replay skip path; slides advance automatically.
		if CoreBridge.can_skip_credits() and frame_input & CoreBridge.START_BUTTON:
			CoreBridge.skip_credits()
		return

	if CoreBridge.is_copyright_screen():
		# Credits End and Copyright are automatic in credits_end.c.
		return

	if CoreBridge.is_credits_end_screen():
		# The original sequence has no input handler; it advances on its timer.
		return

	if CoreBridge.is_character_unlock_screen():
		if frame_input & CoreBridge.START_BUTTON:
			CoreBridge.fast_forward_character_unlock()
		return

	if CoreBridge.is_special_stage_screen():
		# special_stage/main.c handles the paused menu before the global
		# START toggle, so A/Up/Down take precedence while paused.
		if CoreBridge.is_special_stage_paused():
			# The source checks Up and Down independently (Down wins if both
			# are pressed), then consumes cursor movement before A and ignores B.
			if frame_input & CoreBridge.DPAD_UP:
				CoreBridge.move_special_stage_pause_selection(-1)
			if frame_input & CoreBridge.DPAD_DOWN:
				CoreBridge.move_special_stage_pause_selection(1)
				return
			if frame_input & CoreBridge.DPAD_UP:
				return
			if frame_input & CoreBridge.A_BUTTON:
				CoreBridge.confirm_special_stage_pause_selection()
			return
		if frame_input & CoreBridge.START_BUTTON:
			CoreBridge.toggle_special_stage_pause()
		elif frame_input & CoreBridge.A_BUTTON:
			# The original only consumes A during result scoring; the entry
			# sequence advances automatically and ignores A.
			if CoreBridge.is_special_stage_results_screen():
				CoreBridge.advance_special_stage_screen()
		return

	if CoreBridge.is_game_over_screen():
		if frame_input & CoreBridge.START_BUTTON or frame_input & CoreBridge.A_BUTTON:
			CoreBridge.accept_game_over()
		if frame_input & CoreBridge.B_BUTTON or frame_input & CoreBridge.SELECT_BUTTON:
			CoreBridge.cancel_game_over()
		return

	if CoreBridge.is_paused():
		# The source checks confirmation before cursor movement. This also
		# prevents A+Down from quitting when Continue was focused.
		if frame_input & CoreBridge.START_BUTTON:
			CoreBridge.resume_game()
			return
		if frame_input & CoreBridge.A_BUTTON:
			# pause_menu.c confirms A on release; advance_ui_timers handles it.
			return
		if frame_input & CoreBridge.B_BUTTON and (CoreBridge.is_time_attack_run() or CoreBridge.is_multiplayer_run()):
			# pause_menu.c handles multiplayer/Time Attack B before cursor movement.
			CoreBridge.cancel_pause_selection()
			return
		if frame_input & CoreBridge.DPAD_UP:
			CoreBridge.move_pause_selection(-1)
		elif frame_input & CoreBridge.DPAD_DOWN:
			CoreBridge.move_pause_selection(1)
		if frame_input & CoreBridge.B_BUTTON:
			CoreBridge.cancel_pause_selection()
		return
