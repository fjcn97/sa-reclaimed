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
	var block = bridge._add_entity(bridge._level_state, bridge.ENTITY_NOTE_BLOCK, 240.0, 300.0)
	block.note_block = true
	block.note_kind = 4
	block.note_health = 3
	player.world_x = 240.0
	player.world_y = 270.0
	bridge._try_note_block(block)
	_check(block.note_health == 2 and block.note_timer > 0.0 and bridge._velocity_y == -360.0, "note block uses its typed bounce speed")
	bridge._update_note_state(4.0 / 60.0)
	_check(not block.activated and block.active, "note block returns to idle after its four-frame bounce")
	bridge._try_note_block(block)
	bridge._update_note_state(4.0 / 60.0)
	bridge._try_note_block(block)
	bridge._update_note_state(4.0 / 60.0)
	_check(block.note_health == 0 and not block.active, "note block despawns after three impacts")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	var sphere = bridge._add_entity(bridge._level_state, bridge.ENTITY_NOTE_SPHERE, 240.0, 300.0)
	sphere.note_sphere = true
	sphere.note_kind = 7
	player.world_x = 260.0
	player.world_y = 290.0
	player.speed_x = -120.0
	bridge._velocity_y = 0.0
	bridge._try_note_sphere(sphere)
	_check(sphere.note_timer > 0.0 and player.speed_x > 0.0 and bridge._velocity_y < 0.0, "note sphere redirects the player away with typed speed")
	bridge._update_note_state(1.0 / 60.0)
	_check(sphere.note_offset_x != 0.0 or sphere.note_offset_y != 0.0, "note sphere vibrates during its six-frame response")

	print("NOTE_INTERACTIONS_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("NOTE_INTERACTIONS_FAIL: " + label)
