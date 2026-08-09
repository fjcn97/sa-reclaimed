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
	block.note_kind = 2
	block.note_health = 3
	player.world_x = 240.0
	player.world_y = 284.0
	player.is_grounded = false
	bridge._try_note_block(block)
	_check(_count_particles(bridge) == 2, "note block creates two particles")
	bridge._update_note_particle_state(5.0 / 60.0)
	_check(_count_active_particles(bridge) == 2, "particles become visible after source delay")
	bridge._update_note_particle_state(0.5)
	_check(_count_active_particles(bridge) == 0, "particles expire after their source lifetime")
	var sphere = bridge._add_entity(bridge._level_state, bridge.ENTITY_NOTE_SPHERE, 320.0, 300.0)
	sphere.note_sphere = true
	sphere.note_kind = 4
	player.world_x = 320.0
	player.world_y = 300.0
	player.speed_x = 120.0
	bridge._try_note_sphere(sphere)
	_check(_count_particles(bridge) == 4, "note sphere also creates two particles")
	print("NOTE_PARTICLE_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _count_particles(bridge: Node) -> int:
	var count := 0
	for entity in bridge._level_state.entities:
		if entity.note_particle:
			count += 1
	return count

func _count_active_particles(bridge: Node) -> int:
	var count := 0
	for entity in bridge._level_state.entities:
		if entity.note_particle and entity.active:
			count += 1
	return count

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("NOTE_PARTICLE_FAIL: " + label)
