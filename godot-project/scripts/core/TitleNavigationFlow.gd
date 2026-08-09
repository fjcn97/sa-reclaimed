class_name TitleNavigationFlow
extends RefCounted

## Owns title-menu cursor and adjustment behavior. CoreBridge remains the
## transition owner for opening the next screen.

static func adjust(bridge: Object, direction: int) -> void:
	if bridge._game_state != bridge.GAME_STATE_TITLE:
		return
	if bridge._title_phase == bridge.TITLE_PHASE_SINGLEPAK_RESULTS:
		bridge._singlepak_results_cursor = wrapi(bridge._singlepak_results_cursor + direction, 0, bridge.get_singlepak_results_items().size())
	elif bridge._title_phase == bridge.TITLE_PHASE_MULTIPLAYER_LOBBY:
		if bridge._multiplayer_lobby_waiting:
			bridge._title_notice_text = "WAITING FOR ALL LINKED PLAYERS"
		else:
			bridge._multiplayer_lobby_cursor = wrapi(bridge._multiplayer_lobby_cursor + direction, 0, bridge.get_multiplayer_lobby_items().size())
			bridge._title_notice_text = "REMATCH SELECTED" if bridge._multiplayer_lobby_cursor == 0 else "EXIT TO TITLE SELECTED"
	elif bridge._title_phase == bridge.TITLE_PHASE_COURSE_SELECT:
		bridge._start_course_select_travel(direction)
		return
	elif bridge._title_phase == bridge.TITLE_PHASE_TIME_ATTACK_LOBBY and bridge._time_attack_lobby_cursor == 2:
		bridge._selected_level_index = clampi(bridge._selected_level_index + direction, 0, bridge._unlocked_level_index)
		bridge._title_notice_text = "COURSE SET TO %s" % bridge.get_selected_level_text()
		bridge._save_save_data()
	else:
		return
	bridge._status_text = bridge.get_title_prompt_text()

static func move(bridge: Object, direction: int) -> void:
	if bridge._game_state != bridge.GAME_STATE_TITLE:
		return
	bridge._title_notice_text = ""
	match bridge._title_phase:
		bridge.TITLE_PHASE_PLAY_MODE, bridge.TITLE_PHASE_SINGLE_PLAYER, bridge.TITLE_PHASE_MULTI_PLAYER, bridge.TITLE_PHASE_TIME_ATTACK, bridge.TITLE_PHASE_TINY_CHAO_GARDEN, bridge.TITLE_PHASE_TINY_CHAO_SETUP, bridge.TITLE_PHASE_SINGLEPAK_SYNC:
			bridge._title_menu_index = wrapi(bridge._title_menu_index + direction, 0, bridge.get_title_menu_items().size())
		bridge.TITLE_PHASE_TIME_ATTACK_LOBBY:
			bridge._time_attack_lobby_cursor = clampi(bridge._time_attack_lobby_cursor + signi(direction), 0, bridge.get_time_attack_lobby_rows().size() - 1)
		bridge.TITLE_PHASE_COURSE_SELECT:
			if not bridge.is_course_select_busy(): bridge._start_course_select_travel(direction)
		_:
			return
	bridge._status_text = bridge.get_title_prompt_text()
	bridge._save_save_data()

static func start(bridge: Object) -> void:
	if bridge._game_state != bridge.GAME_STATE_TITLE:
		return
	bridge._title_notice_text = ""
	match bridge._title_phase:
		bridge.TITLE_PHASE_PRESS_START:
			bridge.open_title_screen_at_play_mode_menu(0, "", true)
			return
		bridge.TITLE_PHASE_PLAY_MODE:
			if bridge._title_menu_index == 0:
				bridge.open_title_screen_at_single_player_menu(0, "", true)
			else:
				bridge.open_title_screen_at_multiplayer_menu(0)
			return
		bridge.TITLE_PHASE_SINGLE_PLAYER:
			match bridge._title_menu_index:
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
				bridge._start_multiplayer_mode(bridge._title_menu_index)
			return
		bridge.TITLE_PHASE_TIME_ATTACK:
			if bridge._title_menu_index == 0:
				bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE, 0)
			elif not bridge._boss_time_attack_unlocked:
				bridge._title_notice_text = "BOSS TIME ATTACK LOCKED"
			else:
				bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS, 0)
			return
		bridge.TITLE_PHASE_TIME_ATTACK_LOBBY:
			match bridge._time_attack_lobby_cursor:
				0: bridge._begin_level_run(bridge._selected_level_index, true)
				1:
					bridge._selected_level_index = 0
					bridge.open_character_select(bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_BOSS if bridge._time_attack_boss_mode else bridge.CHARACTER_SELECT_CONTEXT_TIME_ATTACK_ZONE)
				2: bridge.open_course_select(bridge.TITLE_PHASE_TIME_ATTACK_LOBBY)
				3: bridge.open_title_screen_and_skip_intro()
			return
		bridge.TITLE_PHASE_COURSE_SELECT:
			if bridge.is_course_select_starting(): return
			if bridge.is_course_select_busy():
				if not bridge._is_multiplayer_course_select():
					bridge._course_select_confirm_pending = true
					bridge._title_notice_text = "COURSE LOCKED IN"
				bridge._status_text = bridge.get_title_prompt_text()
				return
			bridge._course_select_start_timer = bridge._course_select_start_duration
			bridge._title_notice_text = "STARTING %s" % bridge.get_selected_level_text()
			bridge._status_text = bridge.get_title_prompt_text()
			return
		bridge.TITLE_PHASE_TINY_CHAO_GARDEN:
			if bridge._title_menu_index == 0: bridge.open_tiny_chao_setup_menu(0, "TINY CHAO GARDEN READY")
			else: bridge.open_title_screen_at_single_player_menu(3)
			return
		bridge.TITLE_PHASE_MULTI_CONNECT:
			bridge.advance_multiplayer_link_state()
			if bridge.get_multiplayer_link_count() < 2:
				bridge._title_notice_text = "WAITING FOR %s LINK" % ["MULTI-PAK" if bridge._multiplayer_pak_mode == 0 else "SINGLE-PAK"]
			elif bridge._multiplayer_pak_mode == 0:
				bridge._open_multiplayer_outcome(0, bridge.TITLE_PHASE_MULTI_CONNECT)
			else:
				bridge._singlepak_download_timer = 0.0
				bridge._advance_singlepak_transfer_step()
			return
		bridge.TITLE_PHASE_MULTIPLAYER_OUTCOME:
			bridge._resolve_multiplayer_outcome()
			return
		bridge.TITLE_PHASE_SINGLEPAK_SYNC:
			match bridge._title_menu_index:
				0:
					if bridge.is_singlepak_sync_ready(): bridge._begin_level_run(bridge._selected_level_index, false, true)
					else: bridge.advance_singlepak_sync_state()
				1:
					if bridge.is_singlepak_sync_ready():
						bridge._prepare_multiplayer_results_snapshot(bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
						bridge.open_singlepak_results_screen(bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE, 0)
					else: bridge._title_notice_text = "CLIENTS STILL SYNCHRONIZING"
				2:
					if bridge.is_singlepak_transfer_started(): bridge._title_notice_text = "WAIT FOR CLIENT BOOT TO FINISH"
					else: bridge.open_title_screen_at_multiplayer_menu(1)
			return
		bridge.TITLE_PHASE_MULTIPLAYER_LOBBY:
			if bridge._multiplayer_lobby_waiting:
				bridge._title_notice_text = "WAITING FOR ALL LINKED PLAYERS"
			else:
				bridge._multiplayer_lobby_waiting = true
				bridge._multiplayer_lobby_wait_timer = bridge._multiplayer_lobby_wait_duration
				bridge._title_notice_text = "WAITING FOR REMATCH CONFIRMATIONS" if bridge._multiplayer_lobby_cursor == 0 else "WAITING FOR EXIT CONFIRMATIONS"
				bridge._status_text = bridge.get_title_prompt_text()
			return
		bridge.TITLE_PHASE_TINY_CHAO_SETUP:
			match bridge._title_menu_index:
				0:
					if bridge._tiny_chao_session_id == "TCG-0000": bridge._generate_tiny_chao_session_id()
					bridge.open_tiny_chao_garden_play()
				1:
					bridge._generate_tiny_chao_session_id()
					bridge._title_notice_text = "NEW SESSION ID READY"
				2: bridge.open_tiny_chao_garden_menu(0)
			return
	bridge._status_text = bridge.get_title_prompt_text()
