extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var main := (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	get_root().add_child(main)
	_check(main.has_method("get_screen"), "Main scene exposes the composition registry")
	_check(main.get_node_or_null("ScreenStack") != null, "Main scene uses the packed screen stack")
	_check(main.has_screen("TitleScreen"), "Composition registry includes the title screen")
	_check(main.get_screen_count() >= 40, "Composition registry includes the full screen set")
	var bridge: Node = get_root().get_node_or_null("CoreBridge")
	_check(bridge != null, "Main scene keeps the CoreBridge autoload available")
	if bridge == null:
		quit(1)
		return
	bridge._player_profile_name = ["S", "O", "N", "I", "C", " "]
	bridge.open_title_screen_at_multiplayer_menu(0)
	bridge._multiplayer_mode_intro_timer = 0.0
	await process_frame
	_check(main.get_screen("MultiplayerModeScreen") != null, "Main scene contains the multiplayer mode screen")
	bridge.open_multiplayer_comm_screen(0)
	await process_frame
	_check(main.get_screen("MultiplayerCommScreen") != null, "Main scene contains the communication screen")
	bridge.open_multiplayer_outcome_screen(0, bridge.TITLE_PHASE_MULTI_CONNECT)
	await process_frame
	_check(main.get_screen("MultiplayerOutcomeScreen") != null, "Main scene contains the connection outcome screen")
	bridge.open_multiplayer_lobby_screen(0)
	await process_frame
	_check(main.get_screen("MultiplayerLobbyScreen") != null, "Main scene contains the rematch lobby screen")
	print("MULTIPLAYER_SCENE_CHECKS=%d" % checks)
	main.queue_free()
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MULTIPLAYER_SCENE_FAIL: " + label)
