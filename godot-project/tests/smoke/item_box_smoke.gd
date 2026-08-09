extends SceneTree

var checks := 0
var failed := false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = preload("res://scripts/CoreBridge.gd").new()
	bridge.name = "CoreBridge"
	get_root().add_child(bridge)
	bridge.init_level(1, false, false)

	_check(bridge._source_item_kind("SHIELD_MAGNETIC") == bridge.ITEM_BOX_KIND_MAGNETIC_SHIELD, "Maps magnetic shield source kind")
	_check(bridge._source_item_kind("SPEED_UP") == bridge.ITEM_BOX_KIND_SPEED_UP, "Maps speed-up source kind")

	var item = bridge._add_entity(bridge._level_state, bridge.ENTITY_ITEM_BOX, 200.0, 200.0)
	var player = bridge.get_player_state()
	player.world_x = 200.0
	player.world_y = 220.0
	bridge._apply_item_box_effect(item)
	_check(player.rings == 1, "Default item box grants its ring payload")

	item.item_kind = bridge.ITEM_BOX_KIND_SPEED_UP
	bridge._apply_item_box_effect(item)
	_check(bridge._speed_up_timer > 0.0, "Speed-up item starts its timer")
	_check(bridge.is_player_speed_up_active(), "Speed-up state is exposed to visuals")
	item.item_kind = bridge.ITEM_BOX_KIND_INVINCIBILITY
	bridge._apply_item_box_effect(item)
	_check(bridge.is_player_invincible(), "Invincibility state is exposed to visuals")

	item.item_kind = bridge.ITEM_BOX_KIND_MAGNETIC_SHIELD
	bridge._apply_item_box_effect(item)
	_check(player.shielded and bridge._magnetic_shielded, "Magnetic shield enables both shield states")
	_check(bridge.is_player_magnetic_shielded(), "Magnetic shield state is exposed to visuals")

	print("ITEM_BOX_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("ITEM_BOX_FAIL: " + label)
