class_name TitleTransitionFlow
extends RefCounted

## Creates title-front-end states. CoreBridge keeps the public API so scenes
## and smoke tests do not depend on the flow implementation.

static func open_press_start(bridge: Object, notice_text: String) -> void:
	bridge.reset_to_title()
	bridge._title_notice_text = notice_text
	bridge._status_text = bridge.get_title_prompt_text()

static func open_menu(bridge: Object, phase: int, selected_index: int, notice_text: String, intro_duration: float = 0.0) -> void:
	bridge.reset_to_title()
	bridge._title_phase = phase
	bridge._title_menu_index = clampi(selected_index, 0, max(bridge.get_title_menu_items().size() - 1, 0))
	if phase == bridge.TITLE_PHASE_PLAY_MODE:
		bridge._play_mode_intro_timer = intro_duration
	elif phase == bridge.TITLE_PHASE_SINGLE_PLAYER:
		bridge._single_player_intro_timer = intro_duration
	elif phase == bridge.TITLE_PHASE_MULTI_PLAYER:
		bridge._multiplayer_mode_intro_timer = intro_duration
	elif phase == bridge.TITLE_PHASE_TIME_ATTACK:
		bridge._time_attack_mode_intro_timer = intro_duration
	bridge._title_notice_text = notice_text
	bridge._status_text = bridge.get_title_prompt_text()

static func open_tiny_chao_menu(bridge: Object, phase: int, selected_index: int, notice_text: String) -> void:
	bridge._game_state = bridge.GAME_STATE_TITLE
	bridge._title_phase = phase
	bridge._title_menu_index = clampi(selected_index, 0, max(bridge.get_title_menu_items().size() - 1, 0))
	bridge._title_notice_text = notice_text
	bridge._status_text = bridge.get_title_prompt_text()

static func open_tiny_chao_play(bridge: Object) -> void:
	bridge._game_state = bridge.GAME_STATE_TITLE
	bridge._title_phase = bridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY
	bridge._title_menu_index = 0
	bridge._title_notice_text = ""
	bridge._tiny_chao_play_x = 0.0
	bridge._tiny_chao_play_y = 0.0
	bridge._tiny_chao_action_text = "WELCOME TO THE GARDEN"
	bridge._tiny_chao_selected_index = clampi(bridge._tiny_chao_selected_index, 0, bridge._tiny_chao_roster.size() - 1)
	bridge._sync_tiny_chao_selection()
	bridge._status_text = "LEFT/RIGHT MOVE   A CARE   B EXIT"

static func open_singlepak_results(bridge: Object, result_mode: int, cursor: int, notice_text: String) -> void:
	bridge._game_state = bridge.GAME_STATE_TITLE
	bridge._multiplayer_result_mode = clampi(result_mode, bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION, bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
	bridge._title_phase = bridge.TITLE_PHASE_SINGLEPAK_RESULTS
	bridge._singlepak_results_cursor = clampi(cursor, 0, max(bridge.get_singlepak_results_items().size() - 1, 0))
	bridge._singlepak_results_timer = bridge._singlepak_results_character_duration if bridge._multiplayer_result_mode == bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION else bridge._singlepak_results_course_duration
	bridge._title_notice_text = notice_text
	bridge._status_text = bridge.get_title_prompt_text()

static func open_multiplayer_lobby(bridge: Object, cursor: int, notice_text: String) -> void:
	bridge._game_state = bridge.GAME_STATE_TITLE
	bridge._title_phase = bridge.TITLE_PHASE_MULTIPLAYER_LOBBY
	bridge._multiplayer_lobby_cursor = clampi(cursor, 0, max(bridge.get_multiplayer_lobby_items().size() - 1, 0))
	bridge._multiplayer_lobby_waiting = false
	bridge._multiplayer_lobby_wait_timer = 0.0
	bridge._multiplayer_lobby_exit_timer = 0.0
	bridge._title_notice_text = notice_text
	bridge._status_text = bridge.get_title_prompt_text()

static func open_multiplayer_comm(bridge: Object, pak_mode: int, cursor: int, notice_text: String) -> void:
	bridge._game_state = bridge.GAME_STATE_TITLE
	bridge._multiplayer_pak_mode = clampi(pak_mode, 0, 1)
	bridge._multiplayer_disconnect_timer = 0.0
	bridge._title_phase = bridge.TITLE_PHASE_MULTI_CONNECT
	bridge._title_menu_index = clampi(cursor, 0, max(bridge.get_title_menu_items().size() - 1, 0))
	bridge._title_notice_text = notice_text
	bridge._status_text = bridge.get_title_prompt_text()

static func open_singlepak_sync(bridge: Object, cursor: int, notice_text: String) -> void:
	bridge._game_state = bridge.GAME_STATE_TITLE
	bridge._title_phase = bridge.TITLE_PHASE_SINGLEPAK_SYNC
	bridge._title_menu_index = clampi(cursor, 0, max(bridge.get_title_menu_items().size() - 1, 0))
	bridge._title_notice_text = notice_text
	bridge._status_text = bridge.get_title_prompt_text()

static func open_multiplayer_outcome(bridge: Object, outcome: int, return_phase: int, notice_text: String) -> void:
	bridge._game_state = bridge.GAME_STATE_TITLE
	bridge._multiplayer_outcome_type = clampi(outcome, 0, 1)
	bridge._multiplayer_outcome_return_phase = return_phase
	bridge._multiplayer_outcome_timer = bridge._multiplayer_outcome_duration
	bridge._title_phase = bridge.TITLE_PHASE_MULTIPLAYER_OUTCOME
	bridge._title_menu_index = 0
	bridge._title_notice_text = notice_text
	bridge._status_text = bridge.get_title_prompt_text()

static func open_course_select(bridge: Object, return_phase: int, notice_text: String, unlock_cutscene: bool) -> void:
	bridge._game_state = bridge.GAME_STATE_TITLE
	bridge._course_select_return_phase = return_phase
	bridge._title_phase = bridge.TITLE_PHASE_COURSE_SELECT
	bridge._course_select_travel_timer = 0.0
	bridge._course_select_settle_timer = 0.0
	bridge._course_select_confirm_pending = false
	bridge._course_select_unlock_phase = bridge.COURSE_UNLOCK_PHASE_PATH
	bridge._course_select_unlock_phase_timer = 0.0
	bridge._course_select_unlock_phase_duration = 0.0
	bridge._course_select_unlock_timer = 0.0
	bridge._course_select_intro_timer = bridge._course_select_intro_duration
	if unlock_cutscene: bridge._start_course_select_unlock_cutscene()
	bridge._course_select_start_timer = 0.0
	bridge._course_select_from_index = bridge._selected_level_index
	bridge._course_select_to_index = bridge._selected_level_index
	bridge._title_notice_text = notice_text if not notice_text.is_empty() else "COURSE READY: %s" % bridge.get_selected_level_text()
	bridge._status_text = bridge.get_title_prompt_text()

static func return_from_course_select(bridge: Object, notice_text: String) -> void:
	bridge._title_notice_text = notice_text
	match bridge._course_select_return_phase:
		bridge.TITLE_PHASE_PRESS_START: bridge.open_press_start_screen(notice_text)
		bridge.TITLE_PHASE_PLAY_MODE: bridge.open_title_screen_at_play_mode_menu(0, notice_text)
		bridge.TITLE_PHASE_SINGLE_PLAYER: bridge.open_title_screen_at_single_player_menu(0, notice_text)
		bridge.TITLE_PHASE_MULTI_PLAYER: bridge.open_title_screen_at_multiplayer_menu(bridge._multiplayer_pak_mode, notice_text)
		bridge.TITLE_PHASE_TIME_ATTACK: bridge.open_title_screen_at_time_attack_menu(1 if bridge._time_attack_boss_mode else 0, notice_text)
		bridge.TITLE_PHASE_SINGLEPAK_RESULTS: bridge.open_singlepak_results_screen(bridge._multiplayer_result_mode, 0, notice_text)
		bridge.TITLE_PHASE_TIME_ATTACK_LOBBY:
			bridge.open_time_attack_lobby(bridge._time_attack_boss_mode)
			bridge._title_notice_text = notice_text
			bridge._status_text = bridge.get_title_prompt_text()
		bridge.TITLE_PHASE_MULTI_CONNECT: bridge.open_multiplayer_comm_screen(bridge._multiplayer_pak_mode, bridge._title_menu_index, notice_text)
		bridge.TITLE_PHASE_SINGLEPAK_SYNC: bridge.open_singlepak_sync_screen(bridge._title_menu_index, notice_text)
		bridge.TITLE_PHASE_TINY_CHAO_GARDEN: bridge.open_tiny_chao_garden_menu(0, notice_text)
		bridge.TITLE_PHASE_TINY_CHAO_SETUP: bridge.open_tiny_chao_setup_menu(0, notice_text)
		_: bridge.open_press_start_screen(notice_text)
