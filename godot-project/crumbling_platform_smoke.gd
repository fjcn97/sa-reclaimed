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
	bridge.init_level(0, false)
	bridge._add_crumbling_platform(bridge._level_state, 240.0, 300.0, 256.0, 16.0, 31.0 / 60.0)
	var platform = bridge._level_state.platforms.back()
	bridge._start_crumbling_platform(platform)
	_check(platform.crumble_phase == 1 and platform.active, "landing starts the warning phase")
	bridge._update_platform_motion(31.0 / 60.0)
	bridge._update_platform_motion(0.01)
	_check(platform.crumble_phase == 2 and platform.active, "platform remains during the breakup phase")
	bridge._update_platform_motion(32.0 / 60.0)
	_check(platform.crumble_phase == 3 and not platform.active, "platform disappears after breakup completes")

	print("CRUMBLING_PLATFORM_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CRUMBLING_PLATFORM_FAIL: " + label)
