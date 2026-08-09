extends RefCounted
class_name SystemMenuInputRouter

## Handles non-title front-end and paused-game input.
func handle(frame_input: int) -> void:
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


