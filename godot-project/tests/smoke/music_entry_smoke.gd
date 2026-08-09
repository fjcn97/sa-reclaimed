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
	var pipe = bridge._add_entity(bridge._level_state, bridge.ENTITY_MUSIC_ENTRY, 240.0, 300.0)
	pipe.music_entry = true
	pipe.music_entry_pipe = true
	pipe.music_entry_kind = 1
	pipe.music_entry_duration = bridge._music_entry_duration(true, 1)
	player.world_x = 240.0
	player.world_y = 300.0
	bridge._try_music_entry(pipe)
	_check(pipe.music_entry_timer > 0.0 and player.char_state == 8, "pipe entry starts the scripted sequence")
	bridge._update_music_entry_state(0.4)
	_check(player.world_x != 240.0 and pipe.music_entry_timer > 0.0, "pipe sequence moves the player before its exit")
	bridge._update_music_entry_state(0.8)
	_check(pipe.music_entry_timer == 0.0 and bridge._velocity_y == -720.0, "pipe kind one uses the source exit speed")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	var horn = bridge._add_entity(bridge._level_state, bridge.ENTITY_MUSIC_ENTRY, 240.0, 300.0)
	horn.music_entry = true
	horn.music_entry_pipe = false
	horn.music_entry_kind = 2
	horn.music_entry_duration = bridge._music_entry_duration(false, 2)
	player.world_x = 240.0
	player.world_y = 300.0
	bridge._try_music_entry(horn)
	bridge._update_music_entry_state(1.3)
	_check(horn.music_entry_timer == 0.0 and player.speed_x == 540.0 and bridge._velocity_y == -540.0, "horn kind two uses its diagonal exit speed")

	print("MUSIC_ENTRY_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("MUSIC_ENTRY_FAIL: " + label)
