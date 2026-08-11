class_name TitleNavigationFlow
extends RefCounted

## Owns title-menu cursor and adjustment behavior. CoreBridge remains the
## transition owner for opening the next screen.

static func adjust(bridge: Object, direction: int) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_TITLE:
		return
	var title_navigation = bridge.get_title_navigation_state()
	var multiplayer = bridge.get_multiplayer_frontend_state()
	if title_navigation.phase == bridge.TITLE_PHASE_SINGLEPAK_RESULTS:
		multiplayer.results_cursor = wrapi(multiplayer.results_cursor + direction, 0, bridge.get_singlepak_results_items().size())
	elif title_navigation.phase == bridge.TITLE_PHASE_MULTIPLAYER_LOBBY:
		if bridge.get_multiplayer_lobby_state().waiting:
			title_navigation.notice_text = "WAITING FOR ALL LINKED PLAYERS"
		else:
			bridge.get_multiplayer_lobby_state().cursor = wrapi(bridge.get_multiplayer_lobby_state().cursor + direction, 0, bridge.get_multiplayer_lobby_items().size())
			title_navigation.notice_text = "REMATCH SELECTED" if bridge.get_multiplayer_lobby_state().cursor == 0 else "EXIT TO TITLE SELECTED"
	elif title_navigation.phase == bridge.TITLE_PHASE_COURSE_SELECT:
		bridge.start_course_select_travel(direction)
		return
	elif title_navigation.phase == bridge.TITLE_PHASE_TIME_ATTACK_LOBBY and bridge.get_time_attack_session_state().lobby_cursor == 2:
		bridge.set_selected_level_index(clampi(bridge.get_selected_level_index() + direction, 0, bridge.get_profile_state().unlocked_level_index))
		title_navigation.notice_text = "COURSE SET TO %s" % bridge.get_selected_level_text()
		bridge.save_profile()
	else:
		return
	bridge.set_status_text(bridge.get_title_prompt_text())

static func move(bridge: Object, direction: int) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_TITLE:
		return
	var title_navigation = bridge.get_title_navigation_state()
	var multiplayer = bridge.get_multiplayer_frontend_state()
	title_navigation.notice_text = ""
	match title_navigation.phase:
		bridge.TITLE_PHASE_PLAY_MODE, bridge.TITLE_PHASE_SINGLE_PLAYER, bridge.TITLE_PHASE_MULTI_PLAYER, bridge.TITLE_PHASE_TIME_ATTACK, bridge.TITLE_PHASE_TINY_CHAO_GARDEN, bridge.TITLE_PHASE_TINY_CHAO_SETUP, bridge.TITLE_PHASE_SINGLEPAK_SYNC:
			title_navigation.menu_index = wrapi(title_navigation.menu_index + direction, 0, bridge.get_title_menu_items().size())
		bridge.TITLE_PHASE_TIME_ATTACK_LOBBY:
			bridge.get_time_attack_session_state().lobby_cursor = clampi(bridge.get_time_attack_session_state().lobby_cursor + signi(direction), 0, bridge.get_time_attack_lobby_rows().size() - 1)
		bridge.TITLE_PHASE_COURSE_SELECT:
			if not bridge.is_course_select_busy(): bridge.start_course_select_travel(direction)
		_:
			return
	bridge.set_status_text(bridge.get_title_prompt_text())
	bridge.save_profile()

static func start(bridge: Object) -> void:
	if bridge.get_game_state() != bridge.GAME_STATE_TITLE:
		return
	var title_navigation = bridge.get_title_navigation_state()
	var multiplayer = bridge.get_multiplayer_frontend_state()
	title_navigation.notice_text = ""
	match title_navigation.phase:
		bridge.TITLE_PHASE_PRESS_START:
			bridge.open_title_screen_at_play_mode_menu(0, "", true)
			return
		bridge.TITLE_PHASE_PLAY_MODE:
			if title_navigation.menu_index == 0:
				bridge.open_title_screen_at_single_player_menu(0, "", true)
			else:
				bridge.open_title_screen_at_multiplayer_menu(0)
			return
		bridge.TITLE_PHASE_SINGLE_PLAYER:
			match title_navigation.menu_index:
				0:
					if not bridge.has_profile_name(): bridge.open_profile_name_from_game_start()
					else: bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_GAME_START)
				1: bridge.open_title_screen_at_time_attack_menu(0)
				2: bridge.open_options_screen()
				3: bridge.open_tiny_chao_garden_menu(0)
			return
		bridge.TITLE_PHASE_MULTI_PLAYER:
			if not bridge.has_profile_name():
				bridge.open_profile_name_from_multiplayer()
			else:
				bridge.start_multiplayer_mode(title_navigation.menu_index)
			return
		bridge.TITLE_PHASE_TIME_ATTACK:
			if title_navigation.menu_index == 0:
				bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE, 0)
			elif not bridge.is_boss_time_attack_unlocked():
				title_navigation.notice_text = "BOSS TIME ATTACK LOCKED"
			else:
				bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS, 0)
			return
		bridge.TITLE_PHASE_TIME_ATTACK_LOBBY:
			match bridge.get_time_attack_session_state().lobby_cursor:
				0: bridge.begin_level_run(bridge.get_selected_level_index(), true)
				1:
					bridge.set_selected_level_index(0)
					bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS if bridge.get_time_attack_session_state().boss_mode else bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE)
				2: bridge.open_course_select(bridge.TITLE_PHASE_TIME_ATTACK_LOBBY)
				3: bridge.open_title_screen_and_skip_intro()
			return
		bridge.TITLE_PHASE_COURSE_SELECT:
			if bridge.is_course_select_starting(): return
			if bridge.is_course_select_busy():
				if not bridge.is_multiplayer_course_select():
					bridge.get_course_select_presentation_state().request_confirmation()
					title_navigation.notice_text = "COURSE LOCKED IN"
				bridge.set_status_text(bridge.get_title_prompt_text())
				return
			bridge.get_course_select_presentation_state().start()
			title_navigation.notice_text = "STARTING %s" % bridge.get_selected_level_text()
			bridge.set_status_text(bridge.get_title_prompt_text())
			return
		bridge.TITLE_PHASE_TINY_CHAO_GARDEN:
			if title_navigation.menu_index == 0: bridge.open_tiny_chao_setup_menu(0, "TINY CHAO GARDEN READY")
			else: bridge.open_title_screen_at_single_player_menu(3)
			return
		bridge.TITLE_PHASE_MULTI_CONNECT:
			bridge.advance_multiplayer_link_state()
			if bridge.get_multiplayer_link_count() < 2:
				title_navigation.notice_text = "WAITING FOR %s LINK" % ["MULTI-PAK" if multiplayer.pak_mode == 0 else "SINGLE-PAK"]
			elif multiplayer.pak_mode == 0:
				bridge.open_multiplayer_outcome(0, bridge.TITLE_PHASE_MULTI_CONNECT)
			else:
				multiplayer.download_timer = 0.0
				bridge.advance_singlepak_transfer_step()
			return
		bridge.TITLE_PHASE_MULTIPLAYER_OUTCOME:
			bridge.resolve_multiplayer_outcome()
			return
		bridge.TITLE_PHASE_SINGLEPAK_SYNC:
			match title_navigation.menu_index:
				0:
					if bridge.is_singlepak_sync_ready(): bridge.begin_level_run(bridge.get_selected_level_index(), false, true)
					else: bridge.advance_singlepak_sync_state()
				1:
					if bridge.is_singlepak_sync_ready():
						bridge.prepare_multiplayer_results_snapshot(bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
						bridge.open_singlepak_results_screen(bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE, 0)
					else: title_navigation.notice_text = "CLIENTS STILL SYNCHRONIZING"
				2:
					if bridge.is_singlepak_transfer_started(): title_navigation.notice_text = "WAIT FOR CLIENT BOOT TO FINISH"
					else: bridge.open_title_screen_at_multiplayer_menu(1)
			return
		bridge.TITLE_PHASE_MULTIPLAYER_LOBBY:
			if bridge.get_multiplayer_lobby_state().waiting:
				title_navigation.notice_text = "WAITING FOR ALL LINKED PLAYERS"
			else:
				bridge.get_multiplayer_lobby_state().begin_wait()
				title_navigation.notice_text = "WAITING FOR REMATCH CONFIRMATIONS" if bridge.get_multiplayer_lobby_state().cursor == 0 else "WAITING FOR EXIT CONFIRMATIONS"
				bridge.set_status_text(bridge.get_title_prompt_text())
			return
		bridge.TITLE_PHASE_TINY_CHAO_SETUP:
			match title_navigation.menu_index:
				0:
					if bridge.get_tiny_chao_state().session_id == "TCG-0000": bridge.generate_tiny_chao_session_id()
					bridge.open_tiny_chao_garden_play()
				1:
					bridge.generate_tiny_chao_session_id()
					bridge.get_title_navigation_state().notice_text = "NEW SESSION ID READY"
				2: bridge.open_tiny_chao_garden_menu(0)
			return
	bridge.set_status_text(bridge.get_title_prompt_text())
