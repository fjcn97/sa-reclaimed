extends RefCounted
class_name SystemMenuInputRouter

## Handles non-title front-end and paused-game input.
func handle(bridge: Object, frame_input: int) -> void:
	# Input routing must not depend on the global autoload so smoke tests can
	# exercise an isolated state owner.

	if bridge.is_intro_screen():
		if frame_input & bridge.A_BUTTON:
			bridge.skip_intro()
		if frame_input & bridge.B_BUTTON:
			bridge.skip_intro()
		return

	if bridge.is_final_intro_screen():
		if frame_input & bridge.START_BUTTON:
			bridge.skip_final_intro()
		return

	if bridge.is_clear_screen():
		if bridge.is_time_attack_clear_screen() and (frame_input & bridge.START_BUTTON or frame_input & bridge.A_BUTTON):
			bridge.clear_replay()
		return

	if bridge.is_chaos_emeralds_screen():
		# missing_emeralds.c handles this message automatically without input.
		return

	if bridge.is_missing_emeralds_screen():
		# missing_emeralds.c advances automatically and has no input handler.
		return

	if bridge.is_to_be_continued_screen():
		# The ending sequence advances automatically in the original.
		return

	if bridge.is_sega_logo_screen():
		if bridge.can_skip_sega_logo() and (frame_input & bridge.START_BUTTON or frame_input & bridge.A_BUTTON):
			bridge.skip_sega_logo()
		return

	if bridge.is_sonic_team_logo_screen():
		if bridge.can_skip_sonic_team_logo() and (frame_input & bridge.START_BUTTON or frame_input & bridge.A_BUTTON):
			bridge.skip_sonic_team_logo()
		return

	if bridge.is_credits_screen():
		# credits.c only accepts START for the replay skip path; slides advance automatically.
		if bridge.can_skip_credits() and frame_input & bridge.START_BUTTON:
			bridge.skip_credits()
		return

	if bridge.is_copyright_screen():
		# Credits End and Copyright are automatic in credits_end.c.
		return

	if bridge.is_credits_end_screen():
		# The original sequence has no input handler; it advances on its timer.
		return

	if bridge.is_character_unlock_screen():
		if frame_input & bridge.START_BUTTON:
			bridge.fast_forward_character_unlock()
		return

	if bridge.is_special_stage_screen():
		# special_stage/main.c handles the paused menu before the global
		# START toggle, so A/Up/Down take precedence while paused.
		if bridge.is_special_stage_paused():
			# The source checks Up and Down independently (Down wins if both
			# are pressed), then consumes cursor movement before A and ignores B.
			if frame_input & bridge.DPAD_UP:
				bridge.move_special_stage_pause_selection(-1)
			if frame_input & bridge.DPAD_DOWN:
				bridge.move_special_stage_pause_selection(1)
				return
			if frame_input & bridge.DPAD_UP:
				return
			if frame_input & bridge.A_BUTTON:
				bridge.confirm_special_stage_pause_selection()
			return
		if frame_input & bridge.START_BUTTON:
			bridge.toggle_special_stage_pause()
		elif frame_input & bridge.A_BUTTON:
			# The original only consumes A during result scoring; the entry
			# sequence advances automatically and ignores A.
			if bridge.is_special_stage_results_screen():
				bridge.advance_special_stage_screen()
		return

	if bridge.is_game_over_screen():
		if frame_input & bridge.START_BUTTON or frame_input & bridge.A_BUTTON:
			bridge.accept_game_over()
		if frame_input & bridge.B_BUTTON or frame_input & bridge.SELECT_BUTTON:
			bridge.cancel_game_over()
		return

	if bridge.is_paused():
		# The source checks confirmation before cursor movement. This also
		# prevents A+Down from quitting when Continue was focused.
		if frame_input & bridge.START_BUTTON:
			bridge.resume_game()
			return
		if frame_input & bridge.A_BUTTON:
			# pause_menu.c confirms A on release; advance_ui_timers handles it.
			return
		if frame_input & bridge.B_BUTTON and (bridge.is_time_attack_run() or bridge.is_multiplayer_run()):
			# pause_menu.c handles multiplayer/Time Attack B before cursor movement.
			bridge.cancel_pause_selection()
			return
		if frame_input & bridge.DPAD_UP:
			bridge.move_pause_selection(-1)
		elif frame_input & bridge.DPAD_DOWN:
			bridge.move_pause_selection(1)
		if frame_input & bridge.B_BUTTON:
			bridge.cancel_pause_selection()
		return
