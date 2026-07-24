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
	bridge.init_level(1, false, false)

	var propeller = bridge._add_entity(bridge._level_state, bridge.ENTITY_PROPELLER, 300.0, 300.0)
	propeller.world_x = 300.0
	propeller.world_y = 300.0
	propeller.width = 148.0
	propeller.height = 128.0
	propeller.variant = 0
	var player = bridge.get_player_state()
	player.world_x = 300.0
	player.world_y = 300.0
	bridge._try_propeller(propeller, 0, 1.0 / 60.0)
	_check(propeller.variant == 1, "Propeller enters its source floating state")

	for _frame in range(13):
		bridge._try_propeller(propeller, 0, 1.0 / 60.0)
	_check(is_equal_approx(player.world_y, 252.0) and propeller.variant == 2, "Propeller lifts the player to 48 pixels above its origin")

	var before_x: float = player.world_x
	bridge._try_propeller(propeller, bridge.DPAD_RIGHT, 1.0 / 60.0)
	_check(propeller.propeller_horizontal_step > 0.0 and player.world_x > before_x, "Propeller allows source horizontal steering")

	player.world_x = 500.0
	bridge._try_propeller(propeller, 0, 1.0 / 60.0)
	_check(propeller.variant == 0, "Propeller releases the player after leaving its air current")

	print("PROPELLER_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("PROPELLER_FAIL: " + label)
