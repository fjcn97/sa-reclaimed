extends SceneTree

var checks: int = 0
var failed: bool = false

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var bridge: Node = get_root().get_node("CoreBridge")
	bridge.init_level(0, false)
	var player = bridge.get_player_state()
	var chord = bridge._add_entity(bridge._level_state, bridge.ENTITY_CHORD, 240.0, 300.0)
	chord.chord = true
	player.world_x = 264.0
	player.world_y = 300.0
	player.is_grounded = false
	bridge._velocity_y = 400.0
	bridge._try_chord(chord)
	_check(chord.chord_phase == 1 and player.speed_y == 400.0, "falling contact starts the chord bounce")
	_check(player.char_state == 6, "chord holds the player in the spin state during bounce")
	bridge._update_chord_state(0.35)
	_check(chord.chord_phase == 2 and player.speed_y < 0.0, "chord launches after the elements settle")
	_check(absf(player.speed_y) == 600.0, "chord clamps and scales the incoming bounce speed")
	bridge._update_chord_state(0.35)
	_check(chord.chord_phase == 0 and not chord.activated, "chord finishes its vibration phase")

	bridge.init_level(0, false)
	player = bridge.get_player_state()
	chord = bridge._add_entity(bridge._level_state, bridge.ENTITY_CHORD, 240.0, 300.0)
	chord.chord = true
	player.world_x = 264.0
	player.world_y = 300.0
	bridge._velocity_y = -200.0
	bridge._try_chord(chord)
	_check(chord.chord_phase == 0, "chord rejects a player moving upward")

	print("CHORD_CHECKS=%d" % checks)
	quit(1 if failed else 0)

func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failed = true
		push_error("CHORD_FAIL: " + label)
