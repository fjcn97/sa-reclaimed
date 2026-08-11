class_name TitleTransitionFlow
extends RefCounted

## Creates title-front-end states. CoreBridge keeps the public API so scenes
## and smoke tests do not depend on the flow implementation.

static func open_press_start(bridge: Object, notice_text: String) -> void:
	bridge.reset_to_title()
	bridge.get_title_navigation_state().notice_text = notice_text
	bridge.set_status_text(bridge.get_title_prompt_text())

static func open_menu(bridge: Object, phase: int, selected_index: int, notice_text: String, intro_duration: float = 0.0) -> void:
	bridge.reset_to_title()
	var title_navigation = bridge.get_title_navigation_state()
	title_navigation.phase = phase
	title_navigation.menu_index = clampi(selected_index, 0, max(bridge.get_title_menu_items().size() - 1, 0))
	if phase == bridge.TITLE_PHASE_PLAY_MODE:
		bridge.get_frontend_intro_state().start("play_mode", intro_duration)
	elif phase == bridge.TITLE_PHASE_SINGLE_PLAYER:
		bridge.get_frontend_intro_state().start("single_player", intro_duration)
	elif phase == bridge.TITLE_PHASE_MULTI_PLAYER:
		bridge.get_frontend_intro_state().start("multiplayer_mode", intro_duration)
	elif phase == bridge.TITLE_PHASE_TIME_ATTACK:
		bridge.get_frontend_intro_state().start("time_attack_mode", intro_duration)
	title_navigation.notice_text = notice_text
	bridge.set_status_text(bridge.get_title_prompt_text())

static func open_tiny_chao_menu(bridge: Object, phase: int, selected_index: int, notice_text: String) -> void:
	bridge.set_game_state(bridge.GAME_STATE_TITLE)
	var title_navigation = bridge.get_title_navigation_state()
	title_navigation.phase = phase
	title_navigation.menu_index = clampi(selected_index, 0, max(bridge.get_title_menu_items().size() - 1, 0))
	title_navigation.notice_text = notice_text
	bridge.set_status_text(bridge.get_title_prompt_text())

static func open_tiny_chao_play(bridge: Object) -> void:
	bridge.set_game_state(bridge.GAME_STATE_TITLE)
	var title_navigation = bridge.get_title_navigation_state()
	title_navigation.phase = bridge.TITLE_PHASE_TINY_CHAO_GARDEN_PLAY
	title_navigation.menu_index = 0
	title_navigation.notice_text = ""
	bridge.get_tiny_chao_state().begin_play()
	bridge.sync_tiny_chao_selection()
	bridge.set_status_text("LEFT/RIGHT MOVE   A CARE   B EXIT")

static func open_singlepak_results(bridge: Object, result_mode: int, cursor: int, notice_text: String) -> void:
	bridge.set_game_state(bridge.GAME_STATE_TITLE)
	var multiplayer = bridge.get_multiplayer_frontend_state()
	multiplayer.result_mode = clampi(result_mode, bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION, bridge.MULTIPLAYER_RESULTS_MODE_COURSE_COMPLETE)
	bridge.get_title_navigation_state().phase = bridge.TITLE_PHASE_SINGLEPAK_RESULTS
	multiplayer.results_cursor = clampi(cursor, 0, max(bridge.get_singlepak_results_items().size() - 1, 0))
	multiplayer.results_timer = multiplayer.results_character_duration if multiplayer.result_mode == bridge.MULTIPLAYER_RESULTS_MODE_CHARACTER_SELECTION else multiplayer.results_course_duration
	bridge.get_title_navigation_state().notice_text = notice_text
	bridge.set_status_text(bridge.get_title_prompt_text())

static func open_multiplayer_lobby(bridge: Object, cursor: int, notice_text: String) -> void:
	bridge.set_game_state(bridge.GAME_STATE_TITLE)
	bridge.get_title_navigation_state().phase = bridge.TITLE_PHASE_MULTIPLAYER_LOBBY
	bridge.get_multiplayer_lobby_state().open_lobby(cursor, bridge.get_multiplayer_lobby_items().size())
	bridge.get_title_navigation_state().notice_text = notice_text
	bridge.set_status_text(bridge.get_title_prompt_text())

static func open_multiplayer_comm(bridge: Object, pak_mode: int, cursor: int, notice_text: String) -> void:
	bridge.set_game_state(bridge.GAME_STATE_TITLE)
	var multiplayer = bridge.get_multiplayer_frontend_state()
	multiplayer.pak_mode = clampi(pak_mode, 0, 1)
	multiplayer.disconnect_timer = 0.0
	var title_navigation = bridge.get_title_navigation_state()
	title_navigation.phase = bridge.TITLE_PHASE_MULTI_CONNECT
	title_navigation.menu_index = clampi(cursor, 0, max(bridge.get_title_menu_items().size() - 1, 0))
	title_navigation.notice_text = notice_text
	bridge.set_status_text(bridge.get_title_prompt_text())

static func open_singlepak_sync(bridge: Object, cursor: int, notice_text: String) -> void:
	bridge.set_game_state(bridge.GAME_STATE_TITLE)
	var title_navigation = bridge.get_title_navigation_state()
	title_navigation.phase = bridge.TITLE_PHASE_SINGLEPAK_SYNC
	title_navigation.menu_index = clampi(cursor, 0, max(bridge.get_title_menu_items().size() - 1, 0))
	title_navigation.notice_text = notice_text
	bridge.set_status_text(bridge.get_title_prompt_text())

static func open_multiplayer_outcome(bridge: Object, outcome: int, return_phase: int, notice_text: String) -> void:
	bridge.set_game_state(bridge.GAME_STATE_TITLE)
	bridge.get_multiplayer_lobby_state().open_outcome(outcome, return_phase)
	var title_navigation = bridge.get_title_navigation_state()
	title_navigation.phase = bridge.TITLE_PHASE_MULTIPLAYER_OUTCOME
	title_navigation.menu_index = 0
	title_navigation.notice_text = notice_text
	bridge.set_status_text(bridge.get_title_prompt_text())

static func open_course_select(bridge: Object, return_phase: int, notice_text: String, unlock_cutscene: bool) -> void:
	bridge.set_game_state(bridge.GAME_STATE_TITLE)
	bridge.get_title_navigation_state().phase = bridge.TITLE_PHASE_COURSE_SELECT
	bridge.get_course_select_travel_state().reset(bridge.get_selected_level_index())
	bridge.get_course_select_presentation_state().open(return_phase)
	bridge.get_course_select_unlock_flow().reset()
	if unlock_cutscene: bridge.start_course_select_unlock_cutscene()
	bridge.get_title_navigation_state().notice_text = notice_text if not notice_text.is_empty() else "COURSE READY: %s" % bridge.get_selected_level_text()
	bridge.set_status_text(bridge.get_title_prompt_text())

static func return_from_course_select(bridge: Object, notice_text: String) -> void:
	var multiplayer = bridge.get_multiplayer_frontend_state()
	bridge.get_title_navigation_state().notice_text = notice_text
	match bridge.get_course_select_presentation_state().return_phase:
		bridge.TITLE_PHASE_PRESS_START: bridge.open_press_start_screen(notice_text)
		bridge.TITLE_PHASE_PLAY_MODE: bridge.open_title_screen_at_play_mode_menu(0, notice_text)
		bridge.TITLE_PHASE_SINGLE_PLAYER: bridge.open_title_screen_at_single_player_menu(0, notice_text)
		bridge.TITLE_PHASE_MULTI_PLAYER: bridge.open_title_screen_at_multiplayer_menu(multiplayer.pak_mode, notice_text)
		bridge.TITLE_PHASE_TIME_ATTACK: bridge.open_title_screen_at_time_attack_menu(1 if bridge.get_time_attack_session_state().boss_mode else 0, notice_text)
		bridge.TITLE_PHASE_SINGLEPAK_RESULTS: bridge.open_singlepak_results_screen(multiplayer.result_mode, 0, notice_text)
		bridge.TITLE_PHASE_TIME_ATTACK_LOBBY:
			bridge.open_time_attack_lobby(bridge.get_time_attack_session_state().boss_mode)
			bridge.get_title_navigation_state().notice_text = notice_text
			bridge.set_status_text(bridge.get_title_prompt_text())
		bridge.TITLE_PHASE_MULTI_CONNECT: bridge.open_multiplayer_comm_screen(multiplayer.pak_mode, bridge.get_title_navigation_state().menu_index, notice_text)
		bridge.TITLE_PHASE_SINGLEPAK_SYNC: bridge.open_singlepak_sync_screen(bridge.get_title_navigation_state().menu_index, notice_text)
		bridge.TITLE_PHASE_TINY_CHAO_GARDEN: bridge.open_tiny_chao_garden_menu(0, notice_text)
		bridge.TITLE_PHASE_TINY_CHAO_SETUP: bridge.open_tiny_chao_setup_menu(0, notice_text)
		_: bridge.open_press_start_screen(notice_text)
