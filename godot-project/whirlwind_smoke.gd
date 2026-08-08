extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = preload("res://scripts/CoreBridge.gd").new()
	bridge.name = "CoreBridge"
	get_root().add_child(bridge)
	bridge.init_level(1, false, false)
	var whirlwind = bridge._add_entity(bridge._level_state, bridge.ENTITY_WHIRLWIND, 300.0, 300.0)
	whirlwind.width = 128.0
	whirlwind.height = 128.0
	var player = bridge.get_player_state()
	player.world_x = 330.0
	player.world_y = 300.0
	player.is_grounded = true
	bridge._try_whirlwind(whirlwind, 1.0 / 60.0)
	_check(whirlwind.whirlwind_active, "Whirlwind enters its scripted active state")
	_check(player.char_state == 3 and not player.is_grounded, "Whirlwind applies its in-current character state")
	var before_y: float = player.world_y
	for _frame in range(8):
		bridge._try_whirlwind(whirlwind, 1.0 / 60.0)
	_check(player.world_x < 330.0 and player.world_y < before_y, "Whirlwind pulls the player toward its center and upward")
	for _frame in range(70):
		bridge._try_whirlwind(whirlwind, 1.0 / 60.0)
	_check(not whirlwind.whirlwind_active, "Whirlwind releases after the source bounded cycle")
	_check(player.char_state == 2 and bridge._velocity_y < 0.0, "Whirlwind release leaves the player airborne")
	bridge._try_whirlwind(whirlwind, 1.0 / 60.0)
	_check(not whirlwind.whirlwind_active, "Whirlwind does not immediately recapture after release")

	player.world_x = 500.0
	player.world_y = 300.0
	whirlwind.whirlwind_active = false
	bridge._try_whirlwind(whirlwind, 1.0 / 60.0)
	_check(not whirlwind.whirlwind_active, "Whirlwind ignores players outside its hitbox")
	player.world_x = 330.0
	bridge._try_whirlwind(whirlwind, 1.0 / 60.0)
	_check(whirlwind.whirlwind_active, "Whirlwind can be re-entered after leaving its current")

	print("WHIRLWIND_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("WHIRLWIND_FAIL: " + label)
