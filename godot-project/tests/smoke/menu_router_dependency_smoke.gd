extends SceneTree

const MENU_INPUT_ROUTER := preload("res://scripts/core/MenuInputRouter.gd")

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = preload("res://scripts/CoreBridge.gd").new()
	bridge.name = "IsolatedBridge"
	get_root().add_child(bridge)
	var router := MENU_INPUT_ROUTER.new()
	bridge.open_title_screen_at_single_player_menu()
	bridge.advance_ui_timers(1.0)
	router.handle(bridge, bridge.DPAD_DOWN)
	_check(bridge.get_title_menu_index() == 1, "title router uses the injected bridge")
	router.handle(bridge, bridge.B_BUTTON)
	_check(bridge.is_play_mode_screen(), "title back transition uses the injected bridge")
	bridge._game_state = bridge.GAME_STATE_INTRO
	router.handle(bridge, bridge.A_BUTTON)
	_check(bridge._intro_timer <= 0.0, "system router uses the injected bridge")
	bridge.queue_free()
	print("MENU_ROUTER_DEPENDENCY_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MENU_ROUTER_DEPENDENCY_FAIL: " + label)
