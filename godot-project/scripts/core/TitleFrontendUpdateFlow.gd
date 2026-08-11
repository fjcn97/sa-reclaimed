class_name TitleFrontendUpdateFlow
extends RefCounted

## Advances title, course-select, and multiplayer presentation timers. Keeping
## this outside CoreBridge prevents menu-state timing from being coupled to the
## gameplay/results update loop.
static func advance(bridge: Object, delta: float, held_input: int, frame_input: int) -> bool:
	var title_navigation = bridge.get_title_navigation_state()
	var multiplayer = bridge.get_multiplayer_frontend_state()
	if title_navigation.phase == bridge.TITLE_PHASE_COURSE_SELECT:
		bridge.get_course_select_presentation_state().advance_intro(delta)
	if bridge.get_course_select_travel_state().advance(delta) and bridge.get_course_select_presentation_state().consume_confirmation():
			title_navigation.notice_text = "STARTING %s" % bridge.get_selected_level_text()
			bridge.set_status_text(bridge.get_title_prompt_text())
	if bridge.is_course_select_unlocking():
		bridge.advance_course_select_unlock_cutscene(delta)
	if bridge.get_course_select_presentation_state().advance_start(delta) and title_navigation.phase == bridge.TITLE_PHASE_COURSE_SELECT:
			if bridge.is_multiplayer_course_select():
				bridge.continue_multiplayer_after_course_select()
			else:
				bridge.begin_level_run(bridge.get_selected_level_index(), bridge.get_course_select_presentation_state().return_phase == bridge.TITLE_PHASE_TIME_ATTACK_LOBBY)
			return true
	if bridge.get_multiplayer_lobby_state().outcome_timer > 0.0:
		if bridge.get_multiplayer_lobby_state().advance_outcome(delta) and title_navigation.phase == bridge.TITLE_PHASE_MULTIPLAYER_OUTCOME:
			bridge.resolve_multiplayer_outcome()
			return true
	if bridge.get_game_state() == bridge.GAME_STATE_TITLE and title_navigation.phase == bridge.TITLE_PHASE_MULTIPLAYER_LOBBY and bridge.get_multiplayer_lobby_state().exit_timer > 0.0:
		if bridge.get_multiplayer_lobby_state().advance_lobby(delta).exit_complete:
			bridge.open_title_screen_and_skip_intro()
		return true
	if bridge.get_game_state() == bridge.GAME_STATE_TITLE and title_navigation.phase == bridge.TITLE_PHASE_MULTI_CONNECT and multiplayer.pak_mode == 1 and bridge.is_singlepak_transfer_started() and not bridge.is_singlepak_transfer_complete():
		multiplayer.download_timer += delta
		if multiplayer.download_timer >= 0.25:
			multiplayer.download_timer = 0.0
			bridge.advance_singlepak_transfer_step()
			return true
	if bridge.get_multiplayer_lobby_state().wait_timer > 0.0:
		if bridge.get_multiplayer_lobby_state().advance_lobby(delta).wait_complete and title_navigation.phase == bridge.TITLE_PHASE_MULTIPLAYER_LOBBY:
			bridge.resolve_multiplayer_lobby_choice()
			return true
	if bridge.get_game_state() == bridge.GAME_STATE_TITLE and title_navigation.phase == bridge.TITLE_PHASE_MULTI_CONNECT and multiplayer.disconnect_timer > 0.0:
		multiplayer.disconnect_timer = maxf(0.0, multiplayer.disconnect_timer - delta)
		if multiplayer.disconnect_timer <= 0.0:
			multiplayer.link_ready = false
			bridge.open_title_screen_at_multiplayer_menu(multiplayer.pak_mode)
		return true
	if multiplayer.results_timer > 0.0:
		multiplayer.results_timer = maxf(0.0, multiplayer.results_timer - delta)
		if multiplayer.results_timer <= 0.0 and title_navigation.phase == bridge.TITLE_PHASE_SINGLEPAK_RESULTS:
			bridge.advance_singlepak_results_flow()
			return true
	if bridge.get_game_state() == bridge.GAME_STATE_CHARACTER_SELECT:
		bridge.get_frontend_intro_state().advance("character_select", delta)
	if bridge.get_game_state() == bridge.GAME_STATE_TITLE:
		if title_navigation.phase == bridge.TITLE_PHASE_TIME_ATTACK:
			bridge.get_frontend_intro_state().advance("time_attack_mode", delta)
		elif title_navigation.phase == bridge.TITLE_PHASE_PLAY_MODE:
			bridge.get_frontend_intro_state().advance("play_mode", delta)
		elif title_navigation.phase == bridge.TITLE_PHASE_SINGLE_PLAYER:
			bridge.get_frontend_intro_state().advance("single_player", delta)
		elif title_navigation.phase == bridge.TITLE_PHASE_MULTI_PLAYER:
			bridge.get_frontend_intro_state().advance("multiplayer_mode", delta)
		if title_navigation.phase == bridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY:
			bridge.update_tiny_chao_garden(held_input, frame_input, delta)
			bridge.update_camera()
			return true
		if title_navigation.phase == bridge.TITLE_PHASE_PRESS_START:
			if bridge.get_title_demo_state().advance_idle(delta, held_input != 0):
				bridge.start_title_demo()
				return true
	if bridge.get_title_demo_state().active and (bridge.get_game_state() == bridge.GAME_STATE_CLEAR or bridge.get_game_state() == bridge.GAME_STATE_GAME_OVER):
		bridge.open_press_start_screen()
		return true
	return false
