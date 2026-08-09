extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	# Load after the deferred autoload phase so scene scripts can resolve the
	# CoreBridge singleton exactly as they do from the normal project entrypoint.
	var main_scene: PackedScene = load("res://scenes/Main.tscn")
	var main := main_scene.instantiate()
	get_root().add_child(main)
	var source_to_scene := {
		"character_select.c": "CharacterSelectScreen",
		"countdown.c": "IntroScreen",
		"course_select.c": "CourseSelectScreen",
		"game_over.c": "GameOverScreen",
		"multiplayer_lobby.c": "MultiplayerLobbyScreen",
		"stage_intro.c": "IntroScreen",
		"stage_results.c": "ClearScreen",
		"time_attack_lobby.c": "TimeAttackLobbyScreen",
		"time_attack_mode_select.c": "TimeAttackModeScreen",
		"time_attack_results.c": "TimeAttackResultsScreen",
		"options_screen.c": "OptionsMainScreen",
		"save.c": "PlayerDataScreen",
		"sound_test.c": "SoundTestScreen",
		"title_screen.c": "TitleScreen"
	}
	for source_name in source_to_scene:
		var scene_name := str(source_to_scene[source_name])
		_check(main.get_screen(scene_name) != null, "%s maps to %s" % [source_name, scene_name])
	print("UI_SOURCE_COVERAGE_CHECKS=%d" % checks)
	main.queue_free()
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("UI_SOURCE_COVERAGE_FAIL: " + label)
