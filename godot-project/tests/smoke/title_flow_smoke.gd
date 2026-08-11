extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node_or_null("CoreBridge")
	if bridge == null:
		bridge = preload("res://scripts/CoreBridge.gd").new()
		bridge.name = "CoreBridge"
		get_root().add_child(bridge)
	bridge.reset_to_title()
	# Smoke tests share the project's persisted profile directory, so establish
	# the locale required by the first source-logo assertion explicitly.
	bridge._language_index = 1
	bridge.open_press_start_screen()
	_check(bridge.get_title_logo_source_tilemap() == "sa2_logo_en", "English title uses original logo")
	bridge._language_index = 0
	_check(bridge.get_title_logo_source_tilemap() == "sa2_title_logo_jp", "Japanese title uses original logo")
	bridge._language_index = 1
	bridge._open_boot_intro()
	_check(bridge.get_sega_logo_source_tilemap() == "intro_presented_by_sega", "Sega boot uses original source card")
	bridge.skip_sega_logo()
	_check(bridge.is_press_start_screen(), "Sega skip returns to title")
	bridge._boot_intro_pending = true
	bridge._open_sonic_team_logo()
	_check(bridge.is_sonic_team_logo_screen(), "automatic boot transition enters Sonic Team card")
	_check(bridge.get_sonic_team_logo_source_tilemap() == "intro_created_by_sonic_team", "Sonic Team boot uses original source card")
	bridge.skip_sonic_team_logo()
	_check(bridge.is_press_start_screen(), "Sonic Team skip returns to title")
	bridge.start_title_selection()
	_check(bridge.is_play_mode_screen(), "modern A confirm starts title flow")
	bridge.advance_ui_timers(0.5)
	bridge.move_title_selection(1)
	bridge.start_title_selection()
	_check(bridge.is_multiplayer_mode_screen(), "play mode reaches multiplayer")
	_check(bridge.get_multiplayer_mode_intro_progress() == 0.0, "multiplayer intro starts closed")
	bridge.advance_ui_timers(16.0 / 60.0)
	_check(bridge.get_multiplayer_mode_intro_progress() > 0.0 and bridge.get_multiplayer_mode_intro_progress() < 1.0, "multiplayer intro advances")
	bridge.skip_multiplayer_mode_intro()
	bridge.advance_ui_timers(32.0 / 60.0)
	_check(bridge.is_multiplayer_mode_input_ready(), "multiplayer intro accepts input after sweep")
	bridge.open_title_screen_at_play_mode_menu()
	bridge.move_title_selection(1)
	_check(bridge.get_title_menu_index() == 1, "play mode toggles once for vertical input")
	bridge._language_index = 2
	_check(bridge.get_play_mode_prompt_text() == "SPIELART AUSWAEHLEN", "play mode prompt follows localization")
	_check(bridge.get_title_prompt_text().contains("AUSWAEHLEN"), "title navigation prompt follows localization")
	_check(bridge.get_press_start_subtitle_text() == "HOCHGESCHWINDIGKEIT", "press start subtitle follows localization")
	bridge.open_title_screen_at_play_mode_menu(0, "COURSE LOCKED IN")
	_check(bridge.get_play_mode_prompt_text() == "KURS FESTGELEGT", "title notices follow localization")
	bridge.open_title_screen_at_play_mode_menu(0, "STARTING SKY CANYON")
	_check(bridge.get_play_mode_prompt_text() == "STARTET SKY CANYON", "dynamic title notices follow localization")
	bridge.open_title_screen_at_play_mode_menu(0, "PROFILE SAVED")
	_check(bridge.get_play_mode_prompt_text() == "PROFIL GESPEICHERT", "save notices follow localization")
	bridge._language_index = 1
	bridge.open_title_screen_at_play_mode_menu()
	bridge.open_save_options_from_title()
	_check(bridge.is_press_start_screen(), "play mode B returns to press start")
	bridge.open_title_screen_at_play_mode_menu()
	bridge.start_title_selection()
	_check(bridge.is_single_player_menu_screen(), "play mode reaches single player")
	var single_player_language: int = bridge._language_index
	bridge._language_index = 2
	var single_player_rows: Array = bridge.get_single_player_rows()
	_check(single_player_rows[0]["description"] == "DAS HAUPTABENTEUER STARTEN", "single player description follows localization")
	_check(single_player_rows[2]["status"] == "EINSTELLUNGEN" and bool(single_player_rows[2].get("available", false)), "single player options state is localized and semantic")
	bridge._language_index = single_player_language
	var controller: Node = get_root().get_node_or_null("Main/PlayerController")
	if controller == null:
		change_scene_to_file("res://scenes/Main.tscn")
		await scene_changed
		controller = get_root().get_node_or_null("Main/PlayerController")
	_check(controller != null, "main scene exposes the menu input controller")
	if controller != null:
		controller._handle_menu_input(bridge.A_BUTTON | bridge.B_BUTTON)
	_check(bridge.is_play_mode_screen(), "single player prioritizes B over A")
	bridge.open_title_screen_at_single_player_menu()
	bridge.open_save_options_from_title()
	_check(bridge.is_play_mode_screen(), "single player B returns to play mode")
	bridge.open_title_screen_at_single_player_menu()
	bridge.advance_ui_timers(0.5)
	bridge.move_title_selection(1)
	bridge.move_title_selection(1)
	bridge.start_title_selection()
	_check(bridge.is_save_options(), "single player options route remains reachable")
	bridge.open_press_start_screen()
	bridge.advance_ui_timers(15.0 - 1.0 / 60.0)
	_check(bridge.is_press_start_screen(), "press start waits for the full idle interval")
	bridge.advance_ui_timers(1.0 / 60.0)
	_check(bridge.is_demo_mode(), "press start launches the source demo after 15 seconds")
	bridge.open_title_screen_at_time_attack_menu()
	_check(bridge.get_time_attack_mode_intro_progress() == 0.0, "time attack intro starts closed")
	bridge.advance_ui_timers(16.0 / 60.0)
	_check(bridge.get_time_attack_mode_intro_progress() > 0.0 and bridge.get_time_attack_mode_intro_progress() < 1.0, "time attack intro advances")
	bridge.skip_time_attack_mode_intro()
	bridge.advance_ui_timers(32.0 / 60.0)
	_check(bridge.is_time_attack_mode_input_ready(), "time attack intro accepts input after sweep")
	bridge._selected_character_index = 3
	bridge._title_menu_index = 0
	bridge.start_title_selection()
	_check(bridge.is_character_select() and bridge.get_character_menu_index() == 0, "time attack mode starts character select at Sonic")
	bridge.open_title_screen_and_skip_intro()
	print("TITLE_FLOW_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("TITLE_FLOW_FAIL: " + label)
