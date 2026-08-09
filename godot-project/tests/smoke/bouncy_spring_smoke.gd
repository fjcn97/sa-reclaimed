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
	var player = bridge.get_player_state()
	var bar = bridge._add_entity(bridge._level_state, bridge.ENTITY_BOUNCY_SPRING, 240.0, 300.0)
	bar.variant = 2
	bar.width = 120.0
	bar.height = 24.0
	player.world_x = 258.0
	player.world_y = 270.0
	player.is_grounded = false
	bridge._velocity_y = 480.0
	bridge._try_bouncy_spring(bar, 0.0)
	_check(bar.activated and bar.bouncy_landing_speed == 2 and bar.bouncy_launch_frame == 20, "falling speed selects the source bar compression")
	bridge._try_bouncy_spring(bar, 0.4)
	_check(not bar.activated and bridge._velocity_y < -540.0, "bar launches after its compression sequence")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	var spring = bridge._add_entity(bridge._level_state, bridge.ENTITY_BOUNCY_SPRING, 240.0, 300.0)
	spring.variant = 0
	spring.width = 42.0
	spring.height = 22.0
	player.world_x = 240.0
	player.world_y = 300.0
	bridge._velocity_y = 300.0
	bridge._try_bounce_from_spring(spring, 1.0 / 60.0)
	_check(bridge._velocity_y <= -450.0 and not player.is_grounded, "regular spring uses the source minimum launch speed")

	print("BOUNCY_SPRING_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("BOUNCY_SPRING_FAIL: " + label)
