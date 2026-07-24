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
	var slope = bridge._add_entity(bridge._level_state, bridge.ENTITY_CEILING_SLOPE, 240.0, 300.0)
	slope.ceiling_slope = true
	slope.ceiling_slope_variant = 0
	slope.width = 120.0
	slope.height = 80.0
	player.world_x = 240.0
	player.world_y = 320.0
	player.is_grounded = false
	bridge._velocity_y = -180.0
	bridge._try_ceiling_slope(slope)
	_check(slope.ceiling_slope_latched and slope.activated, "ascending player enters ceiling slope")
	_check(player.rotation == -8, "variant A applies the original slope rotation")
	bridge._try_ceiling_slope(slope)
	_check(slope.ceiling_slope_latched, "slope stays latched while player remains inside")

	player.world_x = 500.0
	bridge._update_ceiling_slope_state(0.1)
	_check(not slope.ceiling_slope_latched and not slope.activated, "leaving the rectangle clears the source latch")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	slope = bridge._add_entity(bridge._level_state, bridge.ENTITY_CEILING_SLOPE, 240.0, 300.0)
	slope.ceiling_slope = true
	slope.ceiling_slope_variant = 1
	slope.width = 120.0
	slope.height = 80.0
	player.world_x = 240.0
	player.world_y = 320.0
	player.is_grounded = false
	bridge._velocity_y = 80.0
	bridge._try_ceiling_slope(slope)
	_check(not slope.ceiling_slope_latched, "descending player does not enter slope")

	print("CEILING_SLOPE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CEILING_SLOPE_FAIL: " + label)
