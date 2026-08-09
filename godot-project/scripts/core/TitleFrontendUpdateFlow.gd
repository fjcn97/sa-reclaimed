class_name TitleFrontendUpdateFlow
extends RefCounted

## Advances title, course-select, and multiplayer presentation timers. Keeping
## this outside CoreBridge prevents menu-state timing from being coupled to the
## gameplay/results update loop.
static func advance(bridge: Object, delta: float, held_input: int, frame_input: int) -> bool:
	if bridge._title_phase == bridge.TITLE_PHASE_COURSE_SELECT and bridge._course_select_intro_timer > 0.0:
		bridge._course_select_intro_timer = maxf(0.0, bridge._course_select_intro_timer - delta)
	if bridge._course_select_travel_timer > 0.0:
		bridge._course_select_travel_timer = maxf(0.0, bridge._course_select_travel_timer - delta)
		if bridge._course_select_travel_timer <= 0.0:
			bridge._course_select_settle_timer = bridge._course_select_settle_duration
	if bridge._course_select_settle_timer > 0.0:
		bridge._course_select_settle_timer = maxf(0.0, bridge._course_select_settle_timer - delta)
		if bridge._course_select_settle_timer <= 0.0 and bridge._course_select_confirm_pending:
			bridge._course_select_confirm_pending = false
			bridge._course_select_start_timer = bridge._course_select_start_duration
			bridge._title_notice_text = "STARTING %s" % bridge.get_selected_level_text()
			bridge._status_text = bridge.get_title_prompt_text()
	if bridge._course_select_unlock_timer > 0.0:
		bridge._advance_course_select_unlock_cutscene(delta)
	if bridge._course_select_start_timer > 0.0:
		bridge._course_select_start_timer = maxf(0.0, bridge._course_select_start_timer - delta)
		if bridge._course_select_start_timer <= 0.0 and bridge._title_phase == bridge.TITLE_PHASE_COURSE_SELECT:
			if bridge._is_multiplayer_course_select():
				bridge._continue_multiplayer_after_course_select()
			else:
				bridge._begin_level_run(bridge._selected_level_index, bridge._course_select_return_phase == bridge.TITLE_PHASE_TIME_ATTACK_LOBBY)
			return true
	if bridge._multiplayer_outcome_timer > 0.0:
		bridge._multiplayer_outcome_timer = maxf(0.0, bridge._multiplayer_outcome_timer - delta)
		if bridge._multiplayer_outcome_timer <= 0.0 and bridge._title_phase == bridge.TITLE_PHASE_MULTIPLAYER_OUTCOME:
			bridge._resolve_multiplayer_outcome()
			return true
	if bridge._game_state == bridge.GAME_STATE_TITLE and bridge._title_phase == bridge.TITLE_PHASE_MULTIPLAYER_LOBBY and bridge._multiplayer_lobby_exit_timer > 0.0:
		bridge._multiplayer_lobby_exit_timer = maxf(0.0, bridge._multiplayer_lobby_exit_timer - delta)
		if bridge._multiplayer_lobby_exit_timer <= 0.0:
			bridge.open_title_screen_and_skip_intro()
		return true
	if bridge._game_state == bridge.GAME_STATE_TITLE and bridge._title_phase == bridge.TITLE_PHASE_MULTI_CONNECT and bridge._multiplayer_pak_mode == 1 and bridge.is_singlepak_transfer_started() and not bridge.is_singlepak_transfer_complete():
		bridge._singlepak_download_timer += delta
		if bridge._singlepak_download_timer >= 0.25:
			bridge._singlepak_download_timer = 0.0
			bridge._advance_singlepak_transfer_step()
			return true
	if bridge._multiplayer_lobby_wait_timer > 0.0:
		bridge._multiplayer_lobby_wait_timer = maxf(0.0, bridge._multiplayer_lobby_wait_timer - delta)
		if bridge._multiplayer_lobby_wait_timer <= 0.0 and bridge._title_phase == bridge.TITLE_PHASE_MULTIPLAYER_LOBBY and bridge._multiplayer_lobby_waiting:
			bridge._resolve_multiplayer_lobby_choice()
			return true
	if bridge._game_state == bridge.GAME_STATE_TITLE and bridge._title_phase == bridge.TITLE_PHASE_MULTI_CONNECT and bridge._multiplayer_disconnect_timer > 0.0:
		bridge._multiplayer_disconnect_timer = maxf(0.0, bridge._multiplayer_disconnect_timer - delta)
		if bridge._multiplayer_disconnect_timer <= 0.0:
			bridge._multiplayer_link_ready = false
			bridge.open_title_screen_at_multiplayer_menu(bridge._multiplayer_pak_mode)
		return true
	if bridge._singlepak_results_timer > 0.0:
		bridge._singlepak_results_timer = maxf(0.0, bridge._singlepak_results_timer - delta)
		if bridge._singlepak_results_timer <= 0.0 and bridge._title_phase == bridge.TITLE_PHASE_SINGLEPAK_RESULTS:
			bridge._advance_singlepak_results_flow()
			return true
	if bridge._game_state == bridge.GAME_STATE_CHARACTER_SELECT and bridge._character_select_intro_timer > 0.0:
		bridge._character_select_intro_timer = maxf(0.0, bridge._character_select_intro_timer - delta)
	if bridge._game_state == bridge.GAME_STATE_TITLE:
		if bridge._title_phase == bridge.TITLE_PHASE_TIME_ATTACK and bridge._time_attack_mode_intro_timer > 0.0:
			bridge._time_attack_mode_intro_timer = maxf(0.0, bridge._time_attack_mode_intro_timer - delta)
		elif bridge._title_phase == bridge.TITLE_PHASE_PLAY_MODE and bridge._play_mode_intro_timer > 0.0:
			bridge._play_mode_intro_timer = maxf(0.0, bridge._play_mode_intro_timer - delta)
		elif bridge._title_phase == bridge.TITLE_PHASE_SINGLE_PLAYER and bridge._single_player_intro_timer > 0.0:
			bridge._single_player_intro_timer = maxf(0.0, bridge._single_player_intro_timer - delta)
		elif bridge._title_phase == bridge.TITLE_PHASE_MULTI_PLAYER and bridge._multiplayer_mode_intro_timer > 0.0:
			bridge._multiplayer_mode_intro_timer = maxf(0.0, bridge._multiplayer_mode_intro_timer - delta)
		if bridge._title_phase == bridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
			bridge._update_tiny_chao_garden(held_input, frame_input, delta)
			bridge._update_camera()
			return true
		if bridge._title_phase == bridge.TITLE_PHASE_PRESS_START:
			bridge._title_idle_timer = 0.0 if held_input != 0 else bridge._title_idle_timer + delta
			if bridge._title_idle_timer >= 15.0:
				bridge._start_title_demo()
				return true
	if bridge._demo_mode and (bridge._game_state == bridge.GAME_STATE_CLEAR or bridge._game_state == bridge.GAME_STATE_GAME_OVER):
		bridge.open_press_start_screen()
		return true
	return false
